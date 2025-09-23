             CMD        PROMPT('Reemplazar archivo fisico')
             PARM       KWD(FILE) TYPE(QUAL1) MIN(1) PROMPT('Archivo')
             PARM       KWD(FROMLIB) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Desde biblioteca')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Biblioteca')
