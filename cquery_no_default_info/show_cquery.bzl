#   bazel cquery :foo --output=starlark --starlark:file=$(/bin/pwd)/show_cquery.bzl

def format(target):
    provider_map = providers(target)
    print(provider_map.keys())
    di = provider_map["DefaultInfo"]
    return dir(di)
