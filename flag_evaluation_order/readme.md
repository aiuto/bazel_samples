# Repros for bazel issue #13603

See https://github.com/bazelbuild/bazel/issues/13603

## The core of the problem

- Flags can be set explictly on the command line or indirectly via .bazelrc files
- Users expect that --config=xx acts as if the options are expanded in place
- This is true for built-in options like --cpu
- For starlark defined options, it appears that the --config expansion always
  wins

This is unexpected because it means that users have no way to override (from
the command line) a starlark option which got set by --config processing.

## To demonstrate the problem

```
./show.sh
```
