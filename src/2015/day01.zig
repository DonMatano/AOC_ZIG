const std = @import("std");
const expectToEqual = std.testing.expectEqual;
pub fn countFloors() void {}

fn getFloor(floorsParanthetis: []const u8) !isize {
    var floorNum: isize = 0;
    for (floorsParanthetis) |paranthetis| {
        switch (paranthetis) {
            '(' => floorNum += 1,
            ')' => floorNum -= 1,
            else => unreachable,
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
