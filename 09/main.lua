function main()
	if (#arg ~= 2)
	then
		print("incorrect number of arguments")
		return
	end

	if (arg[1] == "part01")
	then
		xpcall(part01, error_handler)
	end
end

function error_handler(err)
	print("execution failed with: ", err)
end

function part01()
	local data, risk

	i = 1
	data = {}
	for value in io.lines(arg[2])
	do
		data[i] = value
		i = i + 1
	end

	risk = 0
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

			risk = risk + 1 + current

			::continue::
		end
	end

	print(risk)
end

function char_at(s, index)
	return string.sub(s, index, index)
end

main()