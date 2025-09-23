     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('HDIILE/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .: GAUS : Gestion automática de seguro.             *
     *  Objetivo .: Enviar mail a los PAS con un recibo de           *
     *              indemnizacion para el asegurado.                 *
     * ------------------------------------------------------------- *
     *  Autor    .: Fabella Ivan M.                 Fecha : 27-06-24 *
     * - ----------------------------------------------------------- *
     *  IMF - 27/06/24 - Lee CNTRDI para enviar mail                 *
     *                 - PRO001: Busca el numero del recibo en cnhric*
     *                 - PRO002: Busca emp,sucu,poli , nombre del    *
     *                           asegurado y monto impreso.          *
     *                 - PRO003: Busca datos del Vehiculo            *
     *                 - PRO004: Busca fecha de siniestro y localidad*
     *                 - PRO005: Busca mail del pass                 *
     *                 - PRO006: Genera pdf de la indemnizacion      *
     *                 - PRO007: Chequea que no haya errores.        *
     *                           Estos errores son controlados a     *
     *                           medida que el programa avanza.      *
     *                           Son secuenciales!!                  *
     *                 - PRO008: Busca Mails internos                *
     *                 - PRO009: Envia mail a quien corresponda      *
     *                 - PRO010: Marca como procesado al registro y  *
     *                           en caso de que el mail se envio ok  *
     *                           tambien se marca                    *
     *                 - PRO011: Logea los enviados                  *
     * - ----------------------------------------------------------- *
     * - ----------------------------------------------------------- *
      *   Archivos
     * - ----------------------------------------------------------- *
     Fcntrdi    uf a e           k disk
     Fcnhric    if   e           k disk
     Fpahsva    if   e           k disk
     Fpahscd    if   e           k disk

     * - ----------------------------------------------------------- *
      *  Claves de acceso
     * - ----------------------------------------------------------- *
     D k1trdi          ds                  likerec(C1TRDI)
     D k1hric          ds                  likerec(C1HRIC)

     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
     D CXP668N         pr
     D                                1  0
     D CXP668N         pi
     D tipo                           1  0

     * - ----------------------------------------------------------- *
      *   Empresa y sucursal segun area de datos
     * - ----------------------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403

     * - ----------------------------------------------------------- *
      *   Copys
     * - ----------------------------------------------------------- *
     D/copy hdiile/qcpybooks,mail_h
     D/copy hdiile/qcpybooks,recdato_h
     D/copy hdiile/qcpybooks,ifsio_h
     D/copy hdiile/qcpybooks,svpemp_h
     D/copy hdiile/qcpybooks,svpsin_h
     D/copy hdiile/qcpybooks,svpdaf_h
     D/copy HDIILE/qcpybooks,SVPDES_h
     D/copy HDIILE/QCPYBOOKS,COWLOG_H
     d/copy hdiile/qcpybooks,svpmail_h

     * - ----------------------------------------------------------- *
      *  Variables para envio de mail
     * - ----------------------------------------------------------- *
     D x               s             10i 0
     D peCprc          s             20a   inz('ENVIOINDEMINIZACION')
     D peCspr          S             50a   inz('ENVIOINDEMINIZACION')
     D errmail         ds                  likeds(MAIL_ERDS_T)
     D pxRprp          ds                  likeds(RecPrp_t) dim(100)
     D pxSubj          s             70a   varying
     D peLmen          s           5000a
     D peTo            s             50a   dim(100)
     D peToad          s            256a   dim(100)
     D peToty          s             10i 0 dim(100)
     D rc              s             10i 0
     D peMadd          ds                  likeds(MailAddr_t) dim(100)
     D i               s             10i 0
     D z               s             10i 0
     D monthName       S             10a
     D Borrar_adjunto  s              4a   inz('*YES')
     D @@File          S            255a   dim(10)
     D auxFile         s            255a

     * - ----------------------------------------------------------- *
      *  Variables para control
     * - ----------------------------------------------------------- *
     D @nroReciboOk    s               n   inz(*off)
     D @vehiculoOk     S               n   inz(*off)
     D @datosSinOk     s               n   inz(*off)
     D @mailPass       s               n   inz(*off)
     D @creacionPdf    s               n   inz(*off)
     D @finOperacion   s               n   inz(*off)
     D @envioOk        s               n   inz(*off)
     D res             S               n

     * - ----------------------------------------------------------- *
      *  Variables para enviar a metodo JAVA
     * - ----------------------------------------------------------- *
     D peNres          S                   like(jString)
     D peNeml          S                   like(jString)
     D peNomb          S                   like(jString)
     D peImpo          S                   like(jString)
     D peMesc          S                   like(jString)
     D pePoli          S                   like(jString)
     D peDani          S                   like(jString)
     D peVehi          S                   like(jString)
     D peVhan          S                   like(jString)
     D peNmat          S                   like(jString)
     D peFsid          S                   like(jString)
     D peFsim          S                   like(jString)
     D peFsia          S                   like(jString)
     D peLoca          S                   like(jString)
     D peProd          S                   like(jString)

     * - ----------------------------------------------------------- *
      *  Variables para LOG
     * - ----------------------------------------------------------- *
     D Data            s          65535a
     D CRLF            c                   x'0d25'

     D pxNres          S             50a
     D pxNeml          S             50a
     D pxNomb          S             50a
     D pxImpo          S             90a
     D pxMesc          S             90a
     D pxPoli          S             50a
     D pxDani          S             50a
     D pxVehi          S             50a
     D pxVhan          S             50a
     D pxNmat          S             50a
     D pxFsid          S             50a
     D pxFsim          S             50a
     D pxFsia          S             50a
     D pxLoca          S             50a
     D pxProd          S             50a
     D pxDnif          s              8  0
     D pxDdni          s              5a
     D pxDniI          s             15a
     * - ----------------------------------------------------------- *
      *   Variables para manejo del pgm
     * - ----------------------------------------------------------- *
     D finPgm          s               n   inz(*on)
     D pasoNro         S              1  0 inz(1)


     * - ----------------------------------------------------------- *
      *  SP0026 (MONTO ESCRITO)
     * - ----------------------------------------------------------- *
     D sp0026          pr                  extpgm('SP0026')
     D  @1parm                      254

     D                 ds                  inz
     D  d1parm                 1    254
     D  d1mont                 1     11  2
     D  d1canl                12     12  0
     D  d1let1                13     15  0
     D  d1let2                16     18  0
     D  d1let3                19     21  0
     D  d1let4                22     24  0
     D  d1mesc                25    254
     D  qlin01                25     84
     D  qlin02                85    144
     D  qlin03               145    204
     D  qlin04               205    254

     D mesc            s            230a

     * - ----------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;

        setll *start cntrdi;
        read  cntrdi;
        dow not %eof;
        if CNPROC = %char(tipo) and
            CNMAI1 = '0'        and
            (CNRAMA = 3 OR CNRAMA = 12);
            if SVPSIN_getEstSin(CNEMPR
                               :CNSUCU
                               :CNRAMA
                               :CNSINI
                               :CNNOPS
                               :*OMIT) = 1;
                dow finPgm;
                    select;
                        when pasoNro = 1;
                            pro001();
                        when pasoNro = 2;
                            pro002();
                        when pasoNro = 3;
                            pro003();
                        when pasoNro = 4;
                            pro004();
                        when pasoNro = 5;
                            pro005();
                        when pasoNro = 6;
                            pro006();
                    endsl;
                enddo;
                pro007();
                pro008();
                pro009();
            endif;
        endif;
        pro010();
        apagaInd();
        srclos();
        read  cntrdi;

        enddo;

        /end-free
     * - ----------------------------------------------------------- *
      *   Busca el numero del recibo en cnhric
      *   En primera mano se pidio solo para perdida total y
      *   robo total. Luego pidieron que fuera para todos.
     * - ----------------------------------------------------------- *
        dcl-proc pro001;
         @nroReciboOk = *off;
         chain (CNEMPR:CNSUCU:CNARTC:CNPACP) cnhric;
         if %found;
      *      and
      *      (ICTIRE = 25 or
      *      ICTIRE = 13);
            select;
            when ICTIRE = 25;
                pxDani = 'ROBO TOTAL';
            when ICTIRE = 13;
                pxDani = 'PERDIDA TOTAL';
            other;
                pxDani = 'DAÑO';
            endsl;
            @nroReciboOk = *on;
            pxNres =  %trim(%char(ICIVNR));
            pasoNro = 2;
         else;
            finPgm = *off;
         endif;

        end-proc;

     * - ----------------------------------------------------------- *
      *   Busco datos varios (Empresa, importe(escrito y en numero))
      *   numero de poliza y nombre del filiatorio
     * - ----------------------------------------------------------- *
        dcl-proc pro002;
         pxNeml = SVPEMP_getNombre('A');
         pxImpo = %char(CNIMAU);
         rutmon();
         pxMesc = 'PESOS '+ mesc ;
         pxPoli = %char(SVPSIN_getPol( CNEMPR
                                      :CNSUCU
                                      :CNRAMA
                                      :CNSINI
                                      :CNNOPS));
         pxNomb = %trim(svpdaf_getnombre(CNNRMA:*omit));
         if SVPDAF_getDocumento(CNNRMA:*omit:pxDnif) = *off;
            pxDnif = 00000000;
         endif;
         pasoNro = 3;
        end-proc;

     * - ----------------------------------------------------------- *
      *   SP0026 (MONTO ESCRITO)
     * - ----------------------------------------------------------- *
        dcl-proc rutmon;

        d1mont = CNIMAU;
        d1canl = 2;
        d1let1 = 60;
        d1let2 = 60;
        d1let3 = 60;
        d1let4 = 60;
        callp SP0026 ( d1parm );
        mesc = qlin01 + qlin02 + qlin03 + qlin04 ;

        end-proc;

     * - ----------------------------------------------------------- *
      *   Busco los datos del vehiculo.(Marca, modelo, submodelo y año)
      *   y patente
     * - ----------------------------------------------------------- *
        dcl-proc pro003;
         @vehiculoOk = *off;
         chain (CNEMPR:CNSUCU:CNRAMA:CNSINI:CNNOPS) pahsva;
         if %found;
            pxVehi = %trim(SVPDES_marca(VAVHMC))+' '+
                        %trim(SVPDES_modelo(VAVHMO))+' '+
                        %trim(SVPDES_subModelo(VAVHCS))+' ';
            pxVhan = %trim(%char(VAVHAÑ));
            pxNmat = %trim(VANMAT);
            @vehiculoOk = *on;
            pasoNro = 4;
         else;
            finPgm = *off;
         endif;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Busco fecha de siniestro y la localidad
      *   asi no abro dos veces el pahscd para el mismo registro
     * - ----------------------------------------------------------- *
        dcl-proc pro004;
         @datosSinOk  = *off;
         chain (CNEMPR:CNSUCU:CNRAMA:CNSINI:CNNOPS) pahscd;
         if %found;
            pxFsid = %char(cdfsid);
            pxFsia = %char(cdfsia);
            setMesLetras();
            pxFsim = %trim(monthName);
            pxLoca = %trim(SVPDES_provinciaInder(CDRPRO));
            pxProd = %trim(SVPDES_localidad(cdCopo:cdCops));
            @datosSinOk  = *on;
            pasoNro = 5;
         else;
            finPgm = *off;
         endif;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Setea mes en letra segun CDFSIM
     * - ----------------------------------------------------------- *
        dcl-proc setMesLetras;
            select;
            when CDFSIM = 1;
                monthName = 'Enero';
            when CDFSIM = 2;
                monthName = 'Febrero';
            when CDFSIM = 3;
                monthName = 'Marzo';
            when CDFSIM = 4;
                monthName = 'Abril';
            when CDFSIM = 5;
                monthName = 'Mayo';
            when CDFSIM = 6;
                monthName = 'Junio';
            when CDFSIM = 7;
                monthName = 'Julio';
            when CDFSIM = 8;
                monthName = 'Agosto';
            when CDFSIM = 9;
                monthName = 'Septiembre';
            when CDFSIM = 10;
                monthName = 'Octubre';
            when CDFSIM = 11;
                monthName = 'Noviembre';
            when CDFSIM = 12;
                monthName = 'Diciembre';
            other;
                @datosSinOk  = *off;
            endsl;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Busca mail del pass
     * - ----------------------------------------------------------- *
        dcl-proc pro005;
        @mailPass = *off;
        z = *zeros;
        rc = SVPMAIL_xNivc( CNEMPR
                        : CNSUCU
                        : CNNIVT
                        : CNNIVC
                        : peMadd
                        : 1 );
        if rc > 0;
            for i = 1 to rc;
                if MAIL_isValid(peMadd(i).mail);
                    z+=1;
                    peTo(z)   = peMadd(z).nomb;
                    peToad(z) = peMadd(i).mail;
                    peToty(z) = MAIL_NORMAL;
                    @mailPass = *on;
                    pasoNro = 6;
                endif;
            endfor;
        else;
            finPgm = *off;
        endif;
        end-proc;

     * - ----------------------------------------------------------- *
      * Genera PDF y @@FILE para enviar por mail
     * - ----------------------------------------------------------- *
        dcl-proc pro006;
        @creacionPdf = *off;
        parseoJstring();
        res = generateReciboDeRobo( peNres
                                  : peNeml
                                  : peNomb
                                  : peImpo
                                  : peMesc
                                  : pePoli
                                  : peDani
                                  : peVehi
                                  : peVhan
                                  : peNmat
                                  : peFsid
                                  : peFsim
                                  : peFsia
                                  : peLoca
                                  : peProd );

         auxFile = '/home/ReciboDanioTotal/Recibo_' + %char(%trim(pxNres))
                     + '.pdf' ;
         @@File(1) = %trim(auxFile) ;
         if res and access( %trim(auxFile) : F_OK) = 0;
            @creacionPdf = *on;
            pasoNro = 7;
         endif;
         finPgm = *off;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Convierte a obj string
     * - ----------------------------------------------------------- *
        dcl-proc parseoJstring;
        if pxDnif <> 0;
           pxDniI =' DNI: '+ %char(pxDnif);
        else;
           pxDniI = '';
        endif;
         peNres = new_String(%trim(pxNres));
         peNeml = new_String(%trim(pxNeml));
         peNomb = new_String(%trim(pxNomb)+
                             pxDniI);
         peImpo = new_String(%trim(pxImpo));
         peMesc = new_String(%trim(pxMesc));
         pePoli = new_String(%trim(pxPoli));
         peDani = new_String(%trim(pxDani));
         peVehi = new_String(%trim(pxVehi));
         peVhan = new_String(%trim(pxVhan));
         peNmat = new_String(%trim(pxNmat));
         peFsid = new_String(%trim(pxFsid));
         peFsia = new_String(%trim(pxFsia));
         peFsim = new_String(%trim(pxFsim));
         peLoca = new_String(%trim(pxLoca));
         peProd = new_String(%trim(pxProd));
        end-proc;
     * - ----------------------------------------------------------- *
      *   Ultimo paso
     * - ----------------------------------------------------------- *
        dcl-proc pro007;
            @finOperacion = *off;
            select;
            when @nroReciboOk = *off;
                 pxSubj = 'Fallo al obtener recibo para el siniestro: ' +
                          %char(CNSINI) + ' Nro Oper: ' + %char(CNNOPS);
                 peLmen = 'Se produjo un error en el proceso para generar '+
                          'el recibo de indemnizacion';
            when @vehiculoOk = *off;
                 pxSubj = 'Fallo al obtener datos del vehiculo: ' +
                          %char(CNSINI) + ' Nro Oper: ' + %char(CNNOPS);
                 peLmen = 'Se produjo un error en el proceso para generar '+
                          'el recibo de indemnizacion';
            when @datosSinOk = *off;
                 pxSubj = 'Fallo al obtener datos del siniestro: ' +
                          %char(CNSINI) + ' Nro Oper: ' + %char(CNNOPS);
                 peLmen = 'Se produjo un error en el proceso para generar '+
                          'el recibo de indemnizacion';
            when @mailPass = *off;
                 pxSubj = 'Fallo al obtener email del productor : ' +
                          %char(CNSINI) + ' Nro Oper: ' + %char(CNNOPS);
                 peLmen = 'Se produjo un error en el proceso para generar '+
                          'el recibo de indemnizacion';
            when @creacionPdf = *off;
                  pxSubj = 'Fallo al crear pdf : ' +
                          %char(CNSINI) + ' Nro Oper: ' + %char(CNNOPS);
                  peLmen = 'Se produjo un error en el proceso para generar '+
                          'el recibo de indemnizacion';
            other;
                @finOperacion = *on;
                pasoNro = 8;
            endsl;
      *      pro008();
      *      proc009();
        end-proc;
     * - ----------------------------------------------------------- *
      *   Busca mail internos
     * - ----------------------------------------------------------- *
        dcl-proc pro008;
            if @finOperacion = *on;
                rc = MAIL_getSubject( peCprc: peCspr: pxSubj );
                peLmen = 'Adjunto el recibo ' + %trim(%char(pxNres)) +
                ' Siniestro: '+ %trim(%char(CNSINI));
                pxSubj = peLmen;
            else;
                peTo   = *blanks;
                peToad = *blanks;
                z      = 0;
            endif;
            rc = MAIL_getReceipt( peCprc : peCspr : pxRprp : *ON );
            for x = 1 to rc;
                if ( MAIL_isValid( pxRprp(x).rpmail ) = *ON )
                    or( pxRprp(x).rpnomb = '*REQUESTER' );
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
        end-proc;

     * - ----------------------------------------------------------- *
      *   Envia mail al pass y quien corresponda
     * - ----------------------------------------------------------- *
        dcl-proc pro009;
        @envioOk = *off;
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
                            : @@File
                            : Borrar_adjunto
                            : *omit
                            : *omit
                            : *omit
                            : *omit);

        if rc = -1;
            errmail = MAIL_error();
        else;
            if @creacionPdf = *on;
               @envioOk = *on;
            endif;
        endif;

        end-proc;

     * - ----------------------------------------------------------- *
      *   Updatea CNTRDI
     * - ----------------------------------------------------------- *
        dcl-proc pro010;
             CNPROC = '1';
             if @envioOk;
                cnmai1 = '1';
                pro011();
             endif;
             update C1TRDI;
        end-proc;

     * - ----------------------------------------------------------- *
      *   Logea
     * - ----------------------------------------------------------- *
        dcl-proc pro011;
        Data = CRLF
               + ' Numero de Recibo: '
               + pxNres
               + ' Nombre del filiatorio: '
               + pxNomb
               + ' Poliza: '
               + pxPoli
               + ' Vehiculo: '
               + pxVehi
               + ' Siniestro: '
               + %char(CNSINI)
               + ' Numero de operacion: '
               + %char(CNNOPS);
               COWLOG_pgmLog('CXP668N':Data:*on);
        end-proc;

     * - ----------------------------------------------------------- *
      *   Apaga indicadores
     * - ----------------------------------------------------------- *
        dcl-proc apagaInd;
                @nroReciboOk   = *off;
                @vehiculoOk    = *off;
                @datosSinOk    = *off;
                @mailPass      = *off;
                @creacionPdf   = *off;
                @finOperacion  = *off;
                @envioOk       = *off;
                @@File         = *zeros;
                finPgm         = *on;
                pasoNro        = 1;
        end-proc;
     * - ----------------------------------------------------------- *
      *   Cierra archivos
     * - ----------------------------------------------------------- *
        dcl-proc srclos;
            SVPDAF_end();
            SVPSIN_end();
        end-proc;
