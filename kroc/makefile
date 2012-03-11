#
# This is a makefile to build the code for the two assignments in the DIKU
# course "Ekstrem multiprogrammering"
#
# To be able to compile this code you should have the KRoC files in your PATH
# and the variables OCSEARCH and LD_LIBRARY_PATH set to something meaningful.
# This can be done by runnibg setup.{sh,csh} from the KRoC distribution.
#
# Also you should set KROCBASE variable to point to the directory of your KRoC
# installation that contains the 'vtinclude' and 'vtlib' directories .

KROCBASE=~/install/linux/share/kroc

##############################################################################

INC=$(KROCBASE)/vtinclude
LIB=$(KROCBASE)/vtlib

# Adding -l creates a dynamically loadable .so file
#FLAGS=-S -d -v -w 
FLAGS= 

CC=cc -g -pedantic -Wall
KROC=kroc -I$(INC) -L$(LIB) $(FLAGS) -lcourse -lfile

CIRCUIT=test-adder test-mux create-input test-reference
PAWN=pawn-chess

all: test-circuit test-chess 

.PHONY: test test-pawn test-chess clean

.SUFFIXES:
.SUFFIXES: .occ 


test: test-circuit test-chess

test-circuit: $(CIRCUIT)
	@echo
	@echo " ###############################################" 
	@echo " #                                             #"
	@echo " # Testing the digital circuit implementations #"
	@echo " #                                             #"
	@echo " ###############################################"
	@echo
	@sleep 2
	./create-input 5                     > data.mux.tmp
	./create-input 4 2                   > data.adder.tmp
	./test-reference  data.mux.tmp   mux > test.c.mux.tmp
	./test-reference  data.adder.tmp add > test.c.adder.tmp
	cat data.mux.tmp   | ./test-mux      > test.occ.mux.tmp
	cat data.adder.tmp | ./test-adder    > test.occ.adder.tmp
	diff test.c.mux.tmp   test.occ.mux.tmp   || (echo "Mux test failed"   && false)
	diff test.c.adder.tmp test.occ.adder.tmp || (echo "Adder test failed" && false)
	@echo
	@echo " #######################"
	@echo " #                     #"
	@echo " #  Tests succeeded\!  #"
	@echo " #                     #"
	@echo " #######################"
	@sleep 5

test-chess: $(PAWN)
	@echo
	@echo " #############################################################################"
	@echo " #                                                                           #"
	@echo " # Running pawn chess simulation                                             #"
	@echo " #                                                                           #"
	@echo " # Look at the top of the file pawn-chess.occ if you want to set a different #"
	@echo " # depth or allow random picking among equal utility best moves.             #"
	@echo " #                                                                           #"
	@echo " #############################################################################"
	@echo
	@sleep 5
	@./pawn-chess

%:%.occ makefile circuitlib.occ
	$(KROC) $<

%:%.c makefile
	$(CC) $< -o $@

clean:
	@rm -fv $(CIRCUIT) $(PAWN) *.tce *.o *.tmp

