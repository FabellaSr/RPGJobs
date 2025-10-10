      /if defined(SVPINST_H)
      /eof
      /endif
      /define SVPINST_H

            // ----------------------------------------------------
            //  Archivos
            // ----------------------------------------------------
            dcl-f setsrc    usage(*input : *update : *output) keyed;
            dcl-f setins    usage(*input : *update : *output) keyed;
            dcl-f setins01  usage(*input : *update : *output)
                             rename(SITINS:SITINS01) keyed;
            dcl-f setsrcpf  usage(*input) keyed rename(S1TSRC:SPTSRC);

            // ----------------------------------------------------
            //  Generales
            // ----------------------------------------------------

            // ----------------------------------------------------
            //  keyS
            // ----------------------------------------------------
            dcl-ds k1tsrc  likerec(S1TSRC: *key) ;
            dcl-ds k1tins  likerec(SITINS: *key) ;

            dcl-ds @@Dssrc likerec(S1TSRC: *input) ;
            dcl-ds @@Dsins likerec(SITINS: *input) ;
            // ----------------------------------------------------
            //  Estructura para llamar al MOVSRC
            // ----------------------------------------------------
            dcl-pr MOVSRCMBRC extpgm('MOVSRCMBRC');
            FFIL char(20);
            TFIL char(20);
            MBR  char(10);
            end-pr;
            // ----------------------------------------------------
            //  Generales
            // ----------------------------------------------------
            // A partir de acá, variables específicas de cada PGM

            // ----------------------------------------------------
            //  Estructura para llamar al FUENTESB
            // ----------------------------------------------------
            // dcl-pr INSTALFUEN extpgm('FUENTESB'); end-pr;   // (comentado como en el original)

            dcl-pr PGGFUENTES extpgm('PGGFUE');
                  desa char(10);
                  secu packed(2:0);
            end-pr;

            // ----------------------------------------------------
            //  Estructura para llamar al FUENTESA
            // ----------------------------------------------------
            // dcl-pr LECTURAINST extpgm('PGGINST1'); end-pr; // (comentado)

            dcl-pr PGGLECTURA extpgm('PGGLEC');
                  desa char(10);
                  secu packed(2:0);
                  deta char(50);
            end-pr;

            // ----------------------------------------------------
            //  Estructura para llamar al OBJETOS
            // ----------------------------------------------------
            // dcl-pr INSTALOBJ extpgm('OBJETOS'); end-pr;    // (comentado)

            dcl-pr PGGOBJETOS extpgm('PGGOBJ');
            desa char(10);
            secu packed(2:0);
            end-pr;

            // ----------------------------------------------------
            //  Estructura para llamar al procinst
            // ----------------------------------------------------
            dcl-pr INSTCOMP extpgm('INSTCOM');
            desa        char(10);
            desc        char(50);
            flaotipoinst ind;
            estado       ind;
            end-pr;

            dcl-s estoyEn       char(10);
            dcl-s retornoSecu   packed(2:0);
            dcl-s paso          int(10) inz(1);
            dcl-s parasf        ind     inz(*on);
            dcl-s asteri        char(10) inz('*         ');

            // ----------------------------------------------------
            //  FUENTESA
            // ----------------------------------------------------
            dcl-ds QFileDS;
            qfile char(10) pos(1);
            q     char(1)  pos(1) inz('Q');
            file  char(9)  pos(2);
            end-ds;

            dcl-ds conf_ins;
            tlib char(10) pos(1);
            LIBO char(10) pos(11);
            tfil char(10) pos(21);
            end-ds;

            dcl-s @@vsys      char(512);
            // dcl-s FLIB     char(10);    // (comentado como en el original)
            dcl-s tipoInst    ind inz(*off);
            dcl-s estadoInst  ind;
            dcl-s x           int(10);

            // DS con campos superpuestos (longitudes según posiciones)
            dcl-ds Datos1 inz;
            cadena char(100) pos(1);
            nomfue char(10)  pos(2);
            esws   char(2)   pos(2);
            tipo   char(10)  pos(12);
            end-ds;

            // ----------------------------------------------------
            //  FUENTESA
            // ----------------------------------------------------


            // ----------------------------------------------------
            //  FUENTESB
            // ----------------------------------------------------

            dcl-ds FromFileDS;
                  fromfile char(20) pos(1);
                  S1FFIL   char(10) pos(1);
                  S1FLIB   char(10) pos(11);
            end-ds;

            dcl-ds ToFileDS;
                  tofile char(20) pos(1);
                  S1tfil char(10) pos(1);
                  S1tLIB char(10) pos(11);
            end-ds;

            // ----------------------------------------------------
            //  FUENTESB
            // ----------------------------------------------------


            // ----------------------------------------------------
            //  OBJETOS
            // ----------------------------------------------------
            dcl-s bloqueado  ind     inz(*off);
            dcl-s formato    char(8) inz('OBJL0100');
            dcl-s objType    char(10) inz('*FILE');
            dcl-s rcvVar     char(32767);
            dcl-s rcvVarLen  int(10);
            dcl-s tipoObj    char(10);
            dcl-s srvpgm     ind inz(*off);

            dcl-ds ObjLcks;
                  objlck char(20) pos(1);
                  obj    char(10) pos(1);
                  libobj char(10) pos(11);
            end-ds;
            // ---------------------------------------------------
            //  OBJETOS
            // ----------------------------------------------------
