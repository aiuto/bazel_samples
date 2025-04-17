# Where are my files?

## Finding the exact path to the files created by a target.

Most of the time, Bazel users do not need to know the path to the artifacts
created for any given target. A notable exception is for users of packaging
rules. You typically create an RPM or Debian packaged file for the explicit
purpose of taking it from your machine and giving it to someon else.

Users often create scripts to push `blaze build` outputs to other places and
need to know the path to those outputs. This can be a challenge for rules which
may create the file name by combining a base part with a version number,
and maybe a CPU architecture. We don't do find them with shell wildcards
like `blaze-bin/my-pkg/pkg-*.deb`. That is brittle. Fortunately, Bazel
provide all the tools we need to get the pricise path to an output.

## Using cquery to find the exact path to the outputs created for a target.

We can use Bazel's cquery command to find information about a target.
Specifically we use
[cquery's Starlark output](https://docs.bazel.build/versions/main/cquery.html#cquery-starlark-dialect)
to inspect a target and print exactly what we need. Let's try it:

```shell
blaze build :something
blaze cquery :something --output=starlark \
  --starlark:file=experimental/users/aiuto/bazel/finding_outputs/show_outputs.bzl 2>/dev/null
```

That should produce something like

```
blaze-out/k8-fastbuild/bin/experimental/users/aiuto/bazel/finding_outputs/my_package-1.2-k8-fastbuild.tar
```

### How it works

show_deb_outputs.bzl is a Starlark script that must contain a function with the
name `format`, that takes a single argument. The argument is typically named
target, and is a configured Bazel target, as you might have access to while
writing a custom rule. We can inspect its providers and print them in a useful
way.

Most rules return their outputs in the FileProvider. We introspect that
and print the paths of the files found.

```
def format(target):
  provider_map = providers(target)
  file_info = provider_map["FileProvider"]
  return '\n'.join(
      [f.path for f in file_info.files_to_build.to_list()])
```

A full explanation of why this works is beyond the scope of this example. It
requires some knowledge of how to write custom Bazel rules. See the Bazel
documenation for more information.

## proto outputs

This example is a little more interesting.


```shell
blaze build :foo_cc
blaze cquery :foo_cc --output=starlark \
  --starlark:file=experimental/users/aiuto/bazel/finding_outputs/show_outputs.bzl 2>/dev/null
```

That should produce something like:

```

files_to_build: blaze-out/k8-fastbuild/genfiles/experimental/users/aiuto/bazel/finding_outputs/foo.pb.h
files_to_build: blaze-out/k8-fastbuild/genfiles/experimental/users/aiuto/bazel/finding_outputs/foo.pb.cc
files_to_build: blaze-out/k8-fastbuild/genfiles/experimental/users/aiuto/bazel/finding_outputs/foo.proto.h
```
