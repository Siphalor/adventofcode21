import sys
from typing import IO, Any

import part01

BOARD_SIZE = 5


def main():
    if len(sys.argv) != 3:
        print("incorrect number of arguments")
        return

    _, part, input_file_path = sys.argv

    input_data = read_input_data(input_file_path)
    if input_data is None:
        print("failed to parse input")
        return

    if part == "part01":
        part01.run(input_data)
    elif part == "part02":
        pass
    else:
        print("unrecognized part")


def read_input_data(file_path):
    with open(file_path, "r") as file:
        chosen_nums = [int(n) for n in file.readline().split(",")]
        file.readline()
        boards = []
        while True:
            board = read_board(file)
            if board is None:
                break
            boards.append(board)

        return chosen_nums, boards


def read_board(file: IO[Any]):
    board = []
    for i in range(BOARD_SIZE):
        line = file.readline()
        if not line:
            return None

        board.append([int(n) for n in line.split()])
    file.readline()

    return board


if __name__ == '__main__':
    main()
