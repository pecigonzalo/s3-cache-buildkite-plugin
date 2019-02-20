#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment to enable stub debug output:
# export BUILDKITE_AGENT_STUB_DEBUG=/dev/tty

@test "Post-checkout downloads cache" {
  stub aws \
    "s3 cp s3://this/that.tar.gz ./ : echo Uploading artifacts"
  stub tar \
    "-xzf ./tar.tar.gz"

  export BUILDKITE_PIPELINE_SLUG="test"
  export BUILDKITE_BRANCH=master
  export BUILDKITE_PLUGIN_S3CACHE_BUCKET="test"
  export BUILDKITE_PLUGIN_S3CACHE_DIRECTORIES="./cache"
  run "$PWD/hooks/post-checkout"

  assert_success
  assert_output --partial "Downloading cache"
  assert_output --partial "Uncompressing cache"

  unset BUILDKITE_PLUGIN_S3CACHE_DOWNLOAD
}
