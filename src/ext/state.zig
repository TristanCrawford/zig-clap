const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const IStream = @import("../stream.zig").IStream;
const OStream = @import("../stream.zig").OStream;

pub const state_id: ?[*:0]const u8 = "clap.state";

pub const PluginState = extern struct {
    save: ?*const fn (
        plugin: *const Plugin,
        stream: *const OStream,
    ) callconv(.C) bool,

    load: ?*const fn (
        plugin: *const Plugin,
        stream: *const IStream,
    ) callconv(.C) bool,
};

pub const HostState = extern struct {
    markDirty: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
