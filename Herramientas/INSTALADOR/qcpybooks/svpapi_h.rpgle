      /if defined(SVPAPI_H)
      /eof
      /endif
      /define SVPAPI_H
     * - ----------------------------------------------------------- *
     *  Generales
     * - ----------------------------------------------------------- *
     D SPACENAME       DS
     D                               10    INZ('LISTSPACE')
     D                               10    INZ('QTEMP')
      *
     D ATTRIBUTE       S             10    INZ('LSTMBR')
     D ATTRIBUTEFILE   S             10    INZ('*FILE')
     D ATTRIBUTEALL    S             10    INZ('*ALL')
     D INIT_SIZE       S              9B 0 INZ(9999999)
     D AUTHORITY       S             10    INZ('*ALL')
     D TEXT            S             50    INZ('File member space')
     D TEXTOBJ         S             50    INZ('Test object lock')
     D NONE            S             10    INZ('*NONE')
      *
     D SPACE           DS                  BASED(PTR)
     D SP1                        32767
      *
      * ARR is used with OFFSET to access the beginning of the
      * member information in SP1
      *
     D ARR                            1    OVERLAY(SP1) DIM(32767)
      *
      * OFFSET is pointing to start of the member information in SP1
      *
     D OFFSET                         9B 0 OVERLAY(SP1:125)
      *
      * Size has number of member names retrieved
      *
     D SIZE                           9B 0 OVERLAY(SP1:133)
     D MBRPTR          S               *
      *
     D MBR0200_T       DS                  BASED(MBRPTR) DIM(32767)
     D                                     qualified
     D  MBRNAME                     100A
     D pxDsMbr         DS                  likeds(MBR0200_T) Dim(99)
     D pxeDsCMbr       S             10i 0
      *
     D PTR             S               *
      *
     D FILE_LIB        DS            20
     D  FFILE                  1     10
     D  FLIB                  11     20
      *
     D WHICHMBR        S             10    INZ('*ALL      ')
     D OVERRIDE        S              1    INZ('1')
     D blanco          S              1a   INZ(' ')
     D IGNERR          DS
     D                                9B 0 INZ(15)
     D                                9B 0
     D                                7A
     D MBR_LIST        s              8a   inz('MBRL0200')
     D CHK_OBJ         s              8a   inz('OBJL0100')
     D CHK_OBJ2        s              8a   inz('OBJL0200')
      *Para ver objeto bloqueado
     D userspaceHeade  ds                  based(usPtr) qualified
     D  userArea                     64a
     D  headerSize                   10i 0
     D  releaseLevel                  4a
     D  formatName                    8a
     D  apiUsed                      10a
     D  dateCreated                  13a
     D  infoStatus                    1a
     D  usSizeUsed                   10i 0
     D  offsetInput                  10i 0
     D  sizeInput                    10i 0
     D  offsetHeader                 10i 0
     D  headerSecSiz                 10i 0
     D  offsetList                   10i 0
     D  listSecSize                  10i 0
     D  nmbrEntries                  10i 0
     D  entrySize                    10i 0
     D  entryCCSID                   10i 0
     D  regionID                      2a
     D  langID                        3a
     D  subListInd                    1a
     D  us_gen_reser                 42a
     D  stateObj       s               n   inz(*off)
      *
     D endpgm          s               n
     D errCode         S            100a   inz(*loval)
     D                 ds
     D objlock                 1     20
     D objet                   1     10
     D libobjet               11     20
     * ---------------------------------------------------- *
     * Para ejecutar comandos
     * ---------------------------------------------------- *
     D CMD             S            256A
     D CMDLEN          S             15P 5
     * ---------------------------------------------------- *
     * apis
     * ---------------------------------------------------- *
     D QUSDLTUS        PR                  EXTPGM('QUSDLTUS')
     D   UsrSpcName                  20A
     D   ErrorCode                   08A
     D QUSCRTUS        PR                  EXTPGM('QUSCRTUS')
     D   UsrSpcName                  20A
     D   ExtAttr                     10A
     D   InitialSize                  9B 0
     D   InitialValue                01A
     D   Authority                   10A
     D   Description                 50A
     D   Replace                     01A   OPTIONS(*NOPASS)
     D QUSLMBR         PR                  EXTPGM('QUSLMBR')
     D   UsrSpcName                  20A
     D   FormatName                  08A
     D   QualifiedFil                20A
     D   MemberOpt                   10A
     D   OverrideOpt                  1
     D   ErrorCode                   08A   OPTIONS(*NOPASS)
     D QUSPTRUS        PR                  EXTPGM('QUSPTRUS')
     D   UsrSpcName                  20A
     D   Pointer                       *
     D QWCLOBJL        PR                  EXTPGM('QWCLOBJL')
     D   UsrSpcName                  20A
     D   FormatName                   8A
     D   QualObjName                 20A
     D   ObjType                     10a
     D   memberName                  10a
     D   ErrorCode                  100a
     D QCMDEXC         pr                  EXTPGM('QCMDEXC')
     D   CMD                      65535a   const OPTIONS(*VARSIZE)
     D   CMDLEN                      15  5 const
     D QUSRLOBJ        pr                  EXTPGM('QUSRLOBJ')
     D   rcvVar                     256a
     D   rcvVarLen                   10i 0
     D   formatName                   8a
     D   objName                     10a
     D   objLib                      10a
     D   objType                     10a
     D   errorCode                  100a
     D QUSLOBJ         pr                  EXTPGM('QUSLOBJ')
     D   UsrSpcName                  20A
     D   FormatName                   8A
     D   QualObjName                 20A
     D   objType                     10a
     D   errorCode                  100a
     D QUSROBJD        PR                  ExtPgm('QUSROBJD')
     D   rcvVar                     200a
     D   rcvVarLen                    5  0
     D   objD                        10a
     D   TODO                        10a
     D   objt                        10a
     D   errorCode                    1a
     * ---------------------------------------------------- *
     * apis
     * ---------------------------------------------------- *
      * ------------------------------------------------------------ *
      * svpapi_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D svpapi_inz      pr
      * ------------------------------------------------------------ *
      * svpapi_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D svpapi_End      pr
      * ------------------------------------------------------------ *
      * svpapi_spaceUsr():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_spaceUsr...
     D                 pr              n
      * ------------------------------------------------------------ *
      * svpapi_listTheMembers():                                     *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_listTheMembers...
     D                 pr              n
     D peLib                               likeds(file_lib)
      * ------------------------------------------------------------ *
      * svpapi_getPointerToTheUsrSpace():                            *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_getPointerToTheUsrSpace...
     D                 pr              n
     D pePtUs                              like(PTR)
      * ------------------------------------------------------------ *
      * svpapi_dltSpaceUsr():                                        *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_dltSpaceUsr...
     D                 pr              n
      * ------------------------------------------------------------ *
      * svpapi_loadObjToLib():                            *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_loadMemToLib...
     D                 pr              n
     D peLib                               likeds(file_lib)
     D pxMbr                               likeds(MBR0200_T)
     D                                     Options( *Nopass: *Omit ) Dim(99)
     D pxeDsCMbr                     10i 0 Options( *Nopass: *Omit )
      * ------------------------------------------------------------ *
      * svpapi_chkStatusObj():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_chkStatusObj...
     D                 pr              n
     D pxObjlck                            like(objlock)
      * ------------------------------------------------------------ *
      * svpapi_chkobjlck():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_chkobjlck...
     D                 pr              n
     D pxObjlck                            like(objlock)
      * ------------------------------------------------------------ *
      * svpapi_chkobjexist():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_chkobjexist...
     D                 pr              n
     D peNfue                        10a
     D peFlib                        10a
     D peTobj                        10a
      * ------------------------------------------------------------ *
      * svpapi_getTypeAndAttributeObj():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_getTypeAndAttributeObj...
     D                 pr              n
     D peNfue                        10a
     D peFlib                        10a
     D pxTobj                        10a
     D pxAttr                        10a
      * ------------------------------------------------------------ *
      * svpapi_movfil():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_movfil...
     D                 pr              n
     D peObjl                        10a
     D peNfue                        10a
     D peFlib                        10a
     D peTobj                        10a
      * ------------------------------------------------------------ *
      * svpapi_movfil():                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpapi_movobj...
     D                 pr              n
     D peObjl                        10a
     D peNfue                        10a
     D peFlib                        10a
     D peTlib                        10a
     D peTobj                        10a
