     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('INSTALADOR/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *               Mueve los PGGOBJ  segun tabla                   *
     *               Para hacer el codigo mas limpio, las firmas y   *
     *               algunas variables que pueden ser globales, son  *
     *               declaradas en la hoja H                         *
     *  https://wiki.rpgnextgen.com/doku.php?id=check_object_lock    *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpinst_h
      /copy instalador/qcpybooks,svpapi_h
        dcl-f paninsFm workstn;
     * - ----------------------------------------------------------- *
     *Empresa/Sucursal
     * - ----------------------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403
      // -----------------------------------------------------------
      //  Prototipo
      // -----------------------------------------------------------
        dcl-pr PGGOBJ;
          desa char(10);
          secu packed(2:0);
        end-pr;
      // -----------------------------------------------------------
      //  Interfaz
      // -----------------------------------------------------------
        dcl-pi PGGOBJ;
          desa char(10);
          secu packed(2:0);
        end-pi;
     * - ----------------------------------------------------------- *
      *   Cuerpo Principal.
     * - ----------------------------------------------------------- *
      /free
        *inlr = *on;
          k1tsrc.s1empr = usempr;
          k1tsrc.s1sucu = ussucu;
          k1tsrc.s1desa = desa;
          k1tsrc.s1secu = %dec(SECU:2:0);
          cmd = 'ADDLIBLE LIB(INSTALTEMP) POSITION(*FIRST)';
          monitor;
            qCmdExc( %trim(cmd) : %len(%trim(cmd)) );
          on-error;
            *in50 = *on;
          endmon;
          //chkobj();
          if not bloqueado;
            muevoObj();
          else;
            ERROBJ = s1nfue;
            exfmt ERROBJLCK;
            secu = 0;
          endif;
      /end-free
     ******************************************************
      /SPACE
     ******************************************************
        dcl-proc chkobj;
          setll %kds ( k1tsrc:4 ) setsrcpf ;
          reade %kds ( k1tsrc:4 ) setsrcpf ;
          dow not %eof;
            chkobjlck();
            if bloqueado;
              leave;
            endif;
            reade %kds ( k1tsrc:4 ) setsrcpf ;
          enddo;
        end-proc;
     ******************************************************
      /SPACE
     ******************************************************
        dcl-proc muevoObj;
            setll %kds ( k1tsrc:4 ) setsrc ;
            reade %kds ( k1tsrc:4 ) setsrc ;
            dow not %eof;
              if s1attr <> 'PF';
                svpapi_movobj( s1objl
                             : s1nfue
                             : s1flib
                             : s1tlib
                             : s1tipo );
              else;
                svpapi_movfil( s1objl
                             : s1nfue
                             : s1flib
                             : s1tipo );
              endif;
              s1maro = '1';
              update s1tsrc;
              reade %kds ( k1tsrc:4 ) setsrc ;
            enddo;
        end-proc;
     ******************************************************
      /SPACE
     ******************************************************
        dcl-proc chkobjlck;
          obj    = s1nfue;
          libobj = s1objl;
          //if svpapi_chkStatusObj(objlck);

         // endif;
        end-proc;
