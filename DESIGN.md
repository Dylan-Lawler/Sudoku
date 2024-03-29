# Final Project - Sudoku
## Design spec - Submitted 5/23/2022
### Team 10 - Alex Jones, Jordan Kirkbride, Dylan Lawler, Eric Leung
### CS50, Spring 2022

# Overview
The design for Sudoku is based on notes from IMPLEMENTATION.md, lecture notes, 
and final project descriptions. Refer to the aforementioned resources for more details as well.

This set of modules will contain all the functionality needed to make and solve Sudoku boards. The functional decomposition of the major modules is outlined below.

# Sudoku Generator

## Purpose
The purpose of the Sudoku generator is to create a Sudoku puzzle that follows each of the required rules: every number from $1$ to $9$ must appear exactly once in every row, column, and $3 \times 3$ square region.

## Pseudocode
The Sudoku board generator, contained in a function called `make_puzzle`, has a recursive structure and takes a `board` struct, an `int row`, and an `int column` as parameters. It operates as follows:

1. Create a randomly shuffled list containing the numbers 1 through 9 exactly once
2. If the board is already full, return `true`
3. If we have reached the end of a row, move to the next
4. Then, loop over all indices in our randomly shuffled candidates list

    a. If it wouldn't break Sudoku rules to place the chosen number at the current (`row, col`) position in the board, then insert it
    
    b. Now recurse: if `make_puzzle(board, row, column+1)` also returns `true`, then return `true`
    
    c. If the current number doesn't work, then insert a 0 in the current board position
    
5. If no numbers worked and we exited the above loop, then return `false`

The above pseudocode realizes a backtracking solution to puzzle generation. At first, we tentatively insert a number in a given board position, so long as doing so does not immediately violate Sudoku rules. We then try to insert a number in the position after. However, if we break Sudoku rules in this attempt (i.e. no numbers work), then we return to the previous position and try a different number.

# Sudoku Solver

## Purpose
This part of the module solves a premade Sudoku board. That is, it inserts numbers in the empty spaces according to the rules outlined in the project description. Our solver also checks to see if the board passed to it has two solutions or a unique solution.

## Pseudocode
The Sudoku solver operates in much the same way as the puzzle generator (which is to be expected, since the generator is just "solving" and empty puzzle board). It is contained in the `solve_puzzle` function, and takes as parameters a `board`, a `row`, and a `column`. However, instead of returning a boolean, it returns an integer `count` representing the number of distinct solutions found so far. The algorithm flow of the recursive function is as follows:

1. If the board is solved, save the solution to the input board struct and return `count+1`.
2. If not, then the previous function (that checks if the board is full) will assign parameters `row` and `column` to the coordinates of the first empty space found
3. Then, loop over all possible number insertions 1 through 9

    a. If it wouldn't break Sudoku rules to place the current number at the current board position, then insert it
    
    b. Now recurse: call `solve_puzzle` on the board at the current position
    
    c. If the above call returns `count > 1`, return `count`
    
    d. If the current number doesn't work, then insert a 0 in the board at the current position
    
4. If no numbers worked, then insert 0 at the current position and return `count` to trigger backtracking

It can be seen that the flow of this algorithm follows the same basic logic as the `make_puzzle` function above. We tentatively insert numbers in positions that aren't violating any rules, but we backtrack and try different numbers if this causes problems later on.

# Helper functions

There are a number of helper functions contained in the main `sudoku.c` file, as well as in a `board` module contained in a separate library. Simple descriptions of these functions are provided below.

## Main file

### clear_spaces

This function randomly deletes entries from a fully initialized and valid Sudoku board. As per the requirements spec, our function *guarantees* that the board ends up having a unique solution, namely by calling `solve_puzzle`, checking the number of solutions after each cleared space, and re-inserting the number (or, if we've reached the end of the board, starting over) if `solve_puzzle` returns > 1 solutions.

### check

This function takes in a board, a number between $1$ and $9$, and a row and column, and checks to see whether inserting the number in the board at the given `(row,column)` position violates any of the rules of Sudoku. Checking the rows and columns is handled by one for-loop, and checking the rest of the $3 \times 3$ box is handled by another set of nested for-loops. We return `true` if the attempted insert is valid.

### number_list

This function generates a randomly shuffled list of the numbers $1$ through $9$. We first add these numbers to an array, in order. We then shuffle them by looping through the list and randomly swapping pairs of numbers.

## board module

### board_new

This function generates a number blank board with number of rows/columns set by a single parameter. Loops over an array stored in the `board` struct and populates the array with $0$s.

### get_number

Returns the number stored in the input board at a given `(row,column)` position.

### insert_number

Inserts a number in the input board at a given `(row,column)` position.

### full_board

Checks to see whether the board is already full by looping over the entire board and looking for $0$ entries.

### print_board

Loops over the board and prints rows using a print helper function.

### get_row

Returns the `counters` object corresponding to a given row of the board array.
 
### get_size

Returns the number of rows (== number of columns) in the board.

### get_box_size

Returns the square root of the number of rows (== number of columns) in the board. This will always be an `int` because the number of rows must be a perfect square.

# Program pipeline

In the `main` function, the control sequence is as follows:

1. Create a new 9x9 Sudoku board
2. Populate the entire board with valid numerical entries
3. Delete 40 of these entries at random
4. Print the unsolved board
5. Solve the puzzle
6. Print the solved board

# Major data structures

## board

We define a new `board_t` struct that contains an array of counters, as well as an integer number of rows.

## counters

Within the board pointer array, the "rows" are really counters objects, whose indices are "columns" and whose counts are the entries at the `(row,column)` coordinates of the board.
