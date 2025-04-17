tc = Label("//third_party/jdk:toolchain_java7")

_SCALAR_TYPES_ = ["NoneType", "bool", "int", "string"]

_FRAGMENTS = [
    "android",
    "apple",
    "file",
    "google3",
    "google_cpp",
    "j2objc",
    "java",
    "js",
    "objc",
    "platform",
    "proto",
    "py",
    "swift",
    "transitive_sources",
    "files_to_run",
    "runfiles",
]

_TOOLCHAINS = [
    "cpp",
    "python",
]

_FRAGMENT_NAMES = _TOOLCHAINS + _FRAGMENTS

def dump_value(label, v):
    v_type = type(v)
    if v_type in _SCALAR_TYPES_:
        print("%s: %s" % (label, v))
    elif v_type == "dict" or v_type == "list" or v_type == "tuple":
        print("%s: %s" % (label, str(v)))
    elif dir(v):
        v_to_names = {}
        for key in dir(v):
            v = str(getattr(v, key, "undef"))
            v_to_names.setdefault(v, []).append(key)
        for v in v_to_names.keys():
            fields = v_to_names[v]
            if len(fields) == 1:
                print("%s.%s=%s" % (label, fields[0], v))
            else:
                print("%s.%s=%s" % (label, str(fields), v))
    else:
        print("%s: opaque(%s, %s)" % (label, v_type, v))

def dump_dict(label, d, keys, printed_set):
    if d in printed_set:
        print("  %s SKIPPED" % label)
        return
    printed_set.append(d)
    for key in keys:
        v = getattr(d, key, {})
        if v not in printed_set:
            printed_set.append(v)

            # print('  PRINTING %s' % repr(v))
            # print('  len(set) = %d' % len(printed_set))
            dump_value("  %s.%s" % (label, key), v)

def dump_attr(obj, attr_name, label, printed_set):
    if not label:
        label = "." + attr_name
    attr = getattr(obj, attr_name, None)
    attr_type = type(attr)
    if attr_type in _SCALAR_TYPES_:
        print("  %s=%s" % (label, attr))
        return
    if attr_type == "dict":
        dump_dict(label, attr, attr.keys(), printed_set)
        return
    if attr in printed_set:
        print(" SKIPPED %s" % label)
        return

    print("  .%s isa %s" % (attr_name, attr_type))
    if attr_type == "list":
        for key in attr:
            v = getattr(attr, key, {})
            if v not in printed_set:
                print("  PRINTED2 %s" % repr(v))
                print("  %s.%s: %s" % (attr_name, key, str(dir(v))))
                printed_set.append(v)
    elif attr_type == "fragments":
        dump_dict(
            label,
            attr,
            [fname for fname in dir(attr) if fname in _FRAGMENTS],
            printed_set,
        )
        if "cpp" in dir(attr):
            cc_toolchain = cc_common.CcToolchainInfo()
            dump_dict(
                "CPP Toolchain",
                cc_toolchain,
                dir(cc_toolchain),
                printed_set,
            )
    else:
        # an object? turn into a dict
        dump_dict(label, attr, dir(attr), printed_set)

def dumper_impl_internal_(target, ctx):
    print("==============================================")
    if target:
        print("target: %s:%s" % (target.label.package, target.label.name))
    print("ctx: (%s) %s" % (type(ctx), str(dir(ctx))))
    printed_set = []

    #if hasattr(ctx, 'fragments'):
    #  fragments = ctx.fragments
    #  for frag in dir(ctx.fragments):
    #    if hasattr(ctx.fragments, frag):
    #      f = getattr(ctx.fragments, frag)
    #      print('  .fragment.%s: %s' % (frag, str(dir(f))))
    #    else:
    #      print('  .fragment.%s: <not allowed>' % frag)

    dump_attr(ctx, "fragments", "", printed_set)
    dump_attr(ctx, "toolchains", "", printed_set)
    dump_attr(ctx, "actions", "", printed_set)
    dump_attr(ctx, "attr", "", printed_set)
    dump_attr(ctx, "host_fragments", "", printed_set)
    dump_attr(ctx, "workspace_name", "", printed_set)
    dump_attr(ctx, "var", "", printed_set)
    dump_attr(ctx, "version_file", "", printed_set)

    dump_attr(ctx, "expand_make_variables", "", printed_set)
    dump_attr(ctx, "genfiles_dir", "", printed_set)

    #"action", "actions", "aspect_ids", "attr", "bin_dir", "build_file_path",
    #      "check_placeholders", "configuration", "coverage_instrumented",
    #      "created_actions", "default_provider", "disabled_features",
    #      "empty_action", "executable", "expand", "expand_location",
    #      "expand_make_variables", "experimental_new_directory", "features",
    #      "file", "file_action", "files", "fragments", "genfiles_dir",
    #      "host_configuration", "host_fragments", "info_file", "label",
    #      "new_file", "outputs", "resolve_command", "rule", "runfiles",
    #      "split_attr", "template_action", "tokenize", "toolchains", "var",
    #      "version_file", "workspace_name"]

    # If we have target, we are an aspect.
    if target:
        dump_attr(ctx, "rule", "", printed_set)

    if type(ctx) == "rule":
        dump_attr(ctx, "split_attr", "", printed_set)

    if hasattr(ctx.attr, "deps"):
        for dep in ctx.attr.deps:
            target = "%s:%s" % (dep.label.package, dep.label.name)
            print("DEP: %s: %s" % (target, str(dir(dep))))
            if hasattr(dep, "java"):
                print(" .java: " + str(dir(dep.java)))

            #for attr in dir(dep.attr):
            #  dump_attr(dep, 'attr', '  ' + dep.label.name)

    if hasattr(ctx.attr, "files_to_run"):
        for dep in ctx.attr.runfiles:
            target = "%s:%s" % (dep.label.package, dep.label.name)
            print("FILE: %s: %s" % (target, str(dir(dep))))

    return struct(_printed_set = printed_set)

def dumper_impl(target, ctx):
    return dumper_impl_internal_(target, ctx)

print_deps = aspect(
    implementation = dumper_impl,
    attr_aspects = ["deps", "files_to_run", "runfiles"],
    fragments = _FRAGMENT_NAMES,
    host_fragments = _FRAGMENT_NAMES,
)

def toast_impl(ctx):
    # dumper_impl_internal_(None, ctx)
    pass

toast = rule(
    implementation = toast_impl,
    attrs = {
        "deps": attr.label_list(
            allow_files = True,
            non_empty = True,
            aspects = [print_deps],
        ),
    },
    fragments = _FRAGMENT_NAMES,
    host_fragments = _FRAGMENT_NAMES,
    #outputs = {
    #    "deps_file": "%{name}.jar",
    #},
)
