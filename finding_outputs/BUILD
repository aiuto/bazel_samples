load(":my_package_name.bzl", "my_dynamic_naming_info")
load("@rules_pkg//pkg:pkg.bzl", "pkg_tar")

genrule(
    name = "generate_files",
    outs = [
        "etc/example.conf",
        "usr/bin/a_binary",
    ],
    cmd = "for i in $(OUTS); do echo 1 >$$i; done",
)

my_dynamic_naming_info(
    name = "my_naming_vars",
    version = "1.2",
)

pkg_tar(
    name = "something",
    srcs = [":generate_files"],
    package_file_name = "my_package-{version}-{cpu}-{compilation_mode}.tar",
    package_variables = ":my_naming_vars",
)
