const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const log_id: ?[*:0]const u8 = "clap.log";

pub const Severity = enum(i32) {
    debug = 0,
    info = 1,
    warning = 2,
    _error = 3,
    fatal = 4,
    host_misbehaving = 5,
    plugin_misbehaving = 6,
};

pub const HostLog = extern struct {
    log: ?*const fn (
        host: *const Host,
        severity: Severity,
        msg: ?[*:0]const u8,
    ) callconv(.C) void,
};
