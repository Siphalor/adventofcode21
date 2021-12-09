function main()
	if (#arg ~= 2)
	then
		print("incorrect number of arguments")
		return
	end

	if (arg[1] == "part01")
	then
		xpcall(part01, error_handler)
	elseif (arg[1] == "part02")
	then
		xpcall(part02, error_handler)
	end
end

function error_handler(err)
	print("execution failed with: ", err)
end

function read_data()
	local i = 1
	local data = {}
	for value in io.lines(arg[2])
	do
		data[i] = value
		i = i + 1
	end
	return data
end

function find_minima(data)
	local minima = {}
	for y = 1,#data,1
	do
		for x = 1,#data[y],1
		do
			current = char_at(data[y], x)
			if y > 1 and current >= char_at(data[y-1], x)
			then
				goto continue
			end

			if x > 1 and current >= char_at(data[y], x - 1)
			then
				goto continue
			end

			if y < #data and current >= char_at(data[y+1], x)
			then
				goto continue
			end

			if x < #data[y] and current >= char_at(data[y], x + 1)
			then
				goto continue
			end

			minima[#minima+1] = {y, x}

			::continue::
		end
	end
	return minima
end

function part01()
	local data = read_data()

	risk = 0
	local minima = find_minima(data)
	for i, m in ipairs(minima)
	do 
		risk = risk + 1 + char_at(data[m[1]], m[2])
	end

	print(risk)
end

function part02()
	local data = read_data()
	local basin_data = {}
	for y = 1,#data,1
	do
		basin_data[y] = {}
		for x = 1,#data[y],1
		do
			basin_data[y][x] = char_at(data[y], x) + 0
		end
	end
	local basins = {}

	local minima = find_minima(data)
	for i, m in ipairs(minima)
	do
		basins[i] = 1
		basin_data[m[1]][m[2]] = -i
	end

	local current
	local changed = true
	while changed
	do
		changed = false
		for y = 1,#basin_data,1
		do
			for x = 1,#basin_data[y],1
			do
				current = basin_data[y][x]
				if current >= 0
				then
					goto continue
				end

				if y > 1 and basin_data[y-1][x] >= 0 and basin_data[y-1][x] < 9
				then
					basin_data[y-1][x] = current
					basins[-current] = basins[-current] + 1
					changed = true
				end

				if x > 1 and basin_data[y][x-1] >= 0 and basin_data[y][x-1] < 9
				then
					basin_data[y][x-1] = current
					basins[-current] = basins[-current] + 1
					changed = true
				end

				if y < #basin_data and basin_data[y+1][x] >= 0 and basin_data[y+1][x] < 9
				then
					basin_data[y+1][x] = current
					basins[-current] = basins[-current] + 1
					changed = true
				end

				if x < #basin_data[y] and basin_data[y][x+1] >= 0 and basin_data[y][x+1] < 9
				then
					basin_data[y][x+1] = current
					basins[-current] = basins[-current] + 1
					changed = true
				end
				::continue::
			end
		end
	end

	table.sort(basins, function(a, b)
		return a > b
	end)
	print(basins[1] * basins[2] * basins[3])
end

function char_at(s, index)
	return string.sub(s, index, index)
end

function replace_char_at(s, with, at)
	return string.sub(s, 1, at - 1) .. with .. string.sub(s, at + 1)
end

main()
