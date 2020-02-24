-- 68K Assembly
return {
  name = "Assembly 68K",
  lexer = 110,
  extensions = "asm",
  keywords = {
    [0] = {
      name = "Instructions",
      keywords =
        [[ABCD ADD ADDA ADDI ADDQ ADDX AND ANDI ASL ASR BCC BCHG BCLR BCS
        BEQ BGE BGT BHI BLE BLS BLT BMI BNE BPL BRA BSET BSR BTST BVC BVS
        CHK CLR CMP CMPA CMPI CMPM DBCC DBCS DBEQ DBF DBGE DBGT DBHI DBLE
        DBLS DBLT DBMI DBNE DBPL DBRA DBT DBVC DBVS DIVS DIVU EOR EORI EXG
        EXT JMP JSR LEA LINK LSL LSR MOVE MOVEA MOVEM MOVEP MOVEQ MULS MULU
        NBCD NEG NEGX NOT OR ORI PEA ROL ROR ROXL ROXR SBCD SCC SCS SEQ SF
        SGE SGT SHI SLE SLS SLT SMI SNE SPL ST STOP SUB SUBA SUBI SUBQ SUBX
        SVC SVS SWAP TAS TRAP TST UNLK]]
    },
    [1] = {
      name = "Nullary Instructions",
      keywords =
        [[ILLEGAL NOP RESET RTE RTR RTS TRAPV]]
    },
    [2] = {
      name = "Registers",
      keywords =
        [[A0 A1 A2 A3 A4 A5 A6 A7 D0 D1 D2 D3 D4 D5 D6 D7 SP]]
    },
    [3] = {
      name = "Directives",
      keywords =
        [[_BRINGIN _DEBSYM _DGROUP ABSOLUTE COMLINE COMMON DC DCB DS END EQU
        FAIL FEQU FORMAT IDNT INCLUDE LIST LLEN NOFORMAT NOL NOLIST NOOBJ
        NOPAGE OFFSET OPT ORG PAGE REG RESERVE RESUME RORG SECTION SET SPC
        STTL TTL XDEF XREF]]
    },
  },
  style = {
    [1] = {
      name = "Comment",
      style = "comment"
    },
    [2] = {
      name = "Identifier",
      style = "identifier"
    },
    [3] = {
      name = "Number",
      style = "number"
    },
    [4] = {
      name = "Character",
      style = "singleQuotedString"
    },
    [5] = {
      name = "Punctuation",
      style = "operator"
    },
    [6] = {
      name = "Instruction",
      style = "keyword"
    },
    [7] = {
      name = "Nullary Instructions",
      style = "keyword"
    },
    [8] = {
      name = "Register",
      style = "keyword"
    },
    [9] = {
      name = "Directive",
      style = "keyword"
    }
  }
}
