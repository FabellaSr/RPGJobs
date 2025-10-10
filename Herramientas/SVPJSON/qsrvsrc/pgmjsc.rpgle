     H option(*nodebugio: *srcstmt: *nounref: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('HDIILE/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .: GAUS : Gestion automática de seguro.             *
     *  Modulo   .:                                                  *
     *  Objetivo .:                                                  *
     *  Autor    .: Fabella Ivan M.                 Fecha : 26-06-25 *
     * - ----------------------------------------------------------- *
     Fsinensup  if   e           k disk
     Fgntpec    if   e           k disk
     Fpawpec    if   e           k disk
     Fgntpca    if   e           k disk
     * - ----------------------------------------------------------- *
     *   Copys
     * - ----------------------------------------------------------- *
      /copy *libl/qcpybooks,ifsio_h
      /copy DESA_0836/qcpybooks,SVPJSON_h
     * - ----------------------------------------------------------- *
     *   Empresa y sucursal segun area de datos
     * - ----------------------------------------------------------- *
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
        dcl-ds k1tpec  likerec(g@tpec:*key);
        dcl-ds k1wpec  likerec(p@wpec:*key);
        dcl-ds k1tpca  likerec(a@tpca:*key);
     * - ----------------------------------------------------------- *
     *  Variables para envio de mail
     * - ----------------------------------------------------------- *
        dcl-s peCprc char(20) inz('PGMJSC');
        dcl-s peCspr char(50) inz('PGMJSC');
     * - ----------------------------------------------------------- *
     * Datos de cuenta
     * - ----------------------------------------------------------- *
        dcl-s cuenta  char(22);
        dcl-s subramo char(15);
        dcl-s valor   char(15);
     * - ----------------------------------------------------------- *
     *   Variables para archivo
     * - ----------------------------------------------------------- *
        dcl-c CRLF x'0D25';
        dcl-s fd      int(10);
        dcl-s @file   varchar(100);
        dcl-s r       int(10);
        dcl-pr tmpnam pointer extproc('_C_IFS_tmpnam');
            string char(39) options(*omit);
        end-pr;
     * - ----------------------------------------------------------- *
     *   Variables para manipular registro sinensup
     * - ----------------------------------------------------------- *
        dcl-s valores char(50) dim(3);
        dcl-s cantidadC int(10) inz(50);
        //Cada propiedad sera de 50 caracteres.
        //Un total de 30 campos posibles.
        dcl-s propiedad char(50) dim(30);
        dcl-s i         int(10) inz(1);
        dcl-s p         int(10);
        dcl-s temp      varchar(48);
        dcl-s primero   ind inz(*on);
        dcl-s json      varchar(32767);
        //dcl-s auxJson   char(32767) ;
     * - ----------------------------------------------------------- *
     *   Indicadores
     * - ----------------------------------------------------------- *
        dcl-s primeraVez ind inz(*on);
        dcl-s elUltimo   ind inz(*off);
        dcl-s esArray    ind inz(*off);
     * - ----------------------------------------------------------- *
     *   Prototipos externos
     * - ----------------------------------------------------------- *
        dcl-pr SNDMAIL extpgm('SNDMAIL');
            peCprc char(20) const;
            peCspr char(20) options(*nopass:*omit) const;
            peMens varchar(512) options(*nopass:*omit);
            peLmsg char(5000) options(*nopass:*omit);
        end-pr;
     * - ----------------------------------------------------------- *
     *   Constantes varias
     * - ----------------------------------------------------------- *
        dcl-c OFFSET 2;
     * - ----------------------------------------------------------- *
     *   Logica
     * - ----------------------------------------------------------- *
        /free
            *inlr = *on;
            in uds;
            preparoCsv();
            //Inicio objeto general  !
            SVPJSON_inicio( auxJson );
            //Parte "estatica"
            estatico();
            //Objeto cuentas (semi estatica)
            objetoCuentas();
            //objetos de tabla
            objetosArray();
            //Cierro objeto general  !
            SVPJSON_cerrarObj( *on
                             : auxJson );
            //Parseo y gravo
            json = %trim( auxJson );
            callp write( fd: %addr(json)+OFFSET: %len(json) );
            //envio mail
            guardaCsvADiscoEnviaMail();
            return;
        /end-free
     * - ----------------------------------------------------------- *
     *    estatico                                                   *
     * - ----------------------------------------------------------- *
        dcl-proc estatico;
            SVPJSON_agregoCampoString( 'codigoCompania'
                                     : ''
                                     : *off
                                     : auxJson );
            SVPJSON_agregoCampoString( 'tipoEntrega'
                                     : ''
                                     : *off
                                     : auxJson );
            SVPJSON_agregoCampoString( 'cronograma'
                                     : ''
                                     : *off
                                     : auxJson );
        end-proc;
     * - ----------------------------------------------------------- *
     *    objetoCuentas                                              *
     * - ----------------------------------------------------------- *
        dcl-proc objetoCuentas;
            //Inicio el obj cuentas.
            SVPJSON_nuevoObjeto( 'cuentas'
                               : auxJson );
            // leer archivo
            setll *start sinensup;
            read  sinensup;
            dow not %eof;
                // Parseo de campos
                cuenta  = getValor(xxcamp: 1);
                subramo = getValor(xxcamp: 2);
                valor   = getValor(xxcamp: 3);
                //A partir del segundo meto coma
                if not primero;
                    auxJson = ',';
                    //auxJson += ',';
                endif;
                //Abrimos el objeto de cuenta
                SVPJSON_nuevoObjeto( %trim(cuenta)
                                   : auxJson      );
                //Agregamos el campo Valor
                SVPJSON_agregoCampoString( 'valor'
                                         : %trim(valor)
                                         : *off
                                         : auxJson     );
                //Subramo que puede ir en null
                //Mando con *on por que es el ultimo de este objeto
                //cuenta
                if %len(%trim(subramo)) > 0;
                    SVPJSON_agregoCampoString( 'subramo'
                                             : %trim(subramo)
                                             : *on
                                             : auxJson       );
                else;
                    SVPJSON_campoNull( 'subramo'
                                     : *on
                                     : auxJson  );
                endif;
                //Cierro el objeto cuenta
                //Como no se cuando viene el ultimo lo mando con
                //*on. ( imprime } sin la , )
                SVPJSON_cerrarObj( *on
                                 : auxJson );
                //Lo paso al json
                json = %trim(auxJson);
                //Esto va para darle forma
                json += CRLF;
                callp write(fd: %addr(json)+OFFSET: %len(json));
                //Si ya pase por aca, no es el primero.
                primero = *off;
                read sinensup;
            enddo;
            auxJson = *blanks;
            // cerrar objeto "cuentas"
            SVPJSON_cerrarObj( *off
                             : auxJson );
        end-proc;
     * - ----------------------------------------------------------- *
     *    getValor (parseo el campo xxcamp de sinensup)              *
     * - ----------------------------------------------------------- *
        dcl-proc getValor;
            dcl-pi *n varchar(48);
                str varchar(48) const;
                pos int(10)     const;
            end-pi;
            i = 1;
            temp = str;
            dow %scan('|' : temp) > 0 and i <= 3;
                p          = %scan('|' : temp);
                valores(i) = %subst(temp: 1: p - 1);
                temp       = %subst(temp: p + 1);
                i          += 1;
            enddo;
            //Al ultimo valor lo capturo aca
            valores(i) = temp;
            return valores(pos);
        end-proc;
     * - ----------------------------------------------------------- *
     *    Objetos lista                                              *
     * - ----------------------------------------------------------- *
        dcl-proc objetosArray;
            // leer archivo
            k1wpec.p@orde = 1;
            setll %kds(k1wpec:1) pawpec;
            reade %kds(k1wpec:1) pawpec;
            cargaProp();
            dow not %eof;
                if p@tipo = '0';
                    objetosLista();
                else;
                    SVPJSON_nuevoObjeto( %trim(p@nomb)
                                       : auxJson      );
                    objetosArrayAnidados();
                    esArray = *on;
                endif;
                //prendo el primera vez para el proximo que venga.
                primeraVez = *on;
                k1wpec.p@orde += 1;
                reade %kds(k1wpec:1) pawpec;
                if not %eof;
                    if not esArray;
                        SVPJSON_cerrarObjLista( *Off
                                            : auxJson );
                    else;
                        SVPJSON_cerrarObj( *off
                                         : auxJson );
                        esArray = *off;
                    endif;
                    cargaProp();
                else;
                    if not esArray;
                        SVPJSON_cerrarObjLista( *On
                                            : auxJson );
                    else;
                        SVPJSON_cerrarObj( *on
                                         : auxJson );
                        esArray = *on;
                    endif;
                endif;
            enddo;//dow pawpec
        end-proc;
     * - ----------------------------------------------------------- *
     *    Carca Campos                                              *
     * - ----------------------------------------------------------- *
        dcl-proc objetosArrayAnidados;
            primeraVez = *on;
            k1tpca.a@empr = uds.usempr;
            k1tpca.a@sucu = uds.ussucu;
            k1tpca.a@noar = p@nomb;
            k1tpca.a@nrob = 1;
            setll %kds(k1tpca:4) gntpca;
            reade %kds(k1tpca:4) gntpca;
            dow not %eof;
                elUltimo = *off;
                if A@ULTP = '1';
                    elUltimo = *on;
                endif;
                if primeraVez;
                    if A@MAR3 <> '1';
                        SVPJSON_nuevoObjetoLista( a@nomo
                                                : auxJson );
                    endif;
                    primeraVez = *off;
                endif;
                //Seteo segun tipo de dato
                setTipoDato(a@nomp : a@nrop);
                select;
                    when A@ULOB = '1';
                        SVPJSON_cerrarObjLista( *On
                                              : auxJson );
                        primeraVez = *on;
                    when A@ULTP = '1' and A@ULOB = '0' and A@MAR3 <> '1';
                        SVPJSON_cerrarObjLista( *Off
                                              : auxJson );
                        primeraVez = *on;
                    when A@MAR3 = '1';
                        k1tpca.a@nrob += 1;
                        primeraVez = *on;
                endsl;
                if A@ULTP = '1';
                    k1tpca.a@nrob += 1;
                endif;
                reade %kds(k1tpca:4) gntpca;
            enddo;
        end-proc;
     * - ----------------------------------------------------------- *
     *    Carca Campos                                              *
     * - ----------------------------------------------------------- *
        dcl-proc objetosLista;
            k1tpec.g@empr = uds.usempr;
            k1tpec.g@sucu = uds.ussucu;
            k1tpec.g@nomo = p@nomb;
            k1tpec.g@nrop = 1;
            //gntpec contiene campos y tipo de dato
            setll %kds(k1tpec:4) gntpec;
            reade %kds(k1tpec:4) gntpec;
            dow not %eof;
                elUltimo = *off;
                if g@mar1 = '1';
                    elUltimo = *on;
                endif;
                if primeraVez;
                    SVPJSON_nuevoObjetoLista( p@nomb
                                            : auxJson );
                    primeraVez = *off;
                endif;
                //Seteo segun tipo de dato
                setTipoDato(g@nomp : g@nrop);
                k1tpec.g@nrop += 1;
                reade %kds(k1tpec:4) gntpec;
            enddo;
        end-proc;
     * - ----------------------------------------------------------- *
     *    Carca Campos                                              *
     * - ----------------------------------------------------------- *
        dcl-proc cargaProp;
            // Limpiar array primero
            for i = 1 to %elem(propiedad);
                propiedad(i) = *blanks;
            endfor;
            // Cortar en bloques de 50 caracteres
            for i = 1 to %elem(propiedad);
                propiedad(i) = %subst( p@camp
                                     : ((i - 1) * cantidadC) + 1
                                     : cantidadC                );
            endfor;
        end-proc;
     * - ----------------------------------------------------------- *
     *                                                               *
     * - ----------------------------------------------------------- *
        dcl-proc setTipoDato;
            dcl-pi *n ;
                str varchar(50) const;
                pos int(10)     const;
            end-pi;
            select;
                //Numerico
                when g@tipd = 'N';
                    if propiedad(%int(pos)) <> *blanks;
                    SVPJSON_agregoCampoNumerico( str
                                               : propiedad(%int(pos))
                                               : elUltimo
                                               : auxJson           );
                    else;
                        SVPJSON_campoNull( str
                                         : elUltimo
                                         : auxJson  );
                    endif;
                //Alfa
                when G@TIPD = 'S';
                    SVPJSON_agregoCampoString( str
                                             : %trim(
                                              propiedad(%int(pos)))
                                             : elUltimo
                                             : auxJson );
            endsl;
        end-proc;
     * - ----------------------------------------------------------- *
     *   Guardo csv a disco y envio mail.
     * - ----------------------------------------------------------- *
        dcl-proc guardaCsvADiscoEnviaMail;
            unlink( '/tmp/SINENSUP_Json.json' );
            r = rename( @file: '/tmp/SINENSUP_Json.json' );
            if (r = 0);
                SNDMAIL( peCprc : peCspr );
            endif;
        end-proc;
     * - ----------------------------------------------------------- *
     *
     * - ----------------------------------------------------------- *
        dcl-proc preparoCsv;
            @file = %str(tmpnam(*omit));
            fd = open( @file
                     : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                       +O_TEXTDATA+O_TEXT_CREAT
                     : M_RWX
                     : 819
                     : 0 );
            if (fd < 0);
                return;
            endif;
        end-proc;
