extends MainLoop

var xmas_offsets: Array[Array] = [
	[ Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0) ],
	[ Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, 2), Vector2i(0, 3) ],
	[ Vector2i(0, 0), Vector2i(1, 1), Vector2i(2, 2), Vector2i(3, 3) ],
	[ Vector2i(0, 0), Vector2i(-1, 1), Vector2i(-2, 2), Vector2i(-3, 3) ],
]

var x_mas_offsets: Array[Array] = [
	[ Vector2i(-1, -1), Vector2i(0, 0), Vector2i(1, 1), ],
	[ Vector2i(-1, 1), Vector2i(0, 0), Vector2i(1, -1), ],
]

func _initialize():
	var file = FileAccess.open("input", FileAccess.READ)
	var content = file.get_as_text(true).trim_suffix("\n").split("\n")
	var xmas_matches: int = 0
	var x_mas_matches: int = 0

	var height: int = len(content)
	var width: int = len(content[0])

	for i in height:
		for j in width:
			xmas_matches += check_xmas(content, i, j)
			x_mas_matches += check_x_mas(content, i, j)

	print(xmas_matches)
	print(x_mas_matches)

func safe_index(grid: PackedStringArray, line: int, row: int) -> String:
	var height: int = len(grid)
	var width: int = len(grid[0])

	if line >= height or line < 0 or row >= width or row < 0:
		return ""
	return grid[line][row]

func check_xmas(grid: PackedStringArray, line: int, row: int) -> int:
	var matches: int = 0
	for pat in xmas_offsets:
		var word: String = ""
		for offset in pat:
			word += safe_index(grid, line + offset.y, row + offset.x)
		if word == "XMAS" or word == "SAMX":
			matches += 1
	return matches

func check_x_mas(grid: PackedStringArray, line: int, row: int) -> int:
	var matches: int = 0
	for pat in x_mas_offsets:
		var word: String = ""
		for offset in pat:
			word += safe_index(grid, line + offset.y, row + offset.x)
		if word == "MAS" or word == "SAM":
			matches += 1
	return 1 if matches == 2 else 0

func _process(_delta: float) -> bool: 
	return true
