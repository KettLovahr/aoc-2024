extends MainLoop

func _initialize():
	var input: String = FileAccess.open("input", FileAccess.READ).get_as_text().trim_suffix("\n")
	var stones: Array = input.split(" ")
	stones = stones.map(func(a): return int(a))
	print(count_stones(stones, 25))
	print(count_stones(stones, 75))

func count_stones(a: Array, qty: int) -> int:
	var d: Dictionary = {}
	for n in a:
		if n in d: d[n] += 1
		else: d[n] = 1
	for i in qty:
		var nd: Dictionary = {}
		for k in d.keys():
			if k == 0:
				if 1 in nd.keys(): nd[1] += d[k]
				else: nd[1] = d[k]
			elif len(str(k)) % 2 == 0:
				var st: String = str(k)
				var l = int(st.substr(0, len(st) / 2))
				var r = int(st.substr(len(st) / 2, -1))
				if l in nd.keys(): nd[l] += d[k]
				else: nd[l] = d[k]
				if r in nd.keys(): nd[r] += d[k]
				else: nd[r] = d[k]
			else:
				if k * 2024 in nd.keys(): nd[k * 2024] += d[k]
				else: nd[k * 2024] = d[k]
		d = nd
			
	var ret: int = 0
	for k in d.keys():
		ret += d[k]
	return ret

func _process(_delta):
	return true
