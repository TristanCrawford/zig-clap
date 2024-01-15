const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const tail_id: ?[*:0]const u8 = "clap.tail";

pub const PluginTail = extern struct {
    get: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) u32,
};

pub const HostTail = extern struct {
    changed: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
