# Extract the paths to the various outputs of a rule
#
# Usage:
#   bazel cquery :something --output=starlark --starlark:file=show_outputs.bzl
#

def append_file_paths(ret, provider):
    for attr in dir(provider):
        if attr.startswith("_"):
            continue
        attr_value = getattr(provider, attr)
        if type(attr_value) == "depset":
            for file in attr_value.to_list():
                ret.append("%s: %s" % (attr, file.path))

def format(target):
    provider_map = providers(target)
    ret = []
    append_file_paths(ret, provider_map.get("OutputGroupInfo"))
    append_file_paths(ret, provider_map.get("FileProvider"))
    return "\n".join(ret)
