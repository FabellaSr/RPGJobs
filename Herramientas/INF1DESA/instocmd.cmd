    CMD        PROMPT('CREAR MODULO Y SRVPGM')
             PARM       KWD(LIB) TYPE(*CHAR) LEN(10) DFT(TESTGAUS) +
                          PROMPT('Biblioteca de trabajo')
             PARM       KWD(OBJ) TYPE(*CHAR) LEN(10) DFT(SVP) +
                          PROMPT('Fuente a compilar')
             PARM       KWD(SRC) TYPE(*CHAR) LEN(10) DFT(QDESA) +
                          PROMPT('srcpf del fuente a compilar')
             PARM       KWD(DEB) TYPE(*CHAR) LEN(4) DFT('*SI') +
                          PROMPT('Modo debug o no.')
             PARM       KWD(LIBH) TYPE(*CHAR) LEN(10) DFT(HDIILE) +
                          PROMPT('Lib que contiene CONFIG')
