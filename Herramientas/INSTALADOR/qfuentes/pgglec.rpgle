     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('INSTALADOR/HDIBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *               Primer paso de instalaciones.                   *
     *               Este pgm usa apis de IBM para guardar en una    *
     *               estructura los fuentes de un determinado qsrcpf *
     *               El objetivo de este pgm es guardar en la tabla  *
     *               setsrc los fuentes encontrados con su tipo para *
     *               determinar donde se instalar el fuente y el obj *
     *               Se deja documentado el link donde se encuentra  *
     *               el codigo original utilizado para apis          *
     *               Para hacer el codigo mas limpio, las firmas y   *
     *               algunas variables que pueden ser globales, son  *
     *               declaradas en la hoja H                         *
     *       https://www.ibm.com/docs/es/i/7.5.0?topic=type-examples *
     * ------------------------------------------------------------- *
      /copy instalador/qcpybooks,svpapi_h
      /copy instalador/qcpybooks,svpinst_h
      /copy hdiile/qcpybooks,svpvls_h
     FpaninsFm  cf   e             workstn
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
     D PGGLEC          pr
     D                               10
     D                                2  0
     D                               50
     D PGGLEC          pi
     D DESA                          10
     D SECU                           2  0
     D deta                          50
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
          primero();
          //Levanto info de la instalacion.
          callApis();
          //Secuencia de instalacion
          secuencia();
          grabaIns();
          for x = 1 to pxeDsCMbr;
               cadena = %trim(pxDsMbr(x).MBRNAME);
               casos();
               graba();
          endfor;
          if secu = 0;
               exfmt FUENTEAERR;
          endif;

          return;
        /end-free
     * - ----------------------------------------------------------- *
      *  Primero lo
     * - ----------------------------------------------------------- *
          dcl-proc primero;
               SECU = 0;
               k1tsrc.s1empr = usempr;
               k1tsrc.s1sucu = ussucu;
               k1tsrc.s1desa = desa;
               //para APIs
               SVPVLS_getValSys('INSTALTEMP': *omit : @@vsys);
               file  = desa;
               flib  = %trim(@@vsys);
               ffile = qfile;
          end-proc;
     * - ----------------------------------------------------------- *
      *  Calculo secuencia
     * - ----------------------------------------------------------- *
          dcl-proc secuencia;
               chain %kds(k1tsrc:3) setsrc;
               if not %found;
                    s1secu = 1;
               else;
                    setgt %kds(k1tsrc:3) setsrc;
                    readpe(n) %kds(k1tsrc:3) setsrc @@Dssrc;
                    s1secu = @@Dssrc.s1secu + 1;
               endif;
               SECU = s1secu;
          end-proc;
     * - ----------------------------------------------------------- *
      *  Levantamos desde las apis
     * - ----------------------------------------------------------- *
          dcl-proc callApis;
               if not svpapi_loadMemToLib(FILE_LIB:pxDsMbr:pxeDsCMbr);
                    exfmt FUENTEAERR;
                    return;
               endif;
          end-proc;
     * - ----------------------------------------------------------- *
      *  casos - determina si se usa INSTALACPF o INSTALAPGM
     * - ----------------------------------------------------------- *
          dcl-proc casos;
               select;
               when tipo = 'PF' or tipo = 'LF';
                    if SVPVLS_getValSys('INSTALACPF': *omit : @@vsys);
                         conf_ins = %trim(@@vsys);
                    endif;
               other;
                    if SVPVLS_getValSys('INSTALAPGM': *omit : @@vsys);
                         conf_ins = %trim(@@vsys);
                    endif;
               endsl;
               if esWs = 'WS';
                 //   libo = 'QUOMDATA';
               endif;
          end-proc;
     * - ----------------------------------------------------------- *
      * graba - inserta registro en la tabla
     * - ----------------------------------------------------------- *
          dcl-proc graba ;
               s1empr = usempr;
               s1sucu = ussucu;
               s1marf = '0';
               s1marO = '0';
               //From
               s1ffil = %trim(qfile);
               s1flib = flib;
               //to
               s1tlib = tlib;
               s1tfil = tfil;
               //nombre fuente
               s1nfue = nomfue;
               //se mueve a...
               s1objl = libo;
               svpapi_getTypeAndAttributeObj( s1nfue
                                            : s1flib
                                            : s1tipo
                                            : s1attr);
               s1echa = %dec(%date():*iso);
               fech   = %dec(%date():*iso);
               s1anio = feca;
               s1fmes = fecm;
               s1fdia = fecd;
               s1desa = desa;
               s1ech1 = %dec(%date():*iso);
               s1ausu = @PsDs.CurUsr;
               s1date = udate;
               s1time = %dec(%time);
               write s1tsrc;
          end-proc;
     * - ----------------------------------------------------------- *
      * grabaIns - inserta registro en la tabla
     * - ----------------------------------------------------------- *
        dcl-proc grabaIns;
               SIEMPR = usempr;
               SISUCU = ussucu;
               SIINST = desa;
               sideta = deta;
               sidate = udate;
               sitime = %dec(%time);
               siausu = @PsDs.CurUsr;
               sisecu = %dec(SECU:2:0);
               write sitins;
        end-proc;
