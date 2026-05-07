#!/usr/bin/env python3

import subprocess
import argparse
import logging
import importlib
import sys
import os
import os.path

def main():  # type: () -> None

    parser = argparse.ArgumentParser('GCC torture tests runner')

    parser.add_argument('test_dir') 
    parser.add_argument('--debug', '-d', help='Debug level: 0-4', type=int, default=1)
    parser.add_argument('--distro-path', '-p', help='Path to Clang toolchain distro', type=str)
    parser.add_argument('--timeout', '-t', help='Timeout in sec', type=int, default=5)
    parser.add_argument('--temp-path-prefix', '-r', help='', type=str)
    parser.add_argument('--xtensa', '-x', help='Run tests for Xtensa, or for RISCV if missed', action='store_true')
    parser.add_argument('--test-support-bin-dir', '-s', help='Path to look for test support libraries', type=str, default='')

    args = parser.parse_args()

    if args.debug == 0:
        log_level = logging.CRITICAL
    elif args.debug == 1:
        log_level = logging.ERROR
    elif args.debug == 2:
        log_level = logging.WARNING
    elif args.debug == 3:
        log_level = logging.INFO
    else:
        log_level = logging.DEBUG
    logging.basicConfig(format='%(levelname)s: %(message)s', level=log_level)

    # sys.path.append(os.path.dirname(args.test_dir))
    sys.path.append(args.test_dir)
    try:
        gcc_tests = importlib.import_module(os.path.basename(args.test_dir))
    except:
        logging.warning("Can not load list of skipped tests!")

    xtensa_test_cfg = {
        "compile_opts": f"--target=xtensa-esp-elf -mcpu=esp32 -lcrt1-sim -Wl,--whole-archive,-lgloss,-lsys_qemu,--no-whole-archive " \
                        "-T memory.elf.ld -T app.elf.ld --ld-path=xtensa-esp32-elf-clang-ld -z noexecstack",
        "qemu_cmd": "qemu-system-xtensa",
        "qemu_machine": "esp32",
        "tests_to_skip": gcc_tests.TESTS_TO_SKIP_XTENSA,
        "per_file_opts": gcc_tests.PER_FILE_OPTS_XTENSA,
    }
    riscv_test_cfg = {
        "compile_opts": f"-mcpu=esp32c3 -lsemihost -lcrt1_sim_test" + 
            " -L " + os.path.join(args.test_support_bin_dir, "rv32imc-zicsr-zifencei_ilp32_no-rtti", "lib") +
            " -T " + os.path.join(os.path.dirname(os.path.abspath(__file__)), "Inputs", "esp32c3.ld"),
        "qemu_cmd": "qemu-system-riscv32",
        "qemu_machine": "esp32c3",
        "tests_to_skip": gcc_tests.TESTS_TO_SKIP_RISCV,
        "per_file_opts": gcc_tests.PER_FILE_OPTS_RISCV,
    }
    test_cfg = xtensa_test_cfg if args.xtensa else riscv_test_cfg

    test_files = []
    force_files = [] # for testing
    if len(force_files) == 0:
        for root, dirs, files in os.walk(args.test_dir):
            for fname in files:
                if not fname.endswith('.c'):
                    continue
                if root == args.test_dir:
                    fname_chk = fname
                else:
                    fname_chk = os.path.join(os.path.basename(root), fname)
                if fname_chk in gcc_tests.TESTS_TO_SKIP or \
                    fname_chk in test_cfg["tests_to_skip"]:
                    logging.debug("Skip %s", fname_chk)
                    pass
                else:
                    fname = os.path.join(root, fname)
                    logging.debug("Found test %s", fname)
                    test_files.append(fname)
    else:
        for f in force_files:
            test_files.append(os.path.join(args.test_dir, f))

    clang_path = os.path.join(args.distro_path, "bin", "clang")
    cflags = "-Wno-implicit-function-declaration -Wno-implicit-int -Wno-int-conversion -Wno-incompatible-pointer-types " \
            "-fno-rtti -nostartfiles -lpthread_stubs -lm"
    cflags += " " + test_cfg["compile_opts"]
    for fname in test_files:
        rel_fname = os.path.relpath(fname, args.test_dir)
        print(f"Test file: {rel_fname}")
        extra_cflags = ""
        if rel_fname in test_cfg["per_file_opts"]:
            extra_cflags = test_cfg["per_file_opts"][rel_fname]
        outfile = f"{args.temp_path_prefix}.{os.path.basename(fname)}.out"
        clang_cmd = f"{clang_path} {cflags} {extra_cflags} {fname} -o {outfile}"
        try:
            out = subprocess.check_output(clang_cmd, stderr=subprocess.STDOUT, shell=True, timeout=args.timeout)
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as err:
            if err is subprocess.CalledProcessError:
                logging.error("Failed to build test '%s' (%d)!", fname, err.returncode)
            else:
                logging.error("Build test timeout '%s'!", fname)
            out = err.output
            logging.error("CMD: %s", clang_cmd)
            logging.error("============ OUTPUT ============")
            logging.error(err.output.decode())
            logging.error("================================")
            sys.exit(1)
        if len(out):
            print(out.decode())

        cmd = f"{test_cfg['qemu_cmd']} -nographic -machine {test_cfg['qemu_machine']} --semihosting -kernel {outfile}"
        try:
            out = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True, timeout=args.timeout)
        except (subprocess.CalledProcessError, subprocess.TimeoutExpired) as err:
            if err is subprocess.CalledProcessError:
                logging.error("Failed to run test '%s' (%d)!", fname, err.returncode)
            else:
                logging.error("Run test timeout '%s'!", fname)
            logging.error("CMD: %s", clang_cmd)
            logging.error("CMD: %s", cmd)
            logging.error("============ OUTPUT ============")
            logging.error(err.output.decode())
            logging.error("================================")
            out = err.output
            sys.exit(1)
        if len(out):
            print(out.decode())

if __name__ == '__main__':
    main()
    print("Tests passed!")
