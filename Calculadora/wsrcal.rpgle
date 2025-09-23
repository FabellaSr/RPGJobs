     H option(*srcstmt:*noshowcpy) actgrp(*caller) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      *                                                              *
      * ------------------------------------------------------------ *
      *                                      11/01/2022              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy hdiile/qcpybooks,rest_h
      /copy hdiile/qcpybooks,svprest_h
      /copy HDIILE/QCPYBOOKS,COWLOG_H
     D CALLPGM         pr                  ExtPgm('CALCULADOR/WSRCAL')

     D qCmdExc         pr                  ExtPgm('QCMDEXC')
     D  peCmd                     65535a   const options(*varsize)
     D  peLen                        15  5 const
     D cmd             s            500a
     D e               s          32766a
     D buffer          s          65535a
     D options         s            100a
     D psds           sds                  qualified
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6a   overlay(PsDs:264)

     D @@repl          s          65535a

     D rc1             s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
       /free
        *inlr = *on;
        // sleep(10);
        cmd = 'ADDLIBLE LIB(calculador)';
         monitor;
           qCmdExc( %trim(cmd) : %len(%trim(cmd)) );
          on-error;
            *in50 = *on;
        endmon;
          CALLPGM();
       //return;
       /end-free
