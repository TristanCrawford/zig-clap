const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const name_size = @import("../string_sizes.zig").name_size;

pub const note_name_id: ?[*:0]const u8 = "clap.note-name";

pub const NoteName = extern struct {
    name: [name_size]u8,
    port: i16,
    key: i16,
    channel: i16,
};

pub const PluginNoteName = extern struct {
    count: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) u32,

    get: ?*const fn (
        plugin: *const Plugin,
        index: u32,
        note_name: *NoteName,
    ) callconv(.C) bool,
};

pub const HostNoteName = extern struct {
    changed: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
