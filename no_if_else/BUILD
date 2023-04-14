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
    deps = [1],
    server_spec = 42,
)

two_2(
    name = "two_2",
    deps = [1],
    server_spec = "server2",
)

config_setting(
    name = "added_complexity",
    values = {
        "define": "more_nuance=1",
    }
)


# this does not do what you want
wrapper_1(
    name = "w1_select_spec",
    deps = [1],
    server_spec = select({
        ":added_complexity": "42",
        "conditions_default": "lol",
    })
)

wrapper_orig(
    name = "orig_select_deps",
    deps = select({
        ":added_complexity": ["dep_a"],
        "conditions_default": ["lol"],
    }),
    server_spec = "must_be_a_const",
)

wrapper_1(
    name = "w1_select_deps",
    deps = select({
        ":added_complexity": ["dep_a"],
        "conditions_default": ["lol"],
    }),
    server_spec = "must_be_a_const",
)

wrapper_2(
    name = "w2_select_deps",
    deps = select({
        ":added_complexity": ["dep_a"],
        "conditions_default": ["lol"],
    }),
    server_spec = "must_be_a_const",
)

# Does not work.
#two_append(
#    name = "two_append",
#    server_spec = 42,
#    deps = [1],
#)
