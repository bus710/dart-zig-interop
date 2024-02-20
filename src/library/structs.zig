const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
var allocator = gpa.allocator();

const Coordinate = extern struct {
    latitude: f64,
    longitude: f64,
};

const Place = extern struct {
    name: [*]const u8,
    coordinate: Coordinate,
};

pub fn main() !void {
    std.debug.print("{s}\n", .{hello_world()});
    std.debug.print("{s}\n", .{hello_world_slice()});

    // check for leaks
    defer std.debug.assert(gpa.deinit() == .ok);

    const backwards = "backwards";
    const reversed_ptr = reverse(backwards, backwards.len) orelse {
        std.debug.print("failed to allocate reversed string\n", .{});
        return error.OutOfMemory;
    };
    defer free_string(reversed_ptr);

    const reversed = std.mem.span(reversed_ptr);
    std.debug.print("{s} reversed is {s}\n", .{ backwards, reversed });

    const coord: *Coordinate = create_coordinate(3.5, 4.6);
    std.debug.print("Coordinate is lat {d:.2}, long {d:.2}\n", .{ coord.latitude, coord.longitude });

    const place: *Place = create_place("My Home", 42.0, 24.0);
    const printable: [*:0]const u8 = @ptrCast(place.name);
    std.debug.print("The name of my place is {s} at {d:.2}, {d:.2}\n", .{ printable, place.coordinate.latitude, place.coordinate.longitude });

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

//
fn reverse_zig(input: []const u8) ![:0]u8 {
    // It seems like you want this to be a NUL-terminated string
    var reversed_str = try allocator.allocSentinel(u8, input.len, 0);
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        reversed_str[input.len - i - 1] = input[i];
    }
    return reversed_str;
}

/// returns `null` on allocation failure
export fn reverse(ptr: [*]const u8, length: u32) callconv(.C) ?[*:0]u8 {
    const slice = ptr[0..length];
    return reverse_zig(slice) catch return null;
}

export fn free_string(ptr: [*:0]u8) void {
    const slice = std.mem.span(ptr);
    allocator.free(slice);
}

export fn create_coordinate(latitude: f64, longitude: f64) callconv(.C) *Coordinate {
    var coordinate = Coordinate{
        .latitude = latitude,
        .longitude = longitude,
    };
    return &coordinate;
}

export fn create_place(name: [*]const u8, latitude: f64, longitude: f64) callconv(.C) *Place {
    std.debug.print("zig => {any}\n", .{name});
    const printable: [*:0]const u8 = @ptrCast(name);
    std.debug.print("zig => {s}\n", .{printable});

    var place = Place{
        .name = name,
        .coordinate = create_coordinate(latitude, longitude).*,
    };

    return &place;
}

export fn distance(c1: Coordinate, c2: Coordinate) f64 {
    const xd = c2.latitude - c1.latitude;
    const yd = c2.longitude - c1.longitude;

    return std.math.sqrt(xd * xd + yd * yd);
}

export fn print_name(name: [*]const u8) callconv(.C) [*:0]u8 {
    std.debug.print("zig => {any}\n", .{name});
    const printable: [*:0]const u8 = @ptrCast(name);
    std.debug.print("zig => {s}\n", .{printable});
    return @constCast(printable);
}
