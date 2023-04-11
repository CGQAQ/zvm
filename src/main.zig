const std = @import("std");

fn streql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();
    const args = try std.process.argsAlloc(gpa);
    defer std.process.argsFree(gpa, args);

    if (args.len < 2) {
        std.debug.print("usage: {s} <command> [args...]\n", .{args[0]});
        return;
    }

    if (streql(args[1], "help")) {
        std.debug.print(
            \\ usage: {s} <command> [args...]
            \\   help: show this help message
            \\   install: install a version of zig
            \\   uninstall: uninstall a version of zig
        , .{
            args[0],
        });
        return;
    }

    if (streql(args[1], "install")) {
        if (args.len > 2) {
            std.debug.print("usage: {s} {s}\n", .{ args[0], args[1] });
            try install(args[2]);
        } else {
            try install("latest");
        }
        return;
    } else if (streql(args[1], "uninstall") and args.len == 2) {
        std.debug.print("unknown command: {s}\n", .{args[1]});
    }
}

fn install(tag: []const u8) !void {
    if (streql(tag, "latest")) {
        std.debug.print("installing latest\n", .{});
        return;
    }

    std.debug.print("installing {s}\n", .{tag});
}
