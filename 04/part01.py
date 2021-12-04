from util import *


def run(input_data):
    chosen_nums, boards = input_data

    for num in chosen_nums:

        for board in boards:
            for y, row in enumerate(board):
                x = find(row, num)
                if x != -1:
                    row[x] = -1
                    win = check_for_win(board, x, y)

                    if win:
                        unmarked = 0
                        for row in board:
                            for n in row:
                                if n != -1:
                                    unmarked += n

                        print(f"unmarked sum: {unmarked}\nwin number: {num}\nproduct: {unmarked * num}")
                        return

