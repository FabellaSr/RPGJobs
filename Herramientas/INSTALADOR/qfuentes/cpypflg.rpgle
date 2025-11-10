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
      /copy instalador/qcpybooks,svpapi_h
      /copy instalador/qcpybooks,svpcfg_h
      /copy hdiile/qcpybooks,svpvls_H
        // -----------------------------------------------------------
        //  Interfaz
        // -----------------------------------------------------------
        dcl-pi CPYPFLG;
          peNfue char(10);
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
          in uds;
          //Parche
          armaLib();
          //Segun valsys
          getVariables();
          //limpio el PF dodne van a estar los logicos
          clrlogicos();
          //Borro el pf de logicos creado,
          dltdbr();
          //Creo el dspdbr
          dspdbr();
          //Ahora copio el resultado de lo anterior
          //al pf logicos
          cpyf();
          //Borro dependencia de logicos
          dltdeplog();
          //Remplazo el objeto PF
          remplazoFisico();
          //Y ahora vamos a por los logicoz
          setll *start logicos;
          read logicos;
          dow not %eof(logicos);
               crtlgf();
               read logicos;
          enddo;
          //Borro el archivo "nuevo" que queda en testgaus
          dltf();
          return;
        /end-free
     * ------------------------------------------------------------- *
      *    getVariables
     * - ----------------------------------------------------------- *
        dcl-proc armaLib;
          //PARCHE MOMENTANEO
          cmd = 'ADDLIBLE LIB(INF1IVANPR)';
          svpapi_RunCl(cmd);
          cmd = 'ADDLIBLE LIB(INSTALADOR) POSITION(*FIRST)';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    getVariables
     * - ----------------------------------------------------------- *
        dcl-proc getVariables;
          SVPVLS_getValSys('LIBLOGICOS': *omit : @@vsys);
          conf_logicos    = %trim(@@vsys);
          SVPVLS_getValSys('LIBSRCINST': *omit : @@vsys);
          conf_liblogicos = %trim(@@vsys);
        end-proc;
     * ------------------------------------------------------------- *
      *    clrlogicos
     * - ----------------------------------------------------------- *
        dcl-proc clrlogicos;
          cmd = 'CLRPFM FILE('+ liblogicos +'/'+ pflogico +')';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    dltdbr
     * - ----------------------------------------------------------- *
        dcl-proc dltdbr;
          cmd = 'DLTF FILE('+ liblogicos +'/DSPDBR)';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    dspdbr
     * - ----------------------------------------------------------- *
        dcl-proc dspdbr;
          cmd = 'DSPDBR FILE('+ libEnd +'/'+ peNfue +') '+
                'OUTPUT(*OUTFILE) ' +
                'OUTFILE('+ liblogicos +'/DSPDBR)';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    cpyf
     * - ----------------------------------------------------------- *
        dcl-proc cpyf;
          cmd = 'CPYF FROMFILE('+ liblogicos +'/DSPDBR) ' +
                'TOFILE('+ liblogicos +'/'+ pflogico +') MBROPT(*ADD)';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    dltdeplog
     * - ----------------------------------------------------------- *
        dcl-proc dltdeplog;
          cmd = 'DLTDEPLGL FILE('+ libEnd +'/'+ peNfue +')';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    crtlgf
     * - ----------------------------------------------------------- *
        dcl-proc crtlgf;
          cmd = 'CRTLF FILE('+ libEnd +'/'+ WHREFI +')' +
                ' SRCFILE('+ libSrc+'/'+ srcFue +')';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    remplazoFisico
     * - ----------------------------------------------------------- *
        dcl-proc remplazoFisico;
          //Primero renombro el existente
          cmd = 'RNMOBJ OBJ('+ libEnd +'/'+ peNfue +')' +
                ' OBJTYPE(*FILE) NEWOBJ('+%trim(peNfue)+'_)';
          svpapi_RunCl(cmd);//ACA LE PONGO _ AL PRODUCTIVO
          //Segundo hago el dup del nuevo
          cmd = 'CRTDUPOBJ OBJ('+ peNfue +') FROMLIB(instalador)'+
                ' OBJTYPE(*FILE) TOLIB('+ libEnd +')';
          svpapi_RunCl(cmd);
          //Copio los datos
          cmd = 'CPYF FROMFILE('+ libEnd +'/'+%trim(peNfue)+'_) ' +
                'TOFILE('+ libEnd +'/' + peNfue +') MBROPT(*REPLACE) ' +
                'FMTOPT(*MAP *DROP)';
          svpapi_RunCl(cmd);
        end-proc;
     * ------------------------------------------------------------- *
      *    dltf
     * - ----------------------------------------------------------- *
        dcl-proc dltf;
          cmd = 'DLTF FILE('+ libEnd +'/'+%trim(peNfue)+'_) ';
          svpapi_RunCl(cmd);
        end-proc;
