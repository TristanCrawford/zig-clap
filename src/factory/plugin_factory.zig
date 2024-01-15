const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;
const PluginDescriptor = @import("../plugin.zig").PluginDescriptor;

pub const plugin_factory_id: ?[*:0]const u8 = "clap.plugin-factory";

pub const PluginFactory = extern struct {
    getPluginCount: ?*const fn (factory: *const PluginFactory) callconv(.C) u32,
    getPluginDescriptor: ?*const fn (factory: *const PluginFactory, index: u32) callconv(.C) ?*const PluginDescriptor,
    createPlugin: ?*const fn (factory: *const PluginFactory, host: *const Host, plugin_id: ?[*:0]const u8) callconv(.C) ?*const Plugin,
};
