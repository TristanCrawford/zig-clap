pub const major: u32 = 1;
pub const minor: u32 = 1;
pub const revision: u32 = 10;

pub const Version = extern struct {
    major: u32,
    minor: u32,
    revision: u32,

    pub const current = Version{
        .major = major,
        .minor = minor,
        .revision = revision,
    };

    pub fn isCompatible(self: Version) bool {
        return self.major >= 1;
    }
};
