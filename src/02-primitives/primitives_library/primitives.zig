const std = @import("std");

pub fn main() void {
    std.debug.print("3 + 5 = {d}\n", .{sum(3, 5)});

    const mult: *i64 = multiply(3, 5);
    std.debug.print("3 * 5 = {d}\n", .{mult});

    return;
}

export fn sum(a: i64, b: i64) i64 {
    return a + b;
}

export fn multiply(a: i64, b: i64) *i64 {
    const allocator = std.heap.page_allocator;
    var mult = allocator.alloc(i64, 1) catch null;
    if (mult == null) {
        return null;
    }
    mult = a * b;
    return mult;
}
