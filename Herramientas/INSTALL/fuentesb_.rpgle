     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *
     * ------------------------------------------------------------- *
     Fsetsrc    uf   e           k disk
      *Empresa/Sucursal
     D                uds
     D peempr                401    401
     D pesucu                402    403
      *Para Apis

     * ---------------------------------------------------- *
      * prog ext
     * ---------------------------------------------------- *
     Dmovsrcmbrc       pr                  extpgm('movsrcmbrc')
     D FFIL                          20a
     D TFIL                          20a
     D MBR                           10a
     * ---------------------------------------------------- *
      * Variables varias
     * ---------------------------------------------------- *
     D xxiden          s              1  0 inz(1)
     D @rulos          s               n   inz(*off)
     D x               s             10i 0
     D                 ds                  inz
     Dcadena                   1    100
     dnomfue                   2     10
     Dtipo                    12     21
     D FILE_LIB        DS            20
     D  FILE                   1     10
     D  LIB                   11     20
     D SECU            s              2a
      *Estructura para mandar al MOVSRC
     D                 ds            20
     D fromfile                1     20
     D S1FFIL                  1     10
     D S1FLIB                 11     20
     D                 ds            20
     D tofile                  1     20
     D S1FILT                  1     10
     D S1LIBT                 11     20
     D FILT            s             10a
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
2b C     xxiden        caseq     1             pant01                         ||    :
2e C                   endcs                                                  ||    :
1e C                   enddo                                                  |::::::
     C*                   exsr      srclos                                       |
     C                   seton                                            lr    |
     C                   return
     ******************************************************
      /SPACE
     ******************************************************
     C     pant01        begsr
      /free

        setll %kds ( k1tsrc:5 ) setsrc ;
        reade %kds ( k1tsrc:5 ) setsrc ;
        dow not %eof;
          FILT = S1FILT;
          if s1tipo = 'PF';
               FILT = 'QGCTAALL';
          endif;
          exsr mueve;
          exsr graba;
          reade %kds ( k1tsrc:5 ) setsrc ;
        enddo;
        @rulos = *on;
      /end-free

     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     C     MUEVE         begsr
     c*Cargo ds
     C                   call      'MOVSRCMBRC'
     C                   parm                    fromfile
     C                   parm                    tofile
     C                   parm                    S1TFUE
     C                   endsr
     ******************************************************
      *update
     ******************************************************
     C     graba         begsr
     c*Cargo ds
     c*
       /free

          k1tsrc.S1TFUE = S1TFUE;
          chain %kds ( k1tsrc:6 ) setsrc;
          if %found;
               S1FILT = FILT;
               s1marf = '1';
               S1ECH1 = %dec(%date():*iso);
               s1date = udate;
               s1time = %dec(%time);
               s1ausu = @PsDs.CurUsr;
               update s1tsrc;
          ENDIF;
       /end-free
     C                   endsr
     ******************************************************
      /SPACE
     ******************************************************
     C     *inzsr        begsr
     C     *ENTRY        PLIST
     C     FILE          PARM                    FILEPARM         10
     C     LIB           PARM                    LIBPARM          10
     C     SECU          PARM                    SECUPARM          2
     C* Para buscar
     C                   eval          k1tsrc.s1empr = peempr
     C                   eval          k1tsrc.s1sucu = pesucu
     C                   eval          k1tsrc.S1FFIL = FILE
     C                   eval          k1tsrc.S1FLIB = LIB
     C                   eval          k1tsrc.S1secu = %dec(SECU:2:0)
     C                   endsr
