const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() !void {
    // check for leaks
    defer std.debug.assert(gpa.deinit() == .ok);

    std.debug.print("{s}\n", .{"Hello World - Async"});
    _ = hello_world_async();

    return;
}

export fn hello_world_async(input: [*:0]u8, callback: *const fn ([*:0]u8) callconv(.C) void) callconv(.C) void {
    var i: u8 = 0;
    const fin: [*:0]const u8 = "Fin";

    while (i < 3) : (i = i + 1) {
        std.time.sleep(std.time.ms_per_s * 100);
        std.debug.print("{d} - {s}\n", .{ i, input });
        callback(@constCast(fin));
    }
}
