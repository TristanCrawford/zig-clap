const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const posix_fd_support_id: ?[*:0]const u8 = "clap.posix-fd-support";

pub const PosixFdFlags = enum(u32) {
    read = 1 << 0,
    write = 1 << 1,
    _error = 1 << 2,
};

pub const PluginPosixFdSupport = extern struct {
    onFd: ?*const fn (
        plugin: *const Plugin,
        fd: i32,
        flags: PosixFdFlags,
    ) callconv(.C) void,
};

pub const HostPosixFdSupport = extern struct {
    registerFd: ?*const fn (
        host: *const Host,
        fd: i32,
        flags: PosixFdFlags,
    ) callconv(.C) bool,

    modifyFd: ?*const fn (
        host: *const Host,
        fd: i32,
        flags: PosixFdFlags,
    ) callconv(.C) bool,

    unregisterFd: ?*const fn (
        host: *const Host,
        fd: i32,
    ) callconv(.C) bool,
};
