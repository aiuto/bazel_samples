load(
    ":defs.bzl",
    "two_1",
    "two_2",
    "two_append",
    "two_orig",
    "wrapper_1",
    "wrapper_2",
    "wrapper_orig",
)

wrapper_orig(
    name = "w0",
    server_spec = 42,
    deps = [1],
)

wrapper_1(
    name = "w1",
    deps = [1],
)

wrapper_1(
    name = "w1_server",
    server_spec = 42,
    deps = [1],
)

wrapper_2(
    name = "w2_server",
    server_spec = 42,
    deps = [1],
)

two_orig(
    name = "two_orig",
    server_spec = 42,
    deps = [1],
)

two_1(
    name = "two_1",
    server_spec = 42,
    deps = [1],
)

two_2(
    name = "two_2",
    server_spec = 42,
    deps = [1],
)

# Does not work.
#two_append(
#    name = "two_append",
#    server_spec = 42,
#    deps = [1],
#)
