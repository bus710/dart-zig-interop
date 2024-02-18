const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

pub fn main() void {
    std.debug.print("{s}\n", .{hello_world()});

    const backwards = "backwards";
    const backwards_copy = allocator.dupe(u8, backwards) catch undefined;
    const reversed = reverse(&backwards_copy, 9);
    std.debug.print("{s} reversed is {s}\n", .{ backwards, reversed.* });

    return;
}

export fn hello_world() *const [11:0]u8 {
    return "Hello World";
}

export fn reverse(ptr: *const []u8, length: u32) callconv(.C) *[]u8 {
    var reversed_str = allocator.alloc(u8, length + 1) catch undefined;
    if (&reversed_str[0] == undefined) return undefined;

    var i: u8 = 0;
    while (i < length) : (i += 1) {
        reversed_str[length - i - 1] = ptr.*[i];
    }

    // Just to show
    i = 0;
    while (i < length) : (i += 1) {
        std.debug.print("{d}, {c}, {c} \n", .{ i, ptr.*[i], reversed_str[i] });
    }

    return &reversed_str;
}

//
//
//
//
//
//
//
//

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
