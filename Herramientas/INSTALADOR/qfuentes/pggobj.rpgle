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
      // -----------------------------------------------------------
      *   Cuerpo Principal.
      // -----------------------------------------------------------
      /free
        *inlr = *on;
          inicio();
          chkobj();
          if not bloqueado;
            muevoObj();
          else;
            ERROBJ = s1nfue;
            secu   = 0;
            exfmt ERROBJLCK;
          endif;
      /end-free
     ******************************************************
      /SPACE
     ******************************************************
        dcl-proc inicio;
          k1tsrc.s1empr = usempr;
          k1tsrc.s1sucu = ussucu;
          k1tsrc.s1desa = desa;
          k1tsrc.s1secu = %dec(secu:2:0);
          obj           = s1nfue;
          libobj        = s1objl;
          cmd           = 'ADDLIBLE LIB(INSTALTEMP) POSITION(*FIRST)';
          svpapi_RunCl(cmd);
        end-proc;
     ******************************************************
      /SPACE
     ******************************************************
        dcl-proc chkobj;
          setll %kds ( k1tsrc:4 ) setsrcpf ;
          reade %kds ( k1tsrc:4 ) setsrcpf ;
          dow not %eof;
            //si hay algun obj bloqueado me voy
            if svpapi_chkStatusObj(objlck);
              bloqueado = *on;
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
                CPYPFLG( s1nfue );
              endif;
              s1maro = '1';
              update s1tsrc;
              reade %kds ( k1tsrc:4 ) setsrc ;
            enddo;
        end-proc;

