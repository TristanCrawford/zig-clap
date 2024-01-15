pub const IStream = extern struct {
    ctx: *anyopaque,
    read: ?fn (stream: *const IStream, buffer: *anyopaque, size: u64) callconv(.C) i64,
};

pub const OStream = extern struct {
    ctx: *anyopaque,
    write: ?fn (stream: *const IStream, buffer: *const anyopaque, size: u64) callconv(.C) i64,
};
