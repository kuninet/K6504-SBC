#
# Makefile
#

.SUFFIXES: .asm .p .hex .sr

all:	out-6502.hex

.p.hex:
	p2hex -F Intel $*.p $*.hex

.p.sr:
	p2hex -F Moto $*.p $*.sr

.asm.p:	config.inc $(devs)
	asl -L $*.asm

clean:
	rm -f *.p *.hex *.sr *.lst
