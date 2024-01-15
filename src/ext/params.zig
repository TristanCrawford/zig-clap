const Id = @import("../id.zig").Id;
const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const name_size = @import("../string_sizes.zig").name_size;
const path_size = @import("../string_sizes.zig").path_size;
const InputEvents = @import("../events.zig").InputEvents;
const OutputEvents = @import("../events.zig").OutputEvents;

pub const params_id: ?[*:0]const u8 = "clap.params";

pub const ParamInfoFlags = enum(u32) {
    is_stepped = 1 << 0,
    is_periodic = 1 << 1,
    is_hidden = 1 << 2,
    is_readonly = 1 << 3,
    is_bypass = 1 << 4,
    is_automatable = 1 << 5,
    is_automatable_per_note_id = 1 << 6,
    is_automatable_per_key = 1 << 7,
    is_automatable_per_channel = 1 << 8,
    is_automatable_per_port = 1 << 9,
    is_modulatable = 1 << 10,
    is_modulatable_per_note_id = 1 << 11,
    is_modulatable_per_key = 1 << 12,
    is_modulatable_per_channel = 1 << 13,
    is_modulatable_per_port = 1 << 14,
    requires_process = 1 << 15,
    is_enum = 1 << 16,
};

pub const ParamInfo = extern struct {
    id: Id,
    flags: ParamInfoFlags,
    cookie: ?*anyopaque,
    name: [name_size]u8,
    module: [path_size]u8,
    min_value: f64,
    max_value: f64,
    default_value: f64,
};

pub const PluginParams = extern struct {
    count: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) u32,

    getInfo: ?*const fn (
        plugin: *const Plugin,
        param_index: u32,
        param_info: *ParamInfo,
    ) callconv(.C) bool,

    getValue: ?*const fn (
        plugin: *const Plugin,
        param_id: Id,
        out_value: *f64,
    ) callconv(.C) bool,

    valueToText: ?*const fn (
        plugin: *const Plugin,
        param_id: Id,
        value: f64,
        out_buffer: [*:0]u8,
        out_buffer_capacity: u32,
    ) callconv(.C) bool,

    textToValue: ?*const fn (
        plugin: *const Plugin,
        param_id: Id,
        param_value_text: [*:0]const u8,
        out_value: *f64,
    ) callconv(.C) bool,

    flush: ?*const fn (
        plugin: *const Plugin,
        in: *const InputEvents,
        out: *const OutputEvents,
    ) callconv(.C) void,
};

pub const ParamRescanFlags = enum(u32) {
    values = 1 << 0,
    text = 1 << 1,
    info = 1 << 2,
    all = 1 << 3,
};

pub const ParamClearFlags = enum(u32) {
    all = 1 << 0,
    automations = 1 << 1,
    modulations = 1 << 2,
};

pub const HostParams = extern struct {
    rescan: ?*const fn (
        host: *const Host,
        flags: ParamRescanFlags,
    ) callconv(.C) void,

    clear: ?*const fn (
        host: *const Host,
        param_id: Id,
        flags: ParamClearFlags,
    ) callconv(.C) void,

    requestFlush: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,
};
