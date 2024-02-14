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
    parser.add_argument('--temp-path-prefix', '-t', help='', type=str)

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
                    fname_chk in gcc_tests.TESTS_TO_SKIP_RISCV:
                    # logging.debug("Skip %s", fname_chk)
                    pass
                else:
                    fname = os.path.join(root, fname)
                    # logging.debug("Found test %s", fname)
                    test_files.append(fname)
    else:
        for f in force_files:
            test_files.append(os.path.join(args.test_dir, f))

    clang_path = os.path.join(args.distro_path, "bin", "clang")
    clang_config = "rv32imac-zicsr-zifencei_ilp32_no-rtti_qemu_semihost.cfg"
    cflags = "-Wno-implicit-function-declaration -Wno-implicit-int -Wno-int-conversion"
    for fname in test_files:
        outfile = f"{args.temp_path_prefix}.{os.path.basename(fname)}.out"
        clang_cmd = f"{clang_path} --config {clang_config} {cflags} {fname} -o {outfile}"
        try:
            out = subprocess.check_output(clang_cmd, stderr=subprocess.STDOUT, shell=True)
        except subprocess.CalledProcessError as err:
            logging.error("Failed to build test '%s' (%d)!", fname, err.returncode)
            out = err.output
            logging.error("CMD: %s", clang_cmd)
            logging.error("============ OUTPUT ============")
            logging.error(err.output.decode())
            logging.error("================================")
            sys.exit(1)
        if len(out):
            print(out.decode())

        cmd = f"qemu-riscv32 -cpu rv32 {outfile}"
        try:
            out = subprocess.check_output(cmd, stderr=subprocess.STDOUT, shell=True)
        except subprocess.CalledProcessError as err:
            logging.error("Failed to run test '%s' (%d)!", fname, err.returncode)
            logging.error("CMD: %s", clang_cmd)
            logging.error("============ OUTPUT ============")
            logging.error(err.output.decode())
            logging.error("================================")
            out = err.output
            sys.exit(1)
        if len(out):
            print(out.decode())

    print("Tests passed!")

if __name__ == '__main__':
    main()
