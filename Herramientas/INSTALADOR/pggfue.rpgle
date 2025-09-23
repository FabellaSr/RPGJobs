     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *               Mueve los fuentes segun tabla                   *
     *               Para hacer el codigo mas limpio, las firmas y   *
     *               algunas variables que pueden ser globales, son  *
     *               declaradas en la hoja H                         *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpinst_h
       //  /copy instalador/qcpybooks,svpcfg_h
     * - ----------------------------------------------------------- *
      *  PGGFUE
     * - ----------------------------------------------------------- *
     D PGGFUE          pr
     D                               10
     D                                2  0
     D PGGFUE          pi
     D desa                          10
     D secu                           2  0
     * - ----------------------------------------------------------- *
     *Empresa/Sucursal
     * - ----------------------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
            inicializar();
            setll %kds(k1tsrc:4) setsrc;
            reade %kds(k1tsrc:4) setsrc;
            dow not %eof(setsrc);
                mueve();
                graba();
                reade %kds(k1tsrc:4) setsrc;
            enddo;
          return;
        /end-free
     * ------------------------------------------------------------- *
      *   Procedimiento: mueve
     * - ----------------------------------------------------------- *
        dcl-proc mueve;
            callp MOVSRCMBRC(fromfile: tofile: s1nfue);
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
            k1tsrc.S1EMPR = usempr;
            k1tsrc.S1SUCU = ussucu;
            k1tsrc.S1desa = desa;
            k1tsrc.S1SECU = %dec(secu:2:0);
        end-proc;
