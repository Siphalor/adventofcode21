package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) != 3 {
		println("incorrect number of arguments")
		return
	}

	file, err := os.OpenFile(os.Args[2], os.O_RDONLY, 0777)
	if err != nil {
		fmt.Printf("failed to open file: %v\n", err)
		return
	}

	switch os.Args[1] {
	case "part01":
		part01(file)
	default:
		println("unknown part")
	}
}
