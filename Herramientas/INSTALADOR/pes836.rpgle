     *****************************************************************
     *  PES836  : Generar Json a partir de Excel                     *
     *                                                               *
     *  FECHA   : 10/09/2025                                         *
     *  AUTOR   : FABELLA IVAN MAXIMILIANO                           *
     *****************************************************************
     * MODIFICACIONES:                                               *
     *****************************************************************
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
                /copy hdiile/qcpybooks,svpval_h
                /copy hdiile/qcpybooks,SVPINT_h
                /copy hdiile/qcpybooks,hssf_h
                /copy hdiile/qcpybooks,ifsio_h
            dcl-f PES836fm workstn usropn;
            dcl-f gntpec  usage(  *input : *update : *output  ) keyed;
            dcl-f pawpec  usage(  *input : *update : *output  ) keyed;
            dcl-f gntpca  usage(  *input : *update : *output  ) keyed;
            // -----------------------------------------------------------
            //  Claves de archivos (key lists)
            // -----------------------------------------------------------
            dcl-ds k1ticc likerec(G@Tpec: *key);
            dcl-ds k1wicc likerec(P@Wpec: *key);
            dcl-ds k1wpca likerec(A@TPCA: *key);
            // -----------------------------------------------------------
            //  Prototipo
            // -----------------------------------------------------------
            dcl-pr PES836;
                peFile char(75);
                peMand char(2);
            end-pr;
            // Programa ADDCPATH
            dcl-pr ADDCPATH extpgm('TAATOOL/ADDCPATH');
            end-pr;
            // -----------------------------------------------------------
            //  Interfaz de procedimiento
            // -----------------------------------------------------------
            dcl-pi PES836;
                peFile char(75);
                peMand char(2);
            end-pi;
            // -----------------------------------------------------------
            //  Prototipos externos
            // -----------------------------------------------------------
            dcl-pr SNDMAIL extpgm('SNDMAIL');
                peCprc   char(20)           const;
                peCspr   char(20)           const;
                peMens   varchar(512)       const;
                peLmen   char(5000)         const options(*nopass : *omit);
            end-pr;
            // -----------------------------------------------------------
            //  Prototipo SELSTMF
            // -----------------------------------------------------------
            dcl-pr SELSTMF extpgm('SELSTMF');
                peDire varchar(32767) const options(*varsize : *omit);
                pePatt varchar(256)   const;
                peFile char(256);
                peTitu char(70) const options(*nopass : *omit);
            end-pr;
            // -----------------------------------------------------------
            //  Prototipo Java
            // -----------------------------------------------------------
            dcl-pr String_getBytes varchar(1024)
                extproc(*JAVA:'java.lang.String':'getBytes');
            end-pr;
            // -----------------------------------------------------------
            //  Variables y tipos (HSSF, etc.)
            // -----------------------------------------------------------
            dcl-s book    like(SSWorkbook);
            dcl-s Sheet   like(SSSheet);
            dcl-s row     like(SSRow);
            dcl-s cell    like(SSCell);

            dcl-s StrVal  varchar(200);
            dcl-s type    int(10);
            dcl-s campoExcel  varchar(200);

            dcl-s @@aux   packed(29:9);
            dcl-s @@File  char(75);
            dcl-s File    char(128);
            dcl-s @@Vsys  char(512);
            dcl-s xxfile  char(256);
            dcl-s peMens  varchar(512);
            dcl-s p@Path  varchar(256);
            dcl-s p@File  varchar(256);
            dcl-s peHoja  char(30);
            dcl-s p_info  pointer inz(*null);
            dcl-ds info1  likeds(passwd) based(p_info);
            dcl-s NumVal  float(8);
            // -----------------------------------------------------------
            //  Varios
            // -----------------------------------------------------------
            dcl-s z         packed(5:0);
            dcl-s x         int(5);
            dcl-s y         int(5);
            dcl-s hoja      int(5);
            dcl-s clave char(14) inz('JSONCONTADURIA');

            dcl-s graba     ind;
            dcl-s existe    ind;

            dcl-ds @Error dim(9999) likeds(Errores);
            // ----------------------- Empresa / Sucu ------------------------- //
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

            // -----------------------------------------------------------
            //  Template de errores
            // -----------------------------------------------------------
            dcl-ds Errores qualified template;
                HCF  char(10);
                DErr char(50);
            end-ds;
            dcl-ds FechaVigencia inz;
                campo   char(2000) pos(1);
                camp1   char(50)   pos(1);
                camp2   char(50)   pos(51);
                camp3   char(50)   pos(101);
                camp4   char(50)   pos(151);
                camp5   char(50)   pos(201);
                camp6   char(50)   pos(251);
                camp7   char(50)   pos(301);
                camp8   char(50)   pos(351);
                camp9   char(50)   pos(401);
                camp10  char(50)   pos(451);
                camp11  char(50)   pos(501);
                camp12  char(50)   pos(551);
                camp13  char(50)   pos(601);
                camp14  char(50)   pos(651);
                camp15  char(50)   pos(701);
                camp16  char(50)   pos(751);
                camp17  char(50)   pos(801);
            end-ds;
            // -----------------------------------------------------------
            //  Ahora si...
            // -----------------------------------------------------------
            /free

            *inlr = *ON;

            ADDCPATH();

            ss_begin_object_group(100);
            open pes836fm;
            exsr inz10;
            dow not *inkl;
                exsr pant01;
            enddo;
            close pes836fm;

            return;
            begsr pant01;
                exfmt pes83607;
                *in50 = *off;
                *in65 = *off;
                select;
                    when *inka;
                        exsr valiSelec;
                        if not *in50;
                            peFile = @@File;
                            exsr laburo;
                            peMand = 'KA';
                            *inkl = *on;
                        endif;
                    when *inkd;
                        SELSTMF ( *Omit : '.xlsx' : xxfile : *Omit );
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
            //Apertura del excel y grabado de datos
            begsr laburo;
                // Claves para el caso json contaduria
                k1wpca.A@NOAJ = clave;
                k1wicc.P@NOMJ = clave;
                k1ticc.G@NOMJ = clave;
                A@NOAJ        = clave;
                P@NOMJ        = clave;
                G@NOMJ        = clave;
                // ---------------------------------------
                // Abro el excel
                // ---------------------------------------
                book = ss_open( peFile );
                exsr lecturaExcel;

                campo = *blanks;
                hoja = 1;
            endsr;
            begsr lecturaExcel;
                sheet  = ssworkbook_getSheetAt( book : 0 );
                for x = 1 to 65535;
                    row = SSSheet_getRow( sheet : x );
                    if ( row = *null );
                        leave;
                    endif;
                exsr lecturaDeHoja;

                endfor;
            endsr;
            //Primer dato
            begsr lecturaDeHoja;
                select;
                    when x = 1;
                        exsr estadoEvolPatNetoREC;
                    when x = 2;
                    other;

                endsl;

            endsr;
            begsr estadoEvolPatNetoREC;
                for y = 1 to 18;
                    exsr lecturaDeColumna;
                    exsr setCampo;
                endfor;
                    //Grabo
                    k1wicc.P@ORDE = 1;
                    k1wicc.P@NOMB = 'estadoEvolPatNeto';
                    chain %kds(k1wicc) pawpec;
                    p@camp = %trim(campo);
                    if not %found;
                        write p@wpec;
                    else;
                        update p@wpec;
                    endif;
            endsr;
            //Lee la columna
            begsr lecturaDeColumna;
                cell = SSRow_getCell( row : y-1 );
                if (cell <> *null);
                    type = SSCell_getCellType(cell);
                    select;
                        when type = CELL_TYPE_NUMERIC;
                        NumVal = SSCell_getNumericCellValue(cell);
                        campoExcel = %char(%dec(NumVal:15:2));
                        when type = CELL_TYPE_STRING;
                        campoExcel =
                            String_getBytes( SSCell_getStringCellValue(cell));
                    endsl;
                endif;
            endsr;
            //Graba el campo en la tabla
            begsr setCampo;
                select ;
                    when y = 1;
                        camp1  = campoExcel;
                    when y = 2;
                        camp2  = campoExcel;
                    when y = 3;
                        camp3  = campoExcel;
                    when y = 4;
                        camp4  = campoExcel;
                    when y = 5;
                        camp5  = campoExcel;
                    when y = 6;
                        camp6  = campoExcel;
                    when y = 7;
                        camp7  = campoExcel;
                    when y = 8;
                        camp8  = campoExcel;
                    when y = 9;
                        camp9  = campoExcel;
                    when y = 10;
                        camp10 = campoExcel;
                    when y = 11;
                        camp11 = campoExcel;
                    when y = 12;
                        camp12 = campoExcel;
                    when y = 13;
                        camp13 = campoExcel;
                    when y = 14;
                        camp14 = campoExcel;
                    when y = 15;
                        camp15 = campoExcel;
                    when y = 16;
                        camp16 = campoExcel;
                    when y = 17;
                        camp17 = campoExcel;
                endsl;
            endsr;
            //Busco en el directorio principal del usr
            begsr inz10;

                clear x2File;
                clear p@Path;
                clear p@File;
                p_info = getpwnam(%trimr(@PsDs.CurUsr));
                if p_info <> *NULL;
                x2hdir = %str(info1.pw_dir);
                endif;

            endsr;
            //Valido el excel
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

                @@File = %trim(x2hdir) + '/' + %trim(x2File);
                endif;

            endsr;
            /end-free
