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
            dcl-ds userspaceHeader qualified based(usPtr) ;
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

            //para validar si existe fuente
            dcl-s mbr      char(10);
            dcl-s retorno  ind inz(*on);
            // - ---------------------------------------------------- - //
            //  Para api que busca miembros
            // - ---------------------------------------------------- - //
            dcl-ds QUSEC inz;
                  ec        char(516);
                  qusbprv   int(10) overlay(ec:1)  inz(%size(QUSEC));
                  qusbavl   int(10) overlay(ec:5)  inz(0);
                  qusei     char(7)  overlay(ec:9);
                  rsvd      char(1)  overlay(ec:16);
                  msgdata   char(500) overlay(ec:17);
            end-ds;
            dcl-s errmsg   char(50);
            dcl-s response char(1);
            dcl-s msgq     char(10);
            dcl-s dsLen    int(10) inz(%size(MbrDS));
            dcl-s format   char(8)  inz('MBRD0200');
            dcl-s qualFile char(20);
            dcl-s ovrprc   char(1)  inz('0');
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
                  UsrSpcName  char(20);
                  FormatName  char(8);
                  QualObjName char(20);
                  ObjType     char(10);
                  memberName  char(10);
                  ErrorCode   char(100);
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

            dcl-pr QUSRMBRD extpgm('QSYS/QUSRMBRD');
                  ds         char(266);
                  dsLen      int(10);
                  format     char(8);
                  qualFile   char(20);
                  member     char(10);
                  ovrprc     char(1);
                  errorData  likeds(QUSEC);
            end-pr;

            // Data structure returned from API QUSRMBRD (MBRD0200)
            dcl-ds MbrDSds inz;
                  mbrds            char(266);                            // base

                  // Bytes returned / available
                  mbrBytesRetn     uns(10) overlay(mbrds:1);
                  mbrBytesAvail    uns(10) overlay(mbrds:5);

                  // File / lib / member / attrs
                  mbrFile          char(10) overlay(mbrds:9);
                  mbrFileLib       char(10) overlay(mbrds:19);
                  mbrFileMbr       char(10) overlay(mbrds:29);
                  mbrFileAttr      char(10) overlay(mbrds:39);
                  mbrSrcType       char(10) overlay(mbrds:49);

                  // Fechas/horas (char según layout API)
                  mbrCrtDate       char(13) overlay(mbrds:59);
                  mbrLstSrcChg     char(13) overlay(mbrds:72);

                  // Texto
                  mbrTxtDesc       char(50) overlay(mbrds:85);

                  // Flags
                  mbrSrcF          char(1)  overlay(mbrds:135);
                  mbrRmtF          char(1)  overlay(mbrds:136);
                  mbrLglPhy        char(1)  overlay(mbrds:137);
                  mbrODPshr        char(1)  overlay(mbrds:138);
                  mbrRsv1          char(2)  overlay(mbrds:139);

                  // Números/ tamaños (binario entero)
                  mbrNbrRecsA1     int(10)  overlay(mbrds:141);
                  mbrNbrRecsD1     int(10)  overlay(mbrds:145);
                  mbrDtaSize       int(10)  overlay(mbrds:149);
                  mbrAccPthSize    int(10)  overlay(mbrds:153);
                  mbrNbrMbrAll     int(10)  overlay(mbrds:157);

                  // Más fechas
                  mbrChgDate       char(13) overlay(mbrds:161);
                  mbrSavDate       char(13) overlay(mbrds:174);
                  mbrRstDate       char(13) overlay(mbrds:187);
                  mbrExpDate       char(7)  overlay(mbrds:200);
                  mbrRsv2          char(4)  overlay(mbrds:207);

                  // Contadores adicionales
                  mbrMedPref       int(5)   overlay(mbrds:211);
                  mbrNbrDaysUsd    int(10)  overlay(mbrds:213);
                  mbrLstUsdDate    char(7)  overlay(mbrds:217);
                  mbrUseRstDate    char(7)  overlay(mbrds:224);
                  mbrRsv3          char(2)  overlay(mbrds:231);

                  // Multiplicadores / offsets
                  mbrDtaSpcSizM    int(10)  overlay(mbrds:233);
                  mbrAccPthSizM    int(10)  overlay(mbrds:237);
                  mbrTxtCCSID      int(10)  overlay(mbrds:241);
                  mbr200offset     int(10)  overlay(mbrds:245);
                  mbr200len        int(10)  overlay(mbrds:249);

                  // Recuentos grandes (unsigned)
                  mbrNbrRecsA2     uns(10)  overlay(mbrds:253);
                  mbrNbrRecsD2     uns(10)  overlay(mbrds:257);

                  mbrRsv4          char(6)  overlay(mbrds:261);
            end-ds;

            // - ----------------------------------------------------------- - //
            //  Prototipos del módulo (svpap*)
            // - ----------------------------------------------------------- - //
            dcl-pr svpapi_inz end-pr;

            dcl-pr svpapi_End end-pr;

            dcl-pr svpapi_spaceUsr ind end-pr;

            dcl-pr svpapi_listTheMembers ind;
                  peLib likeds(FILE_LIB);
            end-pr;

            dcl-pr svpapi_memberExists  ind;
                  peLib  char(20) const;
                  peMbr  char(10)  const;
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

            dcl-pr svpapi_RunCl  ind;
                  pCmd  varchar(200) const;
            end-pr;
