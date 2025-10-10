     *****************************************************************
     *  PANINS  : PANTALLA DE INSTALACIONES                          *
     *                                                               *
     *  FECHA   : 07/04/2025                                         *
     *  AUTOR   : FABELLA IVAN MAXIMILIANO                           *
     *****************************************************************
     * MODIFICACIONES:                                               *
     *****************************************************************
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
      // - ----------------------------------------------------------- - //
      //   Archivos                                                     //
      // - ----------------------------------------------------------- - //
       dcl-f paninsFm workstn
           sfile(paninss1: sf1rrn)
           sfile(paninss2: sf2rrn);

      /copy *libl/QCPYBOOKS,svpcfg_H
      /copy *libl/QCPYBOOKS,svpinst_H
      /copy *libl/qcpybooks,svpvls_h
        // ----------------------- Empresa / Sucu ------------------------- //
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
        // ----------------------------------------------------------------
        // Variables varias
        // ----------------------------------------------------------------

       // *Variables para control del SF
        dcl-s sf1rrn  packed(9:0);
        dcl-s sf2rrn  packed(9:0);

       // *setins
        dcl-s uinst   like(SIINST);
        dcl-s pinst   like(SIINST);

       // *setsrc
        dcl-s pfuen   like(S1nfue);
        dcl-s ufuen   like(S1nfue);

       // *secuencias
        dcl-s psecu   like(s1secu);
        dcl-s usecu   like(s1secu);
        dcl-s auxSec  like(s1secu);

       // *Variable para descripciones (CTDATA)
        dcl-s des     char(10) dim(4) ctdata perrcd(1);

       // Indicador
        dcl-s instaloOk  ind inz(*off);
        dcl-s endpgm     ind inz(*off);

        dcl-ds k1etins01 likerec(SITINS01:*key);
        dcl-ds kLast     likeds(k1etins01);
        dcl-ds kfirs     likeds(k1etins01);
        // --- Paginación y posición y mas---------------------------------
        dcl-s primeraCarga   ind  inz(*on);
        dcl-s noHayMas       ind  inz(*off);
        dcl-s esPrimeraPag   ind  inz(*on);
        dcl-s primeraEntrada ind  inz(*on);
        dcl-s calculoOk      ind  inz(*off);
        dcl-s pendDisponible ind  inz(*on);
        dcl-s endLoop        ind  inz(*off);
        dcl-s  i         int(10) inz(1);
     *****************************************************************
      /SPACE
     *****************************************************************
      /free
          endpgm = *off;
          exsr inicio;
          dow not endpgm;
               // Preparar control del subfile: limpiar y mostrar
               *in31 = *on;
               *in32 = *off;
               if primeraEntrada;
                    *in30 = *off;
                    write paninsC1;
                    primeraEntrada = *off;
                    exsr sf1car;
               endif;
               select;
                    when xxiden = 1;
                         exsr pant01;
                    when xxiden = 2;
                         exsr pant02;
                         primeraEntrada = *on;
                         primeraCarga   = *on;
                         exsr sf1bor;
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
               xxiden = 1;
               in uds;
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
               // Teclas de función básicas
               // --- F09  -----------------------------------
               if *in12;
                    return;
               endif;
               // --- F3 -------------------------------------
               if  *in03;
                    endpgm = *on;
                    return;
               endif;
               // --- ROLL Adelante --------------------------
               if *in28;
                    exsr  RollDown;
               endif;
               // --- ROLL Atras -----------------------------
               if *in27;
                    exsr  RollUp;
               endif;
               if *in31 and not *in90;
                    exsr vali01;
               endif;
          endsr;
     ******************************************************
      /SPACE
     ******************************************************
          begsr sf1car;

               // Posicionar 1 sola vez al principio del archivo
               if primeraCarga;
                    setll *start setins01;
                    primeraCarga = *off;
                    esPrimeraPag = *on;
               else;
                    setll %kds(kLast) setins01;
               endif;
               // Borrar SFL
               *in30    = *off;
               write     paninsC1;
               sf1rrn    = *zeros;
               noHayMas = *off;
               read(n) setins01;
               dow not %eof(setins01);
                    if sf1rrn = 9;
                         leave;
                    endif;

                    *in30 = *on;
                    // Guardar clave de la primera fila de la página
                    if sf1rrn = 0;
                         kfirs.sidate = sidate;
                         kfirs.siempr = siempr;
                         kfirs.sisucu = sisucu;
                         kfirs.sisecu = sisecu;
                    endif;
                    X1OPCI = *zeros;
                    exsr moar01;
                    sf1rrn += 1;
                    write paninsS1;
                    //Me guardo el ultimo
                    kLast.sidate = sidate;
                    kLast.siempr = siempr;
                    kLast.sisucu = sisucu;
                    kLast.sisecu = sisecu;

                    read(n) setins01;
               enddo;
               if %eof(setins01);
                    noHayMas = *on;
               endif;
               //si in32 = *on va a mostrar "Final"
               *in32  = noHayMas;       // SFLEND(*MORE) si hay más
               *in40  = esPrimeraPag;   // indicador primera página
               *in41  = not noHayMas;   // indicador última página
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
               sf2rrn = *zeros;
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
          // ----------------------------------------------------------------
          // RollDown: continuar desde la posición actual y recargar SFL
          // ----------------------------------------------------------------
          begsr RollDown;
               // Si ya estamos en última página, no hacemos nada
               if NOT noHayMas;
                    noHayMas = *off;
                    esPrimeraPag = *off;
                    exsr sf1car;
               endif;

          endsr;
          // ----------------------------------------------------------------
          // RollUp: retrocede una página (9 ítems) y recarga SFL
          // ----------------------------------------------------------------
          begsr RollUp;
               // Posicionarse antes de la primera clave actual y retroceder 9
               setll %kds(kfirs) setins01;        // al principio de la página actual
               readp(n) setins01;                  // ir al registro anterior
               if %eof(setins01);
                    // Ya estamos en el inicio del archivo
                    primeraCarga = *on;           // para que CargarSubfile haga *LOVAL
                    esPrimeraPag = *on;
                    exsr sf1car;

               endif;
               i = 0;
               // Retroceder hasta 9 registros (o hasta el inicio)
               dow i < 9 and not %eof(setins01);
                    readp(n) setins01;
                    i += 1;
               enddo;
               kLast.sidate = sidate;
               kLast.siempr = siempr;
               kLast.sisucu = sisucu;
               kLast.sisecu = sisecu;
               // Si llegamos al inicio, marcamos primera página
               esPrimeraPag = %eof(setins01);
               // Cargar hacia adelante desde donde quedó el puntero
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
               dow not *in12;
                    if not *in50;
                         write paninsca;
                    endif;
                    write paninsp2;
                    if not *in31;
                         write panins01;
                    endif;
                    exfmt paninsc2;
                    // FUNCIÓN 12: VUELVO

                    // ROLL UP
                    if *in27;
                         exsr rollupSrc;
                    endif;
                    // ROLL DOWN
                    if *in28;
                         exsr rolldo;
                    endif;

                    readc paninss2;
                    if x2opci = 2;
                         exsr cambioDestinoObjFuente;
                    endif;

                    if *in07 and s1marf = '0';
                         auxSec = x1secu;
                         callp pggfuentes(s1desa : auxSec);
                         if auxSec = -1;
                              exfmt FUENTEAERR;
                         else;
                              x1secu = auxSec;
                         endif;
                    endif;
                    if *in08 and s1maro = '0';
                         auxSec = x1secu;
                         callp pggobjetos(s1desa : auxSec);
                         if auxSec = -1;
                              exfmt FUENTEAERR;
                         else;
                              x1secu = auxSec;
                         endif;
                    endif;
                    exsr sf2car;
               enddo;
               xxiden = 1;
               psecu = sisecu;
               pinst = siinst;
               exsr sf1car;
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
               setll ksetsrc setsrc;
               reade ksetsrc setsrc;
               dow not %eof(setsrc) and sf2rrn < 09;
                    *in31 = *on;
                    exsr moar02;
                    if sf2rrn = 1;
                         pfuen = s1nfue;
                    else;
                         ufuen = s1nfue;
                    endif;
                    sf2rrn += 1;
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
          begsr rollupSrc;
               // ROLL PARA ADELANTE
               setgt ksetsrc setsrc;
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
               sf2rrn = *zeros;
               setll ksetsrc1 setsrc;
               dow sf2rrn < 09;
                    readpe ksetsrc setsrc;
                    if %eof(setsrc);
                         leave;
                    else;
                         sf2rrn += 1;
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
               auxSec = 0;
               *in30  = *off;
               *in31  = *off;
               sf2rrn = *zeros;
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
     *  - CAMPOS DE TRABAJO...                            |     |
     *- DEFINICION DE CLAVES P/ACCESO A ARCHIVOS ...      |
     C     ksetsrc1      klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C                   kfld                    X1desa
     C                   kfld                    X1secu
     C                   kfld                    pfuen
     C     ksetsrcu      klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C                   kfld                    s1desa
     C                   kfld                    s1secu
     C                   kfld                    x2obje
     C     ksetsrc       klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C                   kfld                    X1desa
     C                   kfld                    X1secu
      *inst
     C     ksetins       klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C     ksetinsu      klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C                   kfld                    uinst
     C                   kfld                    usecu
     C     ksetinsp      klist
     C                   kfld                    uds.usempr
     C                   kfld                    uds.ussucu
     C                   kfld                    pinst
     C                   kfld                    psecu
     C                   endsr                                                  |
** DES
   ALTA   |1
   BAJA   |2
  CAMBIO  |3
 CONSULTA |4
