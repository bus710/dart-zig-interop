const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() void {
    // check for leaks
    defer std.debug.assert(gpa.deinit() == .ok);

    std.debug.print("3 + 5 = {d}\n", .{sum(3, 5)});

    const mult: *i64 = multiply(3, 5);
    std.debug.print("3 * 5 = {d}\n", .{mult.*});

    free_pointer(mult);

    var sub_num: i64 = 3;
    std.debug.print("3 - 5 = {d}\n", .{subtract(&sub_num, 5)});

    return;
}

export fn sum(a: i64, b: i64) i64 {
    return a + b;
}

export fn multiply(a: i64, b: i64) callconv(.C) *i64 {
    var mult = allocator.alloc(i64, 1) catch undefined;
    mult[0] = a * b;
    return &mult[0];
}

export fn free_pointer(ptr: *i64) void {
    if (ptr == undefined) {
        return;
    }
    const p: *[1]i64 = ptr;
    allocator.free(p);
}

export fn subtract(a: *i64, b: i64) i64 {
    return a.* - b;
}
