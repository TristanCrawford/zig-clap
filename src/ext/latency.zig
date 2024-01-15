const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const latency_id: ?[*:0]const u8 = "clap.latency";

pub const PluginLatency = extern struct {
    get: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) u32,
};

pub const HostLatency = extern struct {
    changed: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
