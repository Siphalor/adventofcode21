def check_for_win(board, x, y):
    win = True

    for row in board:
        if row[x] != -1:
            win = False
            break

    if win:
        return True

    for n in board[y]:
        if n != -1:
            return False
    return True


def find(list, ele):
    for i, e in enumerate(list):
        if e == ele:
            return i
    return -1
