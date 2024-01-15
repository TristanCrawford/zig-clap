const Plugin = @import("../plugin.zig").Plugin;

pub const render_id: ?[*:0]const u8 = "clap.render";

pub const PluginRenderMode = enum(i32) {
    realtime = 0,
    offline = 1,
};

pub const PluginRender = extern struct {
    hasHardRealtimeRequirement: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) bool,

    set: ?*const fn (
        plugin: *const Plugin,
        mode: PluginRenderMode,
    ) callconv(.C) bool,
};
