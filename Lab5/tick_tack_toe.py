''' Tic tac toe '''

import random

def is_player_mark_correct(player_mark):
    ''' Checks if player_mark is correct '''
    if player_mark in ("X", "O"):
        return True
    return False

def read_player_mark():
    ''' Reads player_mark from user '''
    player_mark = input("Podaj znak, ktorym chcesz grac (X lub O): ")

    while not is_player_mark_correct(player_mark):
        player_mark = input("Błąd. Podaj prawidłowy znak (X lub O): ")
    return player_mark

def get_bot_mark_based_on_player_mark(player_mark):
    ''' Returns bot_mark based on player_mark '''
    if player_mark == "X":
        return "O"
    return "X"

def print_board(board):
    ''' Prints board in the console '''
    print("\nTIC TAC TOE")
    print("+---+---+---+")
    print(f"| {board[1]} | {board[2]} | {board[3]} |")
    print("+---+---+---+")
    print(f"| {board[4]} | {board[5]} | {board[6]} |")
    print("+---+---+---+")
    print(f"| {board[7]} | {board[8]} | {board[9]} |")
    print("+---+---+---+")

def check_if_field_is_free(field_number, board):
    ''' Checks if passed field number is free on the board '''
    if board[field_number] == " ":
        return True
    return False

def read_field_number(board):
    ''' Read field number from the user '''
    field_number = input("Podaj numer pola, na ktorym chcesz wykonac ruch: ")
    field_incorrect = True

    while field_incorrect:
        if not field_number.isdigit():
            field_number = input("Podaj wartosc liczbowa: ")
            continue
        field_number = int(field_number)
        if field_number <= 0 or field_number > 9:
            field_number = input("Podaj wartosc liczbowa z zakresu 0-9: ")
            continue

        if not check_if_field_is_free(field_number, board):
            field_number = input("Podaj pole, ktore jest wolne: ")
            continue

        field_incorrect = False
    return field_number

def player_move(player_mark, board):
    ''' Performs player's move '''
    field_number = read_field_number(board)
    board[field_number] = player_mark

def move_if_only_one_of_the_field_is_free(fields, mark_to_check, mark_to_insert, board):
    ''' Performs move if only one field in passed list "fields" is free '''
    number_of_occupied_fields = 0
    number_of_free_fields = 0
    empty_field_index = 0

    for field in fields:
        if board[field] == mark_to_check:
            number_of_occupied_fields = number_of_occupied_fields + 1
        if check_if_field_is_free(field, board):
            number_of_free_fields = number_of_free_fields + 1
            empty_field_index = field

    if number_of_occupied_fields == 2 and number_of_free_fields == 1:
        board[empty_field_index] = mark_to_insert
        return True
    return False

def bot_move(bot_mark, player_mark, board):
    ''' Performs a bot's move '''
    winning_fields = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9],
                      [3, 5, 7]]

    # Try to win
    for fields in winning_fields:
        if move_if_only_one_of_the_field_is_free(fields, bot_mark, bot_mark, board):
            return
    # Try to block player
    for fields in winning_fields:
        if move_if_only_one_of_the_field_is_free(fields, player_mark, bot_mark, board):
            return
    # Random field
    field = random.randint(1, 9)
    while not check_if_field_is_free(field, board):
        field = random.randint(1, 9)

    board[field] = bot_mark

def check_if_there_are_any_free_fields(board):
    ''' Checks if there are any free fields '''
    number_of_occupied_fields = 0

    for field in board.keys():
        if not check_if_field_is_free(field, board):
            number_of_occupied_fields += 1

    if number_of_occupied_fields == 9:
        return False
    return True

def check_for_win_or_draw(player_mark, board):
    ''' Checks if there are win or draw '''
    if not check_if_there_are_any_free_fields(board):
        print_board(board)
        print("Remis!")
        return True
    winning_fields = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9],
                      [3, 5, 7]]

    for fields in winning_fields:
        if (board[fields[0]] == board[fields[1]] and board[fields[0]] == board[fields[2]] and
                board[fields[0]] != " "):
            if board[fields[0]] == player_mark:
                print_board(board)
                print("Wygrales!")
            else:
                print_board(board)
                print("Bot wygral")
            return True
    return False

def main():
    ''' Main method of the program '''
    player_mark = read_player_mark()
    bot_mark = get_bot_mark_based_on_player_mark(player_mark)
    board = {1: " ", 2: " ", 3: " ",
             4: " ", 5: " ", 6: " ",
             7: " ", 8: " ", 9: " "}

    while True:
        print_board(board)
        player_move(player_mark, board)
        if check_for_win_or_draw(player_mark, board):
            break
        bot_move(bot_mark, player_mark, board)
        if check_for_win_or_draw(player_mark, board):
            break

main()
