        // -------------------------------------------------------- //
        // STR020: Estados de Siniestros.                           //
        //         Obtiene Contadores de Zamba.                     //
        //                                                          //
        // -------------------------------------------------------- //
        //  Luis R. Gomez                          *18-Feb-2024     //
        // -------------------------------------------------------- //
        //                                                          //
        // -------------------------------------------------------- //
        ctl-opt
                actgrp(*caller)
                bnddir('HDIILE/HDIBDIR')
                option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
                datfmt(*iso) timfmt(*iso);

        dcl-f set334   disk usage(*input) keyed;
        dcl-f set335   disk usage(*input) prefix(t5:2) keyed;
        dcl-f gti950   usage(*input:*output:*update:*delete) keyed;
        dcl-f set915   usage(*input:*output:*update:*delete) keyed;
        dcl-f ctlst2   usage(*input:*output:*update:*delete) keyed;
        dcl-f gti951   usage(*input:*output) keyed;

        dcl-ds k1yst2 likerec(c1lst2:*key);
        dcl-ds k1y915 likerec(s1t915:*key);
        dcl-ds k1y951 likerec(g1i951:*key);

        dcl-pr STR020 extpgm('STR020');
               peIdpr packed(10:0);
        end-pr;

        dcl-pi STR020;
               peIdpr packed(10:0);
        end-pi;

      /copy hdiile/qcpybooks,jdbc_h
      /copy hdiile/qcpybooks,dclproto_h

        dcl-s peConn   like(Connection);
        dcl-s peStmt   like(PreparedStatement);
        dcl-s peStm2   like(PreparedStatement);
        dcl-s peStm3   like(PreparedStatement);
        dcl-s peRset   like(ResultSet);
        dcl-s peRse2   like(ResultSet);
        dcl-s peTabl   char(10);
        dcl-s @@id     int(10);
        dcl-s @@obsv   char(256);
        dcl-s @@cantR  packed(18:0);
        dcl-s @@cantI  packed(18:0);
        dcl-s @@lchki  char(30);
        dcl-s @@tabla  char(30);

        *inlr = *on;

        clear @@id;
        clear @@cantR;
        clear @@cantI;
        clear @@lchki;
        exsr getUltCorrida;
        exsr setNumeroDeCorrida;
        exsr setIniciaCtl;

        //
        // Conectar y preparar statements
        //
        setgt *hival set334;
        readp set334;
        if %eof;
           @@obsv = 'Falta datos de conexion - SET334';
           exsr setErrorCtl;
           peIdpr = -1;
           return;
        endif;

        peTabl = 'ESTADOS';
        chain peTabl set335;
        if not %found;
           @@obsv = 'Falta datos SQL - SET335';
           exsr setErrorCtl;
           peIdpr = -1;
           return;
        endif;

        monitor;
           peConn = JDBC_Connect( %trim(t@driv)
                                : %trim(t@durl)
                                : %trim(t@bddu)
                                : %trim(t@pass) );
           if peConn = *null;
              @@obsv = 'Fall al intentar conectar con el servidor - SET334';
              exsr setErrorCtl;
              peIdpr = -1;
              return;
           endif;
        on-error;
              @@obsv = 'Fall al intentar conectar con el servidor - SET334';
              exsr setErrorCtl;
              peIdpr = -1;
              return;
        endmon;

        t5stmt = %scanrpl( '%DB%'
                         : %trim(t@bddn)
                         : t5stmt        );

        t5stmt = %scanrpl( '%FECC%'
                         : %trim(@@lchki)
                         : t5stmt        );

        peStmt = JDBC_PrepStmt( peConn : %trim(t5stmt) );
        if peStmt = *null;
           @@obsv = 'Falla  peStmt = *null';
           exsr setErrorCtl;
           JDBC_close( peConn );
           peIdpr = -1;
           return;
        endif;

        peTabl = 'ESTADOS';
        chain peTabl set335;
        if not %found;
           @@obsv = 'Falta datos SQL - SET335';
           exsr setErrorCtl;
           monitor;
             JDBC_freePrepStmt( peStmt );
             JDBC_close( peConn );
           on-error;
           endmon;
           peIdpr = -1;
           return;
        endif;

        t5stmt = %scanrpl( '%DB%'
                         : %trim(t@bddn)
                         : t5stmt        );
        t5stmt = %scanrpl( '%FECC%'
                         : %trim(@@lchki)
                         : t5stmt        );
        peStm2 = JDBC_PrepStmt( peConn : %trim(t5stmt) );
        if peStm2 = *null;
           @@obsv = 'Falla  peStm2 = *null';
           exsr setErrorCtl;
           monitor;
             JDBC_freePrepStmt( peStmt );
             JDBC_close( peConn );
           on-error;
           endmon;
           peIdpr = -1;
           return;
        endif;

         peRset = JDBC_execPrepQry(peStmt);
         if (peRset = *null);
            @@obsv = 'No se encontró información para procesar';
            exsr setErrorCtl;
            monitor;
              JDBC_freePrepStmt( peStmt );
              JDBC_freePrepStmt( peStm2 );
              JDBC_close( peConn );
            on-error;
            endmon;
            peIdpr = -1;
            return;
         endif;

         @@obsv = 'No se encontró información para procesar';
         dow JDBC_nextRow(peRset);
             clear @@obsv;
             G0CHKI  = %char(JDBC_getCol(peRset:1));
             @@lchki = %char(JDBC_getCol(peRset:1));

             monitor;
               G0WKID = %int(JDBC_getCol(peRset:2));
             on-error;
               G0WKID = 0;
             endmon;
             G0WNME = %char(JDBC_getCol(peRset:3));

             monitor;
                G0STID = %int(JDBC_getCol(peRset:4));
              on-error;
                G0STID = 0;
             endmon;
             G0STPN = %char(JDBC_getCol(peRset:5));

             monitor;
                G0SPID = %int(JDBC_getCol(peRset:6));
              on-error;
                G0SPID = 0;
             endmon;

             G0DSPN = %char(JDBC_getCol(peRset:7));

             monitor;
                G0DCID = %int(JDBC_getCol(peRset:8));
             on-error;
                G0DCID = 0;
             endmon;

             monitor;
                G0DTID = %int(JDBC_getCol(peRset:9));
              on-error;
                G0DTID = 0;
             endmon;

             //G0USER = %char(JDBC_getCol(peRset:10));
             //G0USRN = %char(JDBC_getCol(peRset:11));
             //G0USRM = %char(JDBC_getCol(peRset:12));

             G0IDPR = @@id;

             exsr ObtenerData;
             exsr UsuarioCarpeta;

             monitor;
                @@cantR += 1;
                write G1I950;
                @@cantI += 1;
                clear G1I950;
              on-error;
                // Ver de grabar log de errores...
                @@obsv = ' Falló write en gti950 '
                       + 'Rama : ' + %trim(%char(g0rama))
                       + 'Siniestro : ' + %trim(%char(g0sini))
                       + 'Nro Operacion : ' + %trim(%char(g0nops));
                exsr setErrorCtl;

             endmon;
         enddo;

        monitor;
          JDBC_freePrepStmt( peStmt );
          JDBC_freePrepStmt( peStm2 );
          JDBC_close( peConn );
        on-error;
        endmon;
        exsr updCantidadCtl;
        peIdpr = @@id;
        return;

        begsr setNumeroDeCorrida;
          k1y915.t@empr = 'A';
          k1y915.t@sucu = 'CA';
          k1y915.t@tnum = 'PZ';
          chain %kds( k1y915 : 3 ) set915;
          if %found( set915 );
            if t@nres = 9999999;
               t@nres = 0;
            endif;
            t@nres += 1;
            t@user  = @PsDs.CurUsr;
            t@date  = %dec(%date);
            t@time  = %dec(%time);
            update s1t915;
          else;
            t@empr  = 'A';
            t@sucu  = 'CA';
            t@dnum  = 'Proceso de Estados de Siniestros';
            t@tnum  = 'PZ';
            t@nres  = 1;
            t@user  = @PsDs.CurUsr;
            t@date  = %dec(%date);
            t@time  = %dec(%time);
            write  s1t915;
          endif;

          // Guardar nro de Corrida.-
          @@id   = t@nres;
          peIdpr = t@nres;
        endsr;

        begsr setIniciaCtl;

          k1yst2.c1empr = 'A';
          k1yst2.c1sucu = 'CA';
          k1yst2.c1idpr = @@id;
          chain %kds( k1yst2 : 3 ) ctlst2;
          clear c1lst2;
          c1empr = 'A';
          c1sucu = 'CA';
          c1idpr = @@id;
          c1esta = '0';
          c1user = 'PROC_ZAMBA';
          c1date = %dec(%date():*iso);
          c1time = %dec(%time():*iso);
          if %found();
             update c1lst2;
          else;
             write c1lst2;
          endif;
        endsr;

        begsr getUltCorrida;
          clear @@lchki;
          k1yst2.c1empr = 'A';
          k1yst2.c1sucu = 'CA';
          setgt %kds( k1yst2 : 2 ) ctlst2;
          readpe(n) %kds( k1yst2 : 2 ) ctlst2;
          dow not %eof();
             if c1esta <> 'E' and c1fecc <> *blanks;
                @@lchki = c1fecc;
                leave;
             endif;
            readpe(n) %kds( k1yst2 : 2 ) ctlst2;
          enddo;

          if %trim(@@lchki) = *blanks;
             @@lchki = %char( %date() - %years(2)) + ' 00:00:000';
          endif;
        endsr;

        begsr setErrorCtl;
          k1yst2.c1empr = 'A';
          k1yst2.c1sucu = 'CA';
          k1yst2.c1idpr = @@id;
          chain %kds( k1yst2 : 3 ) ctlst2;
            if %found();
               c1obsv = @@obsv;
               c1esta = 'E';
               monitor;
                 update c1lst2;
               on-error;
               endmon;
               return;
            endif;
          return;
        endsr;

        begsr updCantidadCtl;

          k1yst2.c1empr = 'A';
          k1yst2.c1sucu = 'CA';
          k1yst2.c1idpr = @@id;
          chain %kds( k1yst2 : 3 ) ctlst2;
            if %found();
               c1canp = @@cantR;
               c1cani = @@cantI;
               c1obsv = @@obsv;
               c1esta = '1';
               c1fecc = @@lchki;
               monitor;
                 update c1lst2;
               on-error;
               endmon;
            endif;
        endsr;

        begsr ObtenerData;

          clear  g0sini;
          clear  g0rama;
          clear  g0nops;
          clear  g0user;
          clear  g0usrn;
          clear  g0usrm;


           peTabl  = 'I' + %trim(%char(G0DTID));
           chain peTabl set335;
           if not %found;
              clear  g0sini;
              clear  g0rama;
              clear  g0nops;
              leaveSr;
           endif;

           t5stmt = %scanrpl( '%DB%'
                            : %trim(t@bddn)
                            : t5stmt        );

           @@tabla = 'Doc_I' + %trim(%char(G0DTID));
           t5stmt = %scanrpl( '%TABLA%'
                            : %trim(@@tabla)
                            : t5stmt         );

           t5stmt = %scanrpl( '%doc_id%'
                            : %trim(%char(G0DCID))
                            : t5stmt         );

           peStm3 = JDBC_PrepStmt( peConn : %trim(t5stmt) );
           if peStm3 = *null;
              clear  g0sini;
              clear  g0rama;
              clear  g0nops;
              leaveSr;
           endif;

            peRse2 = JDBC_execPrepQry(peStm3);
            if (peRse2 = *null);
              clear  g0sini;
              clear  g0rama;
              clear  g0nops;
              leaveSr;
            endif;

            dow JDBC_nextRow(peRse2);
                monitor;
                  g0sini = %int(JDBC_getCol(peRse2:1));
                  g0rama = %int(JDBC_getCol(peRse2:2));
                  g0nops = %int(JDBC_getCol(peRse2:3));
                on-error;
                endmon;
            enddo;
            JDBC_freePrepStmt( peStm3 );

        endsr;

        begsr UsuarioCarpeta;
           if g0sini > 0   and
              g0sini <> 3  and
              g0sini <> 6  and
              g0sini <> 12;

              peTabl  = 'GET_USER_R';
              chain peTabl set335;
              if not %found;
                 clear  g0user;
                 clear  g0usrn;
                 clear  g0usrm;
                 leaveSr;
              endif;

              t5stmt = %scanrpl( '%DB%'
                               : %trim(t@bddn)
                               : t5stmt        );

              t5stmt = %scanrpl( '%siniestro%'
                               : %trim(%char(G0SINI))
                               : t5stmt         );

              t5stmt = %scanrpl( '%rama%'
                               : %trim(%char(G0RAMA))
                               : t5stmt         );

              t5stmt = %scanrpl( '%nops%'
                               : %trim(%char(G0NOPS))
                               : t5stmt         );

              peStm3 = JDBC_PrepStmt( peConn : %trim(t5stmt) );
              if peStm3 = *null;
                 clear  g0user;
                 clear  g0usrn;
                 clear  g0usrm;
                 leaveSr;
              endif;

               peRse2 = JDBC_execPrepQry(peStm3);
               if (peRse2 = *null);
                 clear  g0user;
                 clear  g0usrn;
                 clear  g0usrm;
                 leaveSr;
               endif;

               dow JDBC_nextRow(peRse2);
                   monitor;
                     g0user = %trim(JDBC_getCol(peRse2:1));
                     g0usrn = %trim(JDBC_getCol(peRse2:2));
                     g0usrm = %trim(JDBC_getCol(peRse2:3));
                   on-error;
                   endmon;
               enddo;
               JDBC_freePrepStmt( peStm3 );
          endif;
        endsr;
