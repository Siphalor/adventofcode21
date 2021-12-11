function main()
    if length(ARGS) != 2
        print("incorrect number of arguments")
        exit(1)
    end

    data = undef
    open(ARGS[2], "r") do file
        data = mapreduce(line->map(c->parse(Int8, c), split(line, "")), (a,b)->hcat(a,b), readlines(file))
    end

    if ARGS[1] == "part01"
        part01(data)
    elseif ARGS[1] == "part02"

    end
end

function part01(data)
    flashes = 0
    for i in 1:100
        for x in 1:size(data, 1)
            for y in 1:size(data, 2)
                bump(data, x, y)
            end
        end

        for x in 1:size(data, 1)
            for y in 1:size(data, 2)
                if data[x, y] > 9
                    flashes += 1
                    data[x, y] = 0
                end
            end
        end
    end

    print(flashes)
end

function bump(data, x, y)
    data[x, y] += 1
    if data[x, y] == 10
        for dx in -1:1
            cx = x + dx
            if cx <= 0 || cx > size(data, 1)
                continue
            end
            for dy in -1:1
                if dx == 0 && dy == 0
                    continue
                end
                cy = y + dy
                if cy <= 0 || cy > size(data, 2)
                    continue
                end

                bump(data, cx, cy)
            end
        end
    end
end

main()
