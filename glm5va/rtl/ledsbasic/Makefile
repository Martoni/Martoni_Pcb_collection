include ../config.mk

PRFLAGS += -ccf src/$(TOP).ccf -cCP
TOP = ledsbasic

ledsbasic_tb: test/ledsbasic_tb.v src/ledsbasic.v src/matrix.v
	iverilog -g2005-sv $^ -o $@
