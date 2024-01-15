const Id = @import("../id.zig").Id;
const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const timer_support_id: ?[*:0]const u8 = "clap.timer-support";

pub const PluginTimerSupport = extern struct {
    onTimer: ?*const fn (
        plugin: *const Plugin,
        timer_id: Id,
    ) callconv(.C) void,
};

pub const HostTimerSupport = extern struct {
    registerTimer: ?*const fn (
        host: *const Host,
        period_ms: u32,
        timer_id: *Id,
    ) callconv(.C) bool,

    unregisterTimer: ?*const fn (
        host: *const Host,
        timer_id: Id,
    ) callconv(.C) bool,
};
