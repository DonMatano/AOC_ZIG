const std = @import("std");
const expectToEqual = std.testing.expectEqual;
const debugLog = std.debug.print;

const HousePosition = struct {
    x: isize,
    y: isize,
};

pub fn run() !void {
    _ = getNumberOfHousesPresentsDelivered("");
}

fn getNumberOfHousesPresentsDelivered(path: []const u8, allocator: std.mem.Allocator) !usize {
    var hashmap = std.AutoArrayHashMap(HousePosition, usize).init(allocator);
    defer hashmap.deinit();
    // Deliver present to first house.
    try hashmap.put(HousePosition{ .x = 0, .y = 0 }, 1);
    var lastHousePosition = HousePosition{ .x = 0, .y = 0 };
    // Go through each character in path.
    for (path) |c| {
        switch (c) {
            '>' => {
                const currentHousePosition = HousePosition{
                    .x = lastHousePosition.x + 1,
                    .y = lastHousePosition.y,
                };
                if (!hashmap.contains(currentHousePosition)) {
                    try hashmap.put(currentHousePosition, 1);
                }
                lastHousePosition = currentHousePosition;
            },
            '<' => {
                const currentHousePosition = HousePosition{
                    .x = lastHousePosition.x - 1,
                    .y = lastHousePosition.y,
                };
                if (!hashmap.contains(currentHousePosition)) {
                    try hashmap.put(currentHousePosition, 1);
                }
                lastHousePosition = currentHousePosition;
            },
            '^' => {
                const currentHousePosition = HousePosition{
                    .x = lastHousePosition.x,
                    .y = lastHousePosition.y + 1,
                };
                if (!hashmap.contains(currentHousePosition)) {
                    try hashmap.put(currentHousePosition, 1);
                }
                lastHousePosition = currentHousePosition;
            },
            'v' => {
                const currentHousePosition = HousePosition{
                    .x = lastHousePosition.x,
                    .y = lastHousePosition.y - 1,
                };
                if (!hashmap.contains(currentHousePosition)) {
                    try hashmap.put(currentHousePosition, 1);
                }
                lastHousePosition = currentHousePosition;
            },
            else => continue,
        }
    }
    debugLog("direction: {s} \n houses: {d}\n\n", .{ path, hashmap.count() });
    return hashmap.count();
}

test "get number of houses presents delivered" {
    const TestStruct = struct {
        input: []const u8,
        expect: usize,
    };
    const tests = [_]TestStruct{
        TestStruct{ .input = ">", .expect = 2 },
        TestStruct{ .input = "^>v<", .expect = 4 },
        TestStruct{ .input = "^v^v^v^v^v", .expect = 2 },
    };

    for (tests) |t| {
        try expectToEqual(t.expect, try getNumberOfHousesPresentsDelivered(t.input, std.testing.allocator));
    }
}
