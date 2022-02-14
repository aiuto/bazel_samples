#
#   bazel build :show
#   bazel cquery :foo --output=starlark --starlark:expr='providers(target)'
#   Where is DefaultInfo

load(':show_rule.bzl', 'show_default_info')

cc_binary(
  name = 'foo',
  srcs = ['foo.cc']
)

show_default_info(
  name = 'show',
  src = ':foo'
)

