#include <stdio.h>

int in_bounds(int x, int y, int w, int h) { return (x >= 0 && y >= 0 && x < w && y < h); }

int count_plot(int w, int h, unsigned char grid[h][w], char c) {
    int perimeter = 0;
    int area = 0;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            if (grid[y][x] != c) {continue;}
            area++;
            if (x == 0     || grid[y][x - 1] != grid[y][x]) {perimeter++;}
            if (x == w - 1 || grid[y][x + 1] != grid[y][x]) {perimeter++;}
            if (y == 0     || grid[y - 1][x] != grid[y][x]) {perimeter++;}
            if (y == h - 1 || grid[y + 1][x] != grid[y][x]) {perimeter++;}
        }
    }
    return perimeter * area;
}

int get_sides(int sx, int sy, int ex, int ey, int w, int h, unsigned char grid[h][w]) {
    int sides = 0;
    for (int y = sy - 1; y <= ey; y++) {
        for (int x = sx - 1; x <= ex; x++) {
            int count = 0;
            if (in_bounds(x, y, w, h)         && grid[y][x]         == 1) {count++;}
            if (in_bounds(x, y + 1, w, h)     && grid[y + 1][x]     == 1) {count++;}
            if (in_bounds(x + 1, y, w, h)     && grid[y][x + 1]     == 1) {count++;}
            if (in_bounds(x + 1, y + 1, w, h) && grid[y + 1][x + 1] == 1) {count++;}
            if (count == 1 || count == 3) {
                sides++;
            } else if (count == 2) {
                if (in_bounds(x, y, w, h) && grid[y][x] == 1 &&
                    in_bounds(x + 1, y + 1, w, h) && grid[y + 1][x + 1] == 1) {
                    sides += 2;
                }
                else if (in_bounds(x + 1, y, w, h) && grid[y][x + 1] == 1 &&
                         in_bounds(x, y + 1, w, h) && grid[y + 1][x] == 1) {
                    sides += 2;
                }
            }
        }
    }
    return sides;
}

int count_plot_sides(int w, int h, unsigned char grid[h][w], char c) {
    int area = 0;
    int sx = -1, sy = -1;
    int ex = -1, ey = -1;
    for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
            if (grid[y][x] != c) {continue;}
            area++;
            if (sx == -1) {
                sx = x; sy = y;
                ex = x; ey = y;
            }
            if (x < sx) {sx = x;}
            if (x > ex) {ex = x;}
            if (y < sy) {sy = y;}
            if (y > ey) {ey = y;}
        }
    }
    int sides = get_sides(sx, sy, ex, ey, w, h, grid);
    return sides * area;
}

void flood_fill(int x, int y, int w, int h, unsigned char grid[h][w], unsigned char to) {
    char c = grid[y][x];
    grid[y][x] = to;

    if (x != 0     && grid[y][x - 1] == c)
    { flood_fill(x - 1, y, w, h, grid, to); }

    if (x != w - 1 && grid[y][x + 1] == c)
    { flood_fill(x + 1, y, w, h, grid, to); }

    if (y != 0     && grid[y - 1][x] == c)
    { flood_fill(x, y - 1, w, h, grid, to); }

    if (y != h - 1 && grid[y + 1][x] == c)
    { flood_fill(x, y + 1, w, h, grid, to); }
}

int main() {
    FILE* input = fopen("input", "r");
    int width  = 140;
    int height = 140;
    int y = 0;
    int x = 0;
    unsigned char grid[height][width];

    char a = 0;
    while (a != EOF) {
        a = fgetc(input);
        if (a >= 'A' && a <= 'Z') {
            grid[y][x] = a;
            x++;
        } else if (a == '\n') {
            x = 0;
            y++;
        }
    }

    int result = 0;
    int result2 = 0;
    for (int i = 0; i < height; i++) { 
        for (int j = 0; j < width; j++) { 
            if (grid[i][j] == 0) { continue; }
            flood_fill(j, i, width, height, grid, 1);
            result += count_plot(width, height, grid, 1);
            result2 += count_plot_sides(width, height, grid, 1);
            flood_fill(j, i, width, height, grid, 0);
        }
    }
    printf("%d\n", result);
    printf("%d\n", result2);
}
