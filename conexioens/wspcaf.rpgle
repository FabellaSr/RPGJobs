     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')

     D CALLPGM         pr                  ExtPgm('DESA_0859/WSPCAF')

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const

     D cmd             s            500a

     D request         ds                  likeds(WSPCAF_t) inz


     D fd              s             10i 0
     D e               s          65535a
     D peMsgs          ds                  likeds(paramMsgs)

      /copy desa_0859/qcpybooks,cartaf_H
      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy hdiile/qcpybooks,ifsio_h
      /copy hdiile/qcpybooks,cowlog_h

      /free

        *inlr = *on;

        wslog(@psds.job);
       //leep(25);
        cmd = 'ADDLIBLE LIB(DESA_0859) POSITION(*FIRST)';
        monitor;
         qCmdExc( %trim(cmd) : %len(%trim(cmd)) );
         on-error;
           *in50 = *on;
        endmon;

       // Inicio
        options = 'path=cartaDeFranquicia ' +
                  'case=any allowextra=yes allowmissing=yes';

       // Lectura y Parseo

        rc = REST_readStdInput( %addr(buffer): %len(buffer) );

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'WSPCAF_t';
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RPG0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : 'RPG0001'
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endmon;

        e = 'WSPCAF_BODY=X';
        putenv(e);

        unlink('/tmp/WSPCAF.xml');
        fd = open( '/tmp/WSPCAF.xml'
                 : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                  +O_TEXTDATA+O_TEXT_CREAT
                 : M_RWX
                 : 819
                 : 0 );
        callp write( fd : %addr(buffer) : %len(%trim(buffer)) );
        callp close(fd);

        CALLPGM();

       return;

