target "docker-metadata-action" {}

target "default" {
  inherits = ["docker-metadata-action"]
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64",
    "linux/386",
    "linux/ppc64le",
    "linux/riscv64",
    "linux/s390x",
  ]
}
