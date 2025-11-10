        ctl-opt
          actgrp(*caller)
          bnddir('INSTALADOR/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *               Mueve los fuentes segun tabla                   *
     *               Para hacer el codigo mas limpio, las firmas y   *
     *               algunas variables que pueden ser globales, son  *
     *               declaradas en la hoja H                         *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpinst_h
        // -----------------------------------------------------------
        //  Prototipo
        // -----------------------------------------------------------
        dcl-pr PGGFUE;
            desa char(10);
            secu packed(2:0);
        end-pr;
        // -----------------------------------------------------------
        //  Interfaz
        // -----------------------------------------------------------
        dcl-pi PGGFUE;
            desa char(10);
            secu packed(2:0);
        end-pi;
        // -----------------------------------------------------------
        //  Interfaz
        // -----------------------------------------------------------
        dcl-ds uds qualified dtaara(*lda);
            usempr char(1) pos(401);
            ussucu char(2) pos(402);
        end-ds;
        dcl-ds @PsDs psds qualified;
            this   char(10)   pos(1);
            Job    char(26)   pos(244);
            JobNam char(10)   pos(244);
            JobUsr char(10)   pos(254);
            JobNum zoned(6:0) pos(264);
            CurUsr char(10)   pos(358);
        end-ds;
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
            *inlr = *on;
            inicializar();
            setll %kds(k1tsrc:4) setsrc;
            reade %kds(k1tsrc:4) setsrc;
            dow not %eof(setsrc);
                if s1marf = '0';
                    mueve();
                    if secu <> -1;
                        graba();
                    endif;
                endif;
                reade %kds(k1tsrc:4) setsrc;
            enddo;
            return;
        /end-free
     * ------------------------------------------------------------- *
      *   Procedimiento: mueve
     * - ----------------------------------------------------------- *
        dcl-proc mueve;
            monitor;
                //callp MOVSRCMBRC(fromfile: tofile: s1nfue);
                callp MVSRCWBKP(fromfile: tofile: s1nfue);
            on-error;
                secu = -1;
            endmon;
        end-proc;
     * ------------------------------------------------------------- *
      *   Procedimiento: graba
     * - ----------------------------------------------------------- *
        dcl-proc graba;
            s1marf = '1';
            S1ECH1 = %dec(%date(): *iso);
            s1date = udate;
            s1time = %dec(%time);
            s1ausu = @PsDs.CurUsr;
            update s1tsrc;
        end-proc;
     * ------------------------------------------------------------- *
      *    inzr
     * - ----------------------------------------------------------- *
        dcl-proc inicializar;
            in uds;
            k1tsrc.S1EMPR = uds.usempr;
            k1tsrc.S1SUCU = uds.ussucu;
            k1tsrc.S1desa = desa;
            k1tsrc.S1SECU = %dec(secu:2:0);
        end-proc;
