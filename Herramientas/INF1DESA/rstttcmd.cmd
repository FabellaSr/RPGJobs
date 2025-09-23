    CMD        PROMPT('RESTAURAR A TEST')
             PARM       KWD(SLB) TYPE(*CHAR) LEN(10) DFT(TESTGAUS) +
                          PROMPT('BIBL. SALVADA.')
             PARM       KWD(SAV) TYPE(*CHAR) LEN(10) DFT(DESA) +
                          PROMPT('SAVF A RESTAURAR')
             PARM       KWD(FTP) TYPE(*CHAR) LEN(10) DFT(FTPDESA) +
                          PROMPT('BIBL. DEL SAVF')
             PARM       KWD(BRE) TYPE(*CHAR) LEN(10) DFT(BIBLREST) +
                          PROMPT('BIBL. DESTINO REST.')
