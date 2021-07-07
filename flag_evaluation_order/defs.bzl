StringFlagInfo = provider(fields = ["value"])

def _string_impl(ctx):
    value = ctx.build_setting_value
    print("--%s=%s" % (ctx.label, value))
    print("--cpu=%s" % ctx.var.get("TARGET_CPU"))
    return StringFlagInfo(value = value)

string_flag = rule(
    implementation = _string_impl,
    build_setting = config.string(flag = True),
)
