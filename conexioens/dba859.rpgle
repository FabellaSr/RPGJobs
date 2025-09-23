     H option(*srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H alwnull(*usrctl)
     H COPYRIGHT('HDI Seguros')
     H bnddir('HDIILE/HDIBDIR')
        // - ----------------------------------------------------------- -
        //  Sistema .: GAUS
        //  Programa : DBA859R  (Control de pantalla carta de franquicia)
        //  Objetivo : Esqueleto con loop principal y manejo básico de SFL
        //  Autor    : ivan
        // - ----------------------------------------------------------- -
        // - ------------------------- Archivos ------------------------- -
        //  Cambiá EXTDSC si tu DSPF tiene otro nombre
        dcl-f dba859fm workstn sfile(DBA859S1:@lsf1);
        dcl-f setcdf usage(*input:*update) keyed;
        // ----------------------------------------------------------------
        // Variables varias
        // ----------------------------------------------------------------
        dcl-s  @lsf1   packed(5:0) inz(0);   // RRN para SFILE
        dcl-s  endpgm  ind         inz(*off);
        dcl-ds k1tcdf  likerec(s1tcdf:*key);
        dcl-ds kLast   likeds(k1tcdf);
        dcl-ds kfirs   likeds(k1tcdf);
        dcl-s  i       int(10) inz(1);
        // ----------------------------------------------------------------
        //   Copys
        // ----------------------------------------------------------------
         /copy *libl/qcpybooks,SVPREST_H
         /copy *libl/qcpybooks,dclproto_h
         /copy *libl/qcpybooks,mail_h
        // ----------------------- Empresa / Sucu ------------------------- //
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
        // ----------------------- Mail ----------------------------------- //
        dcl-s peCprc char(20) inz('WSPCAF');
        dcl-s peCspr char(50) inz('PRODUCTOROK');
        dcl-s pxSubj          varchar(70);
        dcl-s peLmen          varchar(512);
        dcl-s peTo            char(50)   dim(100);
        dcl-s peToad          char(256)  dim(100);
        dcl-s peToty          int(10)    dim(100);
        dcl-ds pxRprp         likeds(RecPrp_t) dim(100);
        dcl-s z               int(10);
        dcl-s x               int(10);
        dcl-ds errmail        likeds(MAIL_ERDS_T);
        dcl-s Borrar_adjunto  char(4) INZ('*YES') ;
        // --- Paginación y posición -------------------------------------
        dcl-s gPrimeraCarga   ind  inz(*on);       // para posicionar al inicio 1 sola vez
        dcl-s gHayMas         ind  inz(*off);      // hay más registros hacia abajo
        dcl-s gEsPrimeraPag   ind  inz(*on);       // estamos en primera página
        dcl-s primeraEntrada  ind  inz(*off);
        dcl-s calculoOk       ind  inz(*off);
        // ----------------------------------------------------------------
        // MAIN: Bucle por Pasos
        // ----------------------------------------------------------------
        *inlr = *on;
         in    uds;
        dou endpgm;
            // Preparar control del subfile: limpiar y mostrar
            *in31 = *on;
            *in32 = *off;
            if not primeraEntrada;
                *in30 = *off;
                write DBA859C1;
                primeraEntrada = *on;
                CargarSubfile();
            endif;
            // Habilitar visualización y pedir entrada
            if *in30;
                exfmt DBA859C1;
            else;
                xmensg = 'Aun sin solicitudes';
                exfmt DBA859MSG;
            endif;
            // Teclas de función básicas
            // --- F12  -----------------------------------
            if *in12;
                return;
            endif;
            // --- F3 -------------------------------------
            if  *in03;
                endpgm = *on;
                iter;
            endif;
            // --- ROLL Adelante --------------------------
            if *in28;
                RollDown();
                iter;
            endif;
            // --- ROLL Atras -----------------------------
            if *in27;
                RollUp();
                iter;
            endif;
            // --- Error ---- -----------------------------
            if *in29;
                iter;
            endif;
            // --- Orden Segun... -------------------------
            if *in07;

            endif;
            // --- Valido teclas --------------------------
            valid01();
        enddo;
        return;
        // ----------------------------------------------------------------
        // - --------------------- Procedimientos stub ------------------ -
        // ----------------------------------------------------------------
        dcl-proc valid01;
            // Busco cual selecciono
            readc DBA859S1;
            dow not %eof;
                select;
                    when X1OPCI = 2;
                        pantDatosSolicitud();
                    other;
                endsl;
                X1OPCI = *zeros;
                update DBA859S1;
                readc  DBA859S1;
            enddo;
        end-proc;
        // ----------------------------------------------------------------
        // Confirmacion de carta franquicia
        // ----------------------------------------------------------------
        dcl-proc pantDatosSolicitud;
            *in54     = *off;
            calculoOk = *off;
            *in53     = *off;
            cargoDatos();
            // --- Mostrar pantalla para que el usuario cargue Mano/Repuestos
            *in51  = *off;
            xdmens = *blanks;
            exfmt dba859cd;
            dow not *in12;
                if s1stat = '1';
                    xmensg = 'Esta carta ya ha sido enviada';
                    exfmt DBA859MSG;
                else;
                    validacionCalculos();
                    if *in01 and s1stat = '0';
                        if calculoOk ;
                            xmensg = 'Si continua no podra volver atras.';
                            exfmt DBA859MSG;
                            if *in01;
                                graboCDF();
                                *in53 = *on;
                                envioMail();
                                xmensg  = 'Se envio el mail al pass';
                                xmensg2 = 'con el aviso correspondiente.';
                                exfmt DBA859MSG;
                                *in53 = *off;
                                leave;
                            endif;
                        endif;
                    endif;
                endif;
            enddo;
            primeraEntrada = *off;
            gPrimeraCarga  = *on;
            *in12          = *off;
            *in54          = *off;
        end-proc;
        // ----------------------------------------------------------------
        // Cargo los datos de la solicitud.
        // ----------------------------------------------------------------
        dcl-proc envioMail;
            rc = MAIL_getSubject( peCprc : peCspr : pxSubj );
            rc = MAIL_getBody   ( peCprc : peCspr : peLmen );
            rc = MAIL_getReceipt( peCprc : peCspr : pxRprp : *ON );
            rc += 1;
            PXRPRP(rc).RPMAIL = %trim(s1mail);
            PXRPRP(rc).RPNOMB = 'Solicitante.';
            PXRPRP(rc).RPMA01 = '1';
            PXRPRP(rc).RPMA02 = 'S';
            peLmen = %scanrpl( '%SIN%'
                             : %trim(%char(s1Sini))
                             :  peLmen           );
            peLmen = %scanrpl( '%EMPR%'
                             : %trim(%char(s1empd))
                             :  peLmen           );
                z  = 0;
            for x = 1 to rc;
                if ( MAIL_isValid( pxRprp(x).rpmail ) = *ON )
                    or
                    (pxRprp(x).rpnomb = '*REQUESTER' );
                    z += 1;
                    peTo(z)    = pxRprp(x).rpnomb;
                    peToad(z)  = pxRprp(x).rpmail;
                    select;
                        when pxRprp(x).rpma01 = '1';
                            peToty(z) = MAIL_NORMAL;
                        when pxRprp(x).rpma01 = '2';
                            peToty(z) = MAIL_CC;
                        when pxRprp(x).rpma01 = '3';
                            peToty(z) = MAIL_CCO;
                        other;
                            peToty(z) = MAIL_NORMAL;
                    endsl;
                endif;
            endfor;
            rc = MAIL_SndLmail( '*SYSTEM'
                              : *blanks
                              : pxSubj
                              : peLmen
                              : 'H'
                              : peTo
                              : peToad
                              : peToty
                              : *omit
                              : *omit
                              : *omit
                              : *omit
                              : *omit
                              : Borrar_adjunto
                              : *omit
                              : *omit
                              : *omit
                              : *omit        );
            if rc = -1;
                errmail = MAIL_error();
            endif;
        end-proc;
        // ----------------------------------------------------------------
        // Cargo los datos de la solicitud.
        // ----------------------------------------------------------------
        dcl-proc graboCDF;
            s1vmob = %dec(xdmano:15:2);
            s1vrep = %dec(xdrepu:15:2);
            s1vtot = %dec(xdtota:15:2);
            s1vfra = %dec(xdfran:15:2);
            s1user = @psds.jobusr;
            s1user = @psds.CurUsr;
            s1date = %dec(%date():*iso);
            s1time = %dec(%time():*iso);
            s1stat = '1';
            update S1TCDF;
        end-proc;
        // ----------------------------------------------------------------
        // Cargo los datos de la solicitud.
        // ----------------------------------------------------------------
        dcl-proc validacionCalculos;
            // --- Validaciones y cálculos ---------------------------------
            // Si el usuario ingresó importes (>=0),
            if (xdmano <> *zeros and xdrepu <> *zeros);
                // No permitir negativos
                if %dec(xdmano:15:2) < 0
                    or %dec(xdrepu:15:2) < 0;
                    *in51  = *on;
                    xdmens = 'Importes negativos no válidos';
                else;
                    xdtota = %char( %dec(xdmano:15:2)
                            + %dec(xdrepu:15:2) ) ;
                    calculoOk = *on;
                    // Si la franquicia supera el total: mostrar aviso y neto=0
                    if %dec(%trim(xdfran):15:2) >
                        %dec(%trim(xdtota):15:2);
                        *in51  = *on;
                        xdmens = 'No supera franquicia';
                        xdneto = *blanks;
                    else;
                        *in51  = *off;
                        xdmens = *blanks;
                        xdneto = %char( %dec(%trim(xdtota):15:2)
                                - %dec(%trim(xdfran):15:2) ) ;
                    endif;
                endif;
                // Refrescar pantalla con los importes resultantes / mensaje
                exfmt dba859cd;
            endif;

        end-proc;
        // ----------------------------------------------------------------
        // Cargo los datos de la solicitud.
        // ----------------------------------------------------------------
        dcl-proc cargoDatos;
            k1tcdf.s1empr = uds.usempr;
            k1tcdf.s1sucu = uds.ussucu;
            k1tcdf.s1rama = x1rama;
            k1tcdf.s1poli = x1poli;
            k1tcdf.s1sini = x1sini;
            chain %kds( k1tcdf : 5 ) setcdf;
            if %found;
                xdrama = s1rama;
                xdpoli = s1poli;
                xdvigd = s1vigd;
                xdvigh = s1vigh;
                xdsini = s1sini;
                xdnivc = s1nivc;
                xdnivt = s1nivt;
                xdfran = %char(s1vfra);
                xdfecs = s1fecs;
                xdmano = %char(s1vmob);
                xdrepu = %char(s1vrep);
                xdtota = %char(s1vtot);
                xdfran = %char(s1vfra);
                xdneto = %char(xdtota + xdfran);
                if s1stat = '1';
                    *in54 = *on;
                endif;
            endif;
        end-proc;
        // ----------------------------------------------------------------
        // RollDown: continuar desde la posición actual y recargar SFL
        // ----------------------------------------------------------------
        dcl-proc RollDown;
           // Si ya estamos en última página, no hacemos nada
           if not gHayMas;
              return;
           endif;
           gEsPrimeraPag = *off;
           CargarSubfile();
        end-proc;
        // ----------------------------------------------------------------
        // RollUp: retrocede una página (9 ítems) y recarga SFL
        // ----------------------------------------------------------------
        dcl-proc RollUp;
           // Posicionarse antes de la primera clave actual y retroceder 9
           setll %kds(kfirs) setcdf;        // al principio de la página actual
           readp(n) setcdf;                  // ir al registro anterior
           if %eof(setcdf);
              // Ya estamos en el inicio del archivo
              gPrimeraCarga = *on;           // para que CargarSubfile haga *LOVAL
              gEsPrimeraPag = *on;
              CargarSubfile();
              return;
           endif;
           i = 0;
           // Retroceder hasta 9 registros (o hasta el inicio)
           dow i < 9 and not %eof(setcdf);
              readp(n) setcdf;
              i += 1;
           enddo;
            kLast.s1empr = s1empr;
            kLast.s1sucu = s1sucu;
            kLast.s1rama = s1rama;
            kLast.s1poli = s1poli;
            kLast.s1sini = s1sini;
            kLast.s1nops = s1nops;
            kLast.s1empd = s1empd;
           // Si llegamos al inicio, marcamos primera página
           gEsPrimeraPag = %eof(setcdf);
           // Cargar hacia adelante desde donde quedó el puntero
           CargarSubfile();
        end-proc;
        // ----------------------------------------------------------------
        // - --------------------- Procedimientos stub ------------------ -
        // ----------------------------------------------------------------
        dcl-proc CargarSubfile;
            // Posicionar 1 sola vez al principio del archivo
            if gPrimeraCarga;
                setll *loval setcdf;
                gPrimeraCarga = *off;
                gEsPrimeraPag = *on;
            else;
                setll %kds(kLast) setcdf;
            endif;
            // Borrar SFL
            *in30   = *off;
            write DBA859C1;
            @lsf1   = *zeros;
            gHayMas = *oN;
            read(n) setcdf;
            dow not %eof(setcdf);
                if @lsf1 = 9;
                    leave;
                endif;
                *in30 = *on;
                // Guardar clave de la primera fila de la página
                if @lsf1 = 0;
                    kfirs.s1empr = s1empr;
                    kfirs.s1sucu = s1sucu;
                    kfirs.s1rama = s1rama;
                    kfirs.s1poli = s1poli;
                    kfirs.s1sini = s1sini;
                    kfirs.s1nops = s1nops;
                    kfirs.s1empd = s1empd;
                endif;
                X1OPCI = *zeros;
                X1SINI = s1sini;
                x1NIVC = s1nivc;
                x1rama = s1rama;
                x1poli = s1poli;
                select;
                    when s1stat = '0';
                        X1ESTA = 'PENDIENTE';
                    when s1stat = '1';
                        X1ESTA = 'DISPONIBLE';
                    other;
                        X1ESTA = 'DESCONOCIDO';
                endsl;
                @lsf1 += 1;
                write DBA859S1;
                //Me guardo el ultimo
                kLast.s1empr = s1empr;
                kLast.s1sucu = s1sucu;
                kLast.s1rama = s1rama;
                kLast.s1poli = s1poli;
                kLast.s1sini = s1sini;
                kLast.s1nops = s1nops;
                kLast.s1empd = s1empd;
                read(n) setcdf;
            enddo;
            if %eof(setcdf);
                gHayMas = *off;
            endif;
            *in32  = gHayMas;       // SFLEND(*MORE) si hay más
            *in40  = gEsPrimeraPag; // indicador primera página
            *in41  = not gHayMas;   // indicador última página
        end-proc;
