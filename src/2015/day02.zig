const std = @import("std");
const expectToEqual = std.testing.expectEqual;
const debugPrint = std.debug.print;
const file_path = "src/2015/files/day02.txt";
const Dimensions = struct {
    length: usize,
    width: usize,
    height: usize,
};
pub fn run() !void {
    const ArrayList = std.ArrayList;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const file_allocator = gpa.allocator();

    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();
    var arr = ArrayList(u8).init(file_allocator);
    defer {
        arr.deinit();
    }
    var total_size: usize = 0;
    while (true) {
        reader.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => {
                const dimensions = try getDimensionFromString(arr.items);

                total_size += calculateTotalWrapNeeded(dimensions);
                break;
            },
            else => return err,
        };
        const dimensions = try getDimensionFromString(arr.items);
        total_size += calculateTotalWrapNeeded(dimensions);
        arr.clearRetainingCapacity();
    }
    debugPrint("Total Size of wrapper needed: {d}", .{total_size});
}

const DimensionError = error{GotNullNextError};
fn getDimensionFromString(dimensions_in_strings: []const u8) !Dimensions {
    var it = std.mem.splitScalar(u8, dimensions_in_strings, 'x');
    const parseInt = std.fmt.parseInt;
    const l = if (it.next()) |n| n else return DimensionError.GotNullNextError;
    const w = if (it.next()) |n| n else return DimensionError.GotNullNextError;
    const h = if (it.next()) |n| n else return DimensionError.GotNullNextError;
    return Dimensions{
        .length = try parseInt(usize, l, 10),
        .width = try parseInt(usize, w, 10),
        .height = try parseInt(usize, h, 10),
    };
}

fn calculateTotalWrapNeeded(wrapperDimension: Dimensions) usize {
    var total_wrap: usize = 0;
    const lw = wrapperDimension.length * wrapperDimension.width;
    const wh = wrapperDimension.width * wrapperDimension.height;
    const hl = wrapperDimension.height * wrapperDimension.length;
    var lowestDimension = if (lw < wh) lw else wh;
    lowestDimension = if (hl < lowestDimension) hl else lowestDimension;
    total_wrap = (lw * 2) + (wh * 2) + (hl * 2) + lowestDimension;
    debugPrint("l: {d}, w: {d}, h: {d}\n", .{
        wrapperDimension.length,
        wrapperDimension.width,
        wrapperDimension.height,
    });
    debugPrint("least dimenstion {d}\n", .{lowestDimension});
    debugPrint("totalWrap Needed {d}\n", .{total_wrap});

    return total_wrap;
}

test "day 2 calculateTotalWrapNeeded" {
    const TestStruct = struct {
        input: Dimensions,
        expect: usize,
    };

    const tests = [_]TestStruct{
        TestStruct{ .input = Dimensions{ .length = 2, .width = 3, .height = 4 }, .expect = 58 },
        TestStruct{ .input = Dimensions{ .length = 1, .width = 1, .height = 10 }, .expect = 43 },
    };
    for (tests) |t| {
        try expectToEqual(t.expect, calculateTotalWrapNeeded(t.input));
    }
}
