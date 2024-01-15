const Version = @import("version.zig").Version;
const Process = @import("process.zig").Process;
const ProcessStatus = @import("process.zig").ProcessStatus;

pub const PluginDescriptor = extern struct {
    clap_version: Version,
    id: ?[*:0]const u8,
    name: ?[*:0]const u8,
    vendor: ?[*:0]const u8,
    url: ?[*:0]const u8,
    manual_url: ?[*:0]const u8,
    support_url: ?[*:0]const u8,
    version: ?[*:0]const u8,
    description: ?[*:0]const u8,
    features: [*]const ?[*:0]const u8,
};

pub const Plugin = extern struct {
    desc: *const PluginDescriptor,
    plugin_data: ?*anyopaque,
    init: ?*const fn (plugin: *const Plugin) callconv(.C) bool,
    destroy: ?*const fn (plugin: *const Plugin) callconv(.C) void,
    activate: ?*const fn (plugin: *const Plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool,
    deactivate: ?*const fn (plugin: *const Plugin) callconv(.C) void,
    startProcessing: ?*const fn (plugin: *const Plugin) callconv(.C) bool,
    stopProcessing: ?*const fn (plugin: *const Plugin) callconv(.C) void,
    reset: ?*const fn (plugin: *const Plugin) callconv(.C) void,
    process: ?*const fn (plugin: *const Plugin, process: *const Process) callconv(.C) ProcessStatus,
    getExtension: ?*const fn (plugin: *const Plugin, id: ?[*:0]const u8) callconv(.C) ?*const anyopaque,
    onMainThread: ?*const fn (plugin: *const Plugin) callconv(.C) void,
};
