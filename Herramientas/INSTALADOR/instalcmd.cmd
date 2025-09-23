             CMD        PROMPT('INSTALADOR')
             PARM       KWD(TIPOINST) TYPE(*CHAR) LEN(1) +
                          PROMPT('TIPO DE INSTALACION')
             PARM       KWD(SAVFTEST) TYPE(*CHAR) LEN(10) +
                          PMTCTL(PMT1) PROMPT('SAVF A INSTALAR')
             PARM       KWD(FROMFILE) TYPE(*CHAR) LEN(10) +
                          PROMPT('QFUENTES')
             PARM       KWD(FROMLIB) TYPE(*CHAR) LEN(10) +
                          DFT(INSTALTEMP) PMTCTL(PMT2) +
                          PROMPT('BIBLIOTECA DESDE')
             PARM       KWD(TOFILE) TYPE(*CHAR) LEN(10) +
                          PMTCTL(PMT2) PROMPT('QFUENTES')
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) +
                          DFT(INSTALTEMP) PMTCTL(PMT2) +
                          PROMPT('BIBLIOTECA HASTA')
             PARM       KWD(DESA) TYPE(*CHAR) LEN(10) DFT(DESA_) +
                          PMTCTL(PMT1) PROMPT('DESA JIRA')
PMT1:       PMTCTL     CTL(TIPOINST) COND((*EQ '1')) NBRTRUE(*EQ 1)
PMT2:       PMTCTL     CTL(TIPOINST) COND((*EQ '2')) NBRTRUE(*EQ 1)
