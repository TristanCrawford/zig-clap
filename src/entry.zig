const Version = @import("version.zig").Version;

pub const PluginEntry = extern struct {
    clap_version: Version,
    init: ?*const fn (plugin_path: ?[*:0]const u8) callconv(.C) bool,
    deinit: ?*const fn () callconv(.C) void,
    getFactory: ?*const fn (factory_id: ?[*:0]const u8) callconv(.C) ?*const anyopaque,
};
