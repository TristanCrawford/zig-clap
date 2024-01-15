const Id = @import("../id.zig").Id;
const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const name_size = @import("../string_sizes.zig").name_size;
const AudioPortInfo = @import("audio_ports.zig").AudioPortInfo;

pub const config_id: ?[*:0]const u8 = "clap.audio-ports-config";
pub const config_info_id: ?[*:0]const u8 = "clap.audio-ports-config-info/draft-0";

pub const AudioPortsConfig = extern struct {
    id: Id,
    name: [name_size]u8,

    input_port_count: u32,
    output_port_count: u32,

    has_main_input: bool,
    main_input_channel_count: u32,
    main_input_port_type: ?[*:0]const u8,

    has_main_output: bool,
    main_output_channel_count: u32,
    main_output_port_type: ?[*:0]const u8,
};

pub const PluginAudioPortsConfig = extern struct {
    count: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) u32,

    get: ?*const fn (
        plugin: *const Plugin,
        index: u32,
        config: *AudioPortsConfig,
    ) callconv(.C) bool,

    select: ?*const fn (
        plugin: *const Plugin,
        config_id: Id,
    ) callconv(.C) bool,
};

pub const PluginAudioPortsConfigInfo = extern struct {
    currentConfig: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) Id,

    get: ?*const fn (
        plugin: *const Plugin,
        config_id: Id,
        port_index: u32,
        is_input: bool,
        info: *AudioPortInfo,
    ) callconv(.C) bool,
};

pub const HostAudioPortsConfig = extern struct {
    rescan: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
