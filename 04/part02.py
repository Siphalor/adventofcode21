from util import *


def run(input_data):
    chosen_nums, boards = input_data

    boards_cnt = len(boards)
    for num in chosen_nums:
        for board in reversed(boards):
            for y, row in enumerate(board):
                x = find(row, num)
                if x != -1:
                    row[x] = -1
                    if check_for_win(board, x, y):
                        boards_cnt -= 1
                        del boards[boards.index(board)]

                if boards_cnt == 0:
                    unmarked = 0
                    for row in board:
                        for ele in row:
                            if ele != -1:
                                unmarked += ele

                    print(f"unmarked sum: {unmarked}\nwin number: {num}\nproduct: {unmarked * num}")
                    return

