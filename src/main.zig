const std = @import("std");
const windows = std.os.windows;
const builtin = @import("builtin");

const Foo = @import("root.zig").Foo;

// Windows
extern "kernel32" fn GetProcAddress(h_module: windows.HMODULE, fn_name: windows.LPCSTR) callconv(windows.WINAPI) ?windows.FARPROC;
extern "kernel32" fn LoadLibraryA(fn_name: windows.LPCSTR) callconv(windows.WINAPI) ?windows.HMODULE;

var add: *const fn (i32, i32) i32 = undefined;
var makeFoo: *const fn (*std.mem.Allocator, i32, i32) *Foo = undefined;

fn win32LoadDllFunctionPointers() void {
    const dll = LoadLibraryA("zig-out/lib/zig-dll-demo.dll");
    if (dll != null) {
        add = @as(@TypeOf(add), @ptrCast(@alignCast(GetProcAddress(dll.?, "add"))));
        makeFoo = @as(@TypeOf(makeFoo), @ptrCast(@alignCast(GetProcAddress(dll.?, "makeFoo"))));
    }
}

fn loadDLLFunctionPointers() !void {
    var dll_file = try std.DynLib.open("zig-out/lib/zig-dll-demo.dll");
    add = dll_file.lookup(@TypeOf(add), "add").?;
    makeFoo = dll_file.lookup(@TypeOf(makeFoo), "makeFoo").?;
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    //win32LoadDllFunctionPointers();

    try loadDLLFunctionPointers();

    const result = add(1, 2);
    std.debug.print("add(1,2) = {}\n", .{result});

    const foo = makeFoo(&allocator, 72, 49);
    std.debug.print("foo = {}\n", .{foo});
}
