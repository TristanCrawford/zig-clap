const Id = @import("../id.zig").Id;
const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const name_size = @import("../string_sizes.zig").name_size;

pub const note_ports_id: ?[*:0]const u8 = "clap.note-ports";

pub const NoteDialect = enum(u32) {
    clap = 1 << 0,
    midi = 1 << 1,
    midi_mpe = 1 << 2,
    midi2 = 1 << 3,
};

pub const NotePortInfo = extern struct {
    id: Id,
    supported_dialects: NoteDialect,
    preferred_dialect: NoteDialect,
    name: [name_size]u8,
};

pub const PluginNotePorts = extern struct {
    count: ?*const fn (
        plugin: *const Plugin,
        is_input: bool,
    ) callconv(.C) u32,

    get: ?*const fn (
        plugin: *const Plugin,
        index: u32,
        is_input: bool,
        info: *NotePortInfo,
    ) callconv(.C) bool,
};

pub const NotePortsRescanFlags = enum(u32) {
    all = 1 << 0,
    names = 1 << 1,
};

pub const HostNotePorts = extern struct {
    supportedDialects: ?*const fn (
        host: *const Host,
    ) callconv(.C) u32,

    rescan: ?*const fn (
        host: *const Host,
        flags: NotePortsRescanFlags,
    ) callconv(.C) void,
};
