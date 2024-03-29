# Makefile for 'sudoku' program
#
# Dylan, Jordan, Alex, Eric
#
# CS50 Spring '22
 
# executables
PROG = sudoku

# executables depend on their object files
OBJS = sudoku.o

# libraries
LLIBS = sudokulib/sudokulib.a libcs50/libcs50-given.a

# compilation
CFLAGS = -Wall -pedantic -std=c11 -ggdb -I/sudokulib -I/libcs50
CC = gcc

$(PROG): $(OBJS) $(LLIBS)
	$(CC) $(CFLAGS) $^ -o $@ -lm
	make -sC testing

# make libraries
$(LLIBS):
	make -sC libcs50
	make -sC sudokulib

PHONY: test clean
# clean all makefile made files and clean libraries

test: 
	bash testing/testing.sh &> testing/testing.out

clean:
	rm -rf *.dSYM  # MacOS debugger info
	rm -rf *~ *.o *.out
	rm -f $(PROG)
	make -sC sudokulib clean
	make -sC testing clean
