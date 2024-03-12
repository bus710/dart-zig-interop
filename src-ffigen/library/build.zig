const std = @import("std");
// const Builder = std.build.Builder;
// const builtin = std.builtin;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    for (LIBRARIES) |LIBRARY| {
        const lib = b.addSharedLibrary(.{
            .name = LIBRARY.name,
            .root_source_file = .{ .path = LIBRARY.path },
            .target = target,
            .optimize = optimize,
            .version = .{ .major = 0, .minor = 1, .patch = 0 },
        });
        b.installArtifact(lib);
        _ = lib.getEmittedH();
        _ = lib.linkLibC();
    }
}

const library = struct {
    name: []const u8,
    path: []const u8,
};

const LIBRARIES = [_]library{
    .{
        .name = "hello",
        .path = "hello.zig",
    },
    .{
        .name = "primitives",
        .path = "primitives.zig",
    },
    .{
        .name = "structs",
        .path = "structs.zig",
    },
};
