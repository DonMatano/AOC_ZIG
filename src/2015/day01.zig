const std = @import("std");
const debugPrint = std.debug.print;
const expectToEqual = std.testing.expectEqual;
const file_path = "src/2015/files/day01.txt";
const utils = @import("../utils.zig");
pub fn countFloors() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    var file_allocator = gpa.allocator();
    const content = try utils.readFileContent(file_path, &file_allocator);
    defer file_allocator.free(content);
    const numOfFloors = try getFloor(content);
    debugPrint("\nnumber of floors {d}\n", .{numOfFloors});
}

fn getFloor(floorsParanthetis: []const u8) !isize {
    var floorNum: isize = 0;
    var hasEverEnteredBasement = false;
    for (floorsParanthetis, 1..) |paranthetis, i| {
        switch (paranthetis) {
            '(' => floorNum += 1,
            ')' => floorNum -= 1,
            else => continue,
        }
        if (!hasEverEnteredBasement and floorNum == -1) {
            debugPrint("Entered to basement at char position {d}\n", .{i});
            hasEverEnteredBasement = true;
        }
    }
    return floorNum;
}

test "day 1 getFloor()" {
    const TestStruct = struct {
        input: []const u8,
        expect: isize,
    };
    const tests = [_]TestStruct{
        TestStruct{ .input = "(())", .expect = 0 },
        TestStruct{ .input = "()()", .expect = 0 },
        TestStruct{ .input = "(((", .expect = 3 },
        TestStruct{ .input = "(()(()(", .expect = 3 },
        TestStruct{ .input = "))(((((", .expect = 3 },
        TestStruct{ .input = "())", .expect = -1 },
        TestStruct{ .input = "))(", .expect = -1 },
        TestStruct{ .input = ")))", .expect = -3 },
        TestStruct{ .input = ")())())", .expect = -3 },
    };

    for (tests) |aTest| {
        try expectToEqual(aTest.expect, getFloor(aTest.input));
    }
}
