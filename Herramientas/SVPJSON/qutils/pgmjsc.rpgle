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
     Fgnticc    if   e           k disk
     Fpawicc    if   e           k disk
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
        dcl-ds k1ticc  likerec(g@ticc:*key);
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
        //Un total de 20 campos posibles.
        dcl-s propiedad char(50) dim(20);
        dcl-s i         int(10) inz(1);
        dcl-s p         int(10);
        dcl-s temp      varchar(48);
        dcl-s primero   ind inz(*on);
        dcl-s json      varchar(32767);
        dcl-s auxJson   char(32767) ;
     * - ----------------------------------------------------------- *
     *   Indicadores
     * - ----------------------------------------------------------- *
        dcl-s primeraVez ind inz(*on);
        dcl-s elUltimo   ind inz(*off);
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
            listaObjTipoLista();
            //Cierro objeto general  !
            SVPJSON_cerrarObj( *on
                             : auxJson );
            //Parseo y gravo
            json = %trim(auxJson);
            callp write(fd: %addr(json)+OFFSET: %len(json) );
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
                                     : auxJson);
            SVPJSON_agregoCampoString( 'tipoEntrega'
                                     : ''
                                     : *off
                                     : auxJson);
            SVPJSON_agregoCampoString( 'cronograma'
                                     : ''
                                     : *off
                                     : auxJson);
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
        dcl-proc listaObjTipoLista;
            // leer archivo
            setll *start pawicc;
            read  pawicc;
            cargaProp();
            dow not %eof;
                i = 1;
                k1ticc.g@empr = uds.usempr;
                k1ticc.g@sucu = uds.ussucu;
                k1ticc.g@nomo = p@nomb;
                k1ticc.g@nrop = i;
                //gnticc contiene campos y tipo de dato
                setll %kds(k1ticc:4) gnticc;
                reade %kds(k1ticc:4) gnticc;
                dow not %eof;
                    if g@mar1 = '1';
                        elUltimo = *on;
                    endif;
                    if primeraVez;

                        SVPJSON_nuevoObjetoLista( p@nomb
                                                : auxJson );
                        primeraVez = *off;
                    endif;
                    //Tipos de dato
                    select;
                        //Numerico
                        when g@tipd = 'N';
                            if propiedad(%int(g@nrop)) <> *blanks;
                            SVPJSON_agregoCampoNumerico( g@nomp
                                                       : propiedad(%int(g@nrop))
                                                       : elUltimo
                                                       : auxJson           );
                            else;
                                SVPJSON_campoNull( g@nomp
                                                 : elUltimo
                                                 : auxJson  );
                            endif;
                        //Alfa
                        when G@TIPD = 'S';
                            SVPJSON_agregoCampoString( g@nomp
                                                     : %trim(
                                                       propiedad(%int(g@nrop)))
                                                     : elUltimo
                                                     : auxJson );
                    endsl;
                    k1ticc.g@nrop += 1;
                    reade %kds(k1ticc:4) gnticc;
                enddo;
                //prendo el primera vez para el proximo que venga.
                primeraVez = *on;
                elUltimo = *off;
                read  pawicc;
                if not %eof;
                    SVPJSON_cerrarObjLista( *Off
                                          : auxJson );
                    cargaProp();
                else;
                    SVPJSON_cerrarObjLista( *On
                                          : auxJson );
                endif;
            enddo;//dow pawicc
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
