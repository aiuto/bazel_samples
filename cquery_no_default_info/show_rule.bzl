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


def _am_i_executable_impl(ctx):
  di = ctx.attr.src[DefaultInfo]
  if not di:
    fail('src did not have DefaultInfo')
  executable = di.files_to_run.executable
  if executable:
    print('%s is executable' % di.files.to_list()[0].path)
  return DefaultInfo(files = None)

am_i_executable = rule(
  implementation = _am_i_executable_impl,
  attrs = {
    'src': attr.label(allow_files=True),
  }
)
