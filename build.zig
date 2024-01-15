const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const plugin = b.addSharedLibrary(.{
        .name = "TGain",
        .root_source_file = .{ .path = "examples/tgain.zig" },
        .target = target,
        .optimize = optimize,
    });

    plugin.addAnonymousModule("clap", .{
        .source_file = .{ .path = "src/clap.zig" },
    });

    const plugin_install = b.addInstallFileWithDir(plugin.getOutputSource(), .lib, "TGain.clap");
    plugin_install.step.dependOn(&plugin.step);

    b.getInstallStep().dependOn(&plugin_install.step);
}
