const Id = @import("../id.zig").Id;
const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const name_size = @import("../string_sizes.zig").name_size;

pub const audio_ports_id: ?[*:0]const u8 = "clap.audio-ports";

pub const mono: ?[*:0]const u8 = "mono";
pub const stereo: ?[*:0]const u8 = "stereo";

pub const AudioPortFlags = enum(u32) {
    is_main = 1 << 0,
    supports_64_bits = 1 << 1,
    prefers_64_bits = 1 << 2,
    requires_common_sample_size = 1 << 3,
};

pub const AudioPortInfo = extern struct {
    id: Id,
    name: [name_size]u8,

    flags: AudioPortFlags,
    channel_count: u32,

    port_type: ?[*:0]const u8,

    in_place_pair: Id,
};

pub const PluginAudioPorts = extern struct {
    count: ?*const fn (
        plugin: *const Plugin,
        is_input: bool,
    ) callconv(.C) u32,

    get: ?*const fn (
        plugin: *const Plugin,
        index: u32,
        is_input: bool,
        info: *AudioPortInfo,
    ) callconv(.C) bool,
};

pub const AudioPortRescanFlags = enum(u32) {
    name = 1 << 0,
    flags = 1 << 1,
    channel_count = 1 << 2,
    port_type = 1 << 3,
    in_place_pair = 1 << 4,
    list = 1 << 5,
};

pub const HostAudioPorts = extern struct {
    isRescanFlagSupported: ?*const fn (
        host: *const Host,
        flag: AudioPortRescanFlags,
    ) callconv(.C) bool,

    rescan: ?*const fn (
        host: *const Host,
        flags: AudioPortRescanFlags,
    ) callconv(.C) void,
};
