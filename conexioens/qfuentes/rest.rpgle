     H nomain
      * ************************************************************ *
      * REST:   Programa de Servicio.                                *
      *         Trabajo con REST.                                    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                    *26-May-2017             *
      * ------------------------------------------------------------ *
      * Modificacion:                                                *
      * SGF 26/10/2017 : Se agrega caracter de Escape(x'3F': '&apos) *
      * EXT 19/07/2018 : Se agrega procedimientos:                   *
      *                  - REST_startArray()                         *
      *                  - REST_endArray()                           *
      * SGF 26/06/2020 : Agrego nombre de sistema en header.         *
      * LRG 14/08/2020 : Agrego parametros opcional de separador     *
      *                  de campo para URI                           *
      * SGF 26/11/2022 : writeHeader() imprime body con el error.    *
      *                  Esto es para que ApiC lo pueda mostrar.     *
      * SGF 22/06/2023 : _getUri() recibe si debe o no convertir a   *
      *                  mayuscula.                                  *
      *                                                              *
      * ************************************************************ *

      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,cowlog_h
      /copy hdiile/qcpybooks,ifsio_h

     D REST_errn       s             10i 0
     D REST_errm       s             80a
     D initialized     s              1n

     D SetError        pr
     D   errn                        10i 0 const
     D   errm                        80a   const

     D rtvSysName      pr            10a

      * ************************************************************ *
      * REST_getEnvVar(): Recupera una variable de entorno.          *
      *                                                              *
      *       peEvar (input) - Variable de entorno.                  *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     P REST_getEnvVar  B                   Export
     D REST_getEnvVar  pi             1n
     D  peEvar                      512a   const
     D  peValu                     1024a

      /free

       REST_inz();

       if getenv(%trim(peEvar)) = *null;
          return *off;
       endif;

       peValu = %str(getenv(%trim(peEvar)));
       return *on;

      /end-free

     P REST_getEnvVar  E

      * ************************************************************ *
      * REST_getUri(): Recupera URI.                                 *
      *                                                              *
      *       peApi  (input) - Nombre del API                        *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     P REST_getUri     B                   Export
     D REST_getUri     pi             1n
     D  peApi                        10a   const
     D  peUri                       512a
     D  peRoot                       20a   const options(*nopass:*omit)
     D  peXlat                        1n   const options(*nopass:*omit)

     D servicio        s             25a
     D api             s             10a
     D peValu          s           1024a
     D pos             s             10i 0
     D rc              s              1n
     D @root           s             20a   inz('/QUOMREST/')
     D @xlat           s              1n

     D Data            s          65535a

      /free

       REST_inz();

       Data = '<br><br>'
            + 'Nombre API: '
            + %trim(peApi)
            + ' - ';
       if %parms >= 3 and %addr(peRoot) <> *null;
          Data = %trim(Data)
               + %trim(peRoot);
       endif;
       if %parms >= 4 and %addr(peXlat) <> *null;
          Data = %trim(Data)
               + 'Aplicar XLATE: ' + %trim(peXlat)
               + '==';
        else;
          Data = %trim(Data)
               + 'No llego peXlat'
               + '==';
       endif;

       @xlat = *on;
       if %parms >= 4 and %addr(peXlat) <> *null;
          @xlat = peXlat;
       endif;

       if %parms >= 3 and %addr(peRoot) <> *null;
          @root = peRoot;
       endif;

       api      = %upper( peApi );

       servicio = %trim(@root) + %trim(api) + '/';

       Data = %trim(Data)
            + ' - Servicio: '
            + %trim(servicio);

       rc       = REST_getEnvVar( 'REQUEST_URI' : peValu );
       if rc = *off;
          return *off;
       endif;

       Data = %trim(Data)
            + ' - peValu antes de UPPER: '
            + %trim(peValu);

       if @xlat;
          peValu = %upper(peValu);
       endif;

       Data = %trim(Data)
            + ' - peValu despues de UPPER: '
            + %trim(peValu);

       pos = %scan( %trim(servicio) : peValu ) + %len( %trim(servicio) );
       peUri = %subst( peValu : pos );

       Data = %trim(Data)
            + ' - peUri a retornar: '
            + %trim(peUri);
       COWLOG_pgmLog( 'REST' : %trim(Data) : *on );

       return *on;

      /end-free

     P REST_getUri     E

      * ************************************************************ *
      * REST_getMethod(): Recuera Metodo.                            *
      *                                                              *
      * Retorna: Nombre del método (asume GET)                       *
      * ************************************************************ *
     P REST_getMethod...
     P                 B                   Export
     D REST_getMethod...
     D                 pi           128a

     D peValu          s           1024a

      /free

       REST_inz();

       if REST_getEnvVar( 'REQUEST_METHOD' : peValu );
          return 'GET';
       endif;

       return %subst( peValu : 1 : 128 );

      /end-free

     P REST_getMethod...
     P                 E

      * ************************************************************ *
      * REST_write(): Graba línea a la stream.                       *
      *                                                              *
      *       peData (input) - Datos a grabar                        *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     P REST_write      B                   Export
     D REST_write      pi             1n
     D  peData                      512a   const

     D data            s            512a   varying

     D err             ds                  qualified
     D  bytesProv                    10i 0 inz(0)
     D  bytesAvail                   10i 0 inz(0)

      /free

       REST_inz();

        data = peData;
        QtmhWrStout( %trim(data): %len(%trim(data)): err);
        return *on;

      /end-free

     P REST_write      E

      * ************************************************************ *
      * REST_writeHeader(): Graba encabezado respuesta HTTP.         *
      *                                                              *
      *       peStat (input) - Status HTTP                           *
      *       peCtyp (input) - Content Type                          *
      *       peEnco (input) - Encoding                              *
      *                                                              *
      * Retorna: *on si ok, *off si hubo algún error.                *
      * ************************************************************ *
     P REST_writeHeader...
     P                 B                   Export
     D REST_writeHeader...
     D                 pi             1n
     D  peStat                        4  0 const options(*nopass:*omit)
     D  peCtyp                      128a   const options(*nopass:*omit)
     D  peEnco                      128a   const options(*nopass:*omit)
     D  peMsid                        7a   const options(*nopass:*omit)
     D  peMsev                       10i 0 const options(*nopass:*omit)
     D  peMsg1                      132a   const options(*nopass:*omit)
     D  peMsg2                     3000a   const options(*nopass:*omit)

     D @stat           s              4a
     D @ctyp           s            128a
     D @enco           s            128a
     D data            s            512a
     D @@sysn          s             10a
     D CRLF            c                   x'0d25'

      /free

       REST_inz();

       @stat = '200';
       @ctyp = 'text/xml';
       @enco = 'ISO-8859-1';

       if %parms >= 1 and %addr(peStat) <> *null;
          @stat = %char(peStat);
       endif;

       if %parms >= 2 and %addr(peCtyp) <> *null;
          @ctyp = peCtyp;
       endif;

       if %parms >= 3 and %addr(peEnco) <> *null;
          @enco = peEnco;
       endif;

       Data = 'Status: '       + %trim(@stat)      + CRLF
            + 'Content-Type: ' + %trim(@ctyp)      + CRLF
            + 'X-Status: '     + %trim(@stat);

       if %parms >= 4 and %addr(peMsid) <> *null;
          Data = %trim(Data)
               + CRLF
               + 'X-MessageId: '
               + %trim(peMsid);
       endif;

       if %parms >= 5 and %addr(peMsev) <> *null;
          Data = %trim(Data)
               + CRLF
               + 'X-MessageSeverity:'
               + %trim(%char(peMsev));
       endif;

       if %parms >= 6 and %addr(peMsg1) <> *null;
          Data = %trim(Data)
               + CRLF
               + 'X-Message:'
               + %trim(peMsg1);
       endif;

       if %parms >= 7 and %addr(peMsg2) <> *null;
          Data = %trim(Data)
               + CRLF
               + 'X-LongMessage:'
               + %trim(peMsg2);
       endif;

       // -----------------------------------------
       // Recupero nombre de sistema, pero para no
       // exponerlo al exterior, mando solo una
       // letra
       // -----------------------------------------
       @@sysn = rtvSysName();
       select;
        when @@sysn = 'SOFTDESA';
             @@sysn = 'D';
        when @@sysn = 'SOFTTEST';
             @@sysn = 'T';
        when @@sysn = 'POWER7';
             @@sysn = 'P';
        other;
             @@sysn = *blanks;
       endsl;
       Data = %trim(Data)
            + CRLF
            + 'X-Sys:'
            + %trim(@@sysn);

       Data = %trim(Data) + CRLF + CRLF;

       if %subst(@stat:1:1) <> '4' and
          %subst(@stat:1:1) <> '5';
          return REST_write( %trim(Data) );
       endif;

       REST_write( %trim(Data) );

       REST_startArray( 'errores' );
       REST_startArray( 'error' );
        REST_writeXmlLine( 'codigo'      : peMsid );
        REST_writeXmlLine( 'descripcion' : peMsg1 );
        REST_startArray( 'detalle' );
         REST_writeXmlLine( 'mensaje' : peMsg2 );
         REST_writeXmlLine( 'severidad' : %char(peMsev) );
         REST_writeXmlLine( 'status'    : @stat         );
         REST_writeXmlLine( 'backend'   : @@sysn        );
        REST_endArray  ( 'detalle' );
       REST_endArray  ( 'error' );
       REST_endArray  ( 'errores' );

       return *on;

      /end-free

     P REST_writeHeader...
     P                 E

      * ************************************************************ *
      * REST_writeXmlLine(): Grabar un tag XML en la stream HTTP.    *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *       peValu (input) - Valor                                 *
      *                                                              *
      * Retorna: *on si ok, *off si hubo error.                      *
      * ************************************************************ *
     P REST_writeXmlLine...
     P                 B                   Export
     D REST_writeXmlLine...
     D                 pi             1n
     D  peTagn                       30a   const
     D  peValu                      256a   const

     D data            s            512a
     D valu            s            512a

      /free

       REST_inz();

       select;
        when peValu = '*BEG';
             Data = '<' + %trim(peTagn) + '>';
        when peValu = '*END';
             Data = '</' + %trim(peTagn) + '>';
        other;
             valu = REST_xmlEscape(peValu);
             Data = '<' + %trim(peTagn) + '>'
                  + %trim(valu)
                  + '</' + %trim(peTagn) + '>';
       endsl;

       return REST_write( %trim(Data) );

      /end-free

     P REST_writeXmlLine...
     P                 E

      * ************************************************************ *
      * REST_writeEncoding(): Grabar encoding XML.                   *
      *                                                              *
      * Retorna: *on si ok, *off si hubo error.                      *
      * ************************************************************ *
     P REST_writeEncoding...
     P                 B                   Export
     D REST_writeEncoding...
     D                 pi             1n

     D data            s            512a
     D valu            s            512a

      /free

       REST_inz();

       return REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>' );

      /end-free

     P REST_writeEncoding...
     P                 E

      * ************************************************************ *
      * REST_getNextPart(): Recuperar siguiente parámetro de la URL. *
      *                                                              *
      *       peUri  (input/output) - URL                            *
      *       peFsp  (input) - Separador de campos de parametros     *
      *                                                              *
      * Retorna: *on si ok, *off si hubo error.                      *
      * ************************************************************ *
     P REST_getNextPart...
     P                 B                   Export
     D REST_getNextPart...
     D                 pi          3000a   varying
     D  peUri                      3000a   varying
     D  peFsp                         1a   const options(*nopass:*omit)

     D pos             s             10i 0
     D ret             s           3000a   varying
     D fsp             s              1a   inz('/')

      /free

       REST_inz();

       if %parms >= 2 and %addr(peFsp) <> *null;
          if peFsp <> *blanks;
             fsp = peFsp;
          endif;
       endif;

       pos = %scan( fsp : peUri );

       select;
        when pos = 0;
         ret = peUri;
         peUri = ' ';
        other;
         ret = %subst(peUri: 1: pos-1);
         monitor;
          peUri = %subst(peUri: pos+1);
         on-error;
          peUri = *blanks;
         endmon;
       endsl;

       return ret;

      /end-free

     P REST_getNextPart...
     P                 E

      * ************************************************************ *
      * REST_xmlEscape(): Escapa carácteres XML especiales.          *
      *                                                              *
      *       peData (input) - Línea XML                             *
      *                                                              *
      * Retorna: la string "escapada".                               *
      * ************************************************************ *
     P REST_xmlEscape...
     P                 B                   Export
     D REST_xmlEscape...
     D                 pi           512a
     D  peData                      512a   const

     D ret             s            512a

      /free

       ret = peData;

       ret = %scanrpl( '&' : '&amp;' : ret );
       ret = %scanrpl( '<' : '&lt;'  : ret );
       ret = %scanrpl( '>' : '&gt;'  : ret );
       ret = %scanrpl( '"' : '&quot;': ret );
       ret = %scanrpl( '''': '&apos;': ret );
       ret = %scanrpl( 'á' : '&#225;': ret );
       ret = %scanrpl( 'é' : '&#233;': ret );
       ret = %scanrpl( 'í' : '&#237;': ret );
       ret = %scanrpl( 'ó' : '&#243;': ret );
       ret = %scanrpl( 'ú' : '&#250;': ret );
       ret = %scanrpl( 'ü' : '&#252;': ret );
       ret = %scanrpl( 'Ü' : '&#220;': ret );
       ret = %scanrpl( x'3F': '&apos;': ret );

       return ret;

      /end-free

     P REST_xmlEscape...
     P                 E

      * ************************************************************ *
      * REST_readStdInput(): Lee la standard input.                  *
      *                                                              *
      *       pePvar (input) - Puntero a la variable para recibir la *
      *                        lectura.                              *
      *       pePlen (input) - Longitud máxima de la variable apunta-*
      *                        da por pePvar.                        *
      * Retorna: Longitud leía.                                      *
      *          ATENCION: Si el valor de retorno es MAYOR que pePlen*
      *          quiere decir que hay más datos que los permitidos.  *
      * ************************************************************ *
     P REST_readStdInput...
     P                 B                   Export
     D REST_readStdInput...
     D                 pi            10i 0
     D  pePvar                         *   value
     D  pePlen                       10i 0 const

     D len             s             10i 0

     D ErrorCode       ds                  qualified
     D  bytesProv                    10i 0 inz(0)
     D  bytesAvail                   10i 0 inz(0)

      /free

       QtmhRdStin( pePvar
                 : pePlen
                 : len
                 : ErrorCode );

       if len > pePlen;
          return -1;
       endif;

       return len;

      /end-free

     P                 E

      * ************************************************************ *
      * REST_inz():  Inicializar Módulo                              *
      *                                                              *
      * ************************************************************ *
     P REST_inz        B                   Export
     D REST_inz        pi

      /free

        if initialized;
           return;
        endif;

        initialized = *on;
        return;

      /end-free
     P REST_inz        E

      * ************************************************************ *
      * REST_end():  Finalizar Módulo                                *
      *                                                              *
      * ************************************************************ *
     P REST_end        B                   Export
     D REST_end        pi

      /free

        initialized = *off;
        return;

      /end-free
     P REST_end        E

      * ************************************************************ *
      * REST_error(): Retorna último error del módulo.               *
      *                                                              *
      *       peErrn (input) - Número de Error                       *
      *                                                              *
      * Retorna: Mensaje con el último error                         *
      * ************************************************************ *
     P REST_error      B                   Export
     D REST_error      pi            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      /free

       REST_inz();

       if %parms >= 1 and %addr(peErrn) <> *null;
          peErrn = REST_errn;
       endif;

       return REST_errm;

      /end-free

     P REST_error      E

     P SetError        B
     D SetError        pi
     D   peErrn                      10i 0 const
     D   peErrm                      80a   const

      /free

       REST_errn = peErrn;
       REST_errm = peErrm;
       return;

      /end-free

     P SetError        E

      * ************************************************************ *
      * REST_startArray(): Comienza Array XML                        *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *                                                              *
      * Retorna: *On si ok / *Off si error.                          *
      * ************************************************************ *
     P REST_startArray...
     P                 B                   Export
     D REST_startArray...
     D                 pi              n
     D  peTagn                       30a   const

      /free

        return REST_writeXmlLine( peTagn : '*BEG' );

      /end-free

     P                 E

      * ************************************************************ *
      * REST_endArray(): Finaliza Array XML                          *
      *                                                              *
      *       peTagn (input) - Nombre del tag                        *
      *                                                              *
      * Retorna: *On si ok / *Off si error.                          *
      * ************************************************************ *
     P REST_endArray...
     P                 B                   Export
     D REST_endArray...
     D                 pi              n
     D  peTagn                       30a   const

      /free

        return REST_writeXmlLine( peTagn : '*END' );

      /end-free

     P                 E

      * ************************************************************ *
      * rtvSysName(): Recupera nombre del sistema.                   *
      *                                                              *
      * Retorna: Nombre de sistema.                                  *
      * ************************************************************ *
     P rtvSysName      B
     D rtvSysName      pi            10a

     D QWCRNETA        pr                  ExtPgm('QWCRNETA')
     D  RcvVar                    32766a   options(*varsize)
     D  RcvVarLen                    10i 0 const
     D  NbrVarToRtn                  10i 0 const
     D  NetAtrVarArr                 10a   const
     D  ErrorCode                  8000a   options(*varsize)

     D rtnStruct       ds                  qualified
     D  nbrRet                       10i 0
     D  nbrRetOff                    10i 0
     D  rtnVal                        1a   dim(1000)

     D p_na            s               *
     D na              ds                  qualified based(p_na)
     D  attr                         10a
     D  type                          1a
     D  status                        1a
     D  length                       10i 0
     D  datachr                    1000a

     D err             ds                  qualified
     D  bytesProv                    10i 0 inz(256)
     D  bytesAvai                    10i 0 inz(0)

      /free

       QWCRNETA( rtnStruct: %size(rtnStruct): 1: 'SYSNAME': err );
       p_na = %addr(rtnStruct) + rtnStruct.nbrRetOff;
       return %subst(na.datachr:1:na.length);

      /end-free

     P rtvSysName      E

      * ************************************************************ *
      * REST_mockLista(): Mockear servicio de listas.                *
      *                                                              *
      *       peName (input) - Nombre del servio                     *
      *                                                              *
      * Retorna: void                                                *
      * ************************************************************ *
     P REST_mockLista...
     P                 b                   export
     D REST_mockLista...
     D                 pi
     D  peName                       10a   const

     D peFile          s            128a
     D fd              s             10i 0
     D len             s             10i 0
     D Data            s          65535a

     D err             ds                  qualified
     D  bytesProv                    10i 0 inz(0)
     D  bytesAvail                   10i 0 inz(0)

      /free

       REST_inz();

       peFile = %trim(REST_MockDir)
              + %trim(peName)
              + '.xml';

       if access( %trim(peFile) : F_OK ) = -1;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'MCK9999'
                          : 40
                          : 'REST_mockLista(): No existe archivo'
                          : 'No se encontró el archivo '
                          + %trim(peFile)                         );
          REST_end();
          return;
       endif;

       fd = open( %trim(peFile)
                : O_RDONLY+O_TEXTDATA );
       if fd < 0;
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'MCK9999'
                          : 40
                          : 'REST_mockLista(): No existe archivo'
                          : 'No se encontró el archivo '
                          + %trim(peFile)                         );
          REST_end();
          return;
       endif;

       REST_writeHeader( 200 );
       len = 0;
       dou len <= 0;
           len = read( fd : %addr(Data) : %size(data) );
           if len <= 0;
              leave;
           endif;
           if Data <> *blanks;
              QtmhWrStout( %trim(data): %len(%trim(data)): err);
           endif;
       enddo;

       callp close(fd);
       return;

      /end-free

     P                 e

