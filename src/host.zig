const Version = @import("version.zig").Version;

pub const Host = extern struct {
    clap_version: Version,
    host_data: *anyopaque,
    name: ?[*:0]const u8,
    vendor: ?[*:0]const u8,
    url: ?[*:0]const u8,
    version: ?[*:0]const u8,
    getExtension: ?*const fn (host: *const Host, extension_id: ?[*:0]const u8) callconv(.C) *const anyopaque,
    requestRestart: ?*const fn (host: *const Host) callconv(.C) void,
    requestProcess: ?*const fn (host: *const Host) callconv(.C) void,
    requestCallback: ?*const fn (host: *const Host) callconv(.C) void,
};
