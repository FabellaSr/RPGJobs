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
     FpaninsFm  cf   e             workstn
     F                                     sfile(paninss1:sf1rrn)
     F                                     sfile(paninss2:sf2rrn)
      /copy instalador/QCPYBOOKS,svpcfg_H
      /copy instalador/QCPYBOOKS,svpinst_H
      /copy hdiile/qcpybooks,svpvls_h
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
      /free
          exsr inicio;
          dou *inkc;
               select;
                    when xxiden = 1;
                         exsr pant01;
                    when xxiden = 2;
                         exsr pant02;
               endsl;
          enddo;
          exsr srclos;
          return;
      /end-free
     ******************************************************
      /SPACE
     ******************************************************
          begsr inicio;
               exsr defini;
               eval xxiden = 1;
               exsr sf1car;
               in @@lda;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr pant01;
               // ENTRADA/SALIDA PANTALLA
               if not *in50;
                    write paninsca;
               endif;
               write paninsp1;
               if not *in31;
                    write panins01;
               endif;
               exfmt paninsc1;
               // CORRIGE SITUACIONES DE ERROR
               exsr apagar;
               // FUNCIÓN 5: ACTUALIZAR
               if *inke;
                    if *in31;
                         chain 1 paninss1;
                         exsr sf1car;
                    endif;
               endif;
               // FUNCIÓN 6: ALTAS manual
               if *inkf;
                    TIPOIN = 'MANUAL';
                    exfmt PANINSAUT;
                    select;
                    // Confirmar
                    when *inka;
                         monitor;
                              tipo = *off;
                              callp INSTCOMP( xxdesa
                                            : xxdesc
                                            : tipo
                                            : instaloOk);
                         on-error;
                              exfmt ERROBCPP;
                         endmon;
                    other;
                         exfmt CANCELA;
                    endsl;
                    if instaloOk;
                         exfmt TODOOK;
                    endif;
                    exsr sf1car;
               endif;
               // FUNCIÓN 7: ALTAS completa
               if *inkg;
                    TIPOIN = 'COMPLETA';
                    exfmt PANINSAUT;
                    select;
                    // Confirmar
                    when *inka;
                         monitor;
                              tipo = *on;
                              callp INSTCOMP( xxdesa
                                            : xxdesc
                                            : tipo
                                            : instaloOk);
                         on-error;
                              exfmt ERROBCPP;
                         endmon;
                    other;
                         exfmt CANCELA;
                    endsl;
                    if instaloOk;
                         exfmt TODOOK;
                    endif;
                    exsr sf1car;
               endif;
               // ROLL UP
               if *in31 and *in22;
                    exsr rupinst;
               endif;
               // ROLL DOWN
               if *in31 and *in23;
                    exsr rdoinst;
               endif;
               // INTRO
               if *in31 and not *in90;
                    exsr vali01;
               endif;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr sf1car;
               // CARGA SUBFILE '1'
               exsr sf1bor;
               setll ksetinsu setins;
               reade ksetins setins;
               dow not %eof(setins) and @@lsf1 < 12;
                    exsr moar01;
                    *in31 = *on;
                    sf1rrn += 1;
                    @@lsf1 += 1;
                    write paninss1;
                    if @@lsf1 = 1;
                         psecu = sisecu;
                         pinst = siinst;
                    endif;
                    usecu = sisecu;
                    uinst = siinst;
                    reade ksetins setins;
               enddo;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr sf1bor;
               // BORRA SUBFILE '1'
               clear x1opci;
               *in30 = *off;
               *in31 = *off;
               sf1rrn = *zeros;
               @@lsf1 = *zeros;
               write paninsc1;
               *in30 = *on;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr moar01;
               // MOVER DATOS DE ARCHIVO A PANTALLA
               x1desa = siinst;
               x1come = sideta;
               x1secu = sisecu;
          endsr;
     ******************************************************
     C/SPACE
     ******************************************************
          begsr apagar;
               // APAGA INDICADORES DE ERROR
               *in50 = *off;
               *in51 = *off;
               *in52 = *off;
               *in60 = *off;
               instaloOk = *off;
               clear x1opci;
          endsr;
     c*PANTALLA ARRIBA, PANTALLA ABAJO
     ******************************************************
      /SPACE
     ******************************************************
          begsr rupinst;
               // ROLL PARA ADELANTE
               setgt ksetinsu setins;
               reade ksetins setins;
               if %eof(setins);
                    usecu = psecu;
                    uinst = siinst;
               else;
                    psecu = sisecu;
                    pinst = siinst;
               endif;
               exsr sf1car;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr rdoinst;
               // ROLL PARA ATRÁS
               @@lsf1 = *zeros;
               setll ksetinsp setins;
               dow @@lsf1 < 12;
                    readpe ksetins setins;
                    if %eof(setins);
                         leave;
                    else;
                         @@lsf1 += 1;
                         usecu = sisecu;
                         uinst = siinst;
                    endif;
               enddo;
               exsr sf1car;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr vali01;
               // VALIDA ENTRADAS PANTALLA 1
               // PROCESA OPCIONES Y GRABA CAMBIOS
               sf1rrn = 1;
               *in60 = *off;
               readc paninss1;
               if x1opci = 5;
                    exsr sf2car;
                    xxiden = 2;
               endif;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr pant02;
               // PROCESO PANTALLA
               if not *in50;
                    write paninsca;
               endif;
               write paninsp2;
               if not *in31;
                    write panins01;
               endif;
               exfmt paninsc2;
               // FUNCIÓN 12: VUELVO
               if *inkl;
                    xxiden = 1;
                    psecu = sisecu;
                    pinst = siinst;
                    exsr sf1car;
               endif;
               // ROLL UP
               if *in31 and *in22;
                    exsr rollup;
               endif;
               // ROLL DOWN
               if *in31 and *in23;
                    exsr rolldo;
               endif;

               readc paninss2;
               if x2opci = 2;
                    exsr cambioDestinoObjFuente;
               endif;

               if *inkg and s1maro = '0';
                    callp pggfuentes(s1desa : x1secu);
               endif;
               if *inkh and s1marf = '0';
                    callp pggobjetos(s1desa : x1secu);
               endif;

               if *inkh;

               endif;
               exsr sf2car;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr cambioDestinoObjFuente;
               XXOBJF = x2obje;
               xxdoba = x2libo;
               xxdfal = x2libf;
               xxdfas = x2srcl;
               xxdobn = x2libo;
               xxdfnl = x2libf;
               xxdfns = x2srcl;
               XXOBJI = 'Instalado';
               XXFUEI = 'Instalado';
               write PANCHG01;
               exfmt PANCHG01;
               xxdobn = xxdobn;
               x2opci = 0;
               chain ksetsrcu setsrc;
               if %found;
                    s1objl = xxdobn;
                    s1tlib = xxdfnl;
                    s1tfil = xxdfns;
                    update s1tsrc;
               endif;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr sf2car;
               // BORRA SUBFILE '2'
               exsr sf2bor;
               setll ksetsrc0 setsrc;
               reade ksetsrc setsrc;
               dow not %eof(setsrc) and @@lsf2 < 12;
                    *in31 = *on;
                    exsr moar02;
                    if @@lsf2 = 1;
                         pfuen = s1nfue;
                    else;
                         ufuen = s1nfue;
                    endif;
                    sf2rrn += 1;
                    @@lsf2 += 1;
                   // if xxin43 = '1';
                         write paninss2;
                         *in43 = *off;
                   // endif;
                    reade ksetsrc setsrc;
               enddo;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr rollup;
               // ROLL PARA ADELANTE
               setgt ksetsrc0 setsrc;
               reade ksetsrc setsrc;
               if %eof(setsrc);
                    ufuen = s1nfue;
               else;
                    pfuen = s1nfue;
               endif;
               exsr sf2car;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr rolldo;
               // ROLL PARA ATRÁS
               @@lsf2 = *zeros;
               setll ksetsrc1 setsrc;
               dow @@lsf2 < 12;
                    readpe ksetsrc setsrc;
                    if %eof(setsrc);
                         leave;
                    else;
                         @@lsf2 += 1;
                         ufuen = s1nfue;
                    endif;
               enddo;
               exsr sf2car;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr sf2bor;
               // BORRA SUBFILE '2'
               *in30 = *off;
               *in31 = *off;
               sf2rrn = *zeros;
               @@lsf2 = *zeros;
               write paninsc2;
               *in30 = *on;
          endsr;
     ******************************************************
     C/SPACE
     ******************************************************
          begsr moar02;
               X2OBJE = s1nfue;
               X2LIBO = s1objl;
               X2LIBF = s1tlib;
               X2SRCL = s1tfil;
               X2DESA = s1desa;
               //Estados de fuentes y objetos
               x2esto = 'InstOk';
               x2estf = 'InstOk';
               *in33 = *on;
               *in34 = *on;
               if s1maro = '0';
                    *in33 = *off;
                    x2esto = 'InsNoOk';
               endif;
               if s1marf = '0';
                    *in34 = *off;
                    x2estf = 'InsNoOk';
               endif;
          endsr;
     ******************************************************
     C/SPACE
     ******************************************************
          begsr srclos;
     ** CERRAR ARCHIVOS DESCARGAR PROGRAMAS---------------|
          endsr;
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
     C     ksetsrcu      klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    s1desa
     C                   kfld                    s1secu
     C                   kfld                    x2obje
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
** DES
   ALTA   |1
   BAJA   |2
  CAMBIO  |3
 CONSULTA |4
