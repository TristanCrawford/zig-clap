pub const AudioBuffer = extern struct {
    data_32: [*][*]f32,
    data_64: [*][*]f64,
    channel_count: u32,
    latency: u32,
    constant_mask: u64,
};
