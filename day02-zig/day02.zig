const std = @import("std");

const input = @embedFile("./input");

const State = enum { NotStarted, FirstCheck, Increasing, Decreasing };

pub fn main() !void {
    try run(false);
    try run(true);
}

pub fn run(dampener: bool) !void {
    var lines = std.mem.splitSequence(u8, input, "\n");
    var safe_count: i32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var nums = std.mem.splitSequence(u8, line, " ");
        var safe = true;
        var cursor: i32 = 0;
        var length: i32 = 0;
        var ignore: i32 = -1;

        while ((dampener and ignore < length) or (ignore == -1)) {
            var last_num: i32 = -1;
            var state = State.NotStarted;
            cursor = 0;
            safe = true;

            while (nums.next()) |num| {
                if (cursor != ignore) {
                    const n = try std.fmt.parseInt(i32, num, 10);

                    const abs = @abs(last_num - n);

                    if (state != State.NotStarted) {
                        if (abs < 1 or abs > 3) {
                            safe = false;
                        }
                    }

                    switch (state) {
                        State.NotStarted => {
                            state = State.FirstCheck;
                        },
                        State.FirstCheck => {
                            if (n > last_num) {
                                state = State.Increasing;
                            }
                            if (n < last_num) {
                                state = State.Decreasing;
                            }
                        },
                        State.Increasing => {
                            if (n < last_num) {
                                safe = false;
                            }
                        },
                        State.Decreasing => {
                            if (n > last_num) {
                                safe = false;
                            }
                        },
                    }

                    if (!safe) {
                        break;
                    }

                    last_num = n;
                }

                cursor += 1;
                if (cursor >= length) {
                    length = cursor + 1;
                }
            }
            ignore += 1;

            if (safe) {
                safe_count += 1;
                break;
            } else {
                nums.reset();
            }
        }
    }

    std.debug.print("{}\n", .{safe_count});
}
