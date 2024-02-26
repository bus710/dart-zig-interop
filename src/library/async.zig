// This is not async as a standalone Zig code, but to be used in the Dart async callback demo.

const std = @import("std");

pub fn main() !void {
    std.debug.print("{s}\n", .{"Hello from Zig"});
    _ = hello_world_async(@constCast("string as a param"), callback);
    std.debug.print("{s}\n", .{"Bye"});
    return;
}

fn callback(str: [*:0]u8) callconv(.C) void {
    std.debug.print("Hello from callback: {s}\n", .{str});
}

export fn hello_world_async(input: [*:0]u8, _callback: *const fn ([*:0]u8) callconv(.C) void) callconv(.C) void {
    std.debug.print("zig: {s}\n", .{input});
    const hello = "string from native function";
    _callback(@constCast(hello));
}
