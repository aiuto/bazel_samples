load(":inspect.bzl", "toast")

java_binary(
    name = "j_foo",
    srcs = ["Foo.java"],
    main_class = "Foo",
    deps = [":j_bar"],
)

java_library(
    name = "j_bar",
    srcs = ["Bar.java"],
)

cc_binary(
    name = "c_foo",
    srcs = ["foo.cc"],
    deps = [":c_bar"],
)

cc_library(
    name = "c_bar",
    srcs = ["bar.cc"],
)

toast(
    name = "t",
    deps = [
        ":c_foo",
        ":j_foo",
    ],
)
