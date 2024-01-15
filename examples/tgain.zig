const std = @import("std");
const clap = @import("clap");

const my_plugin_desc = clap.PluginDescriptor{
    .clap_version = clap.Version.current,
    .id = "com.tristan.gain",
    .name = "TGain",
    .vendor = "Tristan",
    .url = null,
    .manual_url = null,
    .support_url = null,
    .version = "1.0.0",
    .description = "Zig Gain Plugin",
    .features = &[_]?[*:0]const u8{
        clap.plugin_feature.audio_effect,
        clap.plugin_feature.stereo,
        null,
    },
};

const MyPlugin = struct {
    plugin: clap.Plugin = undefined,
    host: *const clap.Host = undefined,
};

var my_plugin = MyPlugin{};
var gain_value: f64 = 0.5;

fn paramsCount(plugin: *const clap.Plugin) callconv(.C) u32 {
    _ = plugin;
    return 1;
}

fn paramsGetInfo(plugin: *const clap.Plugin, param_index: u32, param_info: *clap.ParamInfo) callconv(.C) bool {
    _ = plugin;
    _ = param_index;

    param_info.id = 0;
    param_info.flags = .requires_process;
    param_info.cookie = null;
    std.mem.copyForwards(u8, &param_info.name, "Gain");
    std.mem.copyForwards(u8, &param_info.module, "Params/Gain");
    param_info.min_value = 0.0;
    param_info.max_value = 1.0;
    param_info.default_value = 0.5;

    return true;
}

fn paramsGetValue(
    plugin: *const clap.Plugin,
    param_id: clap.Id,
    out_value: *f64,
) callconv(.C) bool {
    _ = plugin;
    _ = param_id;

    out_value.* = gain_value;

    return true;
}

fn paramsValueToText(plugin: *const clap.Plugin, param_id: clap.Id, value: f64, out_buffer: [*:0]u8, out_buffer_capacity: u32) callconv(.C) bool {
    _ = plugin;
    _ = param_id;
    _ = value;

    _ = std.fmt.bufPrint(out_buffer[0..out_buffer_capacity], "{d:.2}", .{gain_value}) catch return false;

    return true;
}

fn paramsTextToValue(plugin: *const clap.Plugin, param_id: clap.Id, param_value_text: [*:0]const u8, out_value: *f64) callconv(.C) bool {
    _ = plugin;
    _ = param_id;

    out_value.* = std.fmt.parseFloat(f64, std.mem.span(param_value_text)) catch 0.0;

    return true;
}

fn paramsFlush(plugin: *const clap.Plugin, in: *const clap.InputEvents, out: *const clap.OutputEvents) callconv(.C) void {
    _ = plugin;
    _ = in;
    _ = out;
}

const my_params = clap.PluginParams{
    .count = paramsCount,
    .getInfo = paramsGetInfo,
    .getValue = paramsGetValue,
    .valueToText = paramsValueToText,
    .textToValue = paramsTextToValue,
    .flush = paramsFlush,
};

fn pluginInit(plugin: *const clap.Plugin) callconv(.C) bool {
    _ = plugin;

    return true;
}

fn pluginDestroy(plugin: *const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

fn pluginActivate(plugin: *const clap.Plugin, sample_rate: f64, min_frames_count: u32, max_frames_count: u32) callconv(.C) bool {
    _ = plugin;
    _ = sample_rate;
    _ = min_frames_count;
    _ = max_frames_count;

    return true;
}

fn pluginDeactivate(plugin: *const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

fn pluginStartProcessing(plugin: *const clap.Plugin) callconv(.C) bool {
    _ = plugin;

    return true;
}

fn pluginStopProcessing(plugin: *const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

fn pluginReset(plugin: *const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

fn pluginProcess(plugin: *const clap.Plugin, process: *const clap.Process) callconv(.C) clap.ProcessStatus {
    _ = plugin;

    const nframes: u32 = process.frames_count;
    const nev: u32 = process.in_events.size(process.in_events);

    var ev_index: u32 = 0;
    var next_ev_frame = if (nev > 0) 0 else nframes;

    for (0..nframes) |i| {
        while (ev_index < nev and next_ev_frame == i) {
            const hdr = process.in_events.get(process.in_events, ev_index);

            if (hdr.time != i) {
                next_ev_frame = hdr.time;
                break;
            }

            if (hdr._type == .param_value) {
                var event: *const clap.EventParamValue = @alignCast(@ptrCast(hdr));
                gain_value = event.value;
            }

            ev_index += 1;

            if (ev_index == nev) {
                next_ev_frame = nframes;
                break;
            }
        }

        for (i..next_ev_frame) |j| {
            const in_l = process.audio_inputs[0].data_64[0][j];
            const in_r = process.audio_inputs[0].data_64[1][j];

            process.audio_outputs[0].data_64[0][j] = in_l * gain_value;
            process.audio_outputs[0].data_64[1][j] = in_r * gain_value;
        }
    }

    return ._continue;
}

fn pluginGetExtension(plugin: *const clap.Plugin, id: ?[*:0]const u8) callconv(.C) ?*const anyopaque {
    _ = plugin;

    if (std.mem.eql(u8, std.mem.span(id.?), std.mem.span(clap.params_id.?))) {
        return &my_params;
    }

    return null;
}

fn pluginOnMainThread(plugin: *const clap.Plugin) callconv(.C) void {
    _ = plugin;
}

fn factoryGetPluginCount(factory: *const clap.PluginFactory) callconv(.C) u32 {
    _ = factory;

    return 1;
}

fn factoryGetPluginDescriptor(factory: *const clap.PluginFactory, index: u32) callconv(.C) ?*const clap.PluginDescriptor {
    _ = factory;
    _ = index;

    return &my_plugin_desc;
}

fn factoryCreatePlugin(factory: *const clap.PluginFactory, host: *const clap.Host, plugin_id: ?[*:0]const u8) callconv(.C) ?*const clap.Plugin {
    _ = factory;

    if (!clap.Version.isCompatible(host.clap_version)) {
        return null;
    }

    const ids_match = std.mem.eql(
        u8,
        std.mem.span(my_plugin_desc.id.?),
        std.mem.span(plugin_id.?),
    );

    if (ids_match) {
        my_plugin.plugin = clap.Plugin{
            .desc = &my_plugin_desc,
            .plugin_data = &my_plugin,
            .init = pluginInit,
            .destroy = pluginDestroy,
            .activate = pluginActivate,
            .deactivate = pluginDeactivate,
            .startProcessing = pluginStartProcessing,
            .stopProcessing = pluginStopProcessing,
            .reset = pluginReset,
            .process = pluginProcess,
            .getExtension = pluginGetExtension,
            .onMainThread = pluginOnMainThread,
        };

        my_plugin.host = host;

        return &my_plugin.plugin;
    }

    return null;
}

const my_plugin_factory: clap.PluginFactory = .{
    .getPluginCount = factoryGetPluginCount,
    .getPluginDescriptor = factoryGetPluginDescriptor,
    .createPlugin = factoryCreatePlugin,
};

fn entryInit(plugin_path: ?[*:0]const u8) callconv(.C) bool {
    _ = plugin_path;

    return true;
}

fn entryDeinit() callconv(.C) void {}

fn entryGetFactory(factory_id: ?[*:0]const u8) callconv(.C) ?*const anyopaque {
    const ids_match = std.mem.eql(
        u8,
        std.mem.span(factory_id.?),
        std.mem.span(clap.plugin_factory_id.?),
    );

    if (ids_match) {
        return &my_plugin_factory;
    }

    return null;
}

const my_plugin_entry: clap.PluginEntry = .{
    .clap_version = clap.Version.current,
    .init = entryInit,
    .deinit = entryDeinit,
    .getFactory = entryGetFactory,
};

comptime {
    @export(my_plugin_entry, .{ .name = "clap_entry" });
}
