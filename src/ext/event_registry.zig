const Host = @import("../host.zig").Host;

pub const event_registry_id: ?[*:0]const u8 = "clap.event-registry";

pub const HostEventRegistry = extern struct {
    query: ?*const fn (
        host: *const Host,
        space_name: ?[*:0]const u8,
        space_id: *u16,
    ) callconv(.C) bool,
};
