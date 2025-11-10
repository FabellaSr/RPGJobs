     H nomain
     H bnddir('QC2LE')
      * *************************************************** *
      * MAIL: Programa de Servicio.                         *
      *       Envío de correos electrónicos.                *
      *                                                     *
      * Este programa debe enlazarse a:                     *
      * QTCP/QTMMSNDM: Programa de Servicio que contiene el *
      *       Subprocedimiento QTMMSENDMAIL. Aquel que permi*
      *       mandar mails.                                 *
      * QSYSDIR/QAXIS10HT: Programa de Servicio que contiene*
      *       los procedimientos para de/codificar BASE64.  *
      *                                                     *
      * Estos dos programas están en HDIILE/HDIBDIR         *
      *                                                     *
      *  Script de compilación (para INF1SERG/BUILD)        *
      *                                                     *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*  *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                <*  *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*  *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*  *
      *>           DBGVIEW(&DV)                         <*  *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*  *
      *>           MODULE(QTEMP/&N) -                   <*  *
      *>           EXPORT(*SRCFILE) -                   <*  *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*  *
      *> BNDSRVPGM(QSYSDIR/QAXIS10HT QTCP/QTMMSNDM) -   <*  *
      *> TEXT('Programa de Servicio: Envío de mails')   <*  *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*  *
      *                                                     *
      * --------------------------------------------------- *
      * Sergio Fernandez                  *13-Ene-2012      *
      * --------------------------------------------------- *
      * SGF 25/01/13: Cierre todos los descriptores porque  *
      *               pobrecito el iSeries, es groso pero   *
      *               no de goma.                           *
      *               Agrego comillas dobles en los comandos*
      *               de la QShell y PASE para soportar los *
      *               nombres con espacios.                 *
      *               Implemento MAIL_Lbody() para generar  *
      *               el cuerpo del mail "largo".           *
      * SGF 16/07/13: _chkusraddr() para verificar si tiene *
      *               mail un determinado usuario.          *
      *               Controlar %len del mail (ya que es un *
      *               varying) cuando está en blanco en ruti*
      *               na _getDire().                        *
      * SFA 22/07/13: _LSubject() Genera Subject largo para *
      *               envio de mail.                        *
      *               Agrego a _SndLmail como *nopass *omit *
      * SGF 29/11/13: Cambio la expresión regular para la   *
      *               validación de sintáxis.               *
      * SGF 07/07/14: Agrego un HTML encoder para el body y *
      *               la autofirma.                         *
      *               Limpiar ejecución de QShell y PASE con*
      *               CLNQSH().                             *
      *               Implemento CCO.                       *
      *               _lSubject() usaba una variable más    *
      *               corta para grabar en la nota MIME, por*
      *               lo tanto, si bien recibía 270 bytes,  *
      *               grababa sólo 100 al disco.            *
      * SGF 30/07/14: *DIAG en seterror().                  *
      *               _getReceipt().                        *
      * SGF 20/11/14: Cambio zip por jar.                   *
      * SGF 22/12/14: Agrego _getFrom() para recuperar el   *
      *               From de un Proceso/SubProceso.        *
      *               _getBody() para recuperar el body de  *
      *               un Proceso/SubProceso.                *
      *               _getLBody() para recuperar el body de *
      *               un Proceso/SubProceso (body largo).   *
      *               _getAttList() para recuperar la lista *
      *               de archivos adjuntos de un proceso/sub*
      *               proceso.                              *
      *               Parámetro opcional en getReceipt() que*
      *               indica si se devuelven todos o solo   *
      *               los activos.                          *
      * SGF 20/01/15: Agrego _isLongBody() para recuperar si*
      *               proceso/subproceso usa body largo.    *
      *               _mustZip() para saber si debe o no    *
      *               zipear.                               *
      *               _getOptions() para recuperar las opcio*
      *               nes de proceso/subproceso.            *
      *               _getSubject() obtiene asunto.         *
      * SGF 03/02/15: Agrego posibilidad de enviar nombre de*
      *               attach a sndEmail y sndLmail.         *
      * SGF 19/04/17: Cambio expresión regular para soportar*
      *               los .info.                            *
      * GIO 06/07/18: Por adicion del campo PRRPYT a GNTSPR *
      *               (Replay-To en mails), se crea el      *
      *               procedimiento _getReplyTo()           *
      * SGF 10/01/23: Corrijo sendBMail().                  *
      * FAS 04/10/22: Agrego _setMailBand: Graba registro   *
      *               en Bandeja de Salida de Mails         *
      * FAS 19/01/23: Corrijo _setMailBand: Permite         *
      *               llamado con campos opcionales         *
      * FAS 30/01/23: Corrijo _setMailBand: Se eliminan las *
      *               operaciones Close *All                *
      *                                                     *
      * *************************************************** *

     Fmailconf  if   e           k disk    usropn
     Fmailautfirif   e           k disk    usropn
     Fsplfcfg   if   e           k disk    usropn
     Fmailusrs  if   e           k disk    usropn
     Fgntemp    if   e           k disk    usropn
     Fgntmkw    if   e           k disk    usropn
     Fmaillog   if a e           k disk    usropn
     Fgntprp    if   e           k disk    usropn
     Fgntspr    if   e           k disk    usropn
     Fgntpfi    if   e           k disk    usropn
     Fgntbdy    if   e           k disk    usropn
     Fgntbdl    if   e           k disk    usropn
     FmailBand  if a e           k disk    usropn
     FmailBDes  if a e           k disk    usropn

     D/copy HDIILE/QCPYBOOKS,IFSIO_H
     D/copy HDIILE/QCPYBOOKS,MAIL_H
     D/copy HDIILE/QCPYBOOKS,APR_B64_H

     D CRLF            c                   x'0d25'
     D Initialized     s              1N   inz(*OFF)
     D @wdir           s            256a   varying
     D @sysmail        s            256a   varying
     D @rtpmail        s            256a   varying
     D @rpymail        s            256a   varying
     D @rqsmail        s            256a   varying

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D ErrorData       ds                  likeds(MAIL_ERDS_T)

      * --------------------------------------------------- *
      * Estrucutura de datos archivo de configuración
      * --------------------------------------------------- *
     D @MailConfr      ds                  likerec(MAILCONFR:*input)
     D @G1tEmp         ds                  likerec(g1temp:*input)
     D @Dire           ds                  likeds(DireEnt_t)
     D @AutoFirma      s             79a   dim(9999)

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr                  opdesc
     D  Errno                         4s 0 const
     D   peRpld                   32766a   const
     D                                     options(*nopass:*varsize)

      * --------------------------------------------------- *
      * Codifica HTML
      * --------------------------------------------------- *
     D htmlEncode      pr            10i 0
     D  input                      5000a   options(*varsize) const
     D  inputLen                     10i 0 const
     D  output                    65535a   options(*varsize) varying
     D  outputLen                    10i 0

      * --------------------------------------------------- *
      * Limpiar logs QSH/PASE
      * --------------------------------------------------- *
     D CLNQSH          pr                  ExtPgm('CLNQSH')

      * --------------------------------------------------- *
      * Loguear
      * --------------------------------------------------- *
     D MAIL_Log        pr
     D   peMime                     256a   varying const
     D   peFadr                     256a   varying const
     D   peToad                     256a   varying const
     D   peCerr                       4s 0 const

      * --------------------------------------------------- *
      * Area de sistema
      * --------------------------------------------------- *
     D @PsDs          sds                  qualified
     D  JobName                      10a   overlay(@PsDs:244)
     D  UsrName                      10a   overlay(@PsDs:*next)
     D  JobNbr                        6  0 overlay(@PsDs:*next)
     D  CurUsr                       10a   overlay(@PsDs:358)

      * --------------------------------------------------- *
      * MAIL_Inz(): Inicializa módulo.                      *
      *                                                     *
      * Este procedimiento será llamado por todos los demás *
      * procedimiento exportados.                           *
      *                                                     *
      * --------------------------------------------------- *
     P MAIL_Inz        b                   export
     D MAIL_Inz        pi            10i 0

     D @cmd            s            500a   varying
     D @z              s             10i 0
     D @Msg            s            512a
     D TheKey          s              4a
     D wsMail          s            255a

     D QMHSNDM         pr                  extpgm('QMHSNDM')
     D  MsgID                         7a   const
     D  QualMsgF                     20a   const
     D  Message                   32767a   const options(*varsize)
     D  MessageLen                   10i 0 const
     D  MessageType                  10a   const
     D  ListMsgQ                     20a   const dim(1)
     D  NbrMsgQ                      10i 0 const
     D  MsgQueueRpy                  20a   const
     D  TheKey                        4a
     D  ErrCode                    8000a   options(*varsize)

     D ErrorCode       ds                  qualified
     D  BytesA                       10i 0 inz(0)
     D  BytesR                       10i 0 inz(0)

      /free

        if Initialized;
           return *zeros;
        endif;

        // -----------------------------------
        // Salida para QShell/PASE
        // -----------------------------------
          @cmd = 'ADDENVVAR ENVVAR(QIBM_QSH_CMD_OUTPUT) VALUE('
               + ''''
               + 'NONE'
               + ''''
               + ') REPLACE(*YES)';
          MAIL_doCmd(@cmd);

        // -----------------------------------
        // Vuelca Directorio
        // -----------------------------------
        @Dire = MAIL_GetDire( @PsDs.CurUsr );

        // -----------------------------------
        // Arma directorio de trabajo
        // -----------------------------------
          @wdir = '/tmp/'
                + %trim(%editc(@PsDs.JobNbr:'X'))
                + '_'
                + %trim(@PsDs.CurUsr)
                + '_'
                + %trim(@PsDs.JobName);

        // -----------------------------------
        // Accede archivo de empresa
        // -----------------------------------
        monitor;
         open gntemp;
         read gntemp @g1temp;
         if %eof(gntemp);
            SetError( MAIL_E_INZ );
            close *all;
            return -1;
         endif;
         close gntemp;
         on-error;
           SetError( MAIL_E_INZ );
           close *all;
           Initialized = *OFF;
           return -1;
        endmon;

        // -----------------------------------
        // Cargar plantilla autofirma
        // -----------------------------------
        monitor;
         @z = *zeros;
         open mailautfir;
         read mailautfir;
         dow not %eof(mailautfir);
          @z += 1;
          @AutoFirma(@z) = afltxt;
          read mailautfir;
         enddo;
         close mailautfir;
         on-error;
           SetError( MAIL_E_INZ );
           close *all;
           Initialized = *OFF;
           return -1;
        endmon;

        monitor;
          open mailconf;
          read mailconf @mailconfr;
          if %eof(mailconf);
             SetError( MAIL_E_INZ );
             close *all;
             return -1;
          endif;
          close mailconf;
          on-error;
           SetError( MAIL_E_INZ );
           close *all;
           Initialized = *OFF;
           return -1;

        endmon;

          // -----------------------------------------------
          // Cargar mails SYSTEM, RTNPTH, RPYTO y REQUESTER
          // -----------------------------------------------
          @sysmail = %trim(@mailconfr.nfsysm)
                   + '@'
                   + %trim(@mailconfr.nfdomi);
          @rtpmail = %trim(@mailconfr.nfrtpt)
                   + '@'
                   + %trim(@mailconfr.nfdomi);
          @rpymail = %trim(@mailconfr.nfrpym)
                   + '@'
                   + %trim(@mailconfr.nfdomi);

          if ( @Dire.Mail = *blanks );
            @rqsmail = @sysmail;
            @Msg = '**** ATENCION ****'
                 + ' El usuario: ' + %trim(@PsDs.CurUsr)
                 + ' no posee cargada una dirección de mail.'
                 + ' Sus correos se envían a la casilla *SYSTEM.';
            QMHSNDM( 'CPF9897'
                   : 'QCPFMSG   *LIBL'
                   : @Msg
                   : %len(@Msg)
                   : '*INFO'
                   : 'QSYSOPR   *LIBL'
                   : 1
                   : 'QSYSOPR   *LIBL'
                   : TheKey
                   : errorcode );

           else;
            @rqsmail = %trim(@Dire.Mail)
                     + '@'
                     + %trim(@mailconfr.nfdomi);
          endif;

          if not %open(gntprp);
             open  gntprp;
          endif;

          if not %open(gntspr);
             open  gntspr;
          endif;

          if not %open(gntpfi);
             open  gntpfi;
          endif;

          if not %open(gntbdy);
             open  gntbdy;
          endif;

          if not %open(gntbdl);
             open  gntbdl;
          endif;

          if not %open(mailBand);
             open mailBand;
          endif;

          if not %open(mailBDes);
             open mailBDes;
          endif;

          Initialized = *ON;
          return *zeros;


      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_CrtMime(): Crea archivo MIME vacío en el IFS   *
      *                                                     *
      *   peMime (i/o)  = Archivo MIME a generar/generado.  *
      *                   Si *omit este nombre se genera.   *
      *                                                     *
      * retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_CrtMime    b                   export
     D MAIL_CrtMime    pi            10i 0
     D   peMime                     256a   varying

     D mimeFile        s            256a   varying
     D fd              s             10i 0
     D pos             s             10i 0
     D npos            s             10i 0
     D mimeDir         s            256a   varying
     D @slash          s              1n

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       mimeFile = %trim(peMime);

       // ------------------------------
       // Extraer nombre de directorio
       // ------------------------------
       @slash = *off;
       pos = %scan('/':mimeFile);
       dow pos > *zeros;
         @slash = *on;
            pos = %scan('/':mimeFile:pos+1);
            if pos = *zeros;
               leave;
            endif;
           npos = pos;
       enddo;

       if not @slash;
          SetError( MAIL_E_NODIR
                  : mimeFile );
          return -1;
       endif;

       // --------------------------------------
       // Ver si el objeto existe y si tiene aut
       // --------------------------------------
       mimeDir = %subst(%trim(mimeFile):1:npos);
       if MAIL_ChkIfsO( %trim(mimeDir)
                      : '*RWX' ) = NOEXIST;
          SetError( MAIL_E_AUTDIR
                  : mimeDir );
          return -1;
       endif;

       // --------------------------------------
       // Ver si es un directorio
       // --------------------------------------
       if MAIL_IsDir( mimeDir ) = NOTDIR;
          SetError( MAIL_E_NODIR
                  : mimeFile );
          return -1;
       endif;

       unlink(mimeFile);

       fd = open( mimeFile
                : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                 +O_TEXTDATA+O_TEXT_CREAT
                : M_RDWR
                : 819
                : 0 );

       if fd = -1;
          callp close(fd);
          SetError( MAIL_E_CRTMIME
                  : mimeFile );
          return -1;
       endif;

       callp close(fd);
       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_Subject(): Crea asunto del Mail.               *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peSubj (input) = Asunto del mail                  *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error               *
      * --------------------------------------------------- *
     P MAIL_Subject    b                   export
     D MAIL_Subject    pi            10i 0
     D   peMime                     256a   const varying
     D   peSubj                      84a   const varying

     D Data            s            100a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

        if MAIL_Inz() = -1;
           return -1;
        endif;

        if %trim(peSubj) = *blanks;
          SetError( MAIL_E_NOSUBJ );
          return -1;
        endif;

        // ------------------------------
        // Abre nota MIME en modo Append
        // ------------------------------
        fd = open( %trim(peMime)
                 : O_WRONLY+O_TEXTDATA+O_APPEND);

        if fd = -1;
           callp close(fd);
           @ErrMsg = 'MAIL_Subject()                '
                   + %trim(peMime);
           SetError( MAIL_E_NOMIMEX
                   : @ErrMsg );
           return -1;
        endif;

        Data = 'Subject: '
             + %trim(peSubj)
             + CRLF;
        callp write(fd: %addr(Data)+2: %len(Data));

        callp close(fd);
        return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_Date():   Genera fecha actual en formato mail. *
      *                                                     *
      *   'Jue, 03 Ene 1950 14:30:06 -0300'                 *
      *                                                     *
      * Retorna String con la fecha                         *
      * --------------------------------------------------- *
     P MAIL_Date       b                   export
     D MAIL_Date       pi            31a

     D CEEUTCO         pr                  opdesc
     D   Hours                       10i 0
     D   Minutes                     10i 0
     D   Seconds                      8f
     D   fc                          12a   options(*omit)

     D DOMINGO         c                   d'1899-12-31'

     D junkl           s              8f
     D hours           s             10i 0
     D mins            s             10i 0
     D tz_hours        s              2p 0
     D tz_mins         s              2p 0
     D tz              s              5a   varying

     D CurTs           s               z
     D CurTime         s              8a   varying
     D CurDay          s              2p 0
     D CurYear         s              4p 0
     D CurMM           s              2p 0
     D CurMonth        s              3a   varying
     D TempDOW         s             10i 0
     D CurDOW          s              3a   varying

     D DateString      s             31a

      /free

       if MAIL_Inz() = -1;
          return *blanks;
       endif;

       CEEUTCO(hours:mins:junkl:*omit);
       tz_hours = %abs(hours);
       tz_mins  = mins;

       if hours < 0;
          tz = '-';
        else;
          tz = '+';
       endif;

       tz += %editc(tz_hours:'X') + %editc(tz_mins:'X');

       CurTS = %timestamp();

       CurTime = %char(%time(CurTS): *HMS:);

       CurDay  = %subdt(CurTS: *DAYS);
       CurYear = %subdt(CurTS: *YEARS);
       CurMM   = %subdt(CurTS: *MONTHS);

       select;
        when CurMM = 1;
          CurMonth = 'Jan';
        when CurMM = 2;
          CurMonth = 'Feb';
        when CurMM = 3;
          CurMonth = 'Mar';
        when CurMM = 4;
          CurMonth = 'Apr';
        when CurMM = 5;
          CurMonth = 'May';
        when CurMM = 6;
          CurMonth = 'Jun';
        when CurMM = 7;
          CurMonth = 'Jul';
        when CurMM = 8;
          CurMonth = 'Aug';
        when CurMM = 9;
          CurMonth = 'Sep';
        when CurMM = 10;
          CurMonth = 'Oct';
        when CurMM = 11;
          CurMonth = 'Nov';
        when CurMM = 12;
          CurMonth = 'Dec';
       endsl;

       TempDOW = %diff( %date(CurTS) : DOMINGO : *DAYS );
       TempDOW = %rem( TempDOW : 7 );

       select;
        when TempDOW = 0;
          CurDOW = 'Sun';
        when TempDOW = 1;
          CurDOW = 'Mon';
        when TempDOW = 2;
          CurDOW = 'Tue';
        when TempDOW = 3;
          CurDOW = 'Wed';
        when TempDOW = 4;
          CurDOW = 'Thu';
        when TempDOW = 5;
          CurDOW = 'Fri';
        when TempDOW = 6;
          CurDOW = 'Sat';
       endsl;

       DateString = CurDOW + ', '
                  + %editc( CurDay: 'X' ) + ' '
                  + CurMonth + ' '
                  + %editc( CurYear: 'X' ) + ' '
                  + CurTime + ' '
                  + tz;

       Return DateString;

      /end-free
     P                 E

      * --------------------------------------------------- *
      * MAIL_From(): Genera Remitente.                      *
      *              Este procedimiento también agrega la   *
      *              Versión MIME.                          *
      *              Fecha en formato mail.                 *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *                   *SYSTEM  = Toma de Configuración. *
      *                   *CURRENT = Usuario Job.           *
      *   peFAdr (input) = Dirección de correo de prFrom    *
      *                   *SYSTEM  = Toma de Configuración. *
      *                   *CURRENT = Usuario Job.           *
      *   peRpyt (input) = Responder a...                   *
      *                   Si no llega, usa de configuración.*
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     P MAIL_From       b                   export
     D MAIL_From       pi            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peRpyt                     256a   const varying
     D                                     options(*nopass:*omit)

     D Data            s            358a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D @From           s             64a
     D @FAdr           s            256a
     D @@adr           s            256a   varying
     D @Rpty           s            256a

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;


       // -----------------------------
       // Si es *SYSTEM, usa de config
       // -----------------------------
       select;
         when peFrom = '*SYSTEM';
              @From = @mailconfr.nfsysn;
              @FAdr = @sysmail;
         when peFrom = '*CURRENT';
              @From = %trim(@Dire.Fuln);
              @Fadr = %trim(@rqsmail);
         other;
              @From = %trim(peFrom);
              @FAdr = %trim(peFadr);
       endsl;

       if %parms >= 4 and
          %addr(peRpyt) <> *NULL;
           @Rpty = %trim(peRpyt);
        else;
           select;
             when peFrom = '*SYSTEM';
                  @Rpty = @sysmail;
             when peFrom = '*CURRENT';
                  @Rpty = @Fadr;
             other;
                  @Rpty = %trim(peFadr);
           endsl;
       endif;

       // -----------------------------
       // Si no informó Remitente
       // -----------------------------
       if %trim(@From) = *blanks;
          SetError( MAIL_E_NOFRM );
          return -1;
       endif;

       // ---------------------------------
       // Si no informó mail del Remitente
       // ---------------------------------
       if %trim(@FAdr) = *blanks;
          SetError( MAIL_E_NOFRMA );
          return -1;
       endif;

       // ---------------------------------
       // Si el mail del Remit es inválido
       // ---------------------------------
       if MAIL_IsValid( @FAdr ) = NOTVALID;
          SetError( MAIL_E_FRMAIV
                  : @FAdr );
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_From()                   '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = 'Date: '
            + MAIL_Date()
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       Data = 'From: '
            + %trim(@From)
            + ' <'
            + %trim(@FAdr)
            + '>' + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       Data = 'MIME-Version: 1.0'
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       // -------------------------------------
       // Si lo solicitó, y es válido agrego
       // "reply-to": esto hace que quien lo
       // reciba vea una línea que dice:
       // "Por favor, responda a: xx@xxx.com"
       // -------------------------------------
       if MAIL_IsValid( %trim(@Rpty) ) = VALID;
          Data = 'Reply-To: '
               + %trim(@Rpty)
               + CRLF;
          callp write(fd: %addr(Data)+2: %len(Data));
       endif;

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_To():   Genera Destinatarios.                  *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peTonm (input) = Nombre destinatario.             *
      *                  *SYSTEM: Usuario de configuración. *
      *                  *REQUESTER: Usuario del Job.       *
      *   peToad (input) = Dirección destinatario.          *
      *   peToty (input) = Tipo de destinatario.            *
      *                                                     *
      * Retorna 0 si todo bien, -1 por error.               *
      * --------------------------------------------------- *
     P MAIL_To         b                   export
     D MAIL_To         pi            10i 0
     D   peMime                     256a   const varying
     D   peTonm                      50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)

     D Data            s            512a   varying
     D OutData         s            512a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D TotOfTo         s             10i 0
     D TotOfCc         s             10i 0
     D TotOfCco        s             10i 0
     D Cant            s             10i 0
     D @x              s             10i 0
     D @Tonm           s             50a
     D @Toad           s            256a
     D @@oad           s            256a   varying
      * Destinatarios To:
     D RecDsTo         ds                  likeds(RecipDs_t)
     D                                     dim(100)
      * Destinatarios Cc:
     D RecDsCc         ds                  likeds(RecipDs_t)
     D                                     dim(100)
      * Destinatarios Cco:
     D RecDsCco        ds                  likeds(RecipDs_t)
     D                                     dim(100)

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ---------------------------
       // Cantidad total de cada uno
       // ---------------------------
       TotOfTo  = *zeros;
       TotOfCc  = *zeros;
       TotOfCco = *zeros;
       for @x = 1 to 100;
         if peTonm(@x) = *blanks;
            leave;
         endif;
         select;
           when peToty(@x) = MAIL_NORMAL;
             select;
              when peTonm(@x) = '*SYSTEM';
                @Toad = %trim(@sysmail);
                @Tonm = %trim(@mailconfr.nfsysn);
              when peTonm(@x) = '*REQUESTER';
                @Toad = %trim(@rqsmail);
                @Tonm = %trim(@Dire.Fuln);
              when peTonm(@x) = '*RTNPTH';
                @Toad = %trim(@rtpmail);
                @Tonm = @mailconfr.nfrtpn;
              other;
                @Toad = %trim(peToad(@x));
                @Tonm = %trim(peTonm(@x));
             endsl;
             if %trim(@Toad) <> *blanks and
                MAIL_IsValid( %trim(@Toad) );
                TotOfTo  += 1;
                RecDsTo(TotOfTo).ToName = %trim(@Tonm);
                RecDsTo(TotOfTo).ToAddr = %trim(@Toad);
             endif;
           when peToty(@x) = MAIL_CC;
             select;
              when peTonm(@x) = '*SYSTEM';
                @Toad = %trim(@sysmail);
                @Tonm = %trim(@mailconfr.nfsysn);
              when peTonm(@x) = '*REQUESTER';
                @Toad = %trim(@rqsmail);
                @Tonm = %trim(@Dire.Fuln);
              when peTonm(@x) = '*RTNPTH';
                @Toad = %trim(@rtpmail);
                @Tonm = @mailconfr.nfrtpn;
              other;
                @Toad = %trim(peToad(@x));
                @Tonm = %trim(peTonm(@x));
             endsl;
             if %trim(@Toad) <> *blanks and
                MAIL_IsValid( %trim(@Toad) );
                TotOfCc  += 1;
                RecDsCc(TotOfCc).ToName = %trim(@Tonm);
                RecDsCc(TotOfCc).ToAddr = %trim(@Toad);
             endif;
           when peToty(@x) = MAIL_CCO;
             select;
              when peTonm(@x) = '*SYSTEM';
                @Toad = %trim(@sysmail);
                @Tonm = %trim(@mailconfr.nfsysn);
              when peTonm(@x) = '*REQUESTER';
                @Toad = %trim(@rqsmail);
                @Tonm = %trim(@Dire.Fuln);
              when peTonm(@x) = '*RTNPTH';
                @Toad = %trim(@rtpmail);
                @Tonm = @mailconfr.nfrtpn;
              other;
                @Toad = %trim(peToad(@x));
                @Tonm = %trim(peTonm(@x));
             endsl;
             if %trim(@Toad) <> *blanks and
                MAIL_IsValid( %trim(@Toad) );
                TotOfCco += 1;
                RecDsCco(TotOfCco).ToName = %trim(@Tonm);
                RecDsCco(TotOfCco).ToAddr = %trim(@Toad);
             endif;
         endsl;
       endfor;

       // ------------------------------------
       // Debe haber al menos un destinatario
       // principal...
       // ------------------------------------
       if TotOfTo <= *zeros;
          SetError( MAIL_E_NORECIP );
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_To()                     '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       // ---------------------------------
       // Cargar destinatarios principales
       // ---------------------------------
       for @x = 1 to TotOfTo;
           if @x = 1;
              Data = 'To: '
                   + %trim(RecDsTo(@x).ToName)
                   + ' <'
                   + %trim(RecDsTo(@x).ToAddr)
                   + '>';
            else;
              Data = '    '
                   + %trim(RecDsTo(@x).ToName)
                   + ' <'
                   + %trim(RecDsTo(@x).ToAddr)
                   + '>';
           endif;
           if @x < TotOfTo;
              OutData = %trimr(Data)
                      + ','
                      + CRLF;
            else;
              OutData = %trimr(Data)
                      + CRLF;
           endif;
           callp write(fd: %addr(OutData)+2: %len(%trimr(OutData)));
       endfor;

       // ---------------------------------
       // Cargar destinatarios CC
       // ---------------------------------
       for @x = 1 to TotOfCc;
           if @x = 1;
              Data = 'Cc: '
                   + %trim(RecDsCc(@x).ToName)
                   + ' <'
                   + %trim(RecDsCc(@x).ToAddr)
                   + '>';
            else;
              Data = '    '
                   + %trim(RecDsCc(@x).ToName)
                   + ' <'
                   + %trim(RecDsCc(@x).ToAddr)
                   + '>';
           endif;
           if @x < TotOfCc;
              OutData = %trimr(Data)
                      + ','
                      + CRLF;
            else;
              OutData = %trimr(Data)
                      + CRLF;
           endif;
           callp write(fd: %addr(OutData)+2: %len(%trimr(OutData)));
       endfor;

       // ---------------------------------
       // Los CCO no se cargan (RFC)
       // ---------------------------------

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Importance(): Agrega Importancia.              *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peImpo (input) = Imporancia:                      *
      *                    0 = low                          *
      *                    1 = medium                       *
      *                    2 = high                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_Importance...
     P                 b                   export
     D MAIL_Importance...
     D                 pi            10i 0
     D   peMime                     256a   const varying
     D   peImpo                      10i 0 const

     D Data            s            500a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Importance()             '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       select;
        when peImpo = MAIL_IMPL;
         Data = 'Importance: low'
              + CRLF;
        when peImpo = MAIL_IMPM;
         Data = 'Importance: medium'
              + CRLF;
        when peImpo = MAIL_IMPH;
         Data = 'Importance: high'
              + CRLF;
        other;
         Data = 'Importance: low'
              + CRLF;
       endsl;

       callp write(fd: %addr(Data)+2: %len(Data));
       callp close(fd);

       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Priority(): Agrega Prioridad.                  *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMpty (input) = Prioridad:                       *
      *                    0 = non-urgent                   *
      *                    1 = normal                       *
      *                    2 = urgent                       *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_Priority   b                    export
     D MAIL_Priority   pi            10i 0
     D   peMime                     256a    const varying
     D   peMpty                      10i 0  const

     D Data            s            500a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Priority()               '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       select;
        when peMpty = MAIL_PTYT;
         Data = 'Priority: non-urgent'
              + CRLF;
        when peMpty = MAIL_PTYN;
         Data = 'Priority: normal'
              + CRLF;
        when peMpty = MAIL_PTYU;
         Data = 'Priority: urgent'
              + CRLF;
        other;
         Data = 'Priority: normal'
              + CRLF;
       endsl;

       callp write(fd: %addr(Data)+2: %len(Data));
       callp close(fd);

       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_MSens():  Agrega Sensibilidad de mensaje.      *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsen (input) = Sesibilidad:                     *
      *                    0 = normal                       *
      *                    1 = personal                     *
      *                    2 = private                      *
      *                    3 = Company-Confidential         *
      *                                                     *
      * Nota 1: Un mail con sensibilidad 2 no podrá ser     *
      *         impreso ni reenviado.                       *
      * Nota 2: Sensibilidad 3, agrega al asunto el mensaje *
      *         definido en tabla de configuración.         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_MSens      b                    export
     D MAIL_MSens      pi            10i 0
     D   peMime                     256a    const varying
     D   peMsen                      10i 0  const

     D Data            s            500a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_MSens()                  '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       select;
        when peMsen = MAIL_SENN;
         Data = 'Sensitivity: normal'
              + CRLF;
        when peMsen = MAIL_SENP;
         Data = 'Sensitivity: personal'
              + CRLF;
        when peMsen = MAIL_SENV;
         Data = 'Sensitivity: private'
              + CRLF;
        when peMsen = MAIL_SENC;
         Data = 'Sensitivity: Company-Confidential'
              + CRLF;
        other;
         Data = 'Sensitivity: normal'
              + CRLF;
       endsl;

       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_GenBnyStr(): Genera String random para usar co-*
      *                   mo BOUNDARY.                      *
      *                                                     *
      * Retorna String para Boundary.                       *
      * --------------------------------------------------- *
     P MAIL_GenBnyStr  b                   export
     D MAIL_GenBnyStr  pi            36a

     D seed            s             10u 0
     D floater         s              8f
     D @ran            s             30a
     D @x              s             10i 0
     D ALPHA           s             26a   inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
     D @bndy           s             36a

     D Random          pr                  extproc('CEERAN0')
     D   seed                        10u 0
     D   floater                      8f
     D   feedback                    12    options(*omit)

      /free

         if MAIL_Inz() = -1;
            return *blanks;
         endif;

         for @x = 1 to 30;
           random( seed
                 : floater
                 : *omit );
           %subst(@ran:@x:1) = %subst(ALPHA:%Int(floater*26+1):1);
         endfor;

         %subst(@bndy:1:6)  = '----=_';
         %subst(@bndy:7:30) = @ran;
         return @bndy;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_MultiP(): Genera el tipo de contenido:         *
      *                MULTIPART/MIXED; BOUNDARY:"..."      *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_MultiP     b                   export
     D MAIL_MultiP     pi            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D                                     options(*nopass)

     D Data            s            500a   varying
     D @Bndy           s             36a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_MultiP()                 '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = 'Content-Type: MULTIPART/MIXED;'
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       if %parms = 1;
          @Bndy = MAIL_GenBnyStr();
        else;
          @Bndy = %trim(peBndy);
       endif;

       Data = ' BOUNDARY="'
            + %trim(@Bndy)
            + '"'
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_CrtBody(): Crea un cuerpo de MAIL.             *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peCntt (input) = Tipo de contenido                *
      *                    T = text/plain (default)         *
      *                    H = text/html.                   *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_CrtBody    b                   export
     D MAIL_CrtBody    pi            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peCntt                       1a   const
     D                                     options(*nopass)

     D Data            s            500a   varying
     D @Cntt           s              1a
     D @ErrMsg         s            256a   varying
     D fd              s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ----------------------------------
       // Si llegó tipo de contenido, usa
       // si no, usa plain/text por defecto
       // ----------------------------------
       if %parms >= 3;
          @Cntt = peCntt;
        else;
          @Cntt = 'T';
       endif;

       // ----------------------------------
       // Acomoda por si mandaron fruta
       // ----------------------------------
       if @Cntt <> 'H' and
          @Cntt <> 'T';
          @Cntt = 'T';
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_CrtBdy()                 '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = '--'
            + %trim(peBndy)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       Data = 'Content-Type: ';
       select;
        when @Cntt = MAIL_CNTH;
           Data += 'text/html'
                 + CRLF;
        when @Cntt = MAIL_CNTT;
           Data += 'text/plain'
                 + CRLF;
       endsl;
       callp write(fd: %addr(Data)+2: %len(Data));

       Data = 'Content-Disposition: inline'
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Body(): Graba mensaje.                         *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_Body       b                    export
     D MAIL_Body       pi            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                     512a   const varying

     D Data            s          65535a   varying
     D @ErrMsg         s            286a   varying
     D fd              s             10i 0
     D encdata         s             10i 0
     D encdatalen      s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Body()                   '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       htmlEncode( %trim(peMsgd)
                 : %len(%trim(peMsgd))
                 : Data
                 : encDataLen         );

       Data = %trim(Data)
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Lbody(): Graba mensaje "largo".                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_Lbody      b                    export
     D MAIL_Lbody      pi            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                    5000a   const

     D Data            s          65535a   varying
     D @ErrMsg         s            286a   varying
     D fd              s             10i 0
     D encdata         s             10i 0
     D encdatalen      s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Lbody()                  '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       htmlEncode( %trim(peMsgd)
                 : %len(%trim(peMsgd))
                 : Data
                 : encDataLen         );

       Data = %trim(Data)
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Bbody(): Graba mensaje "largo".                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     P MAIL_Bbody      B                   export
     D MAIL_Bbody      pi            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                   65535a   const

     D Data            s          65535a   varying
     D @ErrMsg         s            286a   varying
     D fd              s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Bbody()                  '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = %trim(peMsgd)
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P MAIL_Bbody      E

      * --------------------------------------------------- *
      * MAIL_Att(): Genera Attachment (base64).             *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peAttf (input) = Path IFS del archivo a adjuntar. *
      *   peAttn (input) = Nombre para el archivo.          *
      *                    *FILE = Pone nombre del archivo. *
      *   peAtfd (input) = Borrar archivo.                  *
      *                    *YES = Borra el archivo luego de *
      *                           adjuntar.                 *
      *                    *NO  = No borra el archivo.      *
      *                           Este es el valor x default*
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     P MAIL_Att        b                   export
     D MAIL_Att        pi            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peAttf                     255a   const varying
     D   peAttn                     256a   const
     D   peAtfd                       4a   options(*nopass:*omit)

     D @Atfd           s              4a
     D @Attn           s            256a   varying
     D @Size           s             10i 0
     D @MaxSizeAl      s             10i 0
     D @AttSize        s             13a
     D @MaxSizeAlC     s             13a
     D @RplDta         s             26a
     D fd              s             10i 0
     D attFile         s             10i 0
     D Data            s            512a   varying
     D len             s             10i 0
     D enclen          s             10i 0
     D dataatt         s             54a
     D encDataatt      s             74a
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ---------------------------
       // Si llegó "borrar archivo"
       // ---------------------------
       if %parms >= 5 and
          %addr(peAtfd) <> *NULL;
          @Atfd = %trim(peAtfd);
       endif;

       // ---------------------------
       // Acomodo por el tema "fruta"
       // ---------------------------
       if @Atfd <> '*YES' and
          @Atfd <> '*NO';
          @Atfd = '*NO';
       endif;

       // ---------------------------
       // Valido archivo adjunto
       // ---------------------------
       if MAIL_ChkIfsO( %trim(peAttf) ) = NOEXIST;
          SetError( MAIL_E_NOATT
                  : %trim(peAttf) );
          return -1;
       endif;

       // ---------------------------
       // Valido archivo adjunto
       // ---------------------------
       if MAIL_ChkIfsO( %trim(peAttf)
                      : '*R' ) = NOEXIST;
          SetError( MAIL_E_ATTNE
                  : %trim(peAttf) );
          return -1;
       endif;

       // ---------------------------
       // Valido que sea archivo
       // ---------------------------
       if MAIL_IsDir( %trim(peAttf)
                    : @Size ) = ISDIR;
          SetError( MAIL_E_ATTDIR
                  : %trim(peAttf) );
          return -1;
       endif;

       // -------------------------------------
       // Obtengo nombre del archivo
       // -------------------------------------
       if peAttn = '*FILE';
          if MAIL_GetIfsFile( %trim(peAttf)
                            : @Attn ) = -1;
             SetError( MAIL_E_ATTNAM
                     : %trim(peAttf) );
             return -1;
          endif;
        else;
          @Attn = peAttn;
       endif;

       // ----------------------------------
       // Debe haberse enviado un BOUNDARY
       // ----------------------------------
       if %trim(peBndy) = *blanks;
          SetError( MAIL_E_NOATTBD
                  : %trim(peAttf) );
          return -1;
       endif;

       // ----------------------------------
       // Abrir archivo MIME en modo append
       // ----------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Att()                    '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       // ----------------------------------
       // Abrir archivo a adjuntar
       // ----------------------------------
       attFile = open( %trim(peAttf): O_RDONLY );

       if attFile = -1;
          callp close(attFile);
          callp close(fd);
          SetError( MAIL_E_NOATT
                  : %trim(peAttf) );
          return -1;
       endif;

       // ----------------------------------
       // Grabar encabezado
       // ----------------------------------
       Data = CRLF
            + '--'
            + %trim(peBndy)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Type: application/octet-stream'
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Disposition: attachment; filename="'
            + %trim(@Attn)
            + '"'
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Transfer-Encoding: base64'
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       // -------------------------------------
       // Leer adjunto, codificarlo y grabarlo
       // -------------------------------------
       dow '1';
          len = read(attFile: %addr(dataatt): %size(dataatt));
          if len < 1;
             leave;
          endif;

          enclen = apr_base64_encode_binary( encdataatt
                                           : dataatt
                                           : len ) - 1;
          %subst(encdataatt:enclen+1) = CRLF;
          callp write(fd: %addr(encdataatt): enclen+2);
       enddo;

       callp close(attFile);

       // -------------------------------------
       // Si debe eliminarlo
       // -------------------------------------
       if @Atfd = '*YES';
          unlink(%trim(peAttf));
       endif;

       callp close(fd);
       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_Keyw(): Agrega palabras claves personalizadas. *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peKeyw (input) = Nombre de la palabra clave.      *
      *                    "X-aaaaaaa:".                    *
      *   peKeyv (input) = Valor para la palabra clave.     *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     P MAIL_Keyw       b                   export
     D MAIL_Keyw       pi            10i 0
     D   peMime                     256a   const varying
     D   peKeyw                     256a   const varying
     D   peKeyv                     256a   const varying

     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D Data            s            256a

      /free

        if MAIL_Inz() = -1;
           return -1;
        endif;

        // ------------------------------
        // Abre nota MIME en modo Append
        // ------------------------------
        fd = open( %trim(peMime)
                 : O_WRONLY+O_TEXTDATA+O_APPEND);

        if fd = -1;
           callp close(fd);
           @ErrMsg = 'MAIL_Keyw()                   '
                   + %trim(peMime);
           SetError( MAIL_E_NOMIMEX
                   : @ErrMsg );
           return -1;
        endif;

        if %subst(%trim(peKeyw):1:2) <> 'X-';
           callp close(fd);
           SetError( MAIL_E_KEYW
                   : %trim(peKeyw) );
           return -1;
        endif;

        Data = %trimr(peKeyw)
             + ' ' +  %trim(peKeyv)
             + CRLF;
        callp write(fd: %addr(Data): %len(%trim(Data)));
        callp close(fd);

        return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_Send(): Wrapper para la QtmmSendMail.          *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *   peFAdr (input) = Dirección de correo de prFrom    *
      *   peTonm (input) = Nombre destinatario.             *
      *   peToad (input) = Dirección destinatario.          *
      *   peToty (input) = Tipo de destinatario.            *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     P MAIL_Send       b                   export
     D MAIL_Send       pi            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peTonm                      50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)

     D QtmmSendMail    pr                  ExtProc('QtmmSendMail')
     D   FileName                   255a   const options(*varsize)
     D   FileNameLen                 10i 0 const
     D   MsgFrom                    256a   const options(*varsize)
     D   MsgFromLen                  10i 0 const
     D   RecipBuf                          likeds(ADDT00100)
     D                                     dim(100)
     D                                     options(*varsize)
     D   NumRecips                   10i 0 const
     D   ErrorCode                         likeds(QUsec)

     D @ErrMsg         s            286a   varying
     D recip           ds                  likeds(ADDT00100)
     D                                     dim(100)
     D @Qty            s             10i 0
     D @x              s             10i 0
     D @Fadr           s            256a   varying
     D QUsec           ds                  likeds(QUsec_t)

     D/COPY HDIILE/QCPYBOOKS,QUSEC_H

      /free

       select;
         when peFrom = '*SYSTEM';
              @Fadr = %trim(@sysmail);
         when peFrom = '*CURRENT';
              @Fadr = %trim(@rqsmail);
         other;
              @FAdr = %trim(peFadr);
       endsl;

       @Qty = *zeros;
       for @x = 1 to 100;
         if peTonm(@x) = *blanks;
            leave;
         endif;
         recip(@x).NextOffSet  = 280;
         recip(@x).AddrFormat  = 'ADDT0100';
         select;
          when peToty(@x) = 0;
            recip(@x).DistType   = MAIL_NORMAL;
          when peToty(@x) = 1;
            recip(@x).DistType   = MAIL_CC;
          when peToty(@x) = 2;
            recip(@x).DistType   = MAIL_CCO;
         endsl;
         recip(@x).Reserved   = 0;
         recip(@x).SmtpAddr   = peToad(@x);
         recip(@x).AddrLen    = %len(%trimr(peToad(@x)));
         @Qty += 1;
       endfor;

       if @Qty > *zeros;
          QtmmSendMail( peMime
                      : %len(peMime)
                      : @Fadr
                      : %len(%trimr(@Fadr))
                      : recip
                      : @Qty
                      : QUsec );
          if QUsec.MessageID <> *blanks;
             SetError( MAIL_E_QTMM
                     : QUsec.MessageID );
             return -1;
          endif;
       endif;

       // ---------------------------------
       // Si loguea envios
       // ---------------------------------
       if @mailconfr.nfmlog = '1';
          for @x = 1 to @Qty;
              MAIL_Log( peMime
                      : @Fadr
                      : %trim(recip(@x).SmtpAddr)
                      : *zeros );
          endfor;
       endif;

       CLNQSH();

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * SetError(): Setea un número y texto de error.       *
      *                                                     *
      *   peErno = Número de error.                         *
      *                                                     *
      * Retorna *NONE                                       *
      * --------------------------------------------------- *
     P SetError        b
     D SetError        pi                  opdesc
     D   peErno                       4s 0 const
     D   peRpld                   32766a   const
     D                                     options(*nopass:*varsize)

      * -------------------------------------------
      * Ds para QMHRTVM
      * -------------------------------------------
     D RTVM0300        ds                  qualified
     D BytesReturned                 10i 0
     D BytesAvailable                10i 0
     D MsgSeverity                   10i 0
     D AlertIndex                    10i 0
     D AlertOption                    9a
     D LogIndicator                   1a
     D MsgId                          7a
     D Reserved                       3a
     D NbrSubstVars                  10i 0
     D CCSIDConvStsInd...
     D                               10i 0
     D CCSIDConvStsIndRplDta...
     D                               10i 0
     D CCSIDText                     10i 0
     D DftRpyOffSet                  10i 0
     D LenDftRpyRet                  10i 0
     D LenDftRpyAva                  10i 0
     D MsgOffSet                     10i 0
     D LenMsgRet                     10i 0
     D LenMsgAva                     10i 0
     D MsgHlpOffSet                  10i 0
     D LenMsgHlpRet                  10i 0
     D LenMsgHlpAva                  10i 0
     D SubVarOffSet                  10i 0
     D LenSubVarRet                  10i 0
     D LenSubVarAva                  10i 0
     D Reserved2                      1a

     D QUsec           ds                  likeds(QUsec_t)

      * -------------------------------------------
      * Descripción de parámetros
      * -------------------------------------------
     D CEEGSI          pr                  extproc('CEEGSI')
     D  posn                         10i 0 const
     D  datatype                     10i 0
     D  currlen                      10i 0
     D  maxlen                       10i 0

      * -------------------------------------------
      * Recuperar mensaje
      * -------------------------------------------
     D RtvMsg          pr                  extpgm('QMHRTVM')
     D  MsgInfo                    3192a
     D  LenMsgInfo                   10i 0 const
     D  FormatName                    8a   const
     D  MsgId                         7a   const
     D  QualMsgFile                  20a   const
     D  RplData                      10a   const
     D  LenRplData                   10i 0 const
     D  LenSubVars                   10a   const
     D  FmtCtlChars                  10a   const
     D  QUsec                              likeds(QUsec_t)

     D QMHSNDPM        pr                  ExtPgm('QMHSNDPM')
     D  MessageId                     7a   const
     D  QualMsgF                     20a   const
     D  MsgData                   32767a   const options(*varsize)
     D  MsgDtaLen                    10i 0 const
     D  MsgType                      10a   const
     D  CallStkEnt                   10a   const
     D  CallStkCnt                   10i 0 const
     D  MessageKey                    4a
     D  QUsec                              likeds(QUsec_t)

     D @msID           s              7a   varying
     D @Msg            s            132a   based(p_msg)
     D @MsgHlp         s           3000a   based(p_msghlp)
     D p_msg           s               *
     D p_msghlp        s               *
     D @RtvMsg         s          10000a
     D @Key            s              4a
     D peMsg           s            256a

     D @Replace        s              4a
     D @ReplLen        s             10i 0
     D @ReplDta        s            286a
     D datatype        s             10i 0
     D currlen         s             10i 0
     D maxlen          s             10i 0

      /free

       @msID = @mailconfr.nfmsgp
             + %trim(%editc(peErno:'X'));

       @Replace = '*NO';
       @ReplLen = *zeros;
       @ReplDta = *blanks;

       // ---------------------------------
       // Sólo reemplazar si llegan todos
       // ---------------------------------
       if %parms >= 2;
          CEEGSI( 2
                : datatype
                : currlen
                : maxlen );
          @Replace = '*YES';
          @ReplLen = currlen;
          @ReplDta = %subst(peRpld:1:currlen);
       endif;

       QUsec.BytesProvided = %size(QUsec);
       RtvMsg( @RtvMsg
             : 10000
             : 'RTVM0300'
             : @msID
             : @mailconfr.nfmsgf
             : @ReplDta
             : @ReplLen
             : @Replace
             : '*NO'
             : QUsec );

       RTVM0300 = @RtvMsg;

       // ------------------------------------------------
	      // Direcciona memoria a los mensajes de cada nivel
	      // ------------------------------------------------
       p_Msg    = %addr(@RtvMsg) + RTVM0300.MsgOffSet;
       p_MsgHlp = %addr(@RtvMsg) + RTVM0300.MsgHlpOffSet;

       // ------------------------------------------------
       // Carga estructura de datos global de error.
       // Llamar a MAIL_Error() para recuperar esta DS en
       // caso de necesitar mostrar/loguear/saber el mensa-
	      // je de error.
       // ------------------------------------------------	
       ErrorData.MAIL_Emid = %dec(%subst(@msId:4:4):4:0);
       ErrorData.MAIL_Eml1 = %subst(@Msg:1:RTVM0300.LenMsgRet);
       ErrorData.MAIL_Eml2 = %subst(@MsgHlp:1:RTVM0300.LenMsgHlpRet);

       peMsg = 'MAIL_SetError(): '
             + %trim(@msId)
             + ' - '
             + %trim(ErrorData.MAIL_Eml1);

       QMHSNDPM( 'CPF9897'
               : 'QCPFMSG   *LIBL     '
               : peMsg
               : %len(%trimr(peMsg))
               : '*DIAG'
               : '*'
               : 1
               : @key
               : QUsec              );

       return;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_Error():  Retorna la descripción del último    *
      *                  error del programa.                *
      *                                                     *
      * Retorna útlimo error.                               *
      * --------------------------------------------------- *
     P MAIL_Error      b                   export
     D MAIL_Error      pi                  likeds(MAIL_ERDS_T)
      /free

       return ErrorData;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_IsValid(): Determina si una dirección es valida*
      *                 o no.                               *
      *                                                     *
      *   peAddr = Dirección de mail.                       *
      *                                                     *
      * Retorna *on si es válida, *off si no.               *
      * --------------------------------------------------- *
     P MAIL_IsValid    b                   export
     D MAIL_IsValid    pi             1N
     D   peAddr                     256a   const varying

     D/copy HDIILE/QCPYBOOKS,REGEX_H

     D pattern         s             69a   varying
     D reg             ds                  likeds(regex_t)
     D match           ds                  likeds(regmatch_t)
     D rc              s             10i 0

      /free

       if MAIL_Inz() = -1;
          return NOTVALID;
       endif;

       // ----------------------------------
       // Si el mail es blancos, ni siquiera
       // compilo la expresión regular
       // ----------------------------------
       if %trim(peAddr) = *blanks;
          return NOTVALID;
       endif;

       // ----------------------------------
       // Ñ o ñ no permitidas
       // ----------------------------------
       if %scan('Ñ':peAddr) > *zeros or
          %scan('ñ':peAddr) > *zeros;
              return NOTVALID;
       endif;

       // ----------------------------------
       // Compilar Expresión regular
       // ----------------------------------
          pattern = '^[_a-z0-9-]+(\.[_a-z0-9-]+)'
                  + '*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$';
          if regcomp( reg
                    : pattern
                    : REG_EXTENDED + REG_ICASE + REG_NOSUB) <> *zeros;
             regfree(reg);
             return NOTVALID;
          endif;

       // ----------------------------------
       // Validar mail
       // ----------------------------------
       if regexec( reg
                 : %trim(peAddr)
                 : 0
                 : match
                 : 0) = *zeros;
          regfree(reg);
          return VALID;
        else;
          regfree(reg);
          return NOTVALID;
       endif;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_ChkIfsO(): Chequea existencia de objeto en el  *
      *                 IFS.                                *
      *                                                     *
      *   peIfso (input)  = Objeto a chequear.              *
      *                     "/home/.../.../xxx.eee"         *
      *   peIfsa (input)  = Tipo de Chequeo:                *
      *                     *NONE: Existencia (default)     *
      *                     *R   : Read                     *
      *                     *RW  : Read/Write               *
      *                     *RX  : Read/Execute             *
      *                     *RWX : Read/Write/Execute       *
      *                     *W   : Write                    *
      *                     *WX  : Write/Execute            *
      *                     *X   : Execute                  *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     P MAIL_ChkIfsO    b                   export
     D MAIL_ChkIfsO    pi             1N
     D   peIfso                     256a   const varying
     D   peIfsa                       5a   const options(*nopass)

     D @Ifsa           s              5a
     D Amode           s             10i 0

      /free

       if MAIL_Inz() = -1;
          return NOEXIST;
       endif;

       // --------------------------------
       // Tipo de autorización solicitada
       // --------------------------------
       if %parms >= 2 and
          %addr(peIfsa) <> *NULL;
          @Ifsa = %trim(peIfsa);
        else;
          @Ifsa = '*NONE';
       endif;

       // --------------------------------
       // Si no mandó las validas, pone
       // *NONE (sólo check existencia)
       // --------------------------------
       if %trim(@Ifsa) <> '*NONE' and
          %trim(@Ifsa) <> '*R'    and
          %trim(@Ifsa) <> '*RW'   and
          %trim(@Ifsa) <> '*RX'   and
          %trim(@Ifsa) <> '*RWX'  and
          %trim(@Ifsa) <> '*W'    and
          %trim(@Ifsa) <> '*WX'   and
          %trim(@Ifsa) <> '*X';

            @Ifsa = '*NONE';

       endif;

       // ----------------------------------
       // Chequear siempre si objeto existe
       // ----------------------------------
       if access(%trimr(peIfso): F_OK) < 0;
          return NOEXIST;
       endif;

       // ------------------------------------
       // Chequear autorizaciones especificas
       // ------------------------------------
       if @Ifsa <> '*NONE';
          Amode = *zeros;
          // ---------------------------------
          // Autorización de Read
          // ---------------------------------
          if %scan('R':@Ifsa) > 0;
             Amode += R_OK;
          endif;
          // ----------------------------------
          // Autorización de Write
          // ----------------------------------
          if %scan('W':@Ifsa) > 0;
             Amode += W_OK;
          endif;
          // ----------------------------------
          // Autorización de Ejecución
          // ----------------------------------
          if %scan('X':@Ifsa) > 0;
             Amode += X_OK;
          endif;
          if access(%trimr(peIfso): Amode) < 0;
             return NOEXIST;
          endif;
       endif;

       return EXIST;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_IsDir(): Chequea si un objeto IFS es un directo*
      *               rio o es un archivo.                  *
      *                                                     *
      *   peIfso (input)  = Objeto a chequear.              *
      *                     "/home/.../.../xxx.eee"         *
      *   peSize (output) = Tamaño de peIfso si no es DIR.  *
      *                                                     *
      * Retorna *on si es DIR, *off si no.                  *
      * --------------------------------------------------- *
     P MAIL_IsDir      b                   export
     D MAIL_IsDir      pi             1N
     D   peIfso                     256a   const varying
     D   peSize                      10i 0 options(*nopass)

     D mystat          DS                  likeDS(statds)
     D p_statds        s               *

     D                 ds
     D dirmode                 1      4u 0
     D byte1                   1      1a
     D byte2                   2      2a
     D byte3                   3      3a
     D byte4                   4      4a

      /free

       if MAIL_Inz() = -1;
          return NOTDIR;
       endif;

       if %parms >= 2;
          peSize = *zeros;
       endif;

       // -----------------------------------
       // Recuperar detalles del objeto IFS
       // -----------------------------------
       p_statds = %addr(mystat);
       if stat(peIfso: %addr(mystat)) <> 0;
          return NOTDIR;
       endif;

       // -----------------------------------
       // Controlar si es o no directorio
       // -----------------------------------
       dirmode = mystat.st_mode;

       byte1 = %bitand(byte1:%bitnot(x'FF'));
       byte2 = %bitand(byte2:%bitnot(x'FE'));
       byte3 = %bitand(byte3:%bitnot(x'0F'));
       byte4 = %bitand(byte4:%bitnot(x'FF'));

       if dirmode = 16384;
          return ISDIR;
         else;
          if %parms >= 2;
             peSize = mystat.st_size;
          endif;
          return NOTDIR;
       endif;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_ChkObj(): Chequea existencia de objeto.        *
      *                                                     *
      *   peObjn (input)  = Objeto a chequear.              *
      *   peObjl (input)  = Biblioteca. Valores especiales: *
      *                     *LIBL (default)                 *
      *                     *CURLIB                         *
      *   peObjt (input)  = Tipo de Objeto.                 *
      *   peObjm (input)  = Miembro (en caso de archivo)    *
      *                     *FIRST                          *
      *                     *LAST                           *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     P MAIL_ChkObj     b                   export
     D MAIL_ChkObj     pi             1N
     D   peObjn                      10a   const
     D   peObjl                      10a   const
     D   peObjt                      10a   const
     D   peObjm                      10a   const options(*nopass)

      * ---------------------------------------
      * QUSROBJD
      * ---------------------------------------
     D RtvObjD         pr                  extpgm('QUSROBJD')
     D  RcvVar                      108a   options(*varsize)
     D  RcvVarLen                    10i 0 const
     D  FormatName                    8a   const
     D  Object                             likeds(ObjectDS)
     D  ObjType                      10a
     D  QUsec                              likeds(QUsec_t)

      * ---------------------------------------
      * QUSRMBRD
      * ---------------------------------------
     D RtvMbrD         pr                  extpgm('QUSRMBRD')
     D  RcvVar                      147a   options(*varsize)
     D  RcvVarLen                    10i 0 const
     D  FormatName                    8a   const
     D  DBFile                             likeds(DBFileDS)
     D  DBMember                     10a
     D  Ovr                           1a   const
     D  QUsec                              likeds(QUsec_t)

     D QUsec           ds                  likeds(QUsec_t)

      * ---------------------------------------
      * Objeto calificado
      * ---------------------------------------
     D ObjectDS        ds                  likeds(QualObjName_t)

      * ---------------------------------------
      * Archvio calificado
      * ---------------------------------------
     D DBFileDS        ds                  likeds(QualDBName_t)

     D @ObjType        s             10a
     D @FileMbr        s             10a
     D @RcvVar         s            108a
     D @RcvVar2        s            147a

      /free

       if MAIL_Inz() = -1;
          return NOEXIST;
       endif;

       ObjectDS.ObjName = %trim(peObjn);
       ObjectDS.ObjLibr = %trim(peObjl);

       // ----------------------------------
       // Si llegó miembro, primero chequeo
       // archivo
       // ----------------------------------
       QUsec.BytesProvided = %size(QUsec);
       if %parms >= 4;
          @ObjType = '*FILE';
          @FileMbr = %trim(peObjm);
          RtvObjD( @RcvVar
                 : %size(@RcvVar)
                 : 'OBJD0100'
                 : ObjectDS
                 : @ObjType
                 : QUsec );
          if QUsec.MessageID <> *blanks;
             return NOEXIST;
          endif;
          // ----------------------------------
          // Chequea existencia del miembro
          // ----------------------------------
          QUsec.BytesProvided   = %size(QUsec);
          QUsec.BytesAvailables = *zeros;
          QUsec.MessageID       = *blanks;
          DBFileDS.DBFile       = %trim(peObjn);
          DBFileDS.DBFileLib    = %trim(peObjl);
          RtvMbrD( @RcvVar2
                 : %size(@RcvVar2)
                 : 'MBRD0100'
                 : DBFileDS
                 : @FileMbr
                 : '0'
                 : QUsec );
          if QUsec.MessageID <> *blanks;
             return NOEXIST;
           else;
             return EXIST;
          endif;
       endif;

       // ----------------------------------
       // Si no llegó miembro, usa parms
       // ----------------------------------
       @ObjType            = %trim(peObjt);
       QUsec.BytesProvided = %size(QUsec);
       RtvObjD( @RcvVar
              : %size(@RcvVar)
              : 'OBJD0100'
              : ObjectDS
              : @ObjType
              : QUsec );
       if QUsec.MessageID <> *blanks;
          return NOEXIST;
        else;
          return EXIST;
       endif;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_ChkSplf(): Chequear existencia de Splf.        *
      *                                                     *
      *   peJobn (input)  = Nombre del trabajo del spool.   *
      *   peJobU (input)  = Usuario del trabajo del spool.  *
      *   peJobr (input)  = Número de trabajo del spool.    *
      *   peSplf (input)  = Nombre del spool.               *
      *   peSplN (input)  = Número del spool:               *
      *                     0001-9999                       *
      *                     *ZEROS = *ONLY (default)        *
      *                     -1     = *LAST                  *
      *   peStat (input)  = Status.                         *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     P MAIL_ChkSplf    b                   export
     D MAIL_ChkSplf    pi             1N
     D   peJobn                      10a   const
     D   peJobU                      10a   const
     D   peJobr                       6a   const
     D   peSplf                      10a   const
     D   peSplN                      10i 0 const options(*nopass)
     D   peStat                      10a   options(*nopass:*omit)

      * ---------------------------------------
      * QUSRSPLA
      * ---------------------------------------
     D RtvSplfA        pr                  extpgm('QUSRSPLA')
     D  RcvVar                      128a   options(*varsize)
     D  RcvVarLen                    10i 0 const
     D  RcvVarFmt                     8a   const
     D  QualJobName                        likeds(QualJobName)
     D  IntJobId                     16a   const
     D  IntSplfId                    16a   const
     D  SplfName                     10a   const
     D  SplfNbr                      10i 0 const
     D  QUsec                              likeds(QUsec_t)

     D QUsec           ds                  likeds(QUsec_t)

     D QualJobName     ds                  likeds(QualJobName_t)

     D SPLA0100        ds                  qualified
     D  BytesRet                     10i 0
     D  BytesAva                     10i 0
     D  IntJobId                     16a
     D  IntSplId                     16a
     D  JobName                      10a
     D  UsrName                      10a
     D  JobNumber                     6a
     D  SplFName                     10a
     D  SplFNumber                   10i 0
     D  FormType                     10a
     D  UsrData                      10a
     D  Status                       10a

     D @SplN           s             10i 0
     D @RcvVar         s            128a

      /free

       if MAIL_Inz() = -1;
          return NOEXIST;
       endif;

       // -----------------------------
       // Si el número llegó, usarlo
       // -----------------------------
       if %parms >= 5;
          @SplN = peSplN;
        else;
          @SplN = *zeros;
       endif;

       // -----------------------------
       // Acomodar por si llegó frutita
       // -----------------------------
       if @SplN < -1 or
          @SplN > 9999;
          @SplN = *zeros;
       endif;

       QualJobName.JobName = %trim(peJobn);
       QualJobName.JobUser = %trim(peJobU);
       QualJobName.JobNbr  = %trim(peJobr);

       QUsec.BytesProvided = %size(QUsec);
       RtvSplfA( @RcvVar
               : 128
               : 'SPLA0100'
               : QualJobName
               : *blanks
               : *blanks
               : %trim(peSplf)
               : @SplN
               : QUsec );

       SPLA0100 = @RcvVar;

       if QUsec.MessageID <> *blanks;
          return NOEXIST;
        else;
          if %parms >= 6 and
             %addr(peStat) <> *NULL;
             peStat = SPLA0100.Status;
          endif;
          return EXIST;
       endif;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_ClsBndy(): Cierra Boundary.                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     P MAIL_ClsBndy    b                   export
     D MAIL_ClsBndy    pi            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a

     D Data            s            512a   varying
     D @ErrMsg         s            286a   varying
     D fd              s             10i 0

      /free

        if MAIL_Inz() = -1;
           return -1;
        endif;

        // --------------------------------
        // Si el Boundary es blanco, error
        // --------------------------------
        if %trim(peBndy) = *blanks;
           SetError( MAIL_E_BLKBNDY );
           return -1;
        endif;

        // ------------------------------
        // Abre nota MIME en modo Append
        // ------------------------------
        fd = open( %trim(peMime)
                 : O_WRONLY+O_TEXTDATA+O_APPEND);

        if fd = -1;
           callp close(fd);
           @ErrMsg = 'MAIL_ClsBndy()                '
                   + %trim(peMime);
           SetError( MAIL_E_NOMIMEX
                   : @ErrMsg );
           return -1;
        endif;

        Data = '--'
             + %trim(peBndy)
             + '--';
        callp write(fd: %addr(Data)+2: %len(Data));
        callp close(fd);
        return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_SplfNam(): Obtiene nombre de pdf para un spool.*
      *                                                     *
      *   peSplf (input) = Archivo Spool a buscar.          *
      *                                                     *
      * Retorna nombre encontrado o nombre spool + '.pdf'   *
      * --------------------------------------------------- *
     P MAIL_SplfNam    b                   export
     D MAIL_SplfNam    pi           256a
     D   peSplf                      10a   const

     D retfld          s            256a
     D @ret            s            256a   varying

      /free

          open splfcfg;
          chain peSplf splfcfg;
          if %found;
             retfld = fgspld;
           else;
             @ret   = %trim(peSplf)
                    + '.pdf';
             retfld = %trim(@ret);
          endif;

          close splfcfg;

          return retfld;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_SndEmail(): Procedimiento wrapper para los     *
      *                  demás procedimientos.              *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *   peAttn (input)  = Nombres de los adjuntos.        *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndEmail   b                   export
     D MAIL_SndEmail   pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)
     D   peAttn                     256a   dim(10) options(*nopass:*omit)

      * -----------------------------------
      * Generar nombre temporal en el IFS
      * -----------------------------------
     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

     D @mimeNote       s            256a   varying
     D @res            s             10i 0
     D @Impo           s             10i 0
     D @Sens           s             10i 0
     D @Prio           s             10i 0
     D @x              s             10i 0
     D @Attd           s              4a
     D @Zip            s              4a
     D @Zipn           s             50a
     D @attFileName    s            255a   varying
     D @Bndy           s             36a
     D @Subj           s             84a
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Attf           s            255a   dim(10)
     D @y              s             10i 0
     D @z              s             10i 0
     D @cmd            s           5000a
     D @q              s             10i 0
     D @cFile          s            256a   varying
     D @TotSiz         s             10i 0
     D @Size           s             10i 0
     D @Notf           s              4a
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @Toty           s             10i 0 dim(100)
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D @attn           s            256a   dim(10)
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       @attn(*) = '*FILE';

       // ------------------------------
       // Importancia
       // ------------------------------
       if %parms >= 10 and
          %addr(peImpo) <> *NULL;
           @Impo = peImpo;
           if @Impo < *zeros or
              @Impo > 2;
              @Impo = *zeros;
           endif;
        else;
           @Impo = *zeros;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if %parms >= 11 and
          %addr(peSens) <> *NULL;
           @Sens = peSens;
           if @Sens < *zeros or
              @Sens > 3;
              @Sens = *zeros;
           endif;
        else;
           @Sens = *zeros;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if %parms >= 12 and
          %addr(pePrio) <> *NULL;
           @Prio = pePrio;
           if @Prio < *zeros or
              @Prio > 3;
              @Prio = *zeros;
           endif;
        else;
           @Prio = *zeros;
       endif;

       // ------------------------------
       // Si no llegó delete
       // ------------------------------
       if (%parms < 14) or
          (%parms >= 14 and %addr(peAttd) = *NULL);
              @Attd = '*NO';
        else;
              @Attd = peAttd;
       endif;

       if @Attd <> '*YES' and
          @Attd <> '*NO';
          @Attd = '*NO';
       endif;

       // ------------------------------
       // Zipear si o no?
       // ------------------------------
       if %parms >= 15 and
          %addr(peZip) <> *NULL;
            @Zip = peZip;
       endif;

       if @Zip <> '*YES' and
          @Zip <> '*NO';
            @Zip = '*NO';
       endif;

       // ------------------------------
       // Nombre zip
       // ------------------------------
       if %parms >= 16 and
          %addr(peZipn) <> *NULL;
            @Zipn = %trim(peZipn);
       endif;
       if @Zipn = *blanks;
          @Zipn = 'Files.zip';
       endif;

       // ------------------------------
       // Acuse de recibo/lectura
       // ------------------------------
       if %parms >= 17 and
          %addr(peNotf) <> *NULL;
            @Notf = %trim(peNotf);
       endif;
       if @Notf <> '*YES' and
          @Notf <> '*NO';
            @Notf = '*YES';
       endif;

       // ------------------------------
       // Nombres de los adjuntos
       // ------------------------------
       if %parms >= 18 and
          %addr(peAttn) <> *NULL;
          @Attn = peAttn;
       endif;

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       if @Sens = 3;
          @Subj = %trim(@mailconfr.nfcwor)
                + %trim(peSubj);
        else;
          @Subj = %trim(peSubj);
       endif;
       if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndEmail()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            close gntmkw;
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       @From = %trim(peFrom);
       @Fadr = %trim(peFadr);

       if %parms >= 9 and
          %addr(peRply) <> *NULL;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : %trim(peRply) );
        else;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : *omit );
       endif;
       if (@res = -1);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Notificación
       // -----------------------------------
       if @Notf = '*YES';
          if MAIL_Notif( @mimeNote
                       : @Fadr ) = -1;
             unlink(@mimeNote);
             return -1;
          endif;
       endif;

       // -----------------------------------
       // Importancia
       // -----------------------------------
       if MAIL_Importance( @mimeNote
                         : @Impo ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Sensibilidad
       // -----------------------------------
       if MAIL_MSens( @mimeNote
                    : @Sens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Prioridad
       // -----------------------------------
       if MAIL_Priority( @mimeNote
                       : @Prio ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : %trim(peCntt) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo mensaje
       // -----------------------------------
       if MAIL_Body( @mimeNote
                   : peMens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Autofirma
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : peCntt ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjuntar archivos si corresponde
       // -----------------------------------
       @y   = *zeros;
       @TotSiz = *zeros;
       if %parms >= 13 and
          %addr(peAttf) <> *NULL;
          // -----------------------------------
          // Crear directorio de trabajo
          // -----------------------------------
          @cmd = 'QSH CMD('
               + ''''
               + 'mkdir '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          // -------------------------------------
          // Limpio array y dejo sólo existentes
          // -------------------------------------
          for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 if MAIL_GetIfsFIle( peAttf(@x)
                                   : @cFile ) = *zeros;
                    @y += 1;
                    @Attf(@y) = %trim(@wdir)
                              + '/'
                              + %trim(@cFile);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'cp "'
                         + %trim(peAttf(@x))
                         + '" "'
                         + %trim(@Attf(@y))
                         + '"'
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'chmod go+rxw "'
                         + %trim(@Attf(@y))
                         + '"'
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    if MAIL_IsDir( %trim(@Attf(@y))
                                 : @Size ) = NOTDIR;
                       @TotSiz += @Size;
                    endif;
                 endif;
              endif;
          endfor;
       endif;

       // ---------------------------------
       // Si debe zipear
       // ---------------------------------
       if @y <> *zeros;
          if @Zip = '*YES';
             @cmd = 'QSH CMD('
                  + ''''
                  + 'cd '
                  + %trim(@wdir)
                  + '; jar cfM '
                  + %trim(@Zipn)
                  + ' *.*'
                  + ''''
                  + ')';
             MAIL_doCmd(@cmd);
             @y = 1;
             @Attf(1) = %trim(@wdir)
                      + '/'
                      + %trim(@Zipn);
             if MAIL_IsDir( %trim(@Attf(1))
                          : @TotSiz ) = NOTDIR;
             endif;
          endif;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_Sndemail()' );
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       if @y <> *zeros;
          for @x = 1 to @y;
              if MAIL_Att( @mimeNote
                         : @Bndy
                         : @Attf(@x)
                         : @Attn(@x) ) = -1;
                 unlink(@mimenote);
                 @cmd = 'QSH CMD('
                      + ''''
                      + 'cd ..; rm -R '
                      + %trim(@wdir)
                      + ''''
                      + ')';
                 MAIL_doCmd(@cmd);
                 return -1;
              endif;
          endfor;
       endif;

         @cmd = 'QSH CMD('
              + ''''
              + 'cd ..; rm -R '
              + %trim(@wdir)
              + ''''
              + ')';
         MAIL_doCmd(@cmd);

       if MAIL_ClsBndy( @mimeNote
                      : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @Toad(@z) = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       if MAIL_Send( @mimeNote
                   : @From
                   : @Fadr
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       if @y > *zeros;
          if @Attd = '*YES';
             for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 unlink(%trim(peAttf(@x)));
              endif;
             endfor;
          endif;
       endif;

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_SndLmail(): Envia correo con mensaje "largo"   *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *   peSub2 (input)  = Asunto largo.                   *
      *   peAttn (input)  = Nombres de los adjuntos.        *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndLmail   b                   export
     D MAIL_SndLmail   pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                    5000a   const
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)
     D   peSub2                     270a   const varying
     D                                     options(*nopass:*omit)
     D   peAttn                     256a   dim(10) options(*nopass:*omit)
      * -----------------------------------
      * Generar nombre temporal en el IFS
      * -----------------------------------
     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

     D @mimeNote       s            256a   varying
     D @res            s             10i 0
     D @Impo           s             10i 0
     D @Sens           s             10i 0
     D @Prio           s             10i 0
     D @x              s             10i 0
     D @Attd           s              4a
     D @Zip            s              4a
     D @Zipn           s             50a
     D @attFileName    s            255a   varying
     D @Bndy           s             36a
     D @Subj           s             84a
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Attf           s            255a   dim(10)
     D @y              s             10i 0
     D @z              s             10i 0
     D @cmd            s           5000a
     D @q              s             10i 0
     D @cFile          s            256a   varying
     D @TotSiz         s             10i 0
     D @Size           s             10i 0
     D @Notf           s              4a
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @Toty           s             10i 0 dim(100)
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D @attn           s            256a   dim(10)
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       @attn(*) = '*FILE';

       // ------------------------------
       // Importancia
       // ------------------------------
       if %parms >= 10 and
          %addr(peImpo) <> *NULL;
           @Impo = peImpo;
           if @Impo < *zeros or
              @Impo > 2;
              @Impo = *zeros;
           endif;
        else;
           @Impo = *zeros;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if %parms >= 11 and
          %addr(peSens) <> *NULL;
           @Sens = peSens;
           if @Sens < *zeros or
              @Sens > 3;
              @Sens = *zeros;
           endif;
        else;
           @Sens = *zeros;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if %parms >= 12 and
          %addr(pePrio) <> *NULL;
           @Prio = pePrio;
           if @Prio < *zeros or
              @Prio > 3;
              @Prio = *zeros;
           endif;
        else;
           @Prio = *zeros;
       endif;

       // ------------------------------
       // Si no llegó delete
       // ------------------------------
       if (%parms < 14) or
          (%parms >= 14 and %addr(peAttd) = *NULL);
              @Attd = '*NO';
        else;
              @Attd = peAttd;
       endif;

       if @Attd <> '*YES' and
          @Attd <> '*NO';
          @Attd = '*NO';
       endif;

       // ------------------------------
       // Zipear si o no?
       // ------------------------------
       if %parms >= 15 and
          %addr(peZip) <> *NULL;
            @Zip = peZip;
       endif;

       if @Zip <> '*YES' and
          @Zip <> '*NO';
            @Zip = '*NO';
       endif;

       // ------------------------------
       // Nombre zip
       // ------------------------------
       if %parms >= 16 and
          %addr(peZipn) <> *NULL;
            @Zipn = %trim(peZipn);
       endif;
       if @Zipn = *blanks;
          @Zipn = 'Files.zip';
       endif;

       // ------------------------------
       // Acuse de recibo/lectura
       // ------------------------------
       if %parms >= 17 and
          %addr(peNotf) <> *NULL;
            @Notf = %trim(peNotf);
       endif;
       if @Notf <> '*YES' and
          @Notf <> '*NO';
            @Notf = '*YES';
       endif;

       // ------------------------------
       // Nombres de los adjuntos
       // ------------------------------
       if %parms >= 19 and
          %addr(peAttn) <> *NULL;
          @Attn = peAttn;
       endif;

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       if @Sens = 3;
          @Subj = %trim(@mailconfr.nfcwor)
                + %trim(peSubj);
        else;
          @Subj = %trim(peSubj);
       endif;
       if %parms >= 18 and %addr(peSub2) <> *null;
         if MAIL_LSubject( @mimeNote
                        : %trim(peSub2) ) = -1;
            unlink(@mimeNote);
            return -1;
         endif;
       else;
         if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          unlink(@mimeNote);
          return -1;
         endif;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndEmail()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       @From = %trim(peFrom);
       @Fadr = %trim(peFadr);

       if %parms >= 9 and
          %addr(peRply) <> *NULL;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : %trim(peRply) );
        else;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : *omit );
       endif;
       if (@res = -1);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Notificación
       // -----------------------------------
       if @Notf = '*YES';
          if MAIL_Notif( @mimeNote
                       : @Fadr ) = -1;
             unlink(@mimeNote);
             return -1;
          endif;
       endif;

       // -----------------------------------
       // Importancia
       // -----------------------------------
       if MAIL_Importance( @mimeNote
                         : @Impo ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Sensibilidad
       // -----------------------------------
       if MAIL_MSens( @mimeNote
                    : @Sens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Prioridad
       // -----------------------------------
       if MAIL_Priority( @mimeNote
                       : @Prio ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : %trim(peCntt) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo mensaje
       // -----------------------------------
       if MAIL_Lbody( @mimeNote
                    : peMens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Autofirma
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : peCntt ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjuntar archivos si corresponde
       // -----------------------------------
       @y   = *zeros;
       @TotSiz = *zeros;
       if %parms >= 13 and
          %addr(peAttf) <> *NULL;
          // -----------------------------------
          // Crear directorio de trabajo
          // -----------------------------------
          @cmd = 'QSH CMD('
               + ''''
               + 'mkdir '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          // -------------------------------------
          // Limpio array y dejo sólo existentes
          // -------------------------------------
          for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 if MAIL_GetIfsFIle( peAttf(@x)
                                   : @cFile ) = *zeros;
                    @y += 1;
                    @Attf(@y) = %trim(@wdir)
                              + '/'
                              + %trim(@cFile);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'cp '
                         + %trim(peAttf(@x))
                         + ' '
                         + %trim(@Attf(@y))
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'chmod go+rxw '
                         + %trim(@Attf(@y))
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    if MAIL_IsDir( %trim(@Attf(@y))
                                 : @Size ) = NOTDIR;
                       @TotSiz += @Size;
                    endif;
                 endif;
              endif;
          endfor;
       endif;

       // ---------------------------------
       // Si debe zipear
       // ---------------------------------
       if @y <> *zeros;
          if @Zip = '*YES';
             @cmd = 'QSH CMD('
                  + ''''
                  + 'cd '
                  + %trim(@wdir)
                  + '; jar cfM '
                  + %trim(@Zipn)
                  + ' *.*'
                  + ''''
                  + ')';
             MAIL_doCmd(@cmd);
             @y = 1;
             @Attf(1) = %trim(@wdir)
                      + '/'
                      + %trim(@Zipn);
             if MAIL_IsDir( %trim(@Attf(1))
                          : @TotSiz ) = NOTDIR;
             endif;
          endif;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_Sndemail()' );
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       if @y <> *zeros;
          for @x = 1 to @y;
              if MAIL_Att( @mimeNote
                         : @Bndy
                         : @Attf(@x)
                         : @Attn(@x) ) = -1;
                 unlink(@mimenote);
                 @cmd = 'QSH CMD('
                      + ''''
                      + 'cd ..; rm -R '
                      + %trim(@wdir)
                      + ''''
                      + ')';
                 MAIL_doCmd(@cmd);
                 return -1;
              endif;
          endfor;
       endif;

       @cmd = 'QSH CMD('
            + ''''
            + 'cd ..; rm -R '
            + %trim(@wdir)
            + ''''
            + ')';
       MAIL_doCmd(@cmd);

       if MAIL_ClsBndy( @mimeNote
                      : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @Toad(@z) = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       if MAIL_Send( @mimeNote
                   : @From
                   : @Fadr
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       if @y > *zeros;
          if @Attd = '*YES';
             for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 unlink(%trim(peAttf(@x)));
              endif;
             endfor;
          endif;
       endif;

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_SndBmail(): Envia correo con mensaje "largo"   *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndBmail   B                   export
     D MAIL_SndBmail   pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                   65535a   const
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)
      * -----------------------------------
      * Generar nombre temporal en el IFS
      * -----------------------------------
     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

     D @mimeNote       s            256a   varying
     D @res            s             10i 0
     D @Impo           s             10i 0
     D @Sens           s             10i 0
     D @Prio           s             10i 0
     D @x              s             10i 0
     D @Attd           s              4a
     D @Zip            s              4a
     D @Zipn           s             50a
     D @attFileName    s            255a   varying
     D @Bndy           s             36a
     D @Subj           s             84a
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Attf           s            255a   dim(10)
     D @y              s             10i 0
     D @z              s             10i 0
     D @cmd            s          65535a
     D @q              s             10i 0
     D @cFile          s            256a   varying
     D @TotSiz         s             10i 0
     D @Size           s             10i 0
     D @Notf           s              4a
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @Toty           s             10i 0 dim(100)
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Importancia
       // ------------------------------
       if %parms >= 10 and
          %addr(peImpo) <> *NULL;
           @Impo = peImpo;
           if @Impo < *zeros or
              @Impo > 2;
              @Impo = *zeros;
           endif;
        else;
           @Impo = *zeros;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if %parms >= 11 and
          %addr(peSens) <> *NULL;
           @Sens = peSens;
           if @Sens < *zeros or
              @Sens > 3;
              @Sens = *zeros;
           endif;
        else;
           @Sens = *zeros;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if %parms >= 12 and
          %addr(pePrio) <> *NULL;
           @Prio = pePrio;
           if @Prio < *zeros or
              @Prio > 3;
              @Prio = *zeros;
           endif;
        else;
           @Prio = *zeros;
       endif;

       // ------------------------------
       // Si no llegó delete
       // ------------------------------
       if (%parms < 14) or
          (%parms >= 14 and %addr(peAttd) = *NULL);
              @Attd = '*NO';
        else;
              @Attd = peAttd;
       endif;

       if @Attd <> '*YES' and
          @Attd <> '*NO';
          @Attd = '*NO';
       endif;

       // ------------------------------
       // Zipear si o no?
       // ------------------------------
       if %parms >= 15 and
          %addr(peZip) <> *NULL;
            @Zip = peZip;
       endif;

       if @Zip <> '*YES' and
          @Zip <> '*NO';
            @Zip = '*NO';
       endif;

       // ------------------------------
       // Nombre zip
       // ------------------------------
       if %parms >= 16 and
          %addr(peZipn) <> *NULL;
            @Zipn = %trim(peZipn);
       endif;
       if @Zipn = *blanks;
          @Zipn = 'Files.zip';
       endif;

       // ------------------------------
       // Acuse de recibo/lectura
       // ------------------------------
       if %parms >= 17 and
          %addr(peNotf) <> *NULL;
            @Notf = %trim(peNotf);
       endif;
       if @Notf <> '*YES' and
          @Notf <> '*NO';
            @Notf = '*YES';
       endif;

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       if @Sens = 3;
          @Subj = %trim(@mailconfr.nfcwor)
                + %trim(peSubj);
        else;
          @Subj = %trim(peSubj);
       endif;
       if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndEmail()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       @From = %trim(peFrom);
       @Fadr = %trim(peFadr);

       if %parms >= 9 and
          %addr(peRply) <> *NULL;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : %trim(peRply) );
        else;
            @res = MAIL_From( @mimeNote
                            : %trim(@From)
                            : %trim(@Fadr)
                            : *omit );
       endif;
       if (@res = -1);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Notificación
       // -----------------------------------
       if @Notf = '*YES';
          if MAIL_Notif( @mimeNote
                       : @Fadr ) = -1;
             unlink(@mimeNote);
             return -1;
          endif;
       endif;

       // -----------------------------------
       // Importancia
       // -----------------------------------
       if MAIL_Importance( @mimeNote
                         : @Impo ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Sensibilidad
       // -----------------------------------
       if MAIL_MSens( @mimeNote
                    : @Sens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Prioridad
       // -----------------------------------
       if MAIL_Priority( @mimeNote
                       : @Prio ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : %trim(peCntt) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo mensaje
       // -----------------------------------
       if MAIL_Bbody( @mimeNote
                    : peMens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Autofirma
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : peCntt ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjuntar archivos si corresponde
       // -----------------------------------
       @y   = *zeros;
       @TotSiz = *zeros;
       if %parms >= 13 and
          %addr(peAttf) <> *NULL;
          // -----------------------------------
          // Crear directorio de trabajo
          // -----------------------------------
          @cmd = 'QSH CMD('
               + ''''
               + 'mkdir '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          // -------------------------------------
          // Limpio array y dejo sólo existentes
          // -------------------------------------
          for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 if MAIL_GetIfsFIle( peAttf(@x)
                                   : @cFile ) = *zeros;
                    @y += 1;
                    @Attf(@y) = %trim(@wdir)
                              + '/'
                              + %trim(@cFile);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'cp '
                         + %trim(peAttf(@x))
                         + ' '
                         + %trim(@Attf(@y))
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    @cmd = 'QSH CMD('
                         + ''''
                         + 'chmod go+rxw '
                         + %trim(@Attf(@y))
                         + ''''
                         + ')';
                    MAIL_doCmd(@cmd);
                    if MAIL_IsDir( %trim(@Attf(@y))
                                 : @Size ) = NOTDIR;
                       @TotSiz += @Size;
                    endif;
                 endif;
              endif;
          endfor;
       endif;

       // ---------------------------------
       // Si debe zipear
       // ---------------------------------
       if @y <> *zeros;
          if @Zip = '*YES';
             @cmd = 'QSH CMD('
                  + ''''
                  + 'cd '
                  + %trim(@wdir)
                  + '; jar cfM '
                  + %trim(@Zipn)
                  + ' *.*'
                  + ''''
                  + ')';
             MAIL_doCmd(@cmd);
             @y = 1;
             @Attf(1) = %trim(@wdir)
                      + '/'
                      + %trim(@Zipn);
             if MAIL_IsDir( %trim(@Attf(1))
                          : @TotSiz ) = NOTDIR;
             endif;
          endif;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_Sndemail()' );
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       if @y <> *zeros;
          for @x = 1 to @y;
              if MAIL_Att( @mimeNote
                         : @Bndy
                         : @Attf(@x)
                         : '*FILE') = -1;
                 unlink(@mimenote);
                 @cmd = 'QSH CMD('
                      + ''''
                      + 'cd ..; rm -R '
                      + %trim(@wdir)
                      + ''''
                      + ')';
                 MAIL_doCmd(@cmd);
                 return -1;
              endif;
          endfor;
       endif;

       @cmd = 'QSH CMD('
            + ''''
            + 'cd ..; rm -R '
            + %trim(@wdir)
            + ''''
            + ')';
       MAIL_doCmd(@cmd);

       if MAIL_ClsBndy( @mimeNote
                      : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @Toad(@z) = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       if MAIL_Send( @mimeNote
                   : @From
                   : @Fadr
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       if @y > *zeros;
          if @Attd = '*YES';
             for @x = 1 to 10;
              if peAttf(@x) = *blanks;
                 leave;
              endif;
              if MAIL_ChkIfso( peAttf(@x) ) = EXIST;
                 unlink(%trim(peAttf(@x)));
              endif;
             endfor;
          endif;
       endif;

       return *zeros;

      /end-free
     P MAIL_SndBmail   E

      * --------------------------------------------------- *
      * MAIL_GetIfsFile(): Obtiene nombre de archivo desde  *
      *                    un path IFS.                     *
      *                                                     *
      *   pePath (input)  = Path completo.                  *
      *                   /home/xxx/zzz/.../fff.xxx         *
      *   peFile (output) = Nombre de archivo.              *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     PMAIL_GetIfsFile  b                   export
     D MAIL_GetIfsFile...
     D                 pi            10i 0
     D   pePath                     256a   const varying
     D   peFile                     256a   varying

     D @Dir            s            255a   varying
     D @File           s            255a   varying
     D @slash          s              1N
     D pos             s             10i 0
     D npos            s             10i 0
     D @last           s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       pos    = *zeros;
       npos   = *zeros;
       @last  = %checkr(' ':%trim(pePath));
       @slash = *off;
       pos = %scan('/':%trim(pePath));
       dow (pos > *zeros);
           @slash = *on;
           pos = %scan('/':%trim(pePath):npos+1);
           if pos = *zeros;
              leave;
           endif;
           npos = pos;
       enddo;

       @File  = %subst(pePath:npos+1:@last-npos);
       peFile = %trim(@File);
       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_EmbebImg(): Enbeber imagen.                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peImgp (input) = Path IFS del archivo a adjuntar. *
      *   peImgn (input) = Nombre de la imagen.             *
      *                    *FILE = Extrae.                  *
      *   peCtid (input) = Content-ID.                      *
      *   peImgt (input) = Tipo de imagen.                  *
      *                    "J" = Jpeg.                      *
      *                    "G" = Gif. (default)             *
      *                    "P" = Png.                       *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     P MAIL_EmbebImg   b                   export
     D MAIL_EmbebImg   pi            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peImgp                     256a   const varying
     D   peImgn                      50a   const
     D   peCtid                     100a   const
     D   peImgt                       1a   const
     D                                     options(*nopass:*omit)

     D @Imgt           s              1a
     D @Imgn           s            256a   varying
     D fd              s             10i 0
     D attFile         s             10i 0
     D Data            s            512a   varying
     D len             s             10i 0
     D enclen          s             10i 0
     D dataatt         s             54a
     D encDataatt      s             74a
     D @contenttype    s            100a   varying
     D @ErrMsg         s            286a   varying
     D @Ctid           s            256a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ---------------------------
       // Acomodar Content-Type
       // ---------------------------
       if %parms >= 6 and
          %addr(peImgt) <> *NULL;
          @Imgt = peImgt;
        else;
          @Imgt = 'G';
       endif;

       if @Imgt <> 'J' and
          @Imgt <> 'G' and
          @Imgt <> 'P';
          @Imgt = 'G';
       endif;

       // ---------------------------
       // Valido Content-ID
       // ---------------------------
       if peCtid = *blanks;
          SetError( MAIL_E_NOCTID );
          return -1;
       endif;

       // ---------------------------
       // Valido archivo adjunto
       // ---------------------------
          if MAIL_ChkIfsO( %trim(peImgp)
                         : '*R' ) = NOEXIST;
             SetError( MAIL_E_NOIMG
                    : %trim(peImgp) );
             return -1;
          endif;

       // ---------------------------
       // Valido que sea archivo
       // ---------------------------
       if MAIL_IsDir( %trim(peImgp) ) = ISDIR;
          SetError( MAIL_E_IMGDIR
                  : %trim(peImgp) );
          return -1;
       endif;

       // -------------------------------------
       // Obtengo nombre del archivo
       // -------------------------------------
       if peImgn = '*FILE';
          if MAIL_GetIfsFile( %trim(peImgp)
                            : @Imgn ) = -1;
             SetError( MAIL_E_IMGNAM
                     : %trim(peImgp) );
             return -1;
          endif;
        else;
          @Imgn = peImgn;
       endif;

       // ----------------------------------
       // Debe haberse enviado un BOUNDARY
       // ----------------------------------
       if %trim(peBndy) = *blanks;
          SetError( MAIL_E_NOIMGBD
                  : %trim(peImgp) );
          return -1;
       endif;

       // ----------------------------------
       // Abrir archivo MIME en modo append
       // ----------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_EmbebImg()               '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       // ----------------------------------
       // Abrir archivo a adjuntar
       // ----------------------------------
       attFile = open( %trim(peImgp): O_RDONLY );

       if attFile = -1;
          callp close(attFile);
          callp close(fd);
          SetError( MAIL_E_NOIMG
                  : %trim(peImgp) );
          return -1;
       endif;

       // ----------------------------------
       // Grabar encabezado
       // ----------------------------------
       select;
        when @Imgt = 'J';
             @ContentType = 'image/jpeg';
        when @Imgt = 'G';
             @ContentType = 'image/gif';
        when @Imgt = 'P';
             @ContentType = 'image/png';
       endsl;
       Data = CRLF
            + '--'
            + %trim(peBndy)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Type: '
            + %trim(@ContentType)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Disposition: inline; filename="'
            + %trim(@Imgn)
            + '"'
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       @Ctid = '<'
             + %trim(peCtid)
             + '>';
       Data = 'Content-ID: ' + %trim(@Ctid)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));
       Data = 'Content-Transfer-Encoding: base64'
            + CRLF
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       // -------------------------------------
       // Leer adjunto, codificarlo y grabarlo
       // -------------------------------------
       dow '1';
          len = read(attFile: %addr(dataatt): %size(dataatt));
          if len < 1;
             leave;
          endif;

          enclen = apr_base64_encode_binary( encdataatt
                                           : dataatt
                                           : len ) - 1;
          %subst(encdataatt:enclen+1) = CRLF;
          callp write(fd: %addr(encdataatt): enclen+2);
       enddo;

       callp close(attFile);
       callp close(fd);

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_RtnPth():   Agrega Return-path.                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peAddr (input) = Dirección de correo para Return  *
      *                    Path. Si no llega pone desde la  *
      *                    configuración.                   *
      *                  *SYSTEM  = Configuración.          *
      *                  *CURRENT = Usuario del Job.        *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     P MAIL_RtnPth     b                   export
     D MAIL_RtnPth     pi            10i 0
     D   peMime                     256a   const varying
     D   peAddr                     256a   const varying
     D                                     options(*nopass)

     D @Addr           s            256a   varying
     D Data            s            100a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       if %parms >= 2;
          @Addr = peAddr;
        else;
          @Addr = @mailconfr.NFRTPT;
       endif;

       select;
         when @Addr = '*SYSTEM';
              @Addr = @mailconfr.NFRTPT;
         when @Addr = '*CURRENT';
              @Addr = %trim(@rqsmail);
       endsl;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          @ErrMsg = 'MAIL_RtnPth()                 '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = 'Return-path: '
            + %trim(@Addr)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Sender(): Agrega el Sender:                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peAddr (input) = Dirección de correo de prFrom    *
      *                    *SYSTEM = Saca de configuración. *
      *                    *CURRENT= Usuario del Job.       *
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     P MAIL_Sender     b                   export
     D MAIL_Sender     pi            10i 0
     D   peMime                     256a   const varying
     D   peAddr                     256a   const varying

     D Data            s            358a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D @Addr           s            256a

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // -----------------------------
       // Si es *SYSTEM, usa de config
       // -----------------------------
       select;
          when peAddr = '*SYSTEM';
               @Addr = @sysmail;
          when peAddr = '*CURRENT';
               @Addr = %trim(@rqsmail);
          other;
               @Addr = %trim(peAddr);
       endsl;

       // ---------------------------------
       // Si no informó mail del Remitente
       // ---------------------------------
       if %trim(@Addr) = *blanks;
          SetError( MAIL_E_ADRSNDR );
          return -1;
       endif;

       // ---------------------------------
       // Si el mail del Remit es inválido
       // ---------------------------------
       if MAIL_IsValid( @Addr ) = NOTVALID;
          SetError( MAIL_E_ADRSNDR
                  : @Addr );
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          @ErrMsg = 'MAIL_Sender()                 '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       Data = 'Sender: '
            + %trim(@Addr)
            + CRLF;
       callp write(fd: %addr(Data)+2: %len(Data));

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_Notif(): Genera Content-Notification-To o      *
      *               Return-Receipt-To.                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *   peFAdr (input) = Dirección de correo de peFrom    *
      *                  *SYSTEM = Usa configuración        *
      *                  *CURRENT= Usario del job.          *
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     P MAIL_Notif      b                   export
     D MAIL_Notif      pi            10i 0
     D   peMime                     256a   const varying
     D   peFAdr                     256a   const varying

     D Data            s            358a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D @FAdr           s            256a

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // -----------------------------
       // Si es *SYSTEM, usa de config
       // -----------------------------
       select;
         when peFadr = '*SYSTEM' or
              peFadr = *blanks;
              @FAdr = @sysmail;
         when peFadr = '*CURRENT';
              @FAdr = %trim(@rqsmail);
         other;
              @FAdr = peFAdr;
       endsl;

       // ---------------------------------
       // Si no informó mail del Remitente
       // ---------------------------------
       if %trim(@FAdr) = *blanks;
          SetError( MAIL_E_NONTADR );
          return -1;
       endif;

       // ---------------------------------
       // Si el mail del Remit es inválido
       // ---------------------------------
       if MAIL_IsValid( @FAdr ) = NOTVALID;
          SetError( MAIL_E_IVNTADR
                  : @FAdr );
          return -1;
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Notif()                  '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       if @mailconfr.nfrrcp = '1' or
          @mailconfr.nfrrcp = '3';
          Data = 'Disposition-Notification-To: "'
               + %trim(@FAdr)
               + '"'
               + CRLF;
          callp write(fd: %addr(Data)+2: %len(Data));
       endif;

       if @mailconfr.nfrrcp = '2' or
          @mailconfr.nfrrcp = '3';
          Data = 'Return-Receipt-To: "'
               + %trim(@FAdr)
               + '"'
               + CRLF;
          callp write(fd: %addr(Data)+2: %len(Data));
       endif;

       callp close(fd);
       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_AutoFirma(): Genera autofirma.                 *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *                 *SYSTEM  = Toma de configuración.   *
      *                 *CURRENT = Usuario del job.         *
      *   peFAdr (input) = Dirección de correo de peFrom.   *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     P MAIL_AutoFirma  b                   export
     D MAIL_AutoFirma  pi            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peBndy                      36a   const varying
     D   peCntt                       1a   const
     D                                     options(*nopass:*omit)

     D Data            s            100a
     D @Data           s          65535a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying
     D pos             s             10i 0
     D @x              s             10i 0
     D @Dire           ds                  likeds(DireEnt_t)
     D @img            s              1N
     D fin             s             10i 0
     D len             s             10i 0
     D @cid            s            100a
     D @imgt           s              1a   inz('J')
     D @cntt           s              1a
     D encdatalen      s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       if %parms >= 5 and
          %addr(peCntt) <> *NULL;
          @Cntt = peCntt;
        else;
          @Cntt = 'T';
       endif;

       // ------------------------------
       // Abre nota MIME en modo Append
       // ------------------------------
       fd = open( %trim(peMime)
                : O_WRONLY+O_TEXTDATA+O_APPEND);

       if fd = -1;
          callp close(fd);
          @ErrMsg = 'MAIL_Autofirma()              '
                  + %trim(peMime);
          SetError( MAIL_E_NOMIMEX
                  : @ErrMsg );
          return -1;
       endif;

       // ------------------------------
       // Determina datos a usar
       // ------------------------------
       select;
         when peFrom = '*SYSTEM';
              @Dire.Fuln = *blanks;
              @Dire.Mail = %trim(@sysmail);
              @Dire.Post = *blanks;
              @Dire.Dept = *blanks;
         when peFrom = '*CURRENT';
              @Dire = MAIL_GetDire( @PsDs.CurUsr );
              @Dire.Mail = %trim(@Dire.Mail)
                         + '@'
                         + %trim(@mailconfr.nfdomi);
         other;
              @Dire.Fuln = %trim(peFrom);
              @Dire.Mail = %trim(peFadr);
              @Dire.Post = *blanks;
              @Dire.Dept = *blanks;
       endsl;

       // ------------------------------
       // Genera encabezado
       // ------------------------------
       if @Cntt = 'T';
          @Data = '--'
                + %trim(peBndy)
                + ' '
                + CRLF;
          callp write(fd: %addr(@Data)+2: %len(%trim(@Data)));
          @Data = 'Content-Type: text/html'
                + ' '
                + CRLF;
          callp write(fd: %addr(@Data)+2: %len(%trim(@Data)));
          @Data = 'Content-Disposition: inline'
                + ' '
                + CRLF + CRLF;
          callp write(fd: %addr(@Data)+2: %len(%trim(@Data)));
       endif;

       // ------------------------------
       // Genera firma
       // ------------------------------
       @img = *OFF;
       fin  = *zeros;
       len  = *zeros;
       for @x = 1 to 9999;
         if @AutoFirma(@x) <> *blanks;
            Data = %trim(@AutoFirma(@x));
            pos = %scan('"cid:':Data);
            if (pos > *zeros);
               fin  = %scan('"':Data:pos+1);
               pos += 5;
               fin -= 1;
               len  = fin - pos + 1;
               @cid = %subst(Data:pos:len);
               @img = *ON;
            endif;
            // -----------------------------------
            // Reemplaza nombre - %NAME%
            // -----------------------------------
            pos = %scan('%NAME%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@Dire.Fuln):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza puesto - %POST%
            // -----------------------------------
            pos = %scan('%POST%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@Dire.Post):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza departamento - %DEPT%
            // -----------------------------------
            pos = %scan('%DEPT%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@Dire.Dept):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza nombre empresa - %NEMM%
            // -----------------------------------
            pos = %scan('%NEMM%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.emnemm):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza dirección - %ADDR%
            // -----------------------------------
            pos = %scan('%ADDR%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.emaddr):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza CPA - %CPMA%
            // -----------------------------------
            pos = %scan('%CPMA%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.emcpma):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza País - %PAID%
            // -----------------------------------
            pos = %scan('%PAID%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.empaid):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza Teléfono - %TELN%
            // -----------------------------------
            pos = %scan('%TELN%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.emteln):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza Mail - %MAIL%
            // -----------------------------------
            pos = %scan('%MAIL%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@Dire.Mail):@AutoFirma(@x):pos:6);
            endif;
            // -----------------------------------
            // Reemplaza Página Web - %PWEB%
            // -----------------------------------
            pos = %scan('%PWEB%': @AutoFirma(@x));
            if (pos > *zeros);
               Data = %replace(%trim(@g1temp.empweb):@AutoFirma(@x):pos:6);
            endif;
            if %trim(Data) = '<br>';
             else;
               htmlEncode( %trim(data)
                         : %len(%trim(Data))
                         : @Data
                         : encdatalen        );
               @Data = %trim(@Data)
                     + ' '
                     + CRLF;
               callp write(fd: %addr(@Data)+2: %len(%trim(@Data)));
            endif;
         endif;
       endfor;

       callp close(fd);

       if @img;
          if MAIL_EmbebImg( peMime
                          : peBndy
                          : @mailconfr.nffimg
                          : '*FILE'
                          : %trim(@cid)
                          : @imgt ) = -1;
             return -1;
          endif;
       endif;

       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_SndSplf(): Enviar archivos spool en PDF.       *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                  *SYSTEM = Toma de configuración.   *
      *                  *CURRENT= Usuario del Job.         *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peSplf (input)  = Archivo de spool.               *
      *                     Ver DS DsSpool_t.               *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peZip  (input)  = Zipear si/no.                   *
      *   peZipn (input)  = Nombre Zip.                     *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndSplf    b                   export
     D MAIL_SndSplf    pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peSplf                            likeds(DsSpool_t)
     D                                     dim(9999)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peZip                        4a   const
     D                                     options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)

      * -----------------------------------
      * Generar nombre temporal en el IFS
      * -----------------------------------
     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

      * -----------------------------------
      * Convertir a PDF
      * -----------------------------------
     D CvtSplf         pr                  extpgm('CVTSPLFC')
     D  FromFile                     10a   const
     D  ToStmf                      256a   const
     D  Submit                        1a   const
     D  QualJob                            likeds(QualJobName_t)
     D  SplId                         4  0 const
     D  ToFmt                         5a   const
     D  StmfOpt                       8a   const
     D  StmfCodPag                    5  0 const
     D  Title                        50a   const
     D  BookMark                      7a   const
     D  BookMarkPos                   8a   const
     D  BookMarkKey                 388a   const

     D @Impo           s             10i 0
     D @Sens           s             10i 0
     D @Prio           s             10i 0
     D @res            s             10i 0
     D @Msg            s             40a
     D @Msg2           s             46a
     D pdfFile         s            256a   varying
     D @Spln           s              4  0
     D @Bndy           s             36a
     D @mimeNote       s            256a   varying
     D @Subj           s             84a
     D @Stat           s             10a
     D @DelAtt         s              4a
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Attn           s            256a   dim(100)
     D @Size           s             10i 0
     D @TotSiz         s             10i 0
     D @x              s             10i 0
     D @y              s             10i 0
     D @z              s             10i 0
     D @Zip            s              4a
     D @cmd            s            500a   varying
     D QualJob         ds                  likeds(QualJobName_t)
     D @Splf           ds                  likeds(DsSpool_t)
     D                                     dim(9999)
     D @AttQty         s             10i 0
     D @Zipn           s             50a

     D AttFiles        s            256a   varying dim(9999)
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @@Toad          s            256a   varying
     D @Toty           s             10i 0 dim(100)
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Importancia
       // ------------------------------
       if %parms >= 10 and
          %addr(peImpo) <> *NULL;
           @Impo = peImpo;
        else;
           @Impo = *zeros;
       endif;
       if @Impo < *zeros or
          @Impo > 2;
           @Impo = *zeros;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if %parms >= 11 and
          %addr(peSens) <> *NULL;
           @Sens = peSens;
        else;
           @Sens = *zeros;
       endif;
       if @Sens < *zeros or
          @Sens > 3;
          @Sens = *zeros;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if %parms >= 12 and
          %addr(pePrio) <> *NULL;
           @Prio = pePrio;
        else;
           @Prio = *zeros;
       endif;
       if @Prio < *zeros or
          @Prio > 3;
          @Prio = *zeros;
       endif;

       // ------------------------------
       // Zipear
       // ------------------------------
       if %parms >= 13 and
          %addr(peZip) <> *NULL;
           @Zip = peZip;
        else;
           @Zip = '*NO';
       endif;
       if @Zip <> '*YES' and
          @Zip <> '*NO';
          @Zip = '*NO';
       endif;

       if %parms >= 14 and
          %addr(peZipn) <> *NULL;
           @Zipn = peZipn;
       endif;
       if @Zipn = *blanks;
          @Zipn = 'Files.zip';
       endif;

       // ------------------------------
       // Validar que el spool exista
       // ------------------------------
       @AttQty  = *zeros;
       @TotSiz  = *zeros;
       for @x = 1 to 9999;
           if peSplf(@x).Splf    = *blanks;
              leave;
           endif;
           if MAIL_ChkSplf( peSplf(@x).JobName
                          : peSplf(@x).JobUser
                          : peSplf(@x).JobNbr
                          : peSplf(@x).Splf
                          : peSplf(@x).Splfnbr
                          : @Stat ) = EXIST;
              if @Stat = '*READY' or
                 @Stat = '*HELD'  or
                 @Stat = '*SAVED';
                     @y += 1;
                     @Splf(@y).Splf    = peSplf(@x).Splf;
                     @Splf(@y).Splfnbr = peSplf(@x).Splfnbr;
                     select;
                       when peSplf(@x).Splfnbr = *zeros;
                            @Splf(@y).Splfnbr = -3;
                       when peSplf(@x).Splfnbr = -1;
                            @Splf(@y).Splfnbr = -2;
                     endsl;
                     @Splf(@y).Jobname = peSplf(@x).Jobname;
                     @Splf(@y).JobUser = peSplf(@x).JobUser;
                     @Splf(@y).JobNbr  = peSplf(@x).JobNbr;
              endif;
           endif;
       endfor;

       if @y > *zeros;
          @cmd = 'QSH CMD('
               + ''''
               + 'mkdir '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          for @x = 1 to @y;
              pdfFile = %trim(@wdir)
                      + '/'
                      + %trim(MAIL_SplfNam(@Splf(@x).Splf));
              QualJob.JobName = @Splf(@x).JobName;
              QualJob.JobUser = @Splf(@x).JobUser;
              QualJob.JobNbr  = @Splf(@x).JobNbr;
              CvtSplf( @Splf(@x).Splf
                     : %trim(pdfFile)
                     : '0'
                     : QualJob
                     : @Splf(@x).SplfNbr
                     : '*PDF'
                     : '*REPLACE'
                     : -1
                     : *blanks
                     : '*PAGNBR'
                     : *blanks
                     : *blanks );
              // ------------------------------
              // Obtengo Tamaño del archivo
              // ------------------------------
              @Size = *zeros;
              if MAIL_IsDir( %trim(pdfFile)
                           : @Size ) = NOTDIR;
                 @TotSiz += @Size;
              endif;
              @AttQty += 1;
              AttFiles(@AttQty) = %trim(pdfFile);
          endfor;
       endif;

       // ------------------------------
       // Si debe Zipear...
       // ------------------------------
       if @AttQty > *zeros;
          if @Zip = '*YES';
             @cmd = 'QSH CMD('
                  + ''''
                  + 'cd '
                  + %trim(@wdir)
                  + '; jar cfM '
                  + %trim(@Zipn)
                  + ' *.*'
                  + ''''
                  + ')';
             MAIL_doCmd( @cmd );
             @AttQty = 1;
             AttFiles(@AttQty) = %trim(@wdir)
                               + '/'
                               + %trim(@Zipn);
             if MAIL_IsDir( %trim(@wdir) + '/' + %trim(@Zipn)
                          : @TotSiz) = NOTDIR;
             endif;
          endif;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_SndSplf()' );
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       if @Sens = 3;
          @Subj = %trim(@mailconfr.nfcwor)
                + %trim(peSubj);
        else;
          @Subj = %trim(peSubj);
       endif;
       if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndSplf()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            @cmd = 'QSH CMD('
                 + ''''
                 + 'cd ..; rm -R '
                 + %trim(@wdir)
                 + ''''
                 + ')';
            MAIL_doCmd( @cmd );
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       if MAIL_From( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : *omit ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Importancia
       // -----------------------------------
       if MAIL_Importance( @mimeNote
                         : @Impo ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Sensibilidad
       // -----------------------------------
       if MAIL_MSens( @mimeNote
                    : @Sens ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Prioridad
       // -----------------------------------
       if MAIL_Priority( @mimeNote
                       : @Prio ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : %trim(peCntt) ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo mensaje
       // -----------------------------------
       if MAIL_Body( @mimeNote
                   : peMens ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Autofirma
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : peCntt ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd( @cmd );
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjuntar archivos si corresponde
       // -----------------------------------
       for @x = 1 to @AttQty;
           if MAIL_Att( @mimeNote
                      : @Bndy
                      : AttFiles(@x)
                      : '*FILE' ) = -1;
              @cmd = 'QSH CMD('
                   + ''''
                   + 'cd ..; rm -R '
                   + %trim(@wdir)
                   + ''''
                   + ')';
              MAIL_doCmd( @cmd );
              unlink(@mimeNote);
              return -1;
           endif;
       endfor;

       @cmd = 'QSH CMD('
            + ''''
            + 'cd ..; rm -R '
            + %trim(@wdir)
            + ''''
            + ')';
       MAIL_doCmd(@cmd);

       if MAIL_ClsBndy( @mimeNote
                      : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @@Toad    = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       if MAIL_Send( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_SndiFile(): Enviar un archivo i (en csv).      *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Toma de configuración.    *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peFile (input)  = Nombre de archivo.              *
      *   peLibr (input)  = Nombre del spool.               *
      *   peMbrn (input)  = Miembro para LIBR/FILE.         *
      *                     Nombre.                         *
      *                     *FIRST (omisión).               *
      *                     *LAST.                          *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peNotf (input)  = Acuse de recibo.                *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndiFile   b                   export
     D MAIL_SndiFile   pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peFile                      10a   const
     D   peLibr                      10a   const
     D   peMbrn                      10a   const
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peZip                        4a   const
     D                                     options(*nopass:*omit)
     D   peNotf                       4a   const
     D                                     options(*nopass:*omit)

      * -----------------------------------
      * QCMDEXEC
      * -----------------------------------
     D CmdExc          pr                  extpgm('QCMDEXC')
     D  Cmd                       65535a   const
     D  Len                          15  5 const

      * -----------------------------------
      * Generar nombre temporal en el IFS
      * -----------------------------------
     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

     D @Impo           s             10i 0
     D @Sens           s             10i 0
     D @Prio           s             10i 0
     D iFile           s            256a   varying
     D @Bndy           s             36a
     D @mimeNote       s            256a   varying
     D @Subj           s             84a
     D @DelAtt         s              4a
     D @Mbrn           s             10a
     D @Msg            s             30a
     D Cmd             s            500a   varying
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Attn           s             50a
     D @Zip            s              4a
     D @cmd            s            500a   varying
     D @TotSiz         s             10i 0
     D @Size           s             10i 0
     D @Notf           s              4a
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @@Toad          s            256a   varying
     D @Toty           s             10i 0 dim(100)
     D @z              s             10i 0
     D @y              s             10i 0
     D @x              s             10i 0
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // ------------------------------
       // Importancia
       // ------------------------------
       if %parms >= 12 and
          %addr(peImpo) <> *NULL;
           @Impo = peImpo;
        else;
           @Impo = *zeros;
       endif;
       if @Impo < *zeros or
          @Impo > 2;
          @Impo = *zeros;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if %parms >= 13 and
          %addr(peSens) <> *NULL;
           @Sens = peSens;
        else;
           @Sens = *zeros;
       endif;
       if @Sens < *zeros or
          @Sens > 3;
          @Sens = *zeros;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if %parms >= 14 and
          %addr(pePrio) <> *NULL;
           @Prio = pePrio;
        else;
           @Prio = *zeros;
       endif;
       if @Prio < *zeros or
          @Prio > 3;
          @Prio = *zeros;
       endif;

       // ------------------------------
       // Zipear
       // ------------------------------
       if %parms >= 15 and
          %addr(peZip) <> *NULL;
           @Zip = peZip;
        else;
           @Zip = '*YES';
       endif;
       if @Zip <> '*YES' and
          @Zip <> '*NO';
          @Zip = '*YES';
       endif;

       // ------------------------------
       // Acuse de recibo/Notificacion
       // ------------------------------
       if %parms >= 16 and
          %addr(peNotf) <> *NULL;
            @Notf = %trim(peNotf);
       endif;
       if @Notf <> '*YES' and
          @Notf <> '*NO';
            @Notf = '*YES';
       endif;

       // ------------------------------
       // Acomodar el miembro a copiar
       // ------------------------------
       if %parms >= 11 and
          %addr(peMbrn) <> *NULL;
          @Mbrn = %trim(peMbrn);
        else;
          @Mbrn = '*FIRST';
       endif;

       // ------------------------------
       // Validar que exista
       // ------------------------------
       if MAIL_ChkObj( %trim(peFile)
                     : %trim(peLibr)
                     : '*FILE'
                     : %trim(@Mbrn) )= NOEXIST;
          %subst(@Msg:1:10)  = @Mbrn;
          %subst(@Msg:11:10) = peLibr;
          %subst(@Msg:21:10) = peFile;
          SetError( MAIL_E_NOIFILE
                  : @Msg );
          return -1;
       endif;

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       if @Sens = 3;
          @Subj = %trim(@mailconfr.nfcwor)
                + %trim(peSubj);
        else;
          @Subj = %trim(peSubj);
       endif;
       if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndiFile()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       if MAIL_From( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : *omit ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Notificación
       // -----------------------------------
       if @Notf = '*YES';
          if MAIL_Notif( @mimeNote
                       : peFrom ) = -1;
             unlink(@mimeNote);
             return -1;
          endif;
       endif;

       // -----------------------------------
       // Importancia
       // -----------------------------------
       if MAIL_Importance( @mimeNote
                         : @Impo ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Sensibilidad
       // -----------------------------------
       if MAIL_MSens( @mimeNote
                    : @Sens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Prioridad
       // -----------------------------------
       if MAIL_Priority( @mimeNote
                       : @Prio ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : %trim(peCntt) ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo mensaje
       // -----------------------------------
       if MAIL_Body( @mimeNote
                   : peMens ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Autofirma
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : peCntt ) = -1;
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjunto archivo
       // -----------------------------------
       @cmd = 'QSH CMD('
            + ''''
            + 'mkdir '
            + %trim(@wdir)
            + ''''
            + ')';
       MAIL_doCmd(@cmd);

       iFile = %trim(@wdir)
             + '/'
             + %trim(peFile)
             + '.csv';

       Cmd = 'CPYTOIMPF FROMFILE('
           + %trim(peLibr)
           + '/'
           + %trim(peFile)
           + ' '
           + %trim(@Mbrn)
           + ') '
           + 'TOSTMF('
           + ''''
           + %trim(iFile)
           + ''''
           + ') STMFCODPAG(*PCASCII) RCDDLM(*CRLF) '
           + 'RMVBLANK(*BOTH)';
       CmdExc( Cmd
             : %len(%trimr(Cmd)) );

       if @Zip = '*YES';
          @cmd = 'QSH CMD('
               + ''''
               + 'cd '
               + %trim(@wdir)
               + ' ; jar cfM '
               + %trim(peFile)
               + '.zip *.*'
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          iFile = %trim(@wdir)
                + '/'
                + %trim(peFile)
                + '.zip';
        else;
          iFile = %trim(@wdir)
                + '/'
                + %trim(peFile)
                + '.csv';
       endif;

       if MAIL_IsDir( %trim(iFile)
                    : @TotSiz ) = NOTDIR;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_SndiFile()' );
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       @DelAtt = '*YES';
       if MAIL_Att( %trim(@mimeNote)
                  : @Bndy
                  : iFile
                  : '*FILE'
                  : *omit ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd .. ; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          unlink(@mimeNote);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @Toad(@z) = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       if MAIL_Send( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          @cmd = 'QSH CMD('
               + ''''
               + 'cd .. ; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          unlink(@mimeNote);
          return -1;
       endif;

       @cmd = 'QSH CMD('
            + ''''
            + 'cd .. ; rm -R '
            + %trim(@wdir)
            + ''''
            + ')';
       MAIL_doCmd(@cmd);

       return *zeros;

      /end-free
     P                 e

      * --------------------------------------------------- *
      * MAIL_SndFdsg(): Envía diseño de archivo.            *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *   peFadr (input)  = Dirección remitente.            *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peFile (input)  = Archivo.                        *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     P MAIL_SndFdsg    b                   export
     D MAIL_SndFdsg    pi            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peFile                            likeds(QualDBName_t)

      * ------------------------------------------
      * Genera diseño
      * ------------------------------------------
     D DspfHtml        pr                  extpgm('DSPFHTMLC')
     D   peFile                            likeds(QualDBName_t)
     D   peTdir                     256a   const
     D   peTstm                      64a   const
     D   peTitl                      50a   const

     D tmpnam          pr              *   extproc('_C_IFS_tmpnam')
     D   string                      39a   options(*omit)

     D File            s             10a
     D FileLib         s             10a
     D @Msg            s             30a
     D @Dochtml        s            256a   varying
     D @Titl           s             50a   varying
     D @mimeNote       s            256a   varying
     D @Subj           s             84a
     D @From           s             64a   varying
     D @Fadr           s            256a   varying
     D @Bndy           s             36a
     D @Mens           s            512a   varying
     D @Attn           s             50a
     D @Attd           s              4a   inz('*YES')
     D @@attn          s             50a   varying
     D @TotSiz         s             10i 0
     D @cmd            s            500a   varying
     D @To             s             50a   dim(100)
     D @Toad           s            256a   dim(100)
     D @@Toad          s            256a   varying
     D @Toty           s             10i 0 dim(100)
     D @z              s             10i 0
     D @x              s             10i 0
     D @keyw           s            256a   varying
     D @keyv           s            256a   varying
     D pos             s             10i 0

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       // -------------------------------
       // Separar archivo
       // -------------------------------
       File    = peFile.DBFile;
       FileLib = peFile.DBFileLib;

       // -------------------------------
       // Ver que exista
       // -------------------------------
       if MAIL_ChkObj( File
                     : FileLib
                     : '*FILE' ) = NOEXIST;
          %subst(@Msg:1:10)  = '*FIRST';
          %subst(@Msg:11:10) = File;
          %subst(@Msg:21:10) = FileLib;
          SetError( MAIL_E_NOIFILE
                  : @Msg );
          return -1;
       endif;

       // -------------------------------
       // Nombre para documento html
       // -------------------------------
       @Dochtml = %str(tmpnam(*omit));
       @Dochtml = %trim(%replace(' ':@Dochtml:1:5));
       @Titl = 'Diseño de archivo: '
             + %trim(FileLib)
             + '/'
             + %trim(File);

       // -------------------------------
       // Obtengo diseño
       // -------------------------------
       Dspfhtml( peFile
               : '/tmp'
               : @Dochtml
               : @Titl );

       // -------------------------------
       // Nuevo nombre
       // -------------------------------
       @Dochtml = '/tmp/'
                + %trim(@Dochtml)
                + '.html';

       // ------------------------------
       // Obtener nombre para nota MIME
       // ------------------------------
       @mimeNote = %str(tmpnam(*omit));
       if MAIL_CrtMime( @mimeNote ) = -1;
          unlink(@Dochtml);
          return -1;
       endif;

       // ------------------------------
       // Generar Asunto del mail
       // ------------------------------
       @Subj = @Titl;
       if MAIL_Subject( @mimeNote
                      : %trim(@Subj) ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Palabras claves
       // ------------------------------
       open gntmkw;
       read gntmkw;
       dow not %eof;
         @keyw = %trim(kwkeyw);
         @keyv = %trim(kwkwva);
         pos = %scan('%%SUBP%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( 'MAIL_SndfDsg()'
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         pos = %scan('%%USER%%':@keyv);
         if (pos <> *zeros);
            @keyv  = %replace( %trim(@PsDs.CurUsr)
                             : kwkwva
                             : pos
                             : 8 );
         endif;
         if MAIL_Keyw( @mimeNote
                     : %trim(@keyw)
                     : %trim(@keyv) ) = -1;
            unlink(@Dochtml);
            unlink(@mimeNote);
            return -1;
         endif;
        read gntmkw;
       enddo;
       close gntmkw;

       // ------------------------------
       // Generar Remitente
       // ------------------------------
       if MAIL_From( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : *omit ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Generar Destinatarios
       // ------------------------------
       if MAIL_To( @mimenote
                 : peTo
                 : peToad
                 : peToty ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Importancia
       // ------------------------------
       if MAIL_Importance( @mimeNote
                         : MAIL_IMPL ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Sensibilidad
       // ------------------------------
       if MAIL_MSens( @mimeNote
                    : MAIL_SENN ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // ------------------------------
       // Prioridad
       // ------------------------------
       if MAIL_Priority( @mimeNote
                       : MAIL_PTYN ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Genero Boundary y creo Content-Type
       // -----------------------------------
       @Bndy = MAIL_GenBnyStr();
       if MAIL_MultiP( @mimeNote
                     : @Bndy ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Creo cuerpo del mensaje
       // -----------------------------------
       if MAIL_CrtBody( @mimeNote
                      : @Bndy
                      : 'H' ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Crear mensaje
       // -----------------------------------
       @Mens = '<html>'                  + CRLF
             + 'Estimado,<br>'           + CRLF
             + 'Le adjunto el diseño del'
             + ' archivo de referencia.' + CRLF
             + '<br><br><br>'            + CRLF
             + 'Atte.-'                  + CRLF
             + '<br><br><br>'            + CRLF
             + '</html>'                 + CRLF
             + CRLF;
       if MAIL_Body( @mimeNote
                   : @Mens ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Crear mensaje
       // -----------------------------------
       if MAIL_Autofirma( @mimeNote
                        : peFrom
                        : peFAdr
                        : @Bndy
                        : 'H' ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          return -1;
       endif;

       // -----------------------------------
       // Adjuntar
       // -----------------------------------
       @@Attn = %trim(File)
              + '.html';
       @Attn = %trim(@@Attn);
       @Attd = '*YES';
       if MAIL_IsDir( %trim(@Dochtml)
                    : @TotSiz ) = NOTDIR;
       endif;

       // -----------------------------
       // Tamaño máximo permitido
       // -----------------------------
       if @TotSiz > @mailconfr.nftsiz;
          SetError( MAIL_E_ASIZ
                  : 'MAIL_SndfDsg()' );
          unlink(@mimeNote);
          unlink(@dochtml);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       if MAIL_Att( @mimeNote
                  : @Bndy
                  : @Dochtml
                  : @Attn
                  : @Attd ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       // -----------------------------------
       // Cerrar boundary
       // -----------------------------------
       if MAIL_ClsBndy( @mimeNote
                       : @Bndy ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       // --------------------------------
       // Resolver Destinatarios
       // --------------------------------
       clear @To;
       clear @Toad;
       clear @Toty;
       @z = *zeros;
       for @x = 1 to 100;
           if peTo(@x) = *blanks;
              leave;
           endif;
           @z += 1;
           select;
            when peTo(@x) = '*SYSTEM';
              @To(@z)   = @mailconfr.nfsysn;
              @Toad(@z) = @sysmail;
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*REQUESTER';
              @To(@z)   = %trim(@Dire.Fuln);
              @Toad(@z) = %trim(@rqsmail);
              @Toty(@z) = peToty(@x);
            when peTo(@x) = '*RTNPTH';
              @To(@z)   = @mailconfr.nfrtpn;
              @Toad(@z) = @rtpmail;
              @Toty(@z) = peToty(@x);
            other;
              @To(@z)   = peTo(@x);
              @Toad(@z) = peToad(@x);
              @Toty(@z) = peToty(@x);
           endsl;
       endfor;

       // -----------------------------------
       // Enviar
       // -----------------------------------
       if MAIL_Send( @mimeNote
                   : %trim(peFrom)
                   : %trim(peFadr)
                   : @To
                   : @Toad
                   : @Toty ) = -1;
          unlink(@Dochtml);
          unlink(@mimeNote);
          @cmd = 'QSH CMD('
               + ''''
               + 'cd ..; rm -R '
               + %trim(@wdir)
               + ''''
               + ')';
          MAIL_doCmd(@cmd);
          return -1;
       endif;

       return *zeros;

      /end-free

     P                 e

      * --------------------------------------------------- *
      * MAIL_doCmd(): Ejecuta comando.                      *
      *                                                     *
      *   peCmd  (input) = Comando a ejecutar.              *
      *                                                     *
      * Retorna *zeros si ok, -1 si error.                  *
      * --------------------------------------------------- *
     P MAIL_doCmd      B
     D MAIL_doCmd      pi            10i 0
     D   peCmd                     5000a   const

      * -----------------------------------
      * QCMDEXEC
      * -----------------------------------
     D CmdExc          pr                  extpgm('QCMDEXC')
     D  Cmd                       65535a   const options(*varsize)
     D  Len                          15  5 const

      /free

       monitor;
          CmdExc( %trim(peCmd)
                : %len(%trim(peCmd)) );
          on-error;
            return -1;
       endmon;

       return *zeros;

      /end-free

     P                 E

      * --------------------------------------------------- *
      * MAIL_GetDire(): Obtiene entrada de directorio.      *
      *                                                     *
      *   peUser (input) = Usuario.                         *
      *                                                     *
      * Retorna ds like(DireEnt_t).                         *
      * --------------------------------------------------- *
     P MAIL_GetDire    B                   export
     D MAIL_GetDire    pi                  likeds(DireEnt_t)
     D   peUser                      10a   const

     D @Dire           ds                  likeds(DireEnt_t)

      /free

       // ----------------------------------
       // Blanqueo inicial
       // ----------------------------------
       @Dire = *blanks;

       open mailusrs;
       chain peUser mailusrs;
       if %found;
          @Dire.Fuln = %trim(dxfuln);
          @Dire.Post = %trim(dxjob);
          @Dire.Dept = %trim(dxcomp);
          @Dire.Mail = %trim(dxccma);
          if dxmp01 <> 'S';
             @Dire.Fuln = *blanks;
             @Dire.Post = *blanks;
             @Dire.Dept = *blanks;
             @Dire.Mail = *blanks;
          endif;
        else;
          @Dire = *all'-';
          %len(@Dire.Mail) = 255;
       endif;
       close mailusrs;

       return @Dire;

      /end-free

     P                 E

      * --------------------------------------------------- *
      * MAIL_Log(): Loguear operaciones.                    *
      *                                                     *
      *   peMime (input) = Nota mime.                       *
      *   peFadr (input) = Dirección From.                  *
      *   peToad (input) = Dirección To.                    *
      *   peCerr (input) = Código de Finalización.          *
      *                                                     *
      * Retorna void().                                     *
      * --------------------------------------------------- *
     P MAIL_Log        B
     D MAIL_Log        pi
     D   peMime                     256a   varying const
     D   peFadr                     256a   varying const
     D   peToad                     256a   varying const
     D   peCerr                       4s 0 const

     D @cmd            s            500a   varying

      /free

       @cmd = 'OVRDBF FILE(MAILLOG) TOFILE(*LIBL/MAILLOG)'
            + ' SHARE(*YES)';
       MAIL_doCmd(@cmd);

       open maillog;

       grmime = %trim(peMime);
       grfrom = %trim(peFadr);
       grto   = %trim(peToad);
       grcerr = peCerr;
       grdate = (*year * 10000)
              + (*month *  100)
              +  *day;
       grtime = %dec(%time():*iso);
       write maillogr;

       close maillog;

       @cmd = 'DLTOVR FILE(*ALL)';
       MAIL_doCmd(@cmd);

      /end-free

     P                 E

      * --------------------------------------------------- *
      * MAIL_chkUsrAddr(): Retorna si un perfil tiene o no  *
      *                    cargado mail.                    *
      *                                                     *
      *   peUser (input)  = Perfil de Usuario.              *
      *   peDire (output) = Entrada de directorio (opcional)*
      *                                                     *
      * Retorna *ON si tiene, *OFF si no tiene              *
      * --------------------------------------------------- *
     P MAIL_chkUsrAddr...
     P                 B                   export
     D MAIL_chkUsrAddr...
     D                 pi             1N
     D  peUser                       10a   const
     D  peDire                             likeds(DireEnt_t)
     D                                     options(*nopass)

     D @Dir2           ds                  likeds(direEnt_T)

      /free

       @Dir2 = MAIL_getdire( peUser );

       if (%parms >= 2);
          peDire = @Dir2;
       endif;

       if (@Dir2.Mail = *blanks);
          return *OFF;
       endif;

       return *ON;

      /end-free

     P MAIL_chkUsrAddr...
     P                 E

      * --------------------------------------------------- *
      * MAIL_Domain():  Retornar dominio.                   *
      *                                                     *
      *   peDomi (output) = Dominio.                        *
      *                                                     *
      * Retorna 0 si OK, -1 si error.                       *
      * --------------------------------------------------- *
     P MAIL_Domain     B                   export
     D MAIL_Domain     pi            10i 0
     D   peDomi                      50a

      /free

       if MAIL_Inz() = -1;
          return -1;
       endif;

       peDomi = @mailconfr.nfdomi;
       return *zeros;

      /end-free

     P                 E

      * --------------------------------------------------- *
      * MAIL_LSubject():Crea asunto largo del Mail.         *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peSubj (input) = Asunto del mail                  *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error               *
      * --------------------------------------------------- *
     P MAIL_LSubject   b                   export
     D MAIL_LSubject   pi            10i 0
     D   peMime                     256a   const varying
     D   peSubj                     270a   const varying

     D Data            s            300a   varying
     D fd              s             10i 0
     D @ErrMsg         s            286a   varying

      /free

        if MAIL_Inz() = -1;
           return -1;
        endif;

        if %trim(peSubj) = *blanks;
          SetError( MAIL_E_NOSUBJ );
          return -1;
        endif;

        // ------------------------------
        // Abre nota MIME en modo Append
        // ------------------------------
        fd = open( %trim(peMime)
                 : O_WRONLY+O_TEXTDATA+O_APPEND);

        if fd = -1;
           callp close(fd);
           @ErrMsg = 'MAIL_Subject()                '
                   + %trim(peMime);
           SetError( MAIL_E_NOMIMEX
                   : @ErrMsg );
           return -1;
        endif;

        Data = 'Subject: '
             + %trim(peSubj)
             + CRLF;
        callp write(fd: %addr(Data)+2: %len(Data));

        callp close(fd);
        return *zeros;

      /end-free
     P                 e

      * ------------------------------------------------------------ *
      * htmlEncode():   Codifica el body del mail en HTML encoding   *
      *                                                              *
      *                                                              *
      *      input    (input)   String a codificar                   *
      *      inputLen (input)   Longitud de input                    *
      *      output   (output)  String codificada                    *
      *      outputLen(output)  Longitud de output                   *
      *                                                              *
      * retorna:  Longitud de la string codificada.                  *
      * ------------------------------------------------------------ *
     P htmlEncode      B
     D htmlEncode      pi            10i 0
     D  input                      5000a   options(*varsize) const
     D  inputLen                     10i 0 const
     D  output                    65535a   options(*varsize) varying
     D  outputLen                    10i 0

     D pos             s             10i 0
     D x               s             10i 0

      /free

          output = %subst( input: 1: inputLen );
       outputLen = inputLen;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'á': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&aacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Á': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Aacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'é': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&eacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'É': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Eacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'í': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&iacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Í': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Iacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'ó': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&oacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Ó': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Oacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'ú': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&uacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Ú': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Uacute'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'ñ': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&ntilde'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Ñ': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Ntilde'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'ü': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&uuml'
                            : output
                            : pos
                            : 1         );

       enddo;

       x = 1;
       dou ( pos = 0 );

           pos = %scan( 'Ü': output: x );
           if ( pos = 0 );
              leave;
           endif;
           x = pos;
           output = %replace( '&Uuml'
                            : output
                            : pos
                            : 1         );

       enddo;

       outputLen = %len(%trim(output));
       return outputLen;

      /end-free

     P htmlEncode      E

      * --------------------------------------------------- *
      * MAIL_getReceipt(): Obtiene destinatarios de un      *
      *                    proceso/subproceso.              *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso (opcional).          *
      *   peRprp (output) = Registro GNTPRP.                *
      *   peActi (input)  = Recuperar solo activos.         *
      *                                                     *
      * Retorna cantidad de destinatarios.                  *
      * --------------------------------------------------- *
     P MAIL_getReceipt...
     P                 B                   EXPORT
     D MAIL_getReceipt...
     D                 pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const options(*omit)
     D   peRprp                            likeds(recprp_t) dim(100)
     D   peActi                       1N   const options(*nopass:*omit)

     D @spr            s              1N   inz(*OFF)
     D x               s             10i 0
     D @acti           s              1N   inz(*OFF)
     D k1tprp          ds                  likerec(g1tprp:*key)

      /free

       if MAIL_inz() = -1;
          close *all;
          Initialized = *OFF;
          return 0;
       endif;

       if %parms >= 4 and %addr(peActi) <> *null;
          @acti = peActi;
       endif;

       k1tprp.rpcprc = peCprc;
       if %addr(peCspr) <> *NULL;
          k1tprp.rpcspr = peCspr;
          @spr = *ON;
       endif;

       if @spr;
          setll %kds(k1tprp:2) gntprp;
          reade %kds(k1tprp:2) gntprp;
        else;
          setll %kds(k1tprp:1) gntprp;
          reade %kds(k1tprp:1) gntprp;
       endif;

       dow not %eof;

        if ( @acti = *OFF ) or
           ( @acti = *ON and rpma02 = 'S' );

           x += 1;

           peRprp(x).rpcprc = rpcprc;
           peRprp(x).rpcspr = rpcspr;
           peRprp(x).rpmail = rpmail;
           peRprp(x).rpnomb = rpnomb;
           peRprp(x).rpma01 = rpma01;
           peRprp(x).rpma02 = rpma02;
           peRprp(x).rpma03 = rpma03;
           peRprp(x).rpma04 = rpma04;
           peRprp(x).rpma05 = rpma05;
           peRprp(x).rpma06 = rpma06;
           peRprp(x).rpma07 = rpma07;
           peRprp(x).rpma08 = rpma08;
           peRprp(x).rpma09 = rpma09;
           peRprp(x).rpma10 = rpma10;
           peRprp(x).rpstrg = rpstrg;
           peRprp(x).rpuser = rpuser;
           peRprp(x).rpdate = rpdate;
           peRprp(x).rptime = rptime;

        endif;

         if @spr;
            reade %kds(k1tprp:2) gntprp;
          else;
            reade %kds(k1tprp:1) gntprp;
         endif;
       enddo;

       close *all;
       Initialized = *OFF;
       return x;

      /end-free

     P MAIL_getReceipt...
     P                 E

      * --------------------------------------------------- *
      * MAIL_getFrom():  Obtiene FROM de un proceso/subproce*
      *                  so.                                *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peRemi (output) = Remitente.                      *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     P MAIL_getFrom    B                   Export
     D MAIL_getFrom    pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peRemi                            likeds(Remitente_t)

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr) gntspr;
       if not %found;
          SetError( MAIL_E_NOSPR );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       select;
        when ( prFrom = '*CURRENT' );
             peRemi.From = '*CURRENT';
             peRemi.Fadr = *blanks;
             close *all;
             Initialized = *OFF;
             return 0;
        when ( prFrom = '*SYSTEM'  );
             peRemi.From = '*SYSTEM';
             peRemi.Fadr = *blanks;
             close *all;
             Initialized = *OFF;
             return 0;
        when ( prFrom = '*SPRDFN'  );
             if ( prFadr = *blanks ) or
                ( prFnam = *blanks );
                SetError( MAIL_E_NOADR );
                close *all;
                Initialized = *OFF;
                return -1;
             endif;
             peRemi.From = prFnam;
             peRemi.Fadr = prFadr;
             close *all;
             Initialized = *OFF;
             return 0;
        other;
             SetError( MAIL_E_SPRUREF );
             close *all;
             Initialized = *OFF;
             return -1;
       endsl;


      /end-free

     P MAIL_getFrom    E

      * --------------------------------------------------- *
      * MAIL_getAttList(): Obtiene lista de adjuntos de un  *
      *                    proceso/subproceso.              *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peAttl (output) = Lista de archivos.              *
      *                                                     *
      * Retorna: <> -1 Cantidad de adjuntos                 *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     P MAIL_getAttList...
     P                 B                   export
     D MAIL_getAttList...
     D                 pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peAttl                     255a   dim(10)

     D k1tpfi          ds                  likerec(g1tpfi:*key)
     D count           s             10i 0

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tpfi.ficprc = peCprc;
       k1tpfi.ficspr = peCspr;
       setll %kds(k1tpfi:2) gntpfi;
       reade %kds(k1tpfi:2) gntpfi;
       dow not %eof;

           count += 1;
           if ( count > 10 );
            leave;
           endif;
           peAttl(count) = fifile;

        reade %kds(k1tpfi:2) gntpfi;
       enddo;

       return count;

      /end-free

     P MAIL_getAttList...
     P                 E

      * --------------------------------------------------- *
      * MAIL_getBody():  Obtiene el body de un proceso/sub- *
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peBody (output) = Body.                           *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     P MAIL_getBody    B                   export
     D MAIL_getBody    pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peBody                     512a   varying

     D k1tbdy          ds                  likerec(g1tbdy:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tbdy.dycprc = peCprc;
       k1tbdy.dycspr = peCspr;
       chain %kds(k1tbdy:2) gntbdy;
       if %found;
          peBody = dybody;
        else;
          peBody = *blanks;
       endif;

       return 0;

      /end-free

     P MAIL_getBody    E

      * --------------------------------------------------- *
      * MAIL_getLBody(): Obtiene el body de un proceso/sub- *
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peBody (output) = Body.                           *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     P MAIL_getLBody   B                   export
     D MAIL_getLBody   pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peBody                    5000a

     D k1tbdl          ds                  likerec(g1tbdl:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tbdl.dlcprc = peCprc;
       k1tbdl.dlcspr = peCspr;
       chain %kds(k1tbdl:2) gntbdl;
       if %found;
          peBody = dlbody;
        else;
          peBody = *blanks;
       endif;

       return 0;

      /end-free

     P MAIL_getLBody   E

      * --------------------------------------------------- *
      * MAIL_isLongBody(): Retorna si un proceso/subproceso *
      *                    tiene body largo o no.           *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *                                                     *
      * Retorna: *ON es Long Body                           *
      *          *OFF no lo es   (omisión)                  *
      * --------------------------------------------------- *
     P MAIL_isLongBody...
     P                 B                   Export
     D MAIL_isLongBody...
     D                 pi             1N
     D   peCprc                      20a   const
     D   peCspr                      20a   const

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return *OFF;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr:2) gntspr;
       if not %found;
          return *OFF;
       endif;

       select;
        when (prma03 = '0');
         return *OFF;
        when (prma03 = '1');
         return *ON;
        other;
         return *OFF;
       endsl;

      /end-free

     P MAIL_isLongBody...
     P                 E

      * --------------------------------------------------- *
      * MAIL_mustZip(): Retorna si un proceso/subproceso    *
      *                 debe zipear sus adjuntos.           *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peZipn (output) = Nombre de zip (opcional)        *
      *                                                     *
      * Retorna: *ON debe zipear  (omisión)                 *
      *          *OFF no debe zipear                        *
      * --------------------------------------------------- *
     P MAIL_mustZip    B                   Export
     D MAIL_mustZip    pi             1N
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peZipn                      50a   options(*nopass:*omit)

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          if (%parms >= 3 and %addr(peZipn) <> *NULL);
             peZipn = 'AllFiles.zip';
          endif;
          return *ON;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr:2) gntspr;
       if not %found;
          SetError( MAIL_E_NOSPR );
          close *all;
          Initialized = *OFF;
          if (%parms >= 3 and %addr(peZipn) <> *NULL);
             peZipn = 'AllFiles.zip';
          endif;
          return *ON;
       endif;

       select;
        when (przip = '*YES');
         if (%parms >= 3 and %addr(peZipn) <> *NULL);
            peZipn = przipn;
         endif;
         return *ON;
        when (przip = '*NO');
         return *OFF;
        other;
         if (%parms >= 3 and %addr(peZipn) <> *NULL);
            peZipn = przipn;
         endif;
         return *ON;
       endsl;

      /end-free

     P MAIL_mustZip    E

      * --------------------------------------------------- *
      * MAIL_getOptions(): Retorna las opciones de un proce-*
      *                    so/subproceso.                   *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peOpti (output) = Opciones                        *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     PMAIL_getOptions  B                   Export
     DMAIL_getOptions  pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peOpti                            likeds(MailOpts_t)

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr:2) gntspr;
       if not %found;
          SetError( MAIL_E_NOSPR );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       peOpti.impo = primpo;
       peOpti.sens = prsens;
       peOpti.prio = prprio;
       peOpti.notf = prnotf;
       peOpti.ma01 = prma01;
       if (prma02 = '1');
          peOpti.ma02 = '*YES';
        else;
          peOpti.ma02 = '*NO';
       endif;

       return 0;

      /end-free

     PMAIL_getOptions  E

      * --------------------------------------------------- *
      * MAIL_getSubject(): Retorna asunto de un proceso/sub-*
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peSubj (output) = Asunto.                         *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     P MAIL_getSubject...
     P                 B                   Export
     D MAIL_getSubject...
     D                 pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peSubj                      70a   varying

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr:2) gntspr;
       if not %found;
          SetError( MAIL_E_NOSPR );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       peSubj = prasun;

       return 0;

      /end-free

     P MAIL_getSubject...
     P                 E

      * --------------------------------------------------- *
      * MAIL_getReplyTo(): Retorna mail de destinatario     *
      *                    Reply-To                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peRpyt (output) = Mail Reply-To                   *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     P MAIL_getReplyTo...
     P                 B                   Export
     D MAIL_getReplyTo...
     D                 pi            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peRpyt                      50a   varying

     D k1tspr          ds                  likerec(g1tspr:*key)

      /free

       if ( MAIL_inz() = -1 );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       k1tspr.prcprc = peCprc;
       k1tspr.prcspr = peCspr;
       chain %kds(k1tspr:2) gntspr;
       if not %found;
          SetError( MAIL_E_NOSPR );
          close *all;
          Initialized = *OFF;
          return -1;
       endif;

       peRpyt = prrpyt;

       return 0;

      /end-free

     P MAIL_getReplyTo...
     P                 E

      * ----------------------------------------------------------------- *
      * MAIL_setMailBand() Graba datos en el archivo MailBand             *
      *                                                                   *
      *   peFrom (input)  = Nombre remitente.                             *
      *                     *SYSTEM = Usuario de configuración.           *
      *                     *CURRENT= Usuario del Job.                    *
      *   peFadr (input)  = Dirección remitente.                          *
      *   peSubj (input)  = Asunto del mensaje. Si Sensitivity = 3,       *
      *                     agrega la palabra "*Confidencial'.            *
      *   peMens (input)  = Mensaje.                                      *
      *                     Esto se copia TAL CUAL llega, por lo tanto    *
      *                     el usuario debe formatearlo previamente.      *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.                 *
      *                     T = text/plain.                               *
      *                     H = text/html.                                *
      *   peTo   (input)  = Nombres de Destinatarios.                     *
      *   peToad (input)  = Direcciones destinatarios.                    *
      *   peToty (input)  = Tipo de Destinatarios.                        *
      *   peRply (input)  = Responder a.                                  *
      *   peImpo (input)  = Importancia.                                  *
      *   peSens (input)  = Sensibilidad.                                 *
      *   pePrio (input)  = Prioridad.                                    *
      *   peNotf (input)  = Acuse de recibo.                              *
      *   peSub2 (input)  = Asunto largo.                                 *
      *                                                                   *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P MAIL_setMailBand...
     P                 B                   export
     D MAIL_setMailBand...
     D                 pi              n
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                    5000a   const
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peNotf                       4a   const
     D                                     options(*nopass:*omit)
     D   peSub2                     270a   const varying
     D                                     options(*nopass:*omit)
     D
     D @x              s             10i 0
     D dsMailBand      ds                  likerec( mailBandR : *output )
     D dsMailBDes      ds                  likerec( mailBDesR : *output )

      /free

       MAIL_Inz();

       clear dsMailBand;
       // recupero ultimo ID
       setgt *hival mailBand;
       readp(n) mailBand;
       if not %eof(mailBand);
          dsMailBand.bdIdMa = bdIdMa;
       endif;
       dsMailBand.bdIdMa +=1;
       dsMailBand.bdMEst = 'P';
       dsMailBand.bdFrom = peFrom;
       dsMailBand.bdFadr = peFadr;
       dsMailBand.bdSubj = peSubj;
       dsMailBand.bdMens = peMens;
       dsMailBand.bdCntt = peCntt;
       if %parms >= 9 and %addr(peRply) <> *NULL;
          dsMailBand.bdRply = peRply;
       endif;
       if %parms >= 10 and %addr(peImpo) <> *NULL;
          dsMailBand.bdImpo = peImpo;
       endif;
       if %parms >= 11 and %addr(peSens) <> *NULL;
          dsMailBand.bdSens = peSens;
       endif;
       if %parms >= 12 and %addr(pePrio) <> *NULL;
          dsMailBand.bdPrio = pePrio;
       endif;
       if %parms >= 13 and %addr(peNotf) <> *NULL;
          dsMailBand.bdNotf = peNotf;
       endif;
       if %parms >= 14 and %addr(peSub2) <> *NULL;
          dsMailBand.bdSub2 = peSub2;
       endif;

       monitor;
         write mailBandR dsMailBand;
       on-error;
         return *off;
       endmon;

       dsMailBDes.beIdMa = dsMailBand.bdIdMa;
       for @x = 1 to 100;
         if  peTo(@x)   = *blanks
         and peToad(@x) = *blanks
         and peToty(@x) = *zeros;
           leave;
         else;
           dsMailBDes.beTo   = peTo(@x)  ;
           dsMailBDes.beToad = peToad(@x);
           dsMailBDes.beToty = peToty(@x);

           monitor;
             write mailBDesR dsMailBDes;
           on-error;
             return *off;
           endmon;
         endif;
       endfor;

       return *on;

      /end-free

     P MAIL_setMailBand...
     P                 E

