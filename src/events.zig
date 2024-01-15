const Id = @import("id.zig").Id;
const BeatTime = @import("fixedpoint.zig").BeatTime;
const SecTime = @import("fixedpoint.zig").SecTime;

pub const EventType = enum(u16) {
    note_on = 0,
    note_off = 1,
    note_choke = 2,
    note_end = 3,
    note_expression = 4,
    param_value = 5,
    param_mod = 6,
    param_gesture_begin = 7,
    param_gesture_end = 8,
    transport = 9,
    midi = 10,
    midi_sysex = 11,
    midi2 = 12,
};

pub const EventFlags = enum(u32) {
    is_live = 1 << 0,
    dont_record = 1 << 1,
};

pub const EventHeader = extern struct {
    size: u32,
    time: u32,
    space_id: u16,
    _type: EventType,
    flags: EventFlags,
};

pub const EventNote = extern struct {
    header: EventHeader,
    noteId: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    velocity: f64,
};

pub const NoteExpression = enum(c_long) {
    volume = 0,
    pan = 1,
    tuning = 2,
    vibrato = 3,
    expression = 4,
    brightness = 5,
    pressure = 6,
};

pub const EventNoteExpression = extern struct {
    header: EventHeader,
    expression_id: NoteExpression,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamValue = extern struct {
    header: EventHeader,
    paramId: Id,
    cookie: *anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    value: f64,
};

pub const EventParamMod = extern struct {
    header: EventHeader,
    param_id: Id,
    cookie: *anyopaque,
    note_id: i32,
    port_index: i16,
    channel: i16,
    key: i16,
    amount: f64,
};

pub const EventParamGesture = extern struct {
    header: EventHeader,
    param_id: Id,
};

pub const TransportFlags = enum(u32) {
    has_tempo = 1 << 0,
    has_beats_timeline = 1 << 1,
    has_seconds_timeline = 1 << 2,
    has_time_signature = 1 << 3,
    is_playing = 1 << 4,
    is_recording = 1 << 5,
    is_loop_active = 1 << 6,
    is_within_pre_roll = 1 << 7,
};

pub const EventTransport = extern struct {
    header: EventHeader,
    flags: TransportFlags,
    song_pos_beats: BeatTime,
    song_pos_seconds: SecTime,
    tempo: f64,
    tempo_inc: f64,
    loop_start_beats: BeatTime,
    loop_end_beats: BeatTime,
    loop_start_seconds: SecTime,
    loop_end_seconds: SecTime,
    bar_start: BeatTime,
    bar_number: i32,
    tsig_num: u16,
    tsig_denom: u16,
};

pub const EventMidi = extern struct {
    header: EventHeader,
    port_index: u16,
    data: [3]u8,
};

pub const EventMidiSysEx = extern struct {
    header: EventHeader,
    port_index: u16,
    buffer: [*]const u8,
    size: u32,
};

pub const EventMidi2 = extern struct {
    header: EventHeader,
    port_index: u16,
    data: [4]u8,
};

pub const InputEvents = extern struct {
    ctx: *anyopaque,
    size: *const fn (list: *const InputEvents) callconv(.C) u32,
    get: *const fn (list: *const InputEvents, index: u32) callconv(.C) *const EventHeader,
};

pub const OutputEvents = extern struct {
    ctx: *anyopaque,
    tryPush: ?*const fn (list: *const OutputEvents, event: *const EventHeader) bool,
};
