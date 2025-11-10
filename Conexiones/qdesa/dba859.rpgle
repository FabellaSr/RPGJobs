        // - ----------------------------------------------------------- -
        //  Sistema .: GAUS
        //  Programa : DBA859  (Control de pantalla carta de franquicia)
        //  Autor    : Fabella.
        // - ----------------------------------------------------------- -
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
        // - ------------------------- Archivos ------------------------- -
        dcl-f dba859fm workstn sfile(DBA859S1:@lsf1);
        dcl-f setcdf01 usage(*input) rename(S1TCDF:S1TCDF01) keyed;
        dcl-f setcdf02 usage(*input) rename(S1TCDF:S1TCDF02) keyed;
        dcl-f setcdf   usage(*input:*update) keyed;
        // ----------------------------------------------------------------
        //   Copys
        // ----------------------------------------------------------------
         /copy *libl/qcpybooks,SVPREST_H
         /copy *libl/qcpybooks,dclproto_h
         /copy *libl/qcpybooks,mail_h
         /copy *libl/qcpybooks,SPVFEC_h
        // ----------------------------------------------------------------
        // Variables varias
        // ----------------------------------------------------------------
        dcl-s  @lsf1     packed(5:0) inz(0);   // RRN para SFILE
        dcl-s  endpgm    ind inz(*off);
        dcl-ds k1tcdf01  likerec(s1tcdf01:*key);
        dcl-ds k1tcdf02  likerec(s1tcdf02:*key);
        dcl-ds k1tcdf    likerec(s1tcdf:*key);
        dcl-ds kLast     likeds(k1tcdf02);
        dcl-ds kfirs     likeds(k1tcdf02);
        dcl-s  i         int(10) inz(1);
        // ----------------------- Empresa / Sucu ------------------------- //
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
        // ----------------------- Mail ----------------------------------- //
        dcl-s peCprc          char(20) inz('WSPCAF');
        dcl-s peCspr          char(50) inz('PRODUCTOROK');
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
        // --- Autorizaciones de usr -------------------------------------
        dcl-pr PGGMSG6 extpgm('PGGMSG6');
            peTsbs packed(2:0) const;
            peIpgm char(10)    const;
            peTalt char(1);
            peTbaj char(1);
            peTcam char(1);
            peTcon char(1);
            peNaut packed(1:0);
            peRtrn char(1);
        end-pr;
        dcl-s @alta   char(1);
        dcl-s @baja   char(1);
        dcl-s @camb   char(1);
        dcl-s @cons   char(1);
        dcl-s @Naut   packed(1:0);
        dcl-s @Rtrn   char(1);
        // --- Paginación y posición y mas---------------------------------
        dcl-s primeraCarga   ind  inz(*on);
        dcl-s noHayMas       ind  inz(*off);
        dcl-s esPrimeraPag   ind  inz(*on);
        dcl-s primeraEntrada ind  inz(*off);
        dcl-s calculoOk      ind  inz(*off);
        dcl-s pendDisponible ind  inz(*on);
        dcl-s endLoop        ind  inz(*off);
        // ----------------------------------------------------------------
        // MAIN
        // ----------------------------------------------------------------
        *inlr = *on;
        tareasDeInicio();
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
                exfmt DBA859C2;
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
            // --- Orden Segun... -------------------------
            if *in07;
                if pendDisponible;
                    pendDisponible = *off;
                else;
                    pendDisponible = *on;
                endif;
                primeraCarga = *on;
                CargarSubfile();
            endif;
            // --- Si da enter... -------------------------
            if not *in01 and
             (xxnivc <> *zeros and xxsini <> *zeros);
                k1tcdf01.s1nivc = xxnivc;
                k1tcdf01.s1sini = xxsini;
                chain %kds(k1tcdf01) setcdf01;
                kLast.s1feso = s1feso;
                kLast.s1empr = uds.usempr;
                kLast.s1sucu = uds.ussucu;
                kLast.s1rama = s1rama;
                kLast.s1poli = s1poli;
                kLast.s1sini = s1sini;
                kLast.s1nops = s1nops;
                kLast.s1empd = s1empd;
                primeraCarga = *off;
                CargarSubfile();
            endif;
            // --- Valido teclas --------------------------
            if *in30 = *on;
                valid01();
            endif;
            // --- Error ---- -----------------------------
            if *in29;
                iter;
            endif;
        enddo;
        return;
        // ----------------------------------------------------------------
        // - --------------------- Tareas de inicio --------------------- -
        // ----------------------------------------------------------------
        dcl-proc tareasDeInicio;
            in uds;
            PGGMSG6( 10
                   : 'DBA859A'
                   : @alta
                   : @baja
                   : @camb
                   : @cons
                   : @naut
                   : @rtrn );
            //Puede o no dar F1 segun si corresponde.
            *in56 = *on;
            //@alta = 'S';
            if @alta <> 'S';
                *in56 = *off;
            endif;
        end-proc;
        // ----------------------------------------------------------------
        // - --------------------- Procedimientos ----------------------- -
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
            // Mostrar pantalla para que el usuario
            // cargue Mano O./Repuestos
            *in51   = *off;
            xdmens  = *blanks;
            endLoop = *off;
            dow not endLoop;
                exfmt dba859cd;
                //Me voy
                if *in12;
                    endLoop = *on;
                endif;
                //Pide ver el mail
                if *in04;
                    xmensg  = *blanks;
                    xmensg2 = *blanks;
                    xmensg = %trim(S1MAIL);
                    exfmt DBA859MSG;
                    xmensg  = *blanks;
                    xmensg2 = *blanks;
                    *in04 = *off;
                endif;
                //hago las cuentas
                validacionCalculos();
                //Confirmacion
                if *in01;
                    select;
                        when s1stat = '1';
                            xmensg = 'Esta carta ya ha sido enviada';
                            exfmt DBA859MSG;
                        when s1stat = '0';
                            if *in01         and
                               s1stat = '0'  and
                               calculoOk     and
                               @alta = 'S';
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
                    endsl;
                endif;
            enddo;
            primeraEntrada = *off;
            primeraCarga  = *on;
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
                if %dec(xdmano:15:2) <= -1
                    or %dec(xdrepu:15:2) <= -1;
                    *in51  = *on;
                    xdmens = 'Importes negativos no válidos';
                else;
                    xdtota =  %dec(xdmano:15:2)
                            + %dec(xdrepu:15:2)  ;
                    calculoOk = *on;
                    // Si la franquicia supera el total: mostrar aviso y neto=0
                    if  xdfran  >
                         xdtota ;
                        *in51  = *on;
                        xdmens = 'No supera franquicia';
                        xdneto = *zeros;
                    else;
                        *in51  = *off;
                        xdmens = *blanks;
                        xdneto =  %dec( xdtota :15:2)
                                - %dec( xdfran :15:2)  ;
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
                xdvigd = SPVFEC_giroFecha8( s1vigd : 'DMA' );
                xdvigh = SPVFEC_giroFecha8( s1vigh : 'DMA' );
                xdsini = s1sini;
                xdnivc = s1nivc;
                xdnivt = s1nivt;
                xdfecs = SPVFEC_giroFecha8( s1fecs : 'DMA' );
                xdmano = s1vmob;
                xdrepu = s1vrep;
                xdtota = s1vtot;
                xdfran = s1vfra;
                xdneto = xdtota + xdfran;

                if s1stat = '1';
                    *in54 = *on;
                endif;
            endif;
            //Si no tiene permisos no le dejo modificar, solo mira
            if @alta <> 'S';
                *in54 = *on;
            endif;
        end-proc;
        // ----------------------------------------------------------------
        // RollDown: continuar desde la posición actual y recargar SFL
        // ----------------------------------------------------------------
        dcl-proc RollDown;
           // Si ya estamos en última página, no hacemos nada
           if noHayMas;
              return;
           endif;
           noHayMas = *off;
           esPrimeraPag = *off;
           CargarSubfile();
        end-proc;
        // ----------------------------------------------------------------
        // RollUp: retrocede una página (9 ítems) y recarga SFL
        // ----------------------------------------------------------------
        dcl-proc RollUp;
           // Posicionarse antes de la primera clave actual y retroceder 9
           setll %kds(kfirs) setcdf02;        // al principio de la página actual
           readp(n) setcdf02;                  // ir al registro anterior
           if %eof(setcdf02);
              // Ya estamos en el inicio del archivo
              primeraCarga = *on;           // para que CargarSubfile haga *LOVAL
              esPrimeraPag = *on;
              CargarSubfile();
              return;
           endif;
           i = 0;
           // Retroceder hasta 9 registros (o hasta el inicio)
           dow i < 9 and not %eof(setcdf02);
              readp(n) setcdf02;
              i += 1;
           enddo;
            kLast.s1feso = s1feso;
            kLast.s1empr = s1empr;
            kLast.s1sucu = s1sucu;
            kLast.s1rama = s1rama;
            kLast.s1poli = s1poli;
            kLast.s1sini = s1sini;
            kLast.s1nops = s1nops;
            kLast.s1empd = s1empd;
           // Si llegamos al inicio, marcamos primera página
           esPrimeraPag = %eof(setcdf);
           // Cargar hacia adelante desde donde quedó el puntero
           CargarSubfile();
        end-proc;
        // ----------------------------------------------------------------
        // - --------------------- Procedimientos stub ------------------ -
        // ----------------------------------------------------------------
        dcl-proc CargarSubfile;
            // Posicionar 1 sola vez al principio del archivo
            if primeraCarga;
                setll *start setcdf02;
                primeraCarga = *off;
                esPrimeraPag = *on;
            else;
                setll %kds(kLast) setcdf02;
            endif;
            // Borrar SFL
            *in30    = *off;
            write     DBA859C1;
            @lsf1    = *zeros;
            noHayMas = *off;
            read(n) setcdf02;
            dow not %eof(setcdf02);
                if @lsf1 = 9;
                    leave;
                endif;
                if s1stat = pendDisponible;
                    *in30 = *on;
                    // Guardar clave de la primera fila de la página
                    if @lsf1 = 0;
                        kfirs.s1feso = s1feso;
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
                    x1feso = SPVFEC_giroFecha8( s1feso : 'DMA' );
                    //*n55 color
                    select;
                        when s1stat = '0';
                            X1ESTA = 'PENDIENTE';
                            *in55 = *off;
                        when s1stat = '1';
                            X1ESTA = 'DISPONIBLE';
                            *in55 = *on;
                        other;
                            X1ESTA = 'DESCONOCIDO';
                            *in55 = *off;
                    endsl;
                    @lsf1 += 1;
                    write DBA859S1;
                    //Me guardo el ultimo
                    kLast.s1feso = s1feso;
                    kLast.s1empr = s1empr;
                    kLast.s1sucu = s1sucu;
                    kLast.s1rama = s1rama;
                    kLast.s1poli = s1poli;
                    kLast.s1sini = s1sini;
                    kLast.s1nops = s1nops;
                    kLast.s1empd = s1empd;
                endif;
                read(n) setcdf02;
            enddo;
            if %eof(setcdf02);
                noHayMas = *on;
            endif;
            //si in32 = *on va a mostrar "Final"
            *in32  = noHayMas;       // SFLEND(*MORE) si hay más
            *in40  = esPrimeraPag;   // indicador primera página
            *in41  = not noHayMas;   // indicador última página
        end-proc;
