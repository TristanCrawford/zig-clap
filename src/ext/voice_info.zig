const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const voice_info_id: ?[*:0]const u8 = "clap.voice-info";

pub const VoiceInfoFlags = enum(u64) {
    supports_overlapping_notes = 1 << 0,
};

pub const VoiceInfo = extern struct {
    voice_count: u32,
    voice_capacity: u32,
    flags: VoiceInfoFlags,
};

pub const PluginVoiceInfo = extern struct {
    get: ?*const fn (
        plugin: *const Plugin,
        info: *VoiceInfo,
    ) callconv(.C) bool,
};

pub const HostVoiceInfo = extern struct {
    changed: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
