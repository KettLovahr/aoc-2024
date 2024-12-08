extends MainLoop

var xmas_offsets: Array[Array] = [
	[ [0, 0], [1, 0], [2, 0], [3, 0] ],
	[ [0, 0], [0, 1], [0, 2], [0, 3] ],
	[ [0, 0], [1, 1], [2, 2], [3, 3] ],
	[ [0, 0], [-1, 1], [-2, 2], [-3, 3] ],
]
var x_mas_offsets: Array[Array] = [
	[ [-1, -1], [0, 0], [1, 1], ],
	[ [-1, 1], [0, 0], [1, -1], ],
]

func _initialize():
	var file = FileAccess.open("input", FileAccess.READ)
	var content = file.get_as_text(true).trim_suffix("\n").split("\n")
	var xmas_matches: int = 0
	var x_mas_matches: int = 0

	for i in len(content):
		for j in len(content[i]):
			if content[i][j] == "A":
				x_mas_matches += check_x_mas(content, i, j)
			elif content[i][j] in "XS":
				xmas_matches += check_xmas(content, i, j)

	print(xmas_matches)
	print(x_mas_matches)

func g_index(grid: PackedStringArray, line: int, col: int) -> String:
	if line >= len(grid) or line < 0 or col >= len(grid[0]) or col < 0:
		return ""
	return grid[line][col]

func check_xmas(grid: PackedStringArray, line: int, col: int) -> int:
	var matches: int = 0
	for pat in xmas_offsets:
		var word: String = ""
		for offset in pat:
			word += g_index(grid, line + offset[1], col + offset[0])
		if word == "XMAS" or word == "SAMX":
			matches += 1
	return matches

func check_x_mas(grid: PackedStringArray, line: int, col: int) -> int:
	for pat in x_mas_offsets:
		var word: String = ""
		for offset in pat:
			word += g_index(grid, line + offset[1], col + offset[0])
		if word != "MAS" and word != "SAM":
			return 0
	return 1

func _process(_delta: float) -> bool: 
	return true
