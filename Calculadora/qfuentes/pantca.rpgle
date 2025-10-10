     H decedit(',') datedit(*dmy/)
     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio: *srcstmt)
     H bnddir('CALCULADOR/BNDIRCALC')
     *****************************************************************
     *  PANTCA  : CALCULADORA                                        *
     *                                                               *
     *  FECHA   : 07/04/2025                                         *
     *  AUTOR   : FABELLA IVAN MAXIMILIANO                           *
     *****************************************************************
     * MODIFICACIONES:
     *****************************************************************
     *****************************************************************
      */Archivos
     *****************************************************************
      *de pantalla
     FpantcaFm  cf   e             workstn
     F                                     sfile(pantcas1:sf1rrn)
      *PF
     Fgntpgm    if   e           k disk
     Fsetdat    if   e           k disk
     *****************************************************************
      */copis
     *****************************************************************
      /copy calculador/QCPYBOOKS,svpcalc_H
     *****************************************************************
      */Variables
     *****************************************************************
      *Variables para control del SF
     D @@lsf1          s              2  0
     D sf1rrn          s              9  0
     D psecu           S                   like(s1secu)
     D usecu           S                   like(s1secu)
      *Variable para descripciones
     D des             s             10    dim(4) ctdata perrcd(1)
     *****************************************************************
      *Area de datos
     *****************************************************************
     D @@lda          uds
     D  usempr               401    401
     D  ussucu               402    403
     *- AREA DEL PROGRAMA...
     D                sds
     D  vsjobn               244    253
     D  vsuser               254    263
     *****************************************************************
      *Estructura de datos para manipular fecha
     *****************************************************************
     D                 ds                  inz
     DS1ECH1                   1      8  0
     Danio                     1      4  0
     Dmes                      5      6  0
     Ddia                      7      8  0
     *****************************************************************
      /SPACE
     *****************************************************************
     *----------------------------------------------------|
1b C                   dou       *inkc                                        |::::::
2b C     xxiden        caseq     1             pant01                         ||    :
     C*     xxiden        caseq     2             pant02                         ||    :
     C*     xxiden        caseq     3             pant03                         ||    :
2e C                   endcs                                                  ||    :
1e C                   enddo                                                  |::::::
     C                   exsr      srclos                                       |
     C                   seton                                            lr    |
     *----------------------------------------------------|
     ******************************************************
      /SPACE
     ******************************************************
     C     *inzsr        begsr                                                  |
     ** INICIO DE PROGRAMA -------------------------------|
     *- DEFINICIONES ...                                  |
     C                   exsr      defini                                       |
     *- TESTEO DE LA SEGURIDAD DEL PROGRAMA...            |
     C                   eval      pgausu = vsuser                              |*USUARIO
     C                   eval      pgtsbs = 21                                  |*SUBSISTEMA
     C                   movel     'PANTCA'      pgipgm                         |*PROGRAMA
     C     k1@pgm        chain     g1tpgm                             20        |
     *- SI NO ENCUENTRA REGISTRO PRESUPONE HABILITADO...  |
     *- SOLO PARA CONSULTAS...                            |
1b C                   if        *in20                                        |
     C                   eval      pgtalt = 'N'                                 |
     C                   eval      pgtbaj = 'N'                                 |
     C                   eval      pgtcam = 'N'                                 |
     C                   eval      pgtcon = 'S'                                 |
1e C                   endif                                                  |
     *- PARA EMITIR PANTALLA 1...                         |
     C                   eval      xxiden = 1                                   |
     *- CARGA DATOS SUBFILE '1' ...                       |
     C                   exsr      sf1car                                       |
     *- DESCRIPCION DE LA EMPRESA/SUCURSAL...             |
     C                   call      'SP0000'                                     |
     C                   parm                    xxemsu                         |
     *- LECTURA DE LA LDA...                              |
     C                   in        @@lda                                        |
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     defini        begsr                                                  |
     *- DEFINICIONES DEL PROGRAMA ------------------------|
     *- DEFINICION DE CAMPOS...                           |
     *  - CAMPOS DE TRABAJO...                            |
     C     *dtaara       define    *lda          @@lda                          |
     C                   eval      @@lsf1 = 12                                  |

     *- DEFINICION DE CLAVES P/ACCESO A ARCHIVOS ...      |
     *- GNTPGM...                                         |
     C     k1@pgm        klist                                                  |
     C                   kfld                    pgausu                         |
     C                   kfld                    pgtsbs                         |
     C                   kfld                    pgipgm                         |
     C     ksetdat0      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    usecu
     C     ksetdat1      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C     ksetdat2      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1secu
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     sf1car        begsr                                                  |
     ** CARGA SUBFILE '1' --------------------------------|
     C                   exsr      sf1bor
     C     ksetdat0      setll     setdat                                 99
     C     ksetdat1      reade     setdat                                 99
1b C                   dow       not %eof and
     C                             @@lsf1 < 12
     C                   exsr      moar01                                       ||    :
     C                   seton                                            31    ||    :
     C                   add       1             sf1rrn                         ||    :
     C                   add       1             @@lsf1
     C                   write     pantcas1                                     ||    :
2b C                   if        @@lsf1 = 1
     C                   eval      psecu = s1secu
2e C                   endif
     C                   eval      usecu = s1secu
     C     ksetdat1      reade     setdat
1e C                   enddo
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     sf1bor        begsr                                                  |
     ** BORRA SUBFILE '1' --------------------------------|
     C                   eval      x1opci = *zeros                              |
     C                   setoff                                         3031    |
     C                   eval      sf1rrn = *zeros                              |
     C                   eval      @@lsf1 = *zeros
     C                   write     pantcac1                                     |
     C                   seton                                          30      |
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     moar01        begsr                                                  |
     ** MOVER DATOS DE ARCHIVO A PANTALLA ----------------|
     C                   eval      x1opci = *zeros                              |
     C                   eval      xxin43 = '0'                                 |
     C                   eval      x1num1 = S1NUM1
     C                   eval      x1num2 = S1NUM2
     C                   eval      x1calc = S1TCAL                              |
     C                   eval      x1resu = S1RESU                              |
     C                   eval      x1secu = S1secu                              |
     c*fecha de maquina
     C                   eval      x1fecc = S1ECHA                              |
     c*fecha enviada
     C                   eval      x1feca = ANIO                                |
     C                   eval      x1fecm = mes                                 |
     C                   eval      x1fdia = dia                                 |
     c*Estado
     C                   seton                                            60    ||    :
     C                   eval      x1esta = 'MARCADO'
     c                   if        S1MARP = '0'
     C                   setoff                                           60    ||    :
     C                   eval      x1esta = 'NO MARCADO'
     C                   endif
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     pant01        begsr                                                  |
     ** PROCESO PANTALLA ---------------------------------|
     *- ENTRADA/SALIDA PANTALLA...                        |
     C  n50              write     pantcaca                                     |
     C                   write     pantcap1                                     |
     C  n31              write     pantca01                                     |
     C                   exfmt     pantcac1                                     |
     *- CORRIGE SITUACIONES DE ERROR ...                  |
     C                   exsr      apagar                                       |
     *- FUNCION 5: ACTUALIZAR...                          |
1b C                   if        *inke                                        ||
2b C                   if        *in31                                        |||
     C     1             chain     pantcas1                           20        |||
     C                   exsr      sf1car                                       ||
1e C                   endif                                                  ||
1e C                   endif                                                  ||
     *- FUNCION 6: ALTAS...                               |
1b C                   if        *inkf  and                                   ||
     C                             pgtalt = 'S'                                 ||
     C                   call      'CALCULA'
     C                   eval      usecu = 1
     C                   exsr      sf1car
1e C                   endif                                                  ||
     *- ROLL...                                           |
     *    - ROLL UP...                                    |
1b C   31              if        *in22                                        ||
     C                   exsr      rollup                                       ||
1e C                   endif                                                  ||
     *    - ROLL DOWN...                                  |
1b C   31              if        *in23                                        ||
     C                   exsr      rolldo                                       ||
1e C                   endif                                                  ||
     *- POR INTRO...                                      |
1b C   31              if        not *in90                                    ||
     *   - VALIDAR Y PROCESAR OPCIONES...                 |||
     C                   exsr      vali01                                       |||
2e C                   endif                                                  |||
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
     C/SPACE
     ******************************************************
     C     apagar        begsr                                                  |
     ** APAGA INDICADORES DE ERROR -----------------------|
     * Ojo no usar el *in80 para errores...               |
     C                   setoff                                       505152    |
     C                   setoff                                       60        |
     C                   eval      x1opci = *zeros                              |
     C                   clear                   x1opci
     C                   endsr                                                  |
     c*PANTALLA ARRIBA, PANTALLA ABAJO
     ******************************************************
      /SPACE
     ******************************************************
     C     rollup        begsr                                                  |
     ** ROLL PARA ADELANTE -------------------------------|
     C     ksetdat2      setgt     setdat
     C     ksetdat1      reade     setdat
1b C                   if        %eof(setdat)
     C                   eval      usecu = psecu
1x C                   else
     C                   eval      usecu = s1secu
1e C                   endif
     C                   exsr      sf1car
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     rolldo        begsr                                                  |
     ** ROLL PARA ATRAS ----------------------------------|
     C                   eval      @@lsf1 = *zeros
     C                   eval      usecu = psecu
     C     ksetdat0      setll     setdat
1b C                   dow       @@lsf1 < 12
     C     ksetdat1      readpe    setdat
2b C                   if        %eof
1v C                   leave
2x C                   else
     C                   add       1             @@lsf1
2e C                   endif
     C                   eval      usecu = s1secu
1e C                   enddo
     C                   exsr      sf1car
     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     C     vali01        begsr                                                  |
     ** VALIDA ENTRADAS PANTALLA 1 -----------------------|
     *- PROCESA OPCIONES Y GRABA CAMBIOS...               |
     C                   eval      sf1rrn = 1                                   |
     C                   setoff                                       60        |
     C                   readc     pantcas1                               99    |
1b C                   dow       not *in99                                    |::::::
     *- OPCION 5: VISUALIZAR...                             |     :
2b C                   if        x1opci = 1  and                              ||    :
     C                             pgtcon = 'S'                                 ||    :
     C                   exsr      marcar
     C                   eval      usecu = 1
     C                   exsr      sf1car
2e C                   endif                                                  ||    :
     C                   setoff                                           49    |     :
     C                   update    pantcas1                                    |     :
     C                   readc     pantcas1                               99    |     :
     C  n99
     Cannkc
1e Cannkl              enddo                                                  |::::::
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
     C/SPACE
     ******************************************************
     C     marcar        begsr                                                  |
     ** Marcar Registro---------------|
       /free
          SVPCALC_marcar(x1secu);
       /end-free
     C                   endsr                                                  |
     ******************************************************
     C/SPACE
     ******************************************************
     C     srclos        begsr                                                  |
     ** CERRAR ARCHIVOS DESCARGAR PROGRAMAS---------------|
     c
     c                   callp      SVPCALC_end()
     C                   endsr                                                  |
** DES
   ALTA   |1
   BAJA   |2
  CAMBIO  |3
 CONSULTA |4
