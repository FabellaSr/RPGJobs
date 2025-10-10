             CMD        PROMPT('Calculadora')
             PARM       KWD(NUMERO1) TYPE(*DEC) LEN(5) DFT('1') +
                          PROMPT('NUMERO UNO')
             PARM       KWD(NUMERO2) TYPE(*DEC) LEN(5) DFT('1') +
                          PROMPT('NUMERO DOS')
             PARM       KWD(TIPOCALC) TYPE(*CHAR) LEN(1) +
                          PROMPT('1-SUM 2-RES 3-MUL 4-DIV 5-PER')
             PARM       KWD(DESDE) TYPE(*DATE) DFT(*HOY) +
                          SPCVAL((*HOY 00000000)) PROMPT('Fecha Desde')
             PARM       KWD(SUBMIT) TYPE(*LGL) LEN(1) RSTD(*YES) +
                          DFT(*YES) SPCVAL((*YES '1') (*NO '0')) +
                          PROMPT('Submitir Trabajo Por Lotes')
