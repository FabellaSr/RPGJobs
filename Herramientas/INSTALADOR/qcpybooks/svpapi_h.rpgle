      /if defined(SVPAPI_H)
      /eof
      /endif
      /define SVPAPI_H
            // - ----------------------------------------------------------- - //
            //  Generales                                                     //
            // - ----------------------------------------------------------- - //
            dcl-ds SPACENAME;
                  SpaceNames char(10) inz('LISTSPACE');
                  SpaceLib   char(10) inz('QTEMP');
            end-ds;
            dcl-s count int(10)  inz(0);
            dcl-s ATTRIBUTE      char(10) inz('LSTMBR');
            dcl-s ATTRIBUTEFILE  char(10) inz('*FILE');
            dcl-s ATTRIBUTEALL   char(10) inz('*ALL');
            dcl-s INIT_SIZE      int(10)  inz(9999999);   // 9B 0 \Z int(10)
            dcl-s AUTHORITY      char(10) inz('*ALL');
            dcl-s TEXT           char(50) inz('File member space');
            dcl-s TEXTOBJ        char(50) inz('Test object lock');
            dcl-s NONE           char(10) inz('*NONE');

            // Área de espacio de usuario (basado en puntero PTR)
            dcl-s PTR pointer;
            dcl-s SP1 char(32767) based(PTR);

            // ARR sobre el comienzo de SP1
            dcl-ds US_Map based(PTR);
                  ARR    char(1) dim(32767) pos(1); // bytes crudos desde el inicio
                  OFFSET int(10) pos(125);
                  SIZE   int(10) pos(133);
            end-ds;
            // Puntero a lista de miembros formateada
            dcl-s MBRPTR pointer;

            // Formato MBR0200 (lista de miembros), basado en MBRPTR
            dcl-ds MBR0200_T qualified based(MBRPTR) dim(32767);
                  MBRNAME char(100);
            end-ds;

            // Copia local (hasta 99 miembros)
            dcl-ds pxDsMbr dim(99) likeds(MBR0200_T) ;
            dcl-s  pxeDsCMbr int(10);

            // Nombre calificado archivo/biblioteca
            dcl-ds FILE_LIB qualified;
                  FFILE char(10) pos(1);
                  FLIB  char(10) pos(11);
            end-ds;

            dcl-s WHICHMBR char(10) inz('*ALL      ');
            dcl-s OVERRIDE char(1)  inz('1');
            dcl-s blanco   char(1)  inz(' ');

            // Estructura estándar de error (Qus_EC_t)
            dcl-ds IGNERR;
                  BytesProv  int(10) inz(15); // 9B 0
                  BytesAvail int(10);
                  ExceptId   char(7);
            end-ds;

            dcl-s MBR_LIST char(8) inz('MBRL0200');
            dcl-s CHK_OBJ  char(8) inz('OBJL0100');
            dcl-s CHK_OBJ2 char(8) inz('OBJL0200');

            // Para ver objeto bloqueado (header de User Space)
            dcl-s usPtr pointer;
            dcl-ds userspaceHeade based(usPtr) qualified;
                  userArea      char(64);
                  headerSize    int(10);
                  releaseLevel  char(4);
                  formatName    char(8);
                  apiUsed       char(10);
                  dateCreated   char(13);
                  infoStatus    char(1);
                  usSizeUsed    int(10);
                  offsetInput   int(10);
                  sizeInput     int(10);
                  offsetHeader  int(10);
                  headerSecSiz  int(10);
                  offsetList    int(10);
                  listSecSize   int(10);
                  nmbrEntries   int(10);
                  entrySize     int(10);
                  entryCCSID    int(10);
                  regionID      char(2);
                  langID        char(3);
                  subListInd    char(1);
                  us_gen_reser  char(42);
            end-ds;

            dcl-s stateObj ind inz(*off);
            dcl-s endpgm   ind;
            dcl-s errCode  char(100) inz(*loval);

            // Obj/Lib a chequear (bloqueo, etc.)
            dcl-ds ObjLockDs;
                  objlock char(20) pos(1);
                  objet   char(10) pos(1);
                  libobjet char(10) pos(11);
            end-ds;

            // - ---------------------------------------------------- - //
            //  Para ejecutar comandos
            // - ---------------------------------------------------- - //
            dcl-s CMD    char(256);
            dcl-s CMDLEN packed(15:5);

            // - ---------------------------------------------------- - //
            //  APIs
            // - ---------------------------------------------------- - //
            dcl-pr QUSDLTUS extpgm('QUSDLTUS');
                  UsrSpcName char(20);
                  ErrorCode  char(8);
            end-pr;

            dcl-pr QUSCRTUS extpgm('QUSCRTUS');
                  UsrSpcName   char(20);
                  ExtAttr      char(10);
                  InitialSize  int(10);
                  InitialValue char(1);
                  Authority    char(10);
                  Description  char(50);
                  Replace      char(1) options(*nopass);
            end-pr;

            dcl-pr QUSLMBR extpgm('QUSLMBR');
                  UsrSpcName   char(20);
                  FormatName   char(8);
                  QualifiedFil char(20);
                  MemberOpt    char(10);
                  OverrideOpt  char(1);
                  ErrorCode    char(8) options(*nopass);
            end-pr;

            dcl-pr QUSPTRUS extpgm('QUSPTRUS');
                  UsrSpcName char(20);
                  Pointer    pointer;
            end-pr;

            dcl-pr QWCLOBJL extpgm('QWCLOBJL');
                  UsrSpcName char(20);
                  FormatName char(8);
                  QualObjName char(20);
                  ObjType    char(10);
                  memberName char(10);
                  ErrorCode  char(100);
            end-pr;

            dcl-pr QCMDEXC extpgm('QCMDEXC');
                  CMD    char(65535) const options(*varsize);
                  CMDLEN packed(15:5) const;
            end-pr;

            dcl-pr QUSRLOBJ extpgm('QUSRLOBJ');
                  rcvVar     char(256);
                  rcvVarLen  int(10);
                  formatName char(8);
                  objName    char(10);
                  objLib     char(10);
                  objType    char(10);
                  errorCode  char(100);
            end-pr;

            dcl-pr QUSLOBJ extpgm('QUSLOBJ');
                  UsrSpcName char(20);
                  FormatName char(8);
                  QualObjName char(20);
                  objType    char(10);
                  errorCode  char(100);
            end-pr;

            dcl-pr QUSROBJD extpgm('QUSROBJD');
                  rcvVar    char(200);
                  rcvVarLen packed(5:0);
                  objD      char(10);
                  TODO      char(10);
                  objt      char(10);
                  errorCode char(1);
            end-pr;

            // - ----------------------------------------------------------- - //
            //  Prototipos del módulo (svpap*)
            // - ----------------------------------------------------------- - //
            dcl-pr svpapi_inz end-pr;

            dcl-pr svpapi_End end-pr;

            dcl-pr svpapi_spaceUsr ind end-pr;

            dcl-pr svpapi_listTheMembers ind;
                  peLib likeds(FILE_LIB);
            end-pr;

            dcl-pr svpapi_getPointerToTheUsrSpace ind;
                  pePtUs like(PTR);
            end-pr;

            dcl-pr svpapi_dltSpaceUsr ind end-pr;

            dcl-pr svpapi_loadMemToLib ind;
                  peLib     likeds(FILE_LIB);
                  pxMbr     likeds(MBR0200_T) dim(99) options(*nopass : *omit);
                  pxeDsCMbr int(10)           options(*nopass : *omit);
            end-pr;

            dcl-pr svpapi_chkStatusObj ind;
                  pxObjlck like(objlock);
            end-pr;

            dcl-pr svpapi_chkobjlck ind;
                  pxObjlck like(objlock);
            end-pr;

            dcl-pr svpapi_chkobjexist ind;
                  peNfue char(10);
                  peFlib char(10);
                  peTobj char(10);
            end-pr;

            dcl-pr svpapi_getTypeAndAttributeObj ind;
                  peNfue char(10);
                  peFlib char(10);
                  pxTobj char(10);
                  pxAttr char(10);
            end-pr;

            dcl-pr svpapi_movobj ind;
                  peObjl char(10);
                  peNfue char(10);
                  peFlib char(10);
                  peTlib char(10);
                  peTobj char(10);
            end-pr;

            dcl-pr svpapi_movfil ind;
                  peObjl char(10);
                  peNfue char(10);
                  peFlib char(10);
                  peTobj char(10);
            end-pr;

