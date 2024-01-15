const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const gui_id: ?[*:0]const u8 = "clap.gui";

pub const win32: ?[*:0]const u8 = "win32";
pub const cocoa: ?[*:0]const u8 = "cocoa";
pub const x11: ?[*:0]const u8 = "x11";
pub const wayland: ?[*:0]const u8 = "wayland";

pub const Window = extern struct {
    api: ?[*:0]const u8,
    handle: extern union {
        cocoa: *anyopaque,
        x11: u32,
        win32: *anyopaque,
        ptr: *anyopaque,
    },
};

pub const GuiResizeHints = extern struct {
    can_resize_horizontally: bool,
    can_resize_vertically: bool,

    preserve_aspect_ratio: bool,
    aspect_ratio_width: u32,
    aspect_ratio_height: u32,
};

pub const PluginGui = extern struct {
    isApiSupported: ?*const fn (
        plugin: *const Plugin,
        api: ?[*:0]const u8,
        is_floating: bool,
    ) callconv(.C) bool,

    getPreferredApi: ?*const fn (
        plugin: *const Plugin,
        api: *?[*:0]const u8,
        is_floating: *bool,
    ) callconv(.C) bool,

    create: ?*const fn (
        plugin: *const Plugin,
        api: ?[*:0]const u8,
        is_floating: bool,
    ) callconv(.C) bool,

    destroy: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) void,

    setScale: ?*const fn (
        plugin: *const Plugin,
        scale: f64,
    ) callconv(.C) bool,

    getSize: ?*const fn (
        plugin: *const Plugin,
        width: *u32,
        height: *u32,
    ) callconv(.C) bool,

    canResize: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) bool,

    getResizeHints: ?*const fn (
        plugin: *const Plugin,
        hints: *GuiResizeHints,
    ) callconv(.C) bool,

    adjustSize: ?*const fn (
        plugin: *const Plugin,
        width: *u32,
        height: *u32,
    ) callconv(.C) bool,

    setSize: ?*const fn (
        plugin: *const Plugin,
        width: u32,
        height: u32,
    ) callconv(.C) bool,

    setParent: ?*const fn (
        plugin: *const Plugin,
        window: *Window,
    ) callconv(.C) bool,

    setTransient: ?*const fn (
        plugin: *const Plugin,
        window: *Window,
    ) callconv(.C) bool,

    suggestTitle: ?*const fn (
        plugin: *const Plugin,
        title: ?[*:0]const u8,
    ) callconv(.C) void,

    show: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) bool,

    hide: ?*const fn (
        plugin: *const Plugin,
    ) callconv(.C) bool,
};

pub const HostGui = extern struct {
    resizeHintsChanged: ?*const fn (
        host: *const Host,
    ) callconv(.C) void,

    requestResize: ?*const fn (
        host: *const Host,
        width: u32,
        height: u32,
    ) callconv(.C) bool,

    requestShow: ?*const fn (
        host: *const Host,
    ) callconv(.C) bool,

    requestHide: ?*const fn (
        host: *const Host,
    ) callconv(.C) bool,

    closed: ?*const fn (
        host: *const Host,
        was_destroyed: bool,
    ) callconv(.C) void,
};
