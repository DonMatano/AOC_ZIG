pub fn TestStruct(comptime INPUT_TYPE: type, comptime EXPECT_TYPE: type) type {
    return struct {
        input: INPUT_TYPE,
        expect: EXPECT_TYPE,
    };
}
