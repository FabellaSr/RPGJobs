        // -------------------------------------------------------- //
        // STR021: Estados de Siniestros.                           //
        //         Arma Mensajes a grabar.-                         //
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

        dcl-pr STR021 extpgm('STR021');
               peIdpr packed(10:0);
        end-pr;

        dcl-pi STR021;
               peIdpr packed(10:0);
        end-pi;

        dcl-f set334   disk usage(*input) keyed;
        dcl-f set335   disk usage(*input) prefix(t5:2) keyed;
        dcl-f gti95001 usage(*input) keyed;
        dcl-f gti951   usage(*input) keyed;
        dcl-f gti952   usage(*input) keyed;
        dcl-f set485   usage(*input) keyed;
        dcl-f ctlst2   usage(*input:*output:*update:*delete) keyed;
        dcl-f ctlsew   usage(*input:*output:*update:*delete) keyed;
        dcl-f pahsew   usage(*input:*output:*update:*delete) keyed Usropn;
        dcl-f gnttbe   usage(*input:*output) keyed;

        dcl-ds k1yst2 likerec(c1lst2:*key);
        dcl-ds k1csew likerec(c1lsew:*key);
        dcl-ds k1y950 likerec(g1i950:*key);
        dcl-ds k1y951 likerec(g1i951:*key);
        dcl-ds k1y952 likerec(g1i952:*key);
        dcl-ds k1y485 likerec(s1t485:*key);
        dcl-ds k1ysew likerec(p1hsew:*key);
        dcl-ds k1ytbe likerec(g1ttbe:*key);

      /copy hdiile/qcpybooks,dclproto_h
      /copy hdiile/qcpybooks,jdbc_h
      /copy hdiile/qcpybooks,svpsin_h
      /copy hdiile/qcpybooks,spvfec_h
      /copy hdiile/qcpybooks,svpsi1_h

        //Variables de conexion...
        dcl-s peConn   like(Connection);
        dcl-s peStmt   like(PreparedStatement);
        dcl-s peStm2   like(PreparedStatement);
        dcl-s peStm3   like(PreparedStatement);
        dcl-s peRset   like(ResultSet);
        dcl-s peRse3   like(ResultSet);
        dcl-s peTabl   char(10);
        dcl-s @@wkid   packed(10:0);
        dcl-s @@wnme   char(50);
        dcl-s @@stid   packed(18:0);
        dcl-s @@stpn   char(50);
        dcl-s @@spid   packed(18:0);
        dcl-s @@dspn   char(50);

        dcl-s @@id     int(10);
        dcl-s @@obsv   char(256);
        dcl-s @@camp   int(10);
        dcl-s @@cami   int(10);
        dcl-s @@fech   packed(8:0);

        // Buscar Variables...
        dcl-s posStart    int(5) inz(1);
        dcl-s posPctOpen  int(5);
        dcl-s posPctClose int(5);
        dcl-s varName     varchar(100);
        dcl-s @@stmt      char(1024);
        dcl-s @@secu      int(10);
        dcl-s @@desi      char(256);
        dcl-s @@imp       packed(18:2);
        dcl-ds @@Dsop     likeds( dsCnhopa_t );
        dcl-s @@falt      packed(8:0);
        dcl-s @@halt      packed(6:0);
        dcl-s @@ualt      char(10);
        dcl-s @@manual    ind;

        *inlr = *on;

        if not %open(pahsew);
           open pahsew;
        endif;

        k1yst2.c1empr = 'A';
        k1yst2.c1sucu = 'CA';
        k1yst2.c1idpr = peIdpr;
        chain %kds( k1yst2 : 3 ) ctlst2;
        if not %found();
           // Error.-
           peIdpr = -1;
           close *all;
           svpsin_end();
           svpsi1_end();
           return;
        endif;

        k1csew.c0empr = 'A';
        k1csew.c0sucu = 'CA';
        k1csew.c0idpr = peIdpr;
        chain %kds( k1csew : 3 ) ctlsew;
        if %found();
           // Error.-
           peIdpr = -1;
           close *all;
           svpsin_end();
           svpsi1_end();
           return;
        endif;

        //
        setgt *hival set334;
        readp set334;
        if %eof;
           // Error.-
           @@obsv = 'Fallo en la conexion con BDD de Zamba ';
           c1esta = 'E';
           update c1lst2;
           peIdpr = -1;
           close *all;
           svpsin_end();
           svpsi1_end();
           return;
        endif;

        monitor;
          peConn = JDBC_Connect( %trim(t@driv)
                               : %trim(t@durl)
                               : %trim(t@bddu)
                               : %trim(t@pass) );
        on-error;
           @@obsv = 'Fallo en la conexion con BDD de Zamba'
                  + '-' + %trim(t@driv)
                  + '-' + %trim(t@durl)
                  + '-' + %trim(t@bddu)
                  + '-' + %trim(t@pass);
           c1esta = 'E';
           update c1lst2;
           peIdpr = -1;
           close *all;
           svpsin_end();
           svpsi1_end();
           return;
        endmon;

        if peConn = *null;
           // Error.-
           @@obsv = 'Fallo en la conexion con BDD de Zamba - peConn = *nul';
           c1esta = 'E';
           update c1lst2;
           peIdpr = -1;
           close *all;
           svpsin_end();
           svpsi1_end();
           return;
        endif;

        clear @@camp;
        clear @@cami;

        k1y950.g0idpr = peIdpr;
        setll %kds( k1y950 : 1 ) gti95001;
        reade %kds( k1y950 : 1 ) gti95001;
        dow not %eof();

         k1y951.g1wkid = g0wkid;
         k1y951.g1stid = g0stid;
         k1y951.g1spid = g0spid;
         k1y951.g1rama = g0rama;
         chain %kds( k1y951 : 4 ) gti951;
         if %found();
            k1y485.t@rama = g1rama;
            k1y485.t@cesi = g1cesi;
            chain %kds( k1y485 : 2 ) set485;
            if %found();
               exsr chkExclusiones;
               if c0esta <> 'E';
                  exsr getVariables;
                endif;
            else;
               c0esta = 'E';
               @@obsv = 'No se encuentra mensaje asociado - set485 para el '
                  + 'Siniestro : ' + %trim(%char(g0sini));
            endif;

            if c0esta  <> 'E';
               clear @@secu;
               k1ysew.ewempr = 'A';
               k1ysew.ewsucu = 'CA';
               k1ysew.ewrama = g0rama;
               k1ysew.ewsini = g0sini;
               k1ysew.ewnops = g0nops;
               chain %kds( k1ysew : 5 ) pahsew;
               if %found();
                  @@secu  = ewivse + 1;
               else;
                  @@secu  = 1;
                  exsr setFechaCarga;
                  exsr setUserAsignado;
               endif;
               ewempr = 'A';
               ewsucu = 'CA';
               ewrama = g0rama;
               ewsini = g0sini;
               ewnops = g0nops;
               ewivse = @@secu;
               ewcesi = g1cesi;
               ewdesi = t@desi;
               ewmar1 = '0';
               ewmar2 = '0';
               ewmar3 = '0';
               ewmar4 = '0';
               ewmar5 = '0';
               ewuser = 'PROC_ZAMBA';
               ewdate = %dec(%date);
               ewtime = %dec(%time);
               write p1hsew;
            endif;
            exsr setMensajeCrl;
         else;
           @@obsv = 'No se encuentra mensaje asociado - gti951 para el '
                  + 'Siniestro : ' + %trim(%char(g0sini));
           c0esta = 'E';
           exsr setMensajeCrl;
         endif;
          reade %kds( k1y950 : 1 ) gti95001;
        enddo;

        c1camp = @@camp;
        c1cami = @@cami;
        update c1lst2;

          monitor;
             JDBC_freePrepStmt( peStmt );
             JDBC_close( peConn );
          on-error;
          endmon;
          close *all;
           svpsin_end();
           svpsi1_end();
        return;

        begsr getVariables;
          posStart = 1;
          clear @@desi;
          @@desi = t@desi;
          dow posStart <= %len(%trim(@@desi));
             posPctOpen = %scan('%' : @@desi : posStart);
             if posPctOpen = 0;
                leave;  // No hay más %
             endif;
             posPctClose = %scan('%' : @@desi : posPctOpen + 1);
             if posPctClose = 0;
                // Mal formado ? salir
                leave;
             endif;

             // Extraer variable
             varName = %subst(@@desi : posPctOpen + 1 : (posPctClose -
                       posPctOpen -1));

             k1y952.G2NVAR = %trim(varName);
             chain %kds( k1y952 : 1 ) gti952;
             if %found();
                exsr setReemplazaVariable;
                if c0esta = 'E';
                    leaveSr;
                endif;
             endif;

             // Buscar la próxima
                posStart = posPctClose + 1;

          enddo;

        endsr;

        begsr setReemplazaVariable;

        if g2mar2 = '1';
           Select;
             when varName = 'FECHA_ORDEN_PAGO';
                // obtener Nro de Orden de pago...
                k1y952.G2NVAR = 'ORDEN_PAGO';
                chain %kds( k1y952 : 1 ) gti952;
                if %found();
                   @@obsv = %trim(%char(G0DCID));
                   exsr setQuery;
                   if c0esta = 'E';
                      leaveSr;
                   endif;
                   dow JDBC_nextRow(peRset);
                       @@obsv = %char(JDBC_getCol(peRset:1));
                       clear @@DsOp;
                       if %trim(@@obsv) = *blanks;
                          @@obsv = '00000000';
                       endif;
                       if svpsin_getCnhopa( 'A'
                                          :'CA'
                                          : 60
                                          : %dec(%trim(@@obsv):6:0)
                                          : @@DsOp );
                           k1ytbe.g1empr = 'A';
                           k1ytbe.g1sucu = 'CA';
                           k1ytbe.g1tben = '1';
                           chain %kds( k1ytbe : 3 ) gnttbe;
                           if not %found();
                              g1dia1 = 3;
                           endif;
                           @@fech = %dec(%editc(@@DsOp.pbfasa:'X')
                                  + %editc(@@DsOp.pbfasm:'X')
                                  + %editc(@@DsOp.pbfasd:'X'):8:0);
                           @@fech = SPVFEC_SumResFecha8( @@fech
                                                        : '+'
                                                        : 'D'
                                                        : g1dia1 );
                           clear @@obsv;
                           @@obsv = %subst( %editc(@@fech:'X'):7:2)
                                  + '/'
                                  + %subst( %editc(@@fech:'X'):5:2)
                                  + '/'
                                  + %subst( %editc(@@fech:'X'):1:4);

                           t@desi = %scanrpl( '%'+varName+'%'
                                  : @@obsv
                                  : t@desi       );
                       else;
                          @@obsv = 'XX/XX/XXXX';
                       endif;
                       t@desi = %scanrpl( '%'+varName+'%'
                              : %trim(@@obsv)
                              : t@desi       );
                   enddo;
                endif;
             other;
               clear @@obsv;
             endsl;
        else;
           // check dependencia.-
           if %trim(G2DPVA) <> *blanks;
                exsr setConDependencia;
           else;
                // CAMPO CLAVE EN GTI950 ?.-
                if %trim(G2MARP) = *on;
                   @@obsv = %trim(%char(G0DCID));
                   exsr setQuery;
                   if c0esta = 'E';
                      leaveSr;
                   endif;
                   dow JDBC_nextRow(peRset);
                       @@obsv = %char(JDBC_getCol(peRset:1));
                       select;
                       when g2mar1 = '1';
                          @@obsv = %editw(%dec(
                    %trim(@@obsv): 18: 2):'   .   .   .   .   . 0 ,  ');
                       when g2mar1 = '2';
                          monitor;
                            @@obsv = %subst(%trim(@@obsv): 1: 10);
                          on-error;
                            @@obsv = 'XX/XX/XXXX';
                          endmon;
                       other;
                       endsl;
                       if %trim(@@obsv)= *blank or %trim(@@obsv)=*all'0';
                          @@obsv = '-';
                       endif;
                       t@desi = %scanrpl( '%'+varName+'%'
                              : %trim(@@obsv)
                              : t@desi        );
                       leaveSr;
                   enddo;
                endif;
           endif;
        endif;
        endsr;

        begsr setQuery;
          @@stmt = 'Select '
                 + %trim(G2IDVA)
                 + ' from %DB%'
                 + '.dbo.'
                 + %trim(G2LTID)
                 + %trim(%char(G2DTID))
                 + ' where '
                 + %trim(G2KEY)
                 + '= '
                 + %trim(@@obsv);

          @@stmt = %scanrpl( '%DB%'
                           : %trim(t@bddn)
                           : @@stmt        );

          peStmt = JDBC_PrepStmt( peConn : %trim(@@stmt) );
          if peStmt = *null;
             @@obsv = 'Falla peStmt = *null  - Variable :'
                    + %trim(%char(G2NVAR))
                    + ' Siniestro : '
                    + %trim(%char(G0SINI));
             c0esta = 'E';
          endif;
          peRset = JDBC_execPrepQry(peStmt);
          if (peRset = *null);
             @@obsv = 'No se encontró información para procesar'
                    + ' Variable :'
                    + %trim(%char(G2NVAR))
                    + ' Siniestro : '
                    + %trim(%char(G0SINI));
             c0esta = 'E';
          endif;

        endsr;

        begsr setConDependencia;
          k1y952.G2NVAR = %trim(G2DPVA);
          chain %kds( k1y952 : 1 ) gti952;
          if %found();
             // CAMPO CLAVE EN GTI950 ?.-
             if %trim(G2MARP) = *on;
                 @@obsv = %trim(%char(G0DCID));
                 exsr setQuery;
                 if c0esta = 'E';
                    leaveSr;
                 endif;

                dow JDBC_nextRow(peRset);
                    @@obsv = %char(JDBC_getCol(peRset:1));
                    k1y952.G2NVAR = %trim(varName);
                    chain %kds( k1y952 : 1 ) gti952;
                    if %found();
                       exsr setQuery;
                       if c0esta = 'E';
                          leaveSr;
                       endif;
                       dow JDBC_nextRow(peRset);
                           @@obsv = %char(JDBC_getCol(peRset:1));
                           t@desi = %scanrpl( '%'+varName+'%'
                                  : %trim(@@obsv)
                                  : t@desi        );
                           leaveSr;
                       enddo;
                    endif;
                enddo;

             endif;
          endif;
        endsr;

        begsr setMensajeCrl;

          c0empr = 'A';
          c0sucu = 'CA';
          c0idpr = g0idpr;
          c0rama = g0rama;
          c0sini = g0sini;
          c0nops = g0nops;
          Select;
          when c0esta  = 'E';
               c0obsv  = @@obsv;
               @@camp += 1;
          when c0esta  = '1';
               c0obsv = @@obsv;
               @@cami += 1;
          other;
               c0obsv = t@desi;
               @@cami += 1;
          endsl;
          c0user = 'PROC_ZAMBA';
          c0date = %dec(%date);
          c0time = %dec(%time);

          if @@manual;
             c0wkid = @@wkid;
             c0wnme = @@wnme;
             c0stid = @@stid;
             c0stpn = @@stpn;
             c0spid = @@spid;
             c0dspn = @@dspn;
          else;
             c0wkid = g0wkid;
             c0wnme = g0wnme;
             c0stid = g0stid;
             c0stpn = g0stpn;
             c0spid = g0spid;
             c0dspn = g0dspn;
          endif;
          monitor;
             write c1lsew;
          on-error;
          endmon;
          c0esta = '0';
          clear @@obsv;
          clear @@wkid;
          clear @@wnme;
          clear @@stid;
          clear @@stpn;
          clear @@spid;
          clear @@dspn;

        endsr;

        begsr setFechaCarga;
            clear @@falt;
            clear @@halt;
            clear @@ualt;
            SVPSI1_getDatosAlta( 'A'
                               : 'CA'
                               : g0rama
                               : g0sini
                               : g0nops
                               : @@falt
                               : @@halt
                               : @@ualt );
            ewempr = 'A';
            ewsucu = 'CA';
            ewrama = g0rama;
            ewsini = g0sini;
            ewnops = g0nops;
            ewivse = @@secu;
            ewcesi = 99;
            ewdesi = 'Siniestro cargado en el sistema el dia '
                   +  %subst(%editc(@@falt:'X'):7:2)
                   + '/'
                   +  %subst(%editc(@@falt:'X'):5:2)
                   + '/'
                   +  %subst(%editc(@@falt:'X'):1:4);
            @@obsv = ewdesi;
            ewmar1 = '0';
            ewmar2 = '0';
            ewmar3 = '0';
            ewmar4 = '0';
            ewmar5 = '0';
            ewuser = 'PROC_ZAMBA';
            ewdate = %dec(%date);
            ewtime = %dec(%time);
            write p1hsew;
            clear p1hsew;
            c0esta = '1';
            @@manual = *on;
            @@wkid = 26002;
            @@wnme = 'Reclamos de Siniestros';
            @@stid = 26002;
            @@stpn = 'Ingreso de Denuncias';
            @@spid = 26053;
            @@dspn = 'Carga Finalizada';
            exsr setMensajeCrl;
            @@manual = *off;
            c0esta = '0';
            @@secu  += 1;

        endsr;

        begsr setUserAsignado;
          if  %upper(g0usrn) <> 'ZAMBA' and
              g0usrn <> *blanks;
              ewempr = 'A';
              ewsucu = 'CA';
              ewrama = g0rama;
              ewsini = g0sini;
              ewnops = g0nops;
              ewivse = @@secu;
              ewcesi = 99;
              ewdesi = 'Caso asignado a '  + %upper(%trim(g0usrn))
                     + '/' + %trim(g0usrm);
              @@obsv = ewdesi;
              ewmar1 = '0';
              ewmar2 = '0';
              ewmar3 = '0';
              ewmar4 = '0';
              ewmar5 = '0';
              ewuser = 'PROC_ZAMBA';
              ewdate = %dec(%date);
              ewtime = %dec(%time);
              write p1hsew;
              clear p1hsew;
              c0esta = '1';
              @@manual = *on;
              @@wkid = *all'9';
              @@wnme = 'UserAsignado';
              @@stid = *all'9';
              @@stpn = 'UserAsignado';
              @@spid = *all'9';
              @@dspn = 'UserAsignado';
              exsr setMensajeCrl;
              @@manual = *off;
              c0esta = '0';
              @@secu  += 1;
          endif;
        endsr;

        begsr chkExclusiones;
           clear @@obsv;
           clear c0esta;
           Select;
           // Invesstigaciones solo para Liquidadores;
           when g0wkid = 33201 and
                g0stid = 26010 and
                g0spid = 26103;
                if not chkLiquidador( G0DCID :@@obsv );
                   c0esta = 'E';
                endif;
           other;
           endsl;
        endsr;

        dcl-proc chkLiquidador;
           dcl-pi chkLiquidador  ind;
                  pedcid packed(18:0) const;
                  peObsv char(256);
           end-pi;

           peTabl = 'LIQUIDADOR';
           chain peTabl set335;
           if not %found;
              peObsv = 'Falta datos SQL - SET335 - ' + %TRIM(peTabl);
              return *off;
           endif;

           t5stmt = %scanrpl( '%DB%'
                            : %trim(t@bddn)
                            : t5stmt        );

           t5stmt = %scanrpl( '%doc_id%'
                            : %trim(%char(G0DCID))
                            : t5stmt         );

           peStm3 = JDBC_PrepStmt( peConn : %trim(t5stmt) );
           if peStm3 = *null;
              peObsv = 'No se encontró o tabla a consultar - '
                     +  %TRIM(peTabl);
              return *off;
           endif;

            peRse3 = JDBC_execPrepQry(peStm3);
            if (peRse3 = *null);
              peObsv = 'Investigación no es tipo Liquidador';
              JDBC_freePrepStmt( peStm3 );
              return *off;
            endif;

            dow JDBC_nextRow(peRse3);
                JDBC_freePrepStmt( peStm3 );
                return *on;
            enddo;

            return *off;
        end-proc;


