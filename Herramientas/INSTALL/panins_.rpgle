     H decedit(',') datedit(*dmy/)
     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio: *srcstmt)
     *****************************************************************
     *  PANINS  : PANTALLA DE INSTALACIONES                          *
     *                                                               *
     *  FECHA   : 07/04/2025                                         *
     *  AUTOR   : FABELLA IVAN MAXIMILIANO                           *
     *****************************************************************
     * MODIFICACIONES:                                               *
     *****************************************************************
     *****************************************************************
      */copis
      /copy instalador/QCPYBOOKS,svpcfg_H
      /copy instalador/QCPYBOOKS,svpinst_H
      /copy hdiile/qcpybooks,svpvls_h
     FpaninsFm  cf   e             workstn
     F                                     sfile(paninss1:sf1rrn)
     F                                     sfile(paninss2:sf2rrn)
     * - ----------------------------------------------------------- *
     *Empresa/Sucursal
     * - ----------------------------------------------------------- *
     D @@lda          uds
     D  usempr               401    401
     D  ussucu               402    403
     *****************************************************************
      */Variables
     *****************************************************************
      *Variables para control del SF
     D @@lsf1          s              2  0
     D @@lsf2          s              2  0
     D sf1rrn          s              9  0
     D sf2rrn          s              9  0
      *setins
     D uinst           S                   like(SIINST)
     D pinst           S                   like(SIINST)
      *setsrc
     D pfuen           S                   like(S1nfue)
     D ufuen           S                   like(S1nfue)
      *secuencias
     D psecu           S                   like(s1secu)
     D usecu           S                   like(s1secu)
      *Variable para descripciones
     D des             s             10    dim(4) ctdata perrcd(1)
     D instaloOk       S               n   inz(*off)
     *****************************************************************
      /SPACE
     *****************************************************************
     *----------------------------------------------------|
1b C                   dou       *inkc                                        |::::::
2b C     xxiden        caseq     1             pant01                         ||    :
     C     xxiden        caseq     2             pant02                         ||    :
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
     *- PARA EMITIR PANTALLA 1...                         |
     C                   eval      xxiden = 1                                   |
     *- CARGA DATOS SUBFILE '1' ...                       |
     C                   exsr      sf1car                                       |
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
     C                   eval      @@lsf2 = 12                                  |
     *- DEFINICION DE CLAVES P/ACCESO A ARCHIVOS ...      |
     C     ksetsrc1      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    X1desa
     C                   kfld                    X1secu
     C                   kfld                    pfuen
     C     ksetsrc0      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    X1desa
     C                   kfld                    X1secu
     C                   kfld                    ufuen
     C     ksetsrc       klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    X1desa
     C                   kfld                    X1secu
      *inst
     C     ksetins       klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C     ksetinsu      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    uinst
     C                   kfld                    usecu
     C     ksetinsp      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    pinst
     C                   kfld                    psecu
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     pant01        begsr                                                  |
     ** PROCESO PANTALLA ---------------------------------|
     *- ENTRADA/SALIDA PANTALLA...                        |
     C  n50              write     paninsca                                     |
     C                   write     paninsp1                                     |
     C  n31              write     panins01                                     |
     C                   exfmt     paninsc1                                     |
     *- CORRIGE SITUACIONES DE ERROR ...                  |
     C                   exsr      apagar                                       |
     *- FUNCION 5: ACTUALIZAR...                          |
1b C                   if        *inke                                        ||
2b C                   if        *in31                                        |||
     C     1             chain     paninss1                           20        |||
     C                   exsr      sf1car                                       ||
1e C                   endif                                                  ||
1e C                   endif                                                  ||
     *- FUNCION 6: ALTAS...                               |
1b C                   if        *inkf                                        ||
     C                   exfmt     PANINSAUT
1b C                   select
     * INKA = Confirmar...
1x C                   when      *inka
     C                   monitor
     C                   call      'PROCINST'
     C                   parm                    XXDESA
     C                   parm                    XXdesc
     C                   parm                    instaloOk
     C                   on-error
     C                   exfmt     ERROBCPP
     C                   endmon
     C                   other
     C                   exfmt     CANCELA
     C                   endsl
     C                   if        instaloOk
     C                   exfmt     TODOOK
     C                   else
     C                   exfmt     ERROBCPP
     C                   endif
     C                   eval      instaloOk = *off
     C                   exsr      sf1car
1e C                   endif                                                  ||
     *- ROLL...                                           |
     *    - ROLL UP...                                    |
1b C   31              if        *in22                                        ||
     C                   exsr      rupinst                                      ||
1e C                   endif                                                  ||
     *    - ROLL DOWN...                                  |
1b C   31              if        *in23                                        ||
     C                   exsr      rdoinst                                      ||
1e C                   endif                                                  ||
     *- POR INTRO...                                      |
1b C   31              if        not *in90                                    ||
     *   - VALIDAR Y PROCESAR OPCIONES...                 |||
     C                   exsr      vali01                                       |||
2e C                   endif                                                  |||
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     sf1car        begsr                                                  |
     ** CARGA SUBFILE '1' --------------------------------|
     C                   exsr      sf1bor
     C     ksetinsu      setll     setins                                 99
     C     ksetins       reade     setins                                 99
1b C                   dow       not %eof and
     C                             @@lsf1 < 12
     C                   exsr      moar01                                       ||    :
     C                   seton                                            31    ||    :
     C                   add       1             sf1rrn                         ||    :
     C                   add       1             @@lsf1
     C                   write     paninss1                                     ||    :
2b C                   if        @@lsf1 = 1
     C                   eval      psecu = sisecu
     C                   eval      pinst = siinst
2e C                   endif
     C                   eval      usecu = sisecu
     C                   eval      uinst = siinst

     C     ksetins       reade     setins
1e C                   enddo
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     sf1bor        begsr                                                  |
     ** BORRA SUBFILE '1' --------------------------------|
     C                   clear                   x1opci
     C                   setoff                                         3031    |
     C                   eval      sf1rrn = *zeros                              |
     C                   eval      @@lsf1 = *zeros
     C                   write     paninsc1                                     |
     C                   seton                                          30      |
     *                                                    |
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     moar01        begsr                                                  |
     ** MOVER DATOS DE ARCHIVO A PANTALLA ----------------|
     C                   eval      x1desa = SIINST                              |
     C                   eval      x1come = SIDETA                              |
     C                   eval      X1secu = sisecu
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
     C                   clear                   x1opci
     C                   endsr                                                  |
     c*PANTALLA ARRIBA, PANTALLA ABAJO
     ******************************************************
      /SPACE
     ******************************************************
     C     rupinst       begsr                                                  |
     ** ROLL PARA ADELANTE -------------------------------|
     C     ksetinsu      setgt     setins
     C     ksetins       reade     setins
1b C                   if        %eof(setins)
     C                   eval      usecu = psecu
     C                   eval      uinst = siinst
1x C                   else
     C                   eval      psecu = sisecu
     C                   eval      pinst = siinst
1e C                   endif
     C                   exsr      sf1car
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     rdoinst       begsr                                                  |
     ** ROLL PARA ATRAS ----------------------------------|
     C                   eval      @@lsf1 = *zeros
     C     ksetinsp      setll     setins
1b C                   dow       @@lsf1 < 12
     C     ksetins       readpe    setins
     C                   if        %eof
1v C                   leave
2x C                   else
     C                   add       1             @@lsf1
     C                   eval      usecu = sisecu
     C                   eval      uinst = siinst
2e C                   endif
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
     C                   readc     paninss1                               99    |
1b C                   dow       not *in99                                    |::::::
     *- OPCION 5: VISUALIZAR...                             |     :
2b C                   if        x1opci = 5                                   ||    :
     C                   exsr      sf2car
     C                   eval      xxiden = 2
2e C                   endif                                                  ||    :
     C                   clear                   x1opci
     C                   setoff                                           49    |     :
     C     xxin43        comp      '1'                                    43    |     :
     C                   update    PANINSS2                             98      |     :
     C                   setoff                                           43    |     :
     C                   readc     PANINSS2                               99    |     :
     C  n99
     Cannkc
1e Cannkl              enddo                                                  |::::::
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     pant02        begsr                                                  |
     ** PROCESO PANTALLA ---------------------------------|
     *- ENTRADA/SALIDA PANTALLA...                        |
     C  n50              write     paninsca                                     |
     C                   write     paninsp1                                     |
     C  n31              write     panins01                                     |
     C                   exfmt     paninsc2                                     |
     *- FUNCION 12: VUELVO...                               |
1b C                   if        *inkl
     C                   eval      xxiden = 1                                   ||
     C                   eval      psecu = sisecu
     C                   eval      pinst = siinst
     C                   exsr      sf1car
1e C                   endif                                                  ||
     *- ROLL...                                           |
     *    - ROLL UP...                                    |
1b C   31              if        *in22                                        ||
     C                   exsr      rollup                                      ||
1e C                   endif                                                  ||
     *    - ROLL DOWN...                                  |
1b C   31              if        *in23                                        ||
     C                   exsr      rolldo                                      ||
1e C                   endif                                                  ||
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     sf2car        begsr                                                  |
     ** CARGA SUBFILE '1' --------------------------------|
     C                   exsr      sf2bor
     C     ksetsrc0      setll     setsrc                                 99   ||    :
     C     ksetsrc       reade     setsrc                                 99   ||    :
1b C                   dow       not %eof and
     C                             @@lsf2 < 12
     C                   seton                                            31    ||    :
     C                   exsr      moar02                                       ||    :
     C                   if        @@lsf2 = 1
     C                   eval      pfuen = s1nfue
     C                   else
     C                   eval      ufuen = s1nfue
     C                   endif
     C                   add       1             sf2rrn                         ||    :
     C                   add       1             @@lsf2
     C     xxin43        comp      '1'                                    43    ||    :
     C                   write     paninss2                                     ||    :
     C                   setoff                                           43    ||    :
     C     ksetsrc       reade     setsrc                                       ||    :
1e C                   enddo
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     rollup        begsr                                                  |
     ** ROLL PARA ADELANTE -------------------------------|
     C     ksetsrc0      setgt     setsrc
     C     ksetsrc       reade     setsrc
1b C                   if        %eof(setsrc)
     C                   eval      ufuen = s1nfue
1x C                   else
     C                   eval      pfuen = s1nfue
1e C                   endif
     C                   exsr      sf2car
     C                   endsr                                                  |
     ******************************************************
      /SPACE
     ******************************************************
     C     rolldo        begsr                                                  |
     ** ROLL PARA ATRAS ----------------------------------|
     C                   eval      @@lsf2 = *zeros
     C     ksetsrc1      setll     setsrc
1b C                   dow       @@lsf2 < 12
     C     ksetsrc       readpe    setsrc
     C                   if        %eof
1v C                   leave
2x C                   else
     C                   add       1             @@lsf2
     C                   eval      ufuen = s1nfue
2e C                   endif
1e C                   enddo
     C                   exsr      sf2car
     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     ** BORRA SUBFILE '2' --------------------------------|
     C     sf2bor        begsr                                                  |
     C                   setoff                                         3031    |
     C                   eval      sf2rrn = *zeros                              |
     C                   eval      @@lsf2 = *zeros
     C                   write     paninsC2                                     |
     C                   seton                                          30      |
     C                   endsr                                                  |
     ******************************************************
     C/SPACE
     ******************************************************
     C     moar02        begsr
     C                   eval      X2OBJE = S1nFUE
     C                   eval      X2LIBO = S1OBJL
     C                   eval      X2LIBF = S1tLIB
     C                   eval      X2SRCL = S1tFIL
     C                   eval      X2FECH = S1ECH1
     C                   eval      X2DESA = S1DESA
     C                   endsr
     ******************************************************
     C/SPACE
     ******************************************************
     C     srclos        begsr                                                  |
     ** CERRAR ARCHIVOS DESCARGAR PROGRAMAS---------------|
     c
     C                   endsr                                                  |
** DES
   ALTA   |1
   BAJA   |2
  CAMBIO  |3
 CONSULTA |4
