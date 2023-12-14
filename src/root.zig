const std = @import("std");
const testing = std.testing;
const Allocator = std.mem.Allocator;

pub const Foo = struct {
    allocator: *Allocator,
    width: i32,
    height: i32,
    name: []const u8,

    pub fn init(allocator: *Allocator, width: i32, height: i32) *Foo {
        const foo = allocator.create(Foo) catch unreachable;
        foo.*.allocator = allocator;
        foo.*.width = width;
        foo.*.height = height;
        foo.*.name = "Foo";
        return foo;
    }

    pub fn incrementWidth(self: *Foo) void {
        self.width += 1;
        self.bar.incrementId();
    }
};

export fn makeFoo(allocator: *Allocator, width: i32, height: i32) *Foo {
    return Foo.init(allocator, width, height);
}

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
