package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
	"strconv"
)

func part01(file *os.File) {
	reader := bufio.NewReader(file)

	distribution := make([]int64, 10)

	for {
		part, err := reader.ReadString(',')
		age, err2 := strconv.Atoi(part[:len(part)-1])
		if err2 != nil {
			fmt.Printf("failed to read number: %v\n", err2)
		}
		distribution[age]++
		if errors.Is(err, io.EOF) {
			break
		}
	}

	for i := 0; i < 80; i++ {
		for age, count := range distribution {
			if age == 0 {
				distribution[7] += count
				distribution[9] += count
				distribution[0] = 0
			} else {
				distribution[age-1] += count
				distribution[age] = 0
			}
		}
	}

	var sum int64 = 0
	for _, count := range distribution {
		sum += count
	}
	fmt.Printf("%v lanternfish\n", sum)
}
