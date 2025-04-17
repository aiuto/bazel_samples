# Extract the paths to the various outputs of a proto_library.
#
# Usage:
#   bazel cquery :something --output=starlark --starlark:file=show_proto.bzl
#

def format(target):
  provider_map = providers(target)
  print(provider_map.keys())
  cc_info = provider_map.get("CcInfo", None)
  if cc_info:
    print(str(cc_info.compilation_context))
  proto_info = provider_map.get("@rules_cc//cpp:cc_proto_library.bzl%ProtoCcFilesInfo", None)
  #for x in provider_map.keys():
  #  print("%s => %s" % (x, provider_map[x]))
  #if proto_info:
  #  print(str(proto_info))
  file_info = provider_map["FileProvider"]
  #print(dir(file_info))
  return '\n'.join(
      [f.path for f in file_info.files_to_build.to_list()])
