const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

const Data = extern struct {
    Text: [*:0]const u8,
};

pub fn main() !void {
    std.debug.print("{s}\n", .{hello_world()});
    std.debug.print("{s}\n", .{hello_world_slice()});

    // check for leaks
    defer std.debug.assert(gpa.deinit() == .ok);

    var data = Data{
        .Text = "aaa",
    };

    const data2: *Data = create_data(&data);
    const printable2: [*:0]const u8 = @ptrCast(data2.Text);
    std.debug.print("The name of my place is {s} \n", .{printable2});

    return;
}

export fn hello_world() [*:0]u8 {
    const hello = "Hello World";
    const slice = hello[0..hello.len];
    return @constCast(slice);
}

export fn hello_world_slice() callconv(.C) [*:0]u8 {
    const hello = "Hello World from Slice";
    const slice = hello[0..hello.len];
    return @constCast(slice);
}

export fn create_data(data: *Data) callconv(.C) *Data {
    std.debug.print("zig => {any}\n", .{data.Text});
    std.debug.print("zig => {s}\n", .{data.Text});
    // const printable: [*:0]const u8 = @ptrCast(data.Text);
    // std.debug.print("zig => {s}\n", .{printable});
    return data;
}
