"""Different styles for conditionally adding args."""

def inner(name, deps, tools):
    print(name, deps, tools)

def wrapper_orig(name, deps = [], tools = [], server_spec = None):
    inner_name = "_inner" + name
    inner(
        name = inner_name,
        deps = deps + ([server_spec] if server_spec else []),
        # Why doesn't buildifier wrap the next line?
        tools = tools + ([
            "//server:spec_parser",
        ] if server_spec else []),
    )

def wrapper_1(name, deps = [], tools = [], server_spec = None):
    inner_name = "_inner" + name
    if server_spec:
        deps = deps + [server_spec]
        tools = tools + ["//server:spec_parser"]
    inner(
        name = inner_name,
        deps = deps,
        tools = tools,
    )

def wrapper_2(name, deps = [], tools = [], server_spec = None):
    inner_name = "_inner" + name
    if server_spec:
        server_deps = [server_spec]
        server_tools = ["//server:spec_parser"]
    else:
        server_deps = None
        server_tools = None
    inner(
        name = inner_name,
        deps = deps + server_deps,
        tools = tools + server_tools,
    )

# What happens if we call the method more than once, from the macro
def two_orig(name, deps = [], tools = [], server_spec = None):
    wrapper_orig(name + "_two", deps = deps, tools = tools, server_spec = server_spec)
    wrapper_orig(name + "_two", deps = deps, tools = tools, server_spec = server_spec)

def two_1(name, deps = [], tools = [], server_spec = None):
    wrapper_1(name + "_two", deps = deps, tools = tools, server_spec = server_spec)
    wrapper_1(name + "_two", deps = deps, tools = tools, server_spec = server_spec)

def two_2(name, deps = [], tools = [], server_spec = None):
    wrapper_2(name + "_two", deps = deps, tools = tools, server_spec = server_spec)
    wrapper_2(name + "_two", deps = deps, tools = tools, server_spec = server_spec)

# The danger of append and extend.
def wrapper_append(name, deps = [], tools = [], server_spec = None):
    inner_name = "_inner" + name
    if server_spec:
        deps = deps.append(server_spec)
        tools = tools.extend(["//server:spec_parser"])
    inner(
        name = inner_name,
        deps = deps,
        tools = tools,
    )

# This won't work
def two_append(name, deps = [], tools = [], server_spec = None):
    wrapper_append(name + "_two", deps = deps, tools = tools, server_spec = server_spec)
    wrapper_append(name + "_two", deps = deps, tools = tools, server_spec = server_spec)

format_sample = [
    "aaaaaaaaaaaaaaaaaaaa",
    "bbbbbbbbbbbbbbbbbbbb",
    "cccccccccccccccccccc",
] if True else []
