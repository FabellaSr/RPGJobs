     H dftactgrp(*NO) actgrp('PJENN')
     H option(*srcstmt: *nodebugio: *noshowcpy: *nounref)
     H thread(*serialize)
     H bnddir('HDIILE/HDIBDIR')
     ********************************************************************
     *   SISTEMA:  GAUS         APLICACION:  Producción por Artículos   *
     *   ------------------------------------------------------------   *
     *   PES257:     PROCESO GENERACION AUTOMATICA DE SELECCION DE      *
     *               personas con orden congelamiento activos           *
     *                                                                  *
     *   AUTOR: CARLOS AGUILAR                                          *
     *   FECHA: 19/09/2025                                              *
     *   DESA_0915                                                     *
     ********************************************************************
     Fpes257fm  cf   e             workstn usropn
     Fpew257    if a e           k disk

      /copy hdiile/qcpybooks,hssf_h
      /copy hdiile/qcpybooks,mail_h
      /copy hdiile/qcpybooks,ifsio_h

     D PES257          pr
     D  peFile                       75a
     D  peMand                        2a

     D PES257          pi
     D  peFile                       75a
     D  peMand                        2a

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D SELSTMF         pr                  ExtPgm('SELSTMF')
     D  peDire                    32767a   varying const
     D                                     options(*varsize : *omit)
     D  pePatt                      256a   varying const
     D  peFile                      256a
     D  peTitu                       70a   const options(*nopass:*omit)

     D ADDCPATH        pr                  ExtPgm('TAATOOL/ADDCPATH')

     D PES260          pr                  extpgm('PES260')
     D  tido                          2
     D  nrdo                          8
     D  nomb                         40

     D system          pr            10i 0 extproc('system')
     D   icmd                          *   value options(*string)
      /copy hdiile/qcpybooks,hssf_h
      /copy hdiile/qcpybooks,csv_h

     D String_getBytes...
     D                 pr          1024a   varying
     D                                     extproc(*JAVA:
     D                                     'java.lang.String':
     D                                     'getBytes')

     D book            s                   like(SSWorkbook)
     D Sheet           s                   like(SSSheet)
     D row             s                   like(SSRow)
     D cell            s                   like(SSCell)
     D @@Vsys          s            512a

     D m               s             10i 0
     D x               s             10i 0
     D @tipdocumento   s              3a   varying
     D @nrodocumento   s              8a   varying
     D @nombre         s             40a   varying
     D @movimientos    s            256a   varying
     D csvfile         s                   like(csv_handle)
     D @Separ          s              1a
     D @Nrodo          s              8a
     D @tipdo          s              2a
     D y               s             10i 0
     D @@femi          s              8s 0
     D @@fpro          s              8s 0
     D z               s             10i 0
     D peTalt          s              1a
     D peTbaj          s              1a
     D peTcam          s              1a
     D peTcon          s              1a
     D peNaut          s              1  0
     D peRtrn          s              1a
     D recnum          s              2  0
     D wfmto           s              2a

     D f               s              8  0
     D hoy2            s              8  0
     D grImpa          s              8  0
     D grFimp          s              8  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D file            s            128a
     D xxfile          s            256a
     D p@Path          s            256a   varying
     D p@File          s            256a   varying
     D @@File          s             75a
     D @@Mand          s              2a

     D p_info          s               *
     D info1           ds                  likeds(passwd)
     D                                     based(p_info)

     D info            ds
     D cfkey                 369    369
     D enter           c                   const(X'F1')

     D @psds          sds                  qualified
     D  CurUsr                       10a   overlay(@psds:358)

     D                uds
     D usempr                401    401
     D ussucu                402    403


      /free

       *inlr = *on;
       PAR310X3( usempr
               : peFema
               : peFemm
               : peFemd );

       hoy2 = (peFema * 10000)
            + (peFemm *   100)
            +  peFemd;

       open pes257fm;
       exsr inz10;
       dow not *inkl;
         exsr pant01;
       enddo;
       close pes257fm;

       eval *inlr= *on;

       begsr pant01;

           exfmt pes25707;

           exsr apagar;
           select;
             when *inka;
               exsr valiSelec;
               if not *in50;
                 peFile = @@File;
                 peMand = 'KA';
                 exsr genplani;
                 *inkl = *on;
               endif;

             when *inkd;
               SELSTMF ( *Omit : '.csv' : xxfile : *Omit );
               p@Path = xxfile;
               if MAIL_GetIfsFile ( p@Path : p@File ) = 0;
                 x2File = p@File;
               endif;

             When *inkl;
               peMand = 'KC';

             other;
               exsr valiSelec;
           endsl;

       endsr;

       begsr inz10;

         clear x2File;
         clear p@Path;
         clear p@File;
         p_info = getpwnam(%trimr(@PsDs.CurUsr));
         if p_info <> *NULL;
           x2hdir = %str(info1.pw_dir);
         endif;

       endsr;

       begsr valiSelec;

         if not *in50;
           file = %trim(x2hdir)
                + '/'
                + %trim(x2file);
           if access( %trim(file) : F_OK ) < 0
              or x2file = *blanks;
             *in50 = *on;
             *in65 = *on;
             leavesr;
           endif;

           @@File = %trim(x2hdir) + %trim(x2File);
         endif;

       endsr;

       begsr apagar;



       endsr;

       begsr genplani;
        x = 0;
        clear @separ;

         @Separ = ';';
        csvfile = csv_open( %trim(peFile) : *omit : *omit : @Separ );
        dow csv_loadrec(csvfile);

         x += 1;

         if x > 1;

           csv_getfld(csvfile: @tipdocumento: %size(@tipdocumento));
           csv_getfld(csvfile: @nrodocumento: %size(@nrodocumento));
           csv_getfld(csvfile: @nombre:       %size(@nombre));
           csv_getfld(csvfile: @movimientos:  %size(@movimientos));

           exsr CargData;

         endif;

        enddo;

        csv_close(csvfile);
       endsr;
     ****************************************************************
       begsr CargData;
          pTipDo =  @tipdocumento;
          monitor;
          eval      pNroDo = %dec( @nrodocumento: 8 : 0);
          on-error;
          eval      pNrodo = 0;
          endmon;
          pNombr =  @nombre;
          pMovim =  @movimientos;
          pNomor =  *blanks;
            write p1w257;

       endsr;
