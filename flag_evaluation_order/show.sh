#!/bin/bash

temp_out=$(/bin/mktemp)


function bb() {
  expect="$1"
  expect_cpu="$2"
  shift ; shift
  echo === "$*" '=> expect flag='"$expect"
  bazel build --announce_rc $* :* 2>&1 | tee $temp_out | grep DEBUG
  got=$(sed -n -e 's/^DEBUG.*flag=//p' $temp_out)
  if [[ "$expect" != "$got" ]] ; then
    echo "FAIL: expected $expect, but got $got"
  fi
  got_cpu=$(sed -n -e 's/^DEBUG.*cpu=//p' $temp_out)
  if [[ "$expect_cpu" != "$got_cpu" ]] ; then
    echo "FAIL: expected cpu=$expect_cpu, but got $got_cpu"
  fi
}

bb 'default' 'k8'
bb 'cmdline' 'k8'     --//:flag=cmdline
bb 'linux'   'arm7'   --enable_platform_specific_config
bb 'linux'   'arm7'   --enable_platform_specific_config --config=womble
bb 'cmdline' 'arm7'   --enable_platform_specific_config --//:flag=cmdline
bb 'cmdline' 'darwin' --enable_platform_specific_config --//:flag=cmdline --cpu=darwin
bb 'cmdline' 'darwin' --config=womble --cpu=darwin --//:flag=cmdline
bb 'cmdline' 'womble' --cpu=darwin --config=womble --//:flag=cmdline

/bin/rm $temp_out
