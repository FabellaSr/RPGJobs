     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')

     D CALLPGM         pr                  ExtPgm('CALCULADOR/WSPCAL')

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const

     D cmd             s            500a
     D psds           sds                  qualified
     D  job                          26a   overlay(psds:244)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6a   overlay(PsDs:264)
     * ---------------------------------------------------- *
      * Estrucutura para recibr datos post/get
     * ---------------------------------------------------- *
     D wspcal_t        ds                  qualified template
     D  base                               likeds(paramBaseA)
     D   peNum1                       5  0
     D   peNum2                       5  0
     D   peTcal                       1a
     D request         ds                  likeds(wspcal_t) inz

     D buffer          s          65535a
     D options         s            100a
     D rc1             s             10i 0
     D fd              s             10i 0
     D e               s          65535a
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)


      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy hdiile/qcpybooks,ifsio_h
      /copy hdiile/qcpybooks,cowlog_h

      /free

        *inlr = *on;

        wslog(psds.job);
       //leep(25);
        cmd = 'ADDLIBLE LIB(CALCULADOR) POSITION(*FIRST)';
        monitor;
         qCmdExc( %trim(cmd) : %len(%trim(cmd)) );
         on-error;
           *in50 = *on;
        endmon;

       // Inicio
        options = 'path=calculadora ' +
                  'case=any allowextra=yes allowmissing=yes';

       // Lectura y Parseo

        rc1= REST_readStdInput( %addr(buffer): %len(buffer) );

        monitor;
          xml-into request %xml(buffer : options);
        on-error;
          @@repl = 'wspcal_t';
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

        e = 'WSPCAL_BODY=X';
        putenv(e);

        unlink('/tmp/wspcal.xml');
        fd = open( '/tmp/wspcal.xml'
                 : O_CREAT+O_EXCL+O_WRONLY+O_CCSID
                  +O_TEXTDATA+O_TEXT_CREAT
                 : M_RWX
                 : 819
                 : 0 );
        callp write( fd : %addr(buffer) : %len(%trim(buffer)) );
        callp close(fd);

        CALLPGM();

       return;

