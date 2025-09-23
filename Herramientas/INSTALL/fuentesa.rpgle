     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *       https://www.ibm.com/docs/es/i/7.5.0?topic=type-examples *
     * ------------------------------------------------------------- *
     Fsetsrc    uf a e           k disk
      *Empresa/Sucursal
     D                uds
     D peempr                401    401
     D pesucu                402    403
      *Para Apis
     D SPACENAME       DS
     D                               10    INZ('LISTSPACE')
     D                               10    INZ('QTEMP')
     D ATTRIBUTE       S             10    INZ('LSTMBR')
     D INIT_SIZE       S              9B 0 INZ(9999999)
     D AUTHORITY       S             10    INZ('*CHANGE')
     D TEXT            S             50    INZ('File member space')
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
      *
     D PTR             S               *
     D FILE_LIB        DS            20
     D  FFILE                  1     10
     D  FLIB                  11     20
     D SECU            s              2a
     D WHICHMBR        S             10    INZ('*ALL      ')
     D OVERRIDE        S              1    INZ('1')
     D IGNERR          DS
     D                                9B 0 INZ(15)
     D                                9B 0
     D                                7A
     * ---------------------------------------------------- *
      * prog ext
     * ---------------------------------------------------- *
     Dmvsrccpp         pr                  extpgm('mvsrccpp')
     D rsec                          10a
     D rsrc                          10a
     D fore                          10a
     * ---------------------------------------------------- *
      * Variables varias
     * ---------------------------------------------------- *
     D Tfile           s             10a
     D TLIB            s             10a
     D desa            s             10a
     D xxiden          s              1  0 inz(1)
     D @rulos          s               n   inz(*off)
     D tipoInst        s               n   inz(*off)
     D x               s             10i 0
     D                 ds                  inz
     Dcadena                   1    100
     dnomfue                   2     11
     Dtipo                    12     21
     * ---------------------------------------------------- *
      * key
     * ---------------------------------------------------- *
     D k1tsrc          ds                  likerec( S1Tsrc : *Key )
     D @@Dssrc         ds                  likerec( S1Tsrc : *input  )
     * ---------------------------------------------------- *
      * Estrucutura para fechas
     * ---------------------------------------------------- *
     D                 ds                  inz
     D    fech                 1      8  0
     D    FECA                 1      4  0
     D    FECM                 5      6  0
     D    FECD                 7      8  0
     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     * - ----------------------------------------------------------- *
      *   Cuerpo Principal.
     * - ----------------------------------------------------------- *
     *----------------------------------------------------|
1b C                   dou       @rulos                                       |::::::
2b C     xxiden        caseq     1             proc01                         ||    :
2e C                   endcs                                                  ||    :
1e C                   enddo                                                  |::::::
     C*                   exsr      srclos                                       |
     C                   seton                                            lr    |
     C                   return
     ******************************************************
      /SPACE
     ******************************************************
     C     proc01        begsr
     C                   EVAL      MBRPTR = %ADDR(ARR(OFFSET))
     C                   MOVE      SIZE          CHARSIZE          3
      /free
          if %TRIM(DESA) <> 'DESA_';
               FLIB = 'TEMPORALIN';//instaltemp
               tipoInst = *on;
          endif;

          chain %kds ( k1tsrc:4 ) setsrc;
          if not %found;
               s1secu = 1;
          else;
               setgt %kds(k1tsrc:4) setsrc;
               readpe(n) %kds(k1tsrc:4) setsrc @@Dssrc;
               s1secu = @@Dssrc.s1secu + 1;
          endif;
          SECUPARM = %CHAR(S1SECU);
          // ahora grabo
          for x = 1 to SIZE;
               exsr graba;
          endfor;
          @rulos = *on;
      /end-free

     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     C     graba         begsr
     c*Cargo ds
     C                   eval      cadena = %TRIM(MBR0200_T(X).MBRNAME)
     c*
     C                   eval      s1empr = peempr
     C                   eval      s1sucu = pesucu
     C                   eval      s1marF = '0'
     C                   eval      S1FFIL = ffile
     C                   eval      S1FLIB = flib
     C                   eval      S1LIBT = tlib
     C                   eval      S1FILT = Tfile
     c                   EVAL      S1TFUE = nomfue
     c                   EVAL      S1TIPO = tipo
     C                   eval      S1ECHA = %dec(%date():*iso)
     C                   eval      fech   = %dec(%date():*iso)
     C                   eval      s1anio = feca
     C                   eval      s1fmes = fecm
     C                   eval      S1fdia = fecd
     C                   eval      s1desa = desa
     c*Fecha instalado
     C                   eval      S1ECH1 = %dec(%date():*iso)
     C                   eval      s1ausu = @PsDs.CurUsr
     C                   eval      s1date = udate
     C                   eval      s1time = %dec(%time)
     C                   write     s1tsrc
     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     C     *inzsr        begsr
     C     *ENTRY        PLIST
     C     FFILE         PARM                    FILEPARM         10
     C     FLIB          PARM                    FLIBPARM         10
     C     TFILE         PARM                    TFILEPARM        10
     C     TLIB          PARM                    TLIBPARM         10
     C     DESA          PARM                    desaparm         10
     C     SECU          PARM                    SECUPARM          2

      *
      * Delete the user space if it exists
      *
     C                   CALL      'QUSDLTUS'                           10
     C                   PARM                    SPACENAME
     C                   PARM                    IGNERR
      *
      * Create the user space
      *
     C                   CALL      'QUSCRTUS'
     C                   PARM                    SPACENAME
     C                   PARM                    ATTRIBUTE
     C                   PARM                    INIT_SIZE
     C                   PARM      ' '           INIT_VALUE        1
     C                   PARM                    AUTHORITY
     C                   PARM                    TEXT
      *
      * Call the API to list the members in the requested file
      *
     C                   CALL      'QUSLMBR'
     C                   PARM                    SPACENAME
     C                   PARM      'MBRL0200'    MBR_LIST          8
     C                   PARM                    FILE_LIB
     C                   PARM                    WHICHMBR
     C                   PARM                    OVERRIDE
      *
      * Get a pointer to the user-space
      *
     C                   CALL      'QUSPTRUS'
     C                   PARM                    SPACENAME
     C                   PARM                    PTR
     C* Para buscar
     C                   eval          k1tsrc.s1empr = peempr
     C                   eval          k1tsrc.s1sucu = pesucu
     C                   eval          k1tsrc.S1ffil = FFILE
     C                   eval          k1tsrc.S1fLIB = FLIB
     C                   endsr
