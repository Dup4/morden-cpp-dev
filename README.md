# morden-cpp-dev
Morden C++ development environment

## Build

```bash
docker build -t morden-cpp-dev:latest -f Dockerfile ./
```

## Start

```bash
docker run --rm -v "${PWD}":/app -w /app morden-cpp-dev:latest
```
