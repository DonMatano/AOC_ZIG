const std = @import("std");
const expectToEqual = std.testing.expectEqual;
const debugPrint = std.debug.print;
pub fn run() !void {}

const Dimensions = struct {
    length: usize,
    width: usize,
    height: usize,
};

fn calculateTotalWrapNeeded(wrapperDimension: Dimensions) usize {
    var totalWrap: usize = 0;
    const lw = wrapperDimension.length * wrapperDimension.width;
    const wh = wrapperDimension.width * wrapperDimension.height;
    const hl = wrapperDimension.height * wrapperDimension.length;
    var lowestDimension = if (lw < wh) lw else wh;
    lowestDimension = if (hl < lowestDimension) hl else lowestDimension;
    totalWrap = (lw * 2) + (wh * 2) + (hl * 2) + lowestDimension;
    debugPrint("l: {d}, w: {d}, h: {d}\n", .{
        wrapperDimension.length,
        wrapperDimension.width,
        wrapperDimension.height,
    });
    debugPrint("least dimenstion {d}\n", .{lowestDimension});
    debugPrint("totalWrap Needed {d}\n", .{totalWrap});

    return totalWrap;
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
