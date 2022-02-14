#
#   bazel build :show
#   bazel cquery :foo --output=starlark --starlark:expr='providers(target)'
#   Where is DefaultInfo

load(':show_rule.bzl', 'am_i_executable', 'show_default_info')

cc_binary(
  name = 'foo',
  srcs = ['foo.cc']
)

show_default_info(
  name = 'show',
  src = ':foo'
)

am_i_executable(
  name = 'is_foo_executable',
  src = ':foo'
)


am_i_executable(
  name = 'is_foo.cc_executable',
  src = 'foo.cc'
)
