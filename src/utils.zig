const std = @import("std");
const fs = std.fs;
/// Read file from path. Returns the content of the file. Ensure to free the content to prevent memory leak.
pub fn readFileContent(path: []const u8, allocator: *std.mem.Allocator) ![]const u8 {
    // _ = path;
    const dir = fs.cwd();

    std.debug.print("\nOpening file in path {s}\n", .{path});

    const file = try dir.openFile(path, .{ .mode = .read_only });
    defer file.close();
    const file_status = try file.stat();
    const file_size = file_status.size;
    const buffer: []u8 = try allocator.alloc(u8, file_size);
    _ = try file.readAll(buffer);
    std.debug.print("content {s}", .{buffer});
    return buffer;
}
