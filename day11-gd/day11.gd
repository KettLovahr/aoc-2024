extends MainLoop

func _initialize():
	var stones: Array = Array(FileAccess.open("input", FileAccess.READ).get_as_text().trim_suffix("\n").split(" ")).map(func(a): return int(a))
	var d: Dictionary = {}
	for n in stones:
		if n in d: d[n] += 1
		else:      d[n] = 1
	for i in 75:
		d = count_stones(d)
		if   i == 24: print(result(d))
		elif i == 74: print(result(d))

func count_stones(d: Dictionary) -> Dictionary:
	var nd: Dictionary = {}
	for k in d.keys():
		if d[k] == 0: continue
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
			var n = k * 2024
			if n in nd.keys(): nd[n] += d[k]
			else: nd[n] = d[k]
	return nd

func result(d: Dictionary):
	var ret: int = 0
	for k in d.keys(): ret += d[k]
	return ret

func _process(_delta):
	return true
