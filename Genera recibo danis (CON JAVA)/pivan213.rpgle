     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H datedit(*ymd/)
      * ************************************************************ *
      * PIVAN196: desa196                                            *
      * ------------------------------------------------------------ *
      * Ivan M. Fabella               *10-Oct-2019                   *
      * ************************************************************ *
     Fgntprc    if a e           k disk    usropn
     Fgntspr    if a e           k disk    usropn
     Fgntprp    if a e           k disk    usropn
     Fsetprv    if a e           k disk    usropn
     Fsetlog    if a e           k disk    usropn

      /copy inf1serg/qcpybooks,pmsg_h
      /copy inf1serg/qcpybooks,psys_h
      /copy inf1serg/qcpybooks,ceetrec_h
      /copy inf1serg/qcpybooks,spwliblc_h
      /copy inf1serg/qcpybooks,curlib_h
      /copy inf1serg/qcpybooks,getsysv_h

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const

     D curlib          s             10a
     D AS400Sys        s             10a
     D peCprc          s             20a   inz('ENVIOINDEMINIZACION')
     D peCspr          s             20a   inz('ENVIOINDEMINIZACION')
     D this            s             10a
     D cmd             s            256a

     D                 DS
     D  @@empr                        1A   dim(21)
     D  @@sucu                        2A   dim(21)
     D  @@nivc                        7P 0 dim(21)

     D i               S             10I 0 inz(1)

     D k1tprc          ds                  likerec(g1tprc:*key)
     D k1tspr          ds                  likerec(g1tspr:*key)
     D k1tprp          ds                  likerec(g1tprp:*key)
     D k1tprv          ds                  likerec(a1prap:*key)
     D k1tlog          ds                  likerec(S1TLOG:*key)

     D @PsDs          sds                  qualified
     D  this                         10a   overlay(@PsDs:1)
     D  CurUsr                       10a   overlay(@PsDs:358)

     D peCnam          s             10a   inz('CXP668N')

      /free

       *inlr = *ON;

       this = @PsDs.this;
       // ---------------------------
       // En qué máquina estoy
       // ---------------------------
       AS400Sys = rtvSysName();
       if ( AS400Sys = *blanks );
          PATCH_comp( %trim(this) + ' Error: no se pudo determinar '
                    + 'nombre de Sistema' );
          CEETREC( *omit: 1 );
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

       open gntprc;
       open gntspr;
       open gntprp;
       open setprv;
       open setlog;


       if AS400Sys <> 'SOFTDESA' and AS400Sys <> 'SOFTTEST';
          k1tprp.rpmail = 'Nancy.gochez@hdi.com.ar';

        else;
          k1tprp.rpmail = 'U.01@srvdesa.com';

       endif;

       k1tlog.T@NAME = peCnam;
       setll %kds(k1tlog:1) setlog;
       if not %equal;
          T@NAME = peCnam;
          T@DESC = 'Log de recibos enviados';
          T@HABL = '1';
          T@PROC = '1';
          T@MAR1 = 'D';
          T@MAR2 = '1';
          T@MAR3 = '1';
          write s1tlog;
       endif;
       k1tprc.rccprc = peCprc;
       setll %kds(k1tprc:1) gntprc;
       if not %equal;
          rccprc = k1tprc.rccprc;
          rcdprc = 'ENVIOINDEMINIZACION';
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
          rcuser = @PsDs.CurUsr;
          rcdate = udate;
          rctime = %dec(%time():*iso);
          write g1tprc;
       endif;

       //
       // GNTSPR
       //
       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       setll %kds(k1tspr) gntspr;
       if not %equal;
          prcprc = peCprc;
          prcspr = k1tspr.prcspr;
          prdspr = 'ENVIOINDEMINIZACION';
          prasun = '';
          primpo = 2;
          prsens = 0;
          prprio = 2;
          przip  = '*NO';
          przipn = *blanks;
          prnotf = '*YES';
          prma01 = '0';
          prma02 = '1';
          prma03 = '0';
          prma04 = '0';
          prma05 = '0';
          prma06 = '0';
          prma07 = '0';
          prma08 = '0';
          prma09 = '0';
          prma10 = '0';
          prstrg = '0';
          pruser = @PsDs.CurUsr;
          prdate = udate;
          prtime = %dec(%time():*iso);
          prfrom = '*SYSTEM';
          write g1tspr;
       endif;

       //
       // GNTPRP
       //
       k1tprp.rpcprc = peCprc;
       k1tprp.rpcspr = peCspr;
       rpnomb = 'procAut';
       setll %kds(k1tprp) gntprp;
       if not %equal;
          rpcprc = peCprc;
          rpcspr = k1tprp.rpcspr;
          rpmail = k1tprp.rpmail;
          rpma01 = '1';
          rpma02 = 'S';
          rpma03 = '0';
          rpma04 = '0';
          rpma05 = '0';
          rpma06 = '0';
          rpma07 = '0';
          rpma08 = '0';
          rpma09 = '0';
          rpma10 = '0';
          rpstrg = '0';
          rpuser = @PsDs.CurUsr;
          rpdate = udate;
          rptime = %dec(%time():*iso);
          write g1tprp;
       endif;

       close *all;


       // -----------------------------
       // Reestablezco valor de CURLIB
       // -----------------------------
       setCurLib(curlib);

       PATCH_comp( %trim(this) + ' finalizado CORRECTAMENTE!' );

       CEETREC( *omit: 0 );

       return;

      /end-free


      /define PMSG_LOAD_PROCEDURE
      /copy inf1serg/qcpybooks,pmsg_h

      /define PSYS_LOAD_PROCEDURE
      /copy inf1serg/qcpybooks,psys_h

      /define LOAD_CURLIB_PROCEDURE
      /copy inf1serg/qcpybooks,curlib_h

      /define GETSYSV_LOAD_PROCEDURE
      /copy inf1serg/qcpybooks,getsysv_h

     Pgira_fecha       b
     Dgira_fecha       pi             8  0
     D p@fech                         8  0
     D p@tipo                         3    const

     D retfld          s              8  0

     D                 ds
     D p@famd                  1      8  0
     D amd_aÑo                 1      4  0
     D amd_mes                 5      6  0
     D amd_dia                 7      8  0

     D                 ds
     D p@fdma                  1      8  0
     D dma_dia                 1      2  0
     D dma_mes                 3      4  0
     D dma_aÑo                 5      8  0

      /free
        select;
          when p@tipo = 'AMD';
              p@fdma = p@fech;
              amd_dia = dma_dia;
              amd_mes = dma_mes;
              amd_aÑo = dma_aÑo;
              retfld = p@famd;
              return retfld;
          when p@tipo = 'DMA';
              p@famd = p@fech;
              dma_dia = amd_dia;
              dma_mes = amd_mes;
              dma_aÑo = amd_aÑo;
              retfld = p@fdma;
              return retfld;
        endsl;
              return p@fech;
      /end-free

     Pgira_fecha       e
