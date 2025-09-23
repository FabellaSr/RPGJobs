/*PARMS PGM(CRTLDECPP)*/
/* **************************************************************** */
/* ---------------------------------------------------------------- */
/* **************************************************************** */
    CMD        PROMPT('GENERA DETALLE PARA INSTALAR')
    PARM       KWD(LIB) TYPE(*CHAR) LEN(10)  DFT(OBJ) +
                PROMPT('BIBLIOTECA DEL SRC')
    PARM       KWD(NOM) TYPE(*CHAR) LEN(10)  DFT(LIB) +
                PROMPT('ARCHIVO QDESA****.')
