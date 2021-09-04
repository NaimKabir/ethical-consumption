workspace(
    # How this workspace would be referenced with absolute labels from another workspace
    name = "ethical-consumption",
)

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Docker rules

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "1f4e59843b61981a96835dc4ac377ad4da9f8c334ebe5e0bb3f58f80c09735f4",
    strip_prefix = "rules_docker-0.19.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.19.0/rules_docker-v0.19.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

# Pull postgres base container
container_pull(
    name = "psql",
    registry = "index.docker.io",
    repository = "library/postgres",
    digest = "sha256:29351fa971769c793d19e75e98c71ca7e00ad981267bcd99590862917eea2713" # postgres:latest
)

# Pull MediaWiki base container
container_pull(
    name = "semantic-mediawiki",
    registry = "index.docker.io",
    repository = "naimkabir/semantic-mediawiki",
    digest = "sha256:d14f4e025ddb671326d8bcd084f98c255f842d8ba4156f410f2d4cd5d2e33798" # naimkabir/semantic-mediawiki:3.2.3
)

