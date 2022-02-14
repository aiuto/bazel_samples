def _show_default_info_impl(ctx):
  di = ctx.attr.src[DefaultInfo]
  if not di:
    fail('src did not have DefaultInfo')
  print('files_to_run:', dir(di.files_to_run))
  return DefaultInfo(files = di.files)


show_default_info = rule(
  implementation = _show_default_info_impl,
  attrs = {
    'src': attr.label(),
  }
)


