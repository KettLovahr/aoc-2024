file = open("input", "r").readlines()
width, height = (len(file[0].strip()), len(file))
antenna = {}
antinodes = set()

def antinode_pos(ln, rn, c): return (ln[0] - (rn[0] - ln[0]) * c, ln[1] - (rn[1] - ln[1]) * c)
def bound_check(n): return n[0] >= 0 and n[0] < width and n[1] >= 0 and n[1] < height

x, y = (0, 0)
for line in file:
    x = 0
    line = line.strip()
    for c in line:
        if c.isalnum():
            if c in antenna:
                antenna[c].append((x, y))
            else:
                antenna[c] = [(x, y)]
        x += 1
    y += 1

for c in antenna:
    for node in antenna[c]:
        for other in antenna[c]:
            if node == other:
                continue
            new_anti = antinode_pos(node, other, 1)
            if bound_check(new_anti):
                antinodes.add(new_anti)
print(len(antinodes))

for c in antenna:
    for node in antenna[c]:
        for other in antenna[c]:
            if len(antenna[c]) == 1: continue
            if node == other:
                antinodes.add((node[0], node[1]))
                continue
            count = 1
            while True:
                new_anti = antinode_pos(node, other, count)
                if bound_check(new_anti):
                    antinodes.add(new_anti)
                    count += 1
                else:
                    break
print(len(antinodes))
