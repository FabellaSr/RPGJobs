/*PARMS PGM(CRTLDECPP)*/
/* **************************************************************** */
/* CREAR BIBLIOTECA CON ARCHIVOS SRCF PARA NUEVOS DESARROLLOS       */
/* ---------------------------------------------------------------- */
/* FABELLA IVAN M.                     * 20-DIC-2024                */
/* **************************************************************** */
    CMD        PROMPT('Armar lib para desarrollos')
    PARM       KWD(LIB) TYPE(*CHAR) LEN(10)  DFT(*LIB) +
                PROMPT('Biblioteca a crear.')
    PARM       KWD(NOM) TYPE(*CHAR) LEN(50)  DFT(*TXT) +
                PROMPT('TEXTO DESCRIPTIVO')
