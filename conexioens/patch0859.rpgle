     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
      * ************************************************************ *
      * PIVAN0859 : Agrega registros para envio de mail de archivo   *
      *             Patch correspondiente al desa DESA-859           *
      * ------------------------------------------------------------ *
      * Fabella Ivan M. *25-08-2025                                  *
      * ************************************************************ *
     Fgntprp    if a e           k disk    usropn
     Fgntprc    if a e           k disk    usropn
     Fgntspr    if a e           k disk    usropn
     Fgntbdy    if a e           k disk    usropn
     Fset335    if a e           k disk    usropn
     Fset915    if a e           k disk    usropn
     Fgntpgm    if a e           k disk    usropn
     Fgntdpg    if a e           k disk    usropn

      /copy *libl/qcpybooks,pmsg_h
      /copy *libl/qcpybooks,psys_h
      /copy *libl/qcpybooks,ceetrec_h
      /copy *libl/qcpybooks,spwliblc_h
      /copy *libl/qcpybooks,curlib_h
      /copy *libl/qcpybooks,getsysv_h
     D @PsDs          sds                  qualified
     D  this                         10a   overlay(@PsDs:1)
     D  CurUsr                       10a   overlay(@PsDs:358)
        dcl-s AS400Sys char(10);
        dcl-s curlib char(10);
        dcl-s peCprc char(20) inz('WSPCAF');
        dcl-s peCspr char(50) inz('WSPCAF');
        //claves
        dcl-ds k1tbdy likerec(g1tbdy : *key);
        dcl-ds k1tprp likerec(g1tprp : *key);
        dcl-ds k1tspr likerec(g1tspr : *key);
        dcl-ds k1tprc likerec(g1tprc : *key);
        dcl-ds k1t335 likerec(s1t335 : *key);
        dcl-ds k1y915 likerec(s1t915:*key);
      /free
         *inlr = *on;
        // ---------------------------
        // En qué máquina estoy
        // ---------------------------
         AS400Sys = rtvSysName();
         if ( AS400Sys = *blanks );
         PATCH_comp( %trim(@PsDs.this) + ' Error: no se pudo determinar '
                     + 'nombre de Sistema' );
         CEETREC( *omit: 1 );
         endif;
         if AS400Sys <> 'SOFTDESA' and AS400Sys <> 'SOFTTEST';
            RPNOMB = 'USUARIO PRODUCCION';
            RPMAIL = 'mail@hdi.com.ar';
            pgausu = 'ALVAREZPAB';
         else;
            RPMAIL = 'U.01@srvdesa.com.ar';
            RPNOMB = 'UsuarioTEST';
            pgausu = 'TESTGAUS';
         endif;
        // ---------------------------
        // Salvo CURLIB
        // ---------------------------
         curlib = getCurLib();
        // ---------------------------
        // Elimino CURLIB
        // ---------------------------
         rmvCurLib();
        // ---------------------------
        // Armo LIBL
        // ---------------------------
         spwliblc('P');
         open gntprp;
         //Destinatario de mail.
         k1tprp.rpcprc = peCprc;
         k1tprp.rpcspr = peCspr;
         chain %kds(k1tprp:2) gntprp;
         if not %found;
            RPCPRC = peCprc;
            RPCSPR = peCspr;
            //RPMAIL = ' ';
            //RPNOMB = '*REQUESTER';
            RPMA01 = '1';
            RPMA02 = 'S';
            RPMA03 = '0';
            RPMA04 = '0';
            RPMA05 = '0';
            RPMA06 = '0';
            RPMA07 = '0';
            RPMA08 = '0';
            RPMA09 = '0';
            RPMA10 = '0';
            RPSTRG = '0';
            RPUSER = @PsDs.CurUsr;
            RPDATE = udate;
            RPTIME = %dec(%time():*iso);
            write g1tprp;
         endif;
         k1tprp.rpcprc = peCprc;
         k1tprp.rpcspr = 'PRODUCTOROK';
         chain %kds(k1tprp:2) gntprp;
         if not %found;
            RPCPRC = peCprc;
            RPCSPR = 'PRODUCTOROK';
            //RPMAIL = ' ';
            //RPNOMB = '*REQUESTER';
            RPMA01 = '1';
            RPMA02 = 'S';
            RPMA03 = '0';
            RPMA04 = '0';
            RPMA05 = '0';
            RPMA06 = '0';
            RPMA07 = '0';
            RPMA08 = '0';
            RPMA09 = '0';
            RPMA10 = '0';
            RPSTRG = '0';
            RPUSER = @PsDs.CurUsr;
            RPDATE = udate;
            RPTIME = %dec(%time():*iso);
            write g1tprp;
         endif;
         open gntspr;
         //Asunto de mail
         k1tspr.PRCPRC = peCprc;
         k1tspr.PRCSPR = peCspr;
         chain %kds(k1tspr:2) gntspr;
         if not %found;
            PRCPRC = peCprc;
            PRCSPR = peCspr;
            PRDSPR = 'Carta De Franquicia solicitada';
            PRASUN = 'Carta De Franquicia solicitada';
            PRIMPO = 0;
            PRSENS = 0;
            PRPRIO = 0;
            PRZIP  = '*NO';
            PRZIPN = '';
            PRNOTF = '*YES';
            PRMA01 = '0';
            PRMA02 = '0';
            PRMA03 = '0';
            PRMA04 = '0';
            PRMA05 = '0';
            PRMA06 = '0';
            PRMA07 = '0';
            PRMA08 = '0';
            PRMA09 = '0';
            PRMA10 = '0';
            PRSTRG = '0';
            PRUSER = @PsDs.CurUsr;
            PRDATE = udate;
            PRTIME = %dec(%time():*iso);
            PRFROM = '*SYSTEM';
            PRFADR = ' ';
            PRFNAM = ' ';
            PRRPYT = ' ';
            write g1tspr;
         endif;
         //Asunto de mail
         k1tspr.PRCPRC = peCprc;
         k1tspr.PRCSPR =  'PRODUCTOROK';
         chain %kds(k1tspr:2) gntspr;
         if not %found;
            PRCPRC = peCprc;
            PRCSPR =  'PRODUCTOROK';
            PRDSPR = 'Carta De Franquicia disponible';
            PRASUN = 'Carta De Franquicia disponible';
            PRIMPO = 0;
            PRSENS = 0;
            PRPRIO = 0;
            PRZIP  = '*NO';
            PRZIPN = '';
            PRNOTF = '*YES';
            PRMA01 = '0';
            PRMA02 = '0';
            PRMA03 = '0';
            PRMA04 = '0';
            PRMA05 = '0';
            PRMA06 = '0';
            PRMA07 = '0';
            PRMA08 = '0';
            PRMA09 = '0';
            PRMA10 = '0';
            PRSTRG = '0';
            PRUSER = @PsDs.CurUsr;
            PRDATE = udate;
            PRTIME = %dec(%time():*iso);
            PRFROM = '*SYSTEM';
            PRFADR = ' ';
            PRFNAM = ' ';
            PRRPYT = ' ';
            write g1tspr;
         endif;
         open gntprc;
         k1tprc.RCCPRC = peCprc;
         chain %kds(k1tprc) gntprc;
         if not %found;
            RCCPRC = peCprc;
            RCDPRC = peCspr;
            RCUSER = @PsDs.CurUsr;
            RCDATE = udate;
            RCTIME = %dec(%time():*iso);
            rcma01 = '0';
            rcma02 = '0';
            rcma03 = '0';
            rcma04 = '0';
            rcma05 = '0';
            rcma06 = '0';
            rcma07 = '0';
            rcma08 = '0';
            rcma09 = '0';
            rcma10 = '0';
            rcstrg = '0';
            write g1tprc;
         endif;
         open gntbdy;
         k1tbdy.DYCPRC = peCprc;
         k1tbdy.DYCSPR = peCspr;
         chain %kds(k1tbdy) gntbdy;
         if not %found;
            DYCPRC = peCprc;
            DYCSPR = peCspr;
            dybody = 'Se ha solicitado una carta '   +
                     'de franquicia para el número'  +
                     ' de siniestro %SIN% por el '   +
                     'productor %PRD% para presentar'+
                     ' en la empresa de seguros %EMPR%';
            write g1tbdy;
         endif;

         k1tbdy.DYCPRC = peCprc;
         k1tbdy.DYCSPR = 'PRODUCTOROK';
         chain %kds(k1tbdy) gntbdy;
         if not %found;
            DYCPRC = peCprc;
            DYCSPR = 'PRODUCTOROK';
            dybody = 'Su carta de franquicia ya esta '
                   + 'disponible en la web. Muchas gracias.';
            write g1tbdy;
         endif;

         open set335;
         k1t335.t@tabl = 'INSPECCION';
         chain %kds(k1t335:1) set335;
         if not %found;
            t@tabl = 'INSPECCION';
            t@stmt = 'SELECT a.I26247 AS siniestro, a.I26294 AS rama, '
                    + 'a.I33609 AS ins_res, '
                    + 'a.i33625 as ins_rc FROM %DB%.dbo.Doc_I26032 '
                    + 'a WHERE a.I26247 = %SINIESTRO% AND a.I26294 = %RAMA%';
            write s1t335;
         endif;
         //control de ejecucion
         open set915;
         k1y915.t@empr = 'A';
         k1y915.t@sucu = 'CA';
         k1y915.t@tnum = 'PI';
         chain %kds(k1y915:3) set915;
         if not %found;
            T@EMPR = 'A';
            T@SUCU = 'CA';
            T@TNUM = 'PI';
            write s1t915;
         endif;

         //Autorizaciones al dba859
         open gntdpg;
         open gntpgm;
         //pgm en siniestros (10)
         dgtsbs = 10;
         dgipgm = 'DBA859A';
         dgtdpg = 'CONTROL CARTA DE FRANQUICIA';
         write g1tdpg;
         //Autorizo a usuario
         pgtsbs = 10;
         pgipgm = 'DBA859A';
         pgffva = *year;
         pgffvm = *month;
         pgffvd = *day;
         pgfiva = 2050;
         pgfivm = 12;
         pgfivd = 31;
         pgtalt = 'S';
         pgtbaj = 'S';
         pgtcam = 'S';
         pgtcon = 'S';
         pgnaut = 9;
         pgmarp = 'S';
         write g1tpgm;
         close *all;

      /end-free

      /define PMSG_LOAD_PROCEDURE
      /copy *libl/qcpybooks,pmsg_h

      /define PSYS_LOAD_PROCEDURE
      /copy *libl/qcpybooks,psys_h

      /define LOAD_CURLIB_PROCEDURE
      /copy *libl/qcpybooks,curlib_h

      /define GETSYSV_LOAD_PROCEDURE
      /copy *libl/qcpybooks,getsysv_h

