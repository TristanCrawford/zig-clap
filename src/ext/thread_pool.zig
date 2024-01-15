const Host = @import("../host.zig").Host;
const Plugin = @import("../plugin.zig").Plugin;

pub const thread_pool_id: ?[*:0]const u8 = "clap.thread-pool";

pub const PluginThreadPool = extern struct {
    exec: ?*const fn (
        plugin: *const Plugin,
        task_index: u32,
    ) callconv(.C) void,
};

pub const HostThreadPool = extern struct {
    requestExec: ?*const fn (
        host: *const Host,
        num_tasks: u32,
    ) callconv(.C) bool,
};
