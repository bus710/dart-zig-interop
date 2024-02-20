const std = @import("std");

pub fn main() void {
    hello_world();

    return;
}

export fn hello_world() void {
    std.debug.print("Hello, World\n", .{});
}
