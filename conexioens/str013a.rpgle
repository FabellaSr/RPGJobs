      // -------------------------------------------------------- //
      // STR013A: Inspecciones Siniestros.                        //
      //                                                          //
      // -------------------------------------------------------- //
      //  Fabella Ivan                              03/09/2025    //
      // -------------------------------------------------------- //
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
        // --------------------------- copys ..--------------------------- //
      /copy *libl/qcpybooks,spwliblc_h
        // ---------------------- Chequeo procesos ----------------------- //
        dcl-f  set915 usage(*input) keyed;
        dcl-ds k1y915 likerec(s1t915:*key);
        // -------------------- Interfaz de programa --------------------- //
        dcl-pr STR013A extpgm('STR013A');
          pXIdpr ind;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pr;
        dcl-pi STR013A;
          pXIdpr ind;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pi;
        // -------------------- Interfaz de programa ---------------------- //
        // --------------------     de validacion    ---------------------- //
        dcl-pr STR013 extpgm('*LIBL/STR013');
          pXIdpr ind;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pr;
        // --------------------       Entorno       ----------------------- //
        dcl-pr ADDCFNE1 extpgm('TAATOOL/ADDCFNE1');
        end-pr;
        // ----------------------------------------------------------------
        // MAIN
        // ----------------------------------------------------------------
        *inlr = *on;
        k1y915.t@empr = peEmpr;
        k1y915.t@sucu = peSucu;
        k1y915.t@tnum = 'PI';
        pXIdpr = *OFF;
        chain %kds(k1y915:3) set915;
        if %found(set915);
            spwliblc('P');
            //Entorno
            ADDCFNE1();
            //Programa!
            STR013( pXIdpr
                  : peEmpr
                  : peSucu
                  : peSini
                  : peRama);
        endif;


        return;

