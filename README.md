<img align="right" width="96px" src="./assets/1200px-ISO_C++_Logo.svg.png">

# Morden C++ Dev
[![Shellcheck](https://github.com/Dup4/morden-cpp-dev/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/Dup4/morden-cpp-dev/actions/workflows/shellcheck.yml)
[![Build Docker Image](https://github.com/Dup4/morden-cpp-dev/actions/workflows/build_docker_image.yml/badge.svg)](https://github.com/Dup4/morden-cpp-dev/actions/workflows/build_docker_image.yml)

Morden C++ development environment

It's based on Ubuntu 20.04 and contains softwares below:

- GCC 11(from [PPA](https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test))
- Clang 13(from [LLVM](https://apt.llvm.org/))
- CMake

## Build

```bash
docker build -t morden-cpp-dev:latest -f Dockerfile ./
```

## Start

```bash
docker run --rm -v "${PWD}":/app -w /app morden-cpp-dev:latest
```
