const Host = @import("../host.zig").Host;

pub const thread_check_id: ?[*:0]const u8 = "clap.thread-check";

pub const HostThreadCheck = extern struct {
    isMainThread: ?*const fn (
        host: *const Host,
    ) callconv(.C) bool,

    isAudioThread: ?*const fn (
        host: *const Host,
    ) callconv(.C) bool,
};
