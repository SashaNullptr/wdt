# Warp Speed Data Transfer II

## What is this repository?

An opinionated fork of Facebook's [Warp Speed Data transfer](https://github.com/facebook/wdt).

## Dependencies

| Component                                  | Version (≥)                                                 | Minimum | CLI Tool | Tests |
|--------------------------------------------|-------------------------------------------------------------|---------|----------|-------|
| g++                                        | 4.9                                                         | ✓       | ✓        | ✓     |
| CMake                                      | 3.2                                                         | ✓       | ✓        | ✓     |
| glog                                       | 0.3.5                                                       | ✓       | ✓        | ✓     |
| gtest                                      | 1.8.0-6                                                     |         |          | ✓     |
| [Folly](https://github.com/facebook/folly) | > commit [cc3f05](cc3f054a35dec6d6385ed62738b479b879904293) | ✓       | ✓        | ✓     |
| openssl                                    | 1.1.0                                                       | ✓       | ✓        |       

## Supported Platforms

| Platform     | Fully Supported | Experimental |
|--------------|-----------------|--------------|
| Ubuntu 18.04 | ✓               |              |
| Ubuntu 16.04 |                 | ✓            |

## Building

See [the build docs](build/README.md).