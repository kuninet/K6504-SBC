	CPU	6502

TARGET:	EQU	"6502"

ACIADR:	EQU	$1200		; Data Register
ACIASR:	EQU	$1201		; Status Register
ACIACM:	EQU	$1202		; Command Register
ACIACR:	EQU	$1203		; Control Register
ACCR_V:	EQU	$1E		; Control: 8bit, 9600bps
ACCM_V:	EQU	$0B		; Command: No-parity
;
RIOT_DATA_A: EQU	$1080		
RIOT_DDR_A:	EQU	$1081		
RIOT_DATA_B: EQU	$1082		
RIOT_DDR_B:	EQU	$1083	

	ORG $100
WK_CNT:	RMB 1	 

	ORG	$1600

CSTART:
	LDA	#$81
	STA	WK_CNT
;
	JSR WAIT
;
	JSR RIOT_INIT
	JSR INIT_ACIA
;
;
	JSR RIOT_55_AA
	JSR WAIT
	JSR RIOT_AA_55
	JSR WAIT
;
.LOOP
	LDA WK_CNT
	JSR CONOUT
	LDA WK_CNT
	JSR RIOT_OUT
;
	INC WK_CNT
	BEQ QUIT
	JSR WAIT
	JMP .LOOP
QUIT:
	JMP CSTART	

;
	
INIT_ACIA:
	LDA	#ACCR_V
	STA	ACIACR
	LDA	#ACCM_V
	STA	ACIACM
	RTS
	
CONIN:
	LDA	ACIASR
	AND	#$08
	BEQ	CONIN
	LDA	ACIADR
	RTS
	
CONST:
	LDA	ACIASR
	AND	#$08
	LSR	A
	LSR	A
	LSR	A
	RTS
	
CONOUT:
;	PHA
;CO0:
;	LDA	ACIASR
;	AND	#$10
;	BEQ	CO0
;	PLA
	STA	ACIADR
	JSR     DELAY_6551
	RTS

DELAY_6551:
	TYA
	PHA
	TXA
	PHA
DELAY_LOOP   LDY   #4    ;Get delay value (clock rate in MHz 2 clock cycles)
;
MINIDLY   LDX   #$68      ;Seed X reg
DELAY_1   DEX         ;Decrement low index
  BNE   DELAY_1   ;Loop back until done
;
  DEY         ;Decrease by one
  BNE   MINIDLY   ;Loop until done
	PLA
	TAX
	PLA
	TAY
DELAY_DONE   RTS         ;Delay done, return

RIOT_INIT:
	LDA	#$FF
	STA	RIOT_DDR_A
	STA	RIOT_DDR_B
	RTS

RIOT_OUT:
	STA	RIOT_DATA_A
	STA	RIOT_DATA_B
	RTS

RIOT_55_AA:
	LDA #$55
	STA	RIOT_DATA_A
	LDA #$AA
	STA	RIOT_DATA_B
	RTS

RIOT_AA_55:
	LDA #$AA
	STA	RIOT_DATA_A
	LDA #$55
	STA	RIOT_DATA_B
	RTS
;
; ループで待ち
;
WAIT:
   LDY   #$FF    ;Get delay value (clock rate in MHz 2 clock cycles)
.LOOP1:  LDX   #$FF      ;Seed X reg
.LOOP2   DEX         ;Decrement low index
  BNE   .LOOP2   ;Loop back until done
;
  DEY         ;Decrease by one
  BNE   .LOOP1   ;Loop until done
　RTS

TRACE:
	JSR RIOT_OUT
	JSR WAIT
	RTS

BRKENT:
	RTI

	;;
	;; Vector area
	;; 

	ORG	$1FFA

	FDB	$0000		; NMI
	FDB	CSTART		; RESET
	FDB	BRKENT		; IRQ/BRK

	END

END