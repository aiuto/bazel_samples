"""Example rules to show package naming techniques."""

load("//third_party/bazel_rules/rules_pkg/pkg:providers.bzl", "PackageVariablesInfo")

def _my_dynamic_naming_info_impl(ctx):
    values = {}
    values["version"] = ctx.attr.version
    values["cpu"] = ctx.var.get("TARGET_CPU")
    values["compilation_mode"] = ctx.var.get("COMPILATION_MODE")
    return PackageVariablesInfo(values = values)

#
# Extracting variables from the toolchain to use in the pacakge name.
#
my_dynamic_naming_info = rule(
    implementation = _my_dynamic_naming_info_impl,
    attrs = {
        "version": attr.string(
            doc = "Placeholder for our release version.",
        ),
    },
)
