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
     * - ----------------------------------------------------------- *
     *   Copys
     * - ----------------------------------------------------------- *
      /copy hdiile/qcpybooks,ifsio_h
     * - ----------------------------------------------------------- *
     *   Se llama...
     * - ----------------------------------------------------------- *
     D JSNCON_         pr
     D JSNCON_         pi
     * - ----------------------------------------------------------- *
     *   Empresa y sucursal segun area de datos
     * - ----------------------------------------------------------- *
        dcl-ds uds;
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
     * - ----------------------------------------------------------- *
     *  Variables para envio de mail
     * - ----------------------------------------------------------- *
        dcl-s peCprc char(20) inz('JSNCON');
        dcl-s peCspr char(50) inz('JSNCON');
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
        dcl-s valores char(48) dim(3);
        dcl-s i       int(10) inz(1);
        dcl-s p       int(10);
        dcl-s temp    varchar(48);
        dcl-s primero int(3) inz(1);
        dcl-s json    varchar(32767);
     * - ----------------------------------------------------------- *
     *   Indicadores
     * - ----------------------------------------------------------- *
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
            preparoCsv();
            encabezado();
            // leer archivo
            setll *start sinensup;
            read  sinensup;
            dow not %eof;
                //Obtengo datos a setear en el json
                cuenta  = getValor(xxcamp: 1);
                subramo = getValor(xxcamp: 2);
                valor   = getValor(xxcamp: 3);
                //primero viene con valor 1
                //si no es el primero meto coma.
                if primero = 0;
                    json = ',';
                endif;
                //Cuenta y valor
                json += '"' + %trim (cuenta) + '": {';
                json += '"valor": "' + %trim(valor) + '",';
                //Subramo puede ir en null.
                if %len(%trim(subramo)) > 0;
                    json += '"subramo": "' + %trim(subramo) + '"';
                else;
                    json += '"subramo": null';
                endif;
                //Cierro el "objeto" cuenta
                json += '}';
                //Grabo.
                json += CRLF;
                callp write(fd: %addr(json)+OFFSET: %len(json));
                //Si ya pase por aca, no es el primero.
                primero = 0;
                read sinensup;
            enddo;
            // cerrar objeto "cuentas" y el "objeto" general
            json = '}'  + '}';
            callp write(fd: %addr(json)+OFFSET: %len(json) );
            guardaCsvADiscoEnviaMail();
            return;
        /end-free
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
            i         += 1;
        enddo;
        //Al ultimo valor lo capturo aca
        valores(i) = temp;
        return valores(pos);
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
     * - ----------------------------------------------------------- *
     *    Encabezado                                                 *
     * - ----------------------------------------------------------- *
        dcl-proc encabezado;
            // inicializar JSON
            json = '{'
                 + '  "codigoCompania": ""' + ','
                 + '  "tipoEntrega": ""'    + ','
                 + '  "cronograma": ""'     + ','
                 + '  "cuentas": {'   ;
            json += CRLF;
        end-proc;
