# Building from source

## Host platforms

LLVM Embedded Toolchain for Arm is built and tested on Ubuntu 18.04 LTS.

The Windows version is built on Windows Server 2019 and lightly tested on Windows 10.

Building and testing on macOS is functional but experimental.

## Installing prerequisites

The build requires the following software to be installed, in addition
to the [LLVM requirements](https://llvm.org/docs/GettingStarted.html#software):
* CMake 3.20 or above
* Meson
* Git
* Ninja
* Python
* QEMU (for running the test suite, so optional)

On a Ubuntu 18.04.5 LTS machine you can use the following commands to install
the software mentioned above:
```
$ apt-get install python3 git make ninja-build qemu
$ apt-get install clang # If the Clang version installed by the package manager is older than 6.0.0, download a recent version from https://releases.llvm.org or build from source
$ apt-get install cmake # If the CMake version installed by the package manager is too old, download a recent version from https://cmake.org/download and add it to PATH
$ pip install meson
```

On macOS, you can use homebrew:
```
$ brew install llvm python3 git make ninja qemu cmake
$ pip install meson
```

## Building

The toolchain can be built directly with CMake.

```
mkdir build
cd build
cmake .. -GNinja -DFETCHCONTENT_QUIET=OFF
ninja llvm-toolchain
```

To make it easy to get started, the above command checks out and patches llvm-project & picolibc Git repos automatically.
If you prefer you can check out and patch the repos manually and use those.
If you check out repos manually then it is your responsibility to ensure that the correct revisions are checked out - see `versions.json` to identify these.

```
mkdir repos
git -C repos clone https://github.com/llvm/llvm-project.git
git -C repos/llvm-project apply ../../patches/llvm-project.patch
git -C repos clone https://github.com/picolibc/picolibc.git
git -C repos/picolibc apply ../../patches/picolibc.patch
mkdir build
cd build
cmake .. -GNinja -DFETCHCONTENT_SOURCE_DIR_LLVMPROJECT=../repos/llvm-project -DFETCHCONTENT_SOURCE_DIR_PICOLIBC=../repos/picolibc
ninja llvm-toolchain
```

### Testing the toolchain

```
ninja check-llvm-toolchain
```

### Packaging the toolchain

After building, create a zip or tar.gz file as appropriate for the platform:
```
ninja package-llvm-toolchain
```

### Cross-compiling the toolchain for Windows

The LLVM Embedded Toolchain for Arm can be cross-compiled to run on Windows.
The compilation itself still happens on Linux. In addition to the prerequisites
mentioned in the [Installing prerequisites](#installing-prerequisites) section
you will also need a Mingw-w64 toolchain based on GCC 7.1.0 or above installed.
For example, to install it on Ubuntu Linux use the following command:
```
# apt-get install mingw-w64
```

The MinGW build includes GCC & MinGW libraries into the package.

The following three libraries are used:

Library             | Project   | Link
--------------------|-----------|---------------------
libstdc++-6.dll     | GCC       | https://gcc.gnu.org
libgcc_s_seh-1.dll  | GCC       | https://gcc.gnu.org
libwinpthread-1.dll | Mingw-w64 | http://mingw-w64.org

The libraries are distributed under their own licenses, this needs to
be taken into consideration if you decide to redistribute the built toolchain.

To enable the MinGW build, set the LLVM_TOOLCHAIN_CROSS_BUILD_MINGW option:
```
cmake . -DLLVM_TOOLCHAIN_CROSS_BUILD_MINGW=ON
ninja package-llvm-toolchain
```
The same build directory can be used for both native and MinGW toolchains.

## Known limitations
* Depending on the state of the sources, build errors may occur when
  the latest revisions of the llvm-project & picolibc repos are used.

## Divergences from upstream

### picolibc:
* Added a fix for building with -mthumb

### LLVM:
* Recognize $@ in a config file argument to mean the directory of the config
  file, allowing toolchain relative paths.

## Espressif Toolchain Specifics

Espressif exteneded original Cmake scripts with the following features:
* Toolchain can be built for several target architectures. RISCV and Xtensa. See `LLVM_TOOLCHAIN_ENABLED_TARGETS`.
* Toolchain can be built for several host architecures (x86_64/ARM/ARM64) and platforms (Linux, MacOS, Windows). See `HOST_TRIPLE`.
* User can select whether and what C library should be included into toolchain: newlib or picolibc. See `USE_LIBC`. ***NOTE: Picolibc was not tested yet***.
* User can select what run-time librarires should be included into toolchain: `compiler-rt` and/or `libgcc`. See `USE_RTLIB`. Currently pre-built `libgcc` binaries are picked up from the specified Espressif GNU toolchain release (see `ESP_GNU_TOOLCHAIN_VER`).
* User can select what C++ librarires should be included into toolchain: `libstdc++` and/or `libcxx`. See `USE_LIBCXX`. Currently pre-built `libstdc++` binaries are picked up from the specified Espressif GNU toolchain release (see `ESP_GNU_TOOLCHAIN_VER`). ***NOTE: Building `libcxx` is not well tested yet***.
* There exist some integration problems with esp-idf, so toolchain includes GNU `as`, `ld` and `objdump` to work around them. See `USE_BINUTILS`.

### Configuration variables

Variable name       | Description
--------------------|-------------
ESP_TOOLCHAIN | Enables options specific to Espressif toolchain build. `YES` or `NO`.
HOST_TRIPLE | Host triple to build toolchain for. String.
LLVM_TOOLCHAIN_ENABLED_TARGETS | Build only the specified targets. If not specified then build all targets. Semicolon separated list, e.g. `RISCV;Xtensa`.
USE_LIBC | What libc to use for toolchain. One of `picolibc`, `newlib` or `none`. String.
USE_RTLIB | What run time library to include into toolchain: `compiler-rt`, `libgcc`. Semicolon separated list.
USE_LIBCXX | What C++ library to include into toolchain: `libcxx`, `libstdcxx`. Semicolon separated list.
USE_BINUTILS | Includes GNU binutils into toolchain. `YES` or `NO`.
ESP_GNU_TOOLCHAIN_VER | Espressif GNU toolchain version to pick libgcc and libstdc++ from. String.
LLVM_PROJECT_REPO_URL | llvm-project repo URL. String. Default `https://github.com/espressif/llvm-project.git`
NEWLIB_REPO_URL | Newlib repo URL. String. Default `https://github.com/espressif/newlib-esp32.git`
BINUTILS_REPO_URL | Binutils repo URL. String. Default `https://github.com/espressif/binutils-gdb.git`
XTENSA_OVERLAYS_REPO_URL | Xtensa overlays repo URL. String. Default `https://github.com/espressif/xtensa-overlays.git`

### How to build

#### Using remote repositories

The process of building is very similar to ARM toolchain, but may need some additional configuration variables to be set. Below is an example of how to build complete toolchain for `x86_64-linux-gnu` host.

```bash
git clone -b esp-17.0.1_20240419 https://github.com/espressif/esp-llvm-embedded-toolchain.git

cmake $PWD/esp-llvm-embedded-toolchain -GNinja \
        -DLLVMPROJECT_REPO_URL="https://github.com/espressif/llvm-project.git" \
        -DNEWLIB_REPO_URL="https://github.com/espressif/newlib-esp32.git" \
        -DBINUTILS_REPO_URL="https://github.com/espressif/binutils-gdb.git" \
        -DXTENSA_OVERLAYS_REPO_URL="https://github.com/espressif/xtensa-overlays.git" \
        -DFETCHCONTENT_QUIET=OFF \
        -DESP_GNU_TOOLCHAIN_VER="13.2.0_20240305" \
        -DCPACK_ARCHIVE_THREADS=0 \
        -DUSE_LIBC=newlib \
        -DUSE_LIBCXX="libstdcxx" \
        -DUSE_RTLIB="compiler-rt;libgcc" \
        -DUSE_BINUTILS=ON \
        -DESP_TOOLCHAIN=ON \
        -DHOST_TRIPLE=x86_64-linux-gnu \
        -DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa" \
        --install-prefix=/tmp/esp-clang_Release

# install toolchain to /tmp/esp-clang_Release
ninja install-llvm-toolchain

# or package toolchain
ninja package-llvm-toolchain
# print path to packed toolchain
ninja print-llvm-toolchain-package-path
```
URLs in the example above are default ones and can be skipped. They are shown just for the sake of example. You can customize them to point to you own fork of those projects. If you want to use custom branch or tag for any of the repo it should be set up in `versions.json`.

#### Using local repositories

If you want to build toolchain using repos/branches checked out locally the following commands can be used

```bash
cmake $PWD/esp-llvm-embedded-toolchain -GNinja \
        -DFETCHCONTENT_SOURCE_DIR_LLVMPROJECT=/home/user/llvm-project \
        -DFETCHCONTENT_SOURCE_DIR_BINUTILS=/home/user/binutils-gdb \
        -DFETCHCONTENT_SOURCE_DIR_NEWLIB=/home/user/newlib-cygwin \
        -DFETCHCONTENT_SOURCE_DIR_XTENSA_OVERLAYS=/home/user/xtensa-overlays \
        -DFETCHCONTENT_QUIET=OFF \
        -DESP_GNU_TOOLCHAIN_VER="13.2.0_20240305" \
        -DCPACK_ARCHIVE_THREADS=0 \
        -DUSE_LIBC=newlib \
        -DUSE_LIBCXX="libstdcxx" \
        -DUSE_RTLIB="compiler-rt;libgcc" \
        -DUSE_BINUTILS=ON \
        -DESP_TOOLCHAIN=ON \
        -DHOST_TRIPLE=x86_64-linux-gnu \
        -DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa" \
        --install-prefix=/tmp/esp-clang_Release

# install toolchain to /tmp/esp-clang_Release
ninja install-llvm-toolchain

# or package toolchain
ninja package-llvm-toolchain
# print path to packed toolchain
ninja print-llvm-toolchain-package-path
```

#### Target libraries

If you want to build toolchain for the host other then `x86_64-linux-gnu` you need to build toolchain core and target libraries separately. Libraries should be built for `x86_64-linux-gnu` host and added to the toolchain manualy.

```bash
cmake $PWD/esp-llvm-embedded-toolchain -GNinja \
        -DFETCHCONTENT_QUIET=OFF \
        -DESP_GNU_TOOLCHAIN_VER="13.2.0_20240305" \
        -DCPACK_ARCHIVE_THREADS=0 \
        -DUSE_LIBC=newlib \
        -DUSE_LIBCXX="libstdcxx" \
        -DUSE_RTLIB="compiler-rt;libgcc" \
        -DUSE_BINUTILS=ON \
        -DESP_TOOLCHAIN=ON \
        -DHOST_TRIPLE=x86_64-linux-gnu \
        -DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa"

# package target libraries
ninja package-llvm-toolchain-target-libs
# print path to packed target librarires
ninja print-llvm-toolchain-target-libs-package-path
```

#### For MacOS host

To build for MacOS you need to install [OSXCROSS](https://github.com/tpoechtrager/osxcross) environment. The command to build toolchain for MacOS w/o target libraries is below.

```bash
cmake $PWD/esp-llvm-embedded-toolchain -GNinja \
        -DFETCHCONTENT_QUIET=OFF \
        -DESP_GNU_TOOLCHAIN_VER="13.2.0_20240305" \
        -DCPACK_ARCHIVE_THREADS=0 \
        -DUSE_LIBC=none \
        -DUSE_LIBCXX="" \
        -DUSE_RTLIB="" \
        -DUSE_BINUTILS=ON \
        -DESP_TOOLCHAIN=ON \
        -DHOST_TRIPLE=x86_64-apple-darwin21.1 \
        -DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa"

# package toolchain
ninja package-llvm-toolchain
# print path to packed toolchain
ninja print-llvm-toolchain-package-path
```
***NOTE: To get complete toolchain you need to add target libraries to the toolchain.***

#### For Windows host

To build for Windows you need to install Mingw. See `Cross-compiling the toolchain for Windows` chapter on how to do this. The command to build toolchain for Windows w/o target libraries is below.

```bash
cmake $PWD/esp-llvm-embedded-toolchain -GNinja \
        -DFETCHCONTENT_QUIET=OFF \
        -DESP_GNU_TOOLCHAIN_VER="13.2.0_20240305" \
        -DCPACK_ARCHIVE_THREADS=0 \
        -DUSE_LIBC=none \
        -DUSE_LIBCXX="" \
        -DUSE_RTLIB="" \
        -DUSE_BINUTILS=ON \
        -DESP_TOOLCHAIN=ON \
        -DLLVM_TOOLCHAIN_CROSS_BUILD_MINGW=ON \
        -DHOST_TRIPLE=x86_64-w64-mingw32 \
        -DLLVM_TOOLCHAIN_ENABLED_TARGETS="RISCV;Xtensa"

# package toolchain
ninja package-llvm-toolchain
# print path to packed toolchain
ninja print-llvm-toolchain-package-path
```
***NOTE: To get complete toolchain you need to add target libraries to the toolchain.***
