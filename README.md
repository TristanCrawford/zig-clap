# zig-clap

Work-in-progress Zig bindings for the [CLAP](https://github.com/free-audio/clap) plugin format.

Bear in mind, at this point these are (mostly) a direct translation of the CLAP C header and don't provide any convenience wrappers, use with caution.

---

An example gain plugin can be found in `examples/tgain.zig`, which `zig build` will build by default.
