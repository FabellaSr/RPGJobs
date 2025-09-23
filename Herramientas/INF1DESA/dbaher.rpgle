     H option(*nodebugio:*srcstmt)
     H actgrp(*caller) dftactgrp(*no)
     * ********************************************************** *
     * dbaher: HERRAMIENTAS DE DESARROLLO                         *
     * ---------------------------------------------------------- *
     * Ivan M Fabella                                 26/12/2024  *
     * ********************************************************** *
     Fsether    uf a e           k disk
     Fdbaherfm  cf   e             workstn sfile(dbahers1:@lsf1)
     * ---------------------------------------------------------- *
     D dbaher          pr
     D dbaher          pi
      ************************************************
     D CALLHER         pr                  ExtPgm('CALLHER')
     D  psCcmd                       10a   const
     D  psLcmd                       10a   const
     D  peRtrn                        1a
      *VARIABLES *************************************
     D xxiden          s              1  0 inz(1)
     D @lsf1           s              2  0
     D                uds
     D peempr                401    401
     D pesucu                402    403
     D x2ncmd          s              1a
     D cmdc            s              2  0 dim(20)
     D i               s              2  0 inz(0)
     D ncmdc           S              2  0 inz(1)
     D encontrado      S               N
     D @rtrn           s              1a
      ************************************************
     C                   exsr      sf1car
1b C                   dow       not *inkc
2b C                   select
2x C                   when      xxiden = 1
     C                   exsr      pant01
2x C                   when      xxiden = 2
     C                   exsr      pant02
2x C                   when      xxiden = 3
     C                   exsr      pant03
2e C                   endsl
1e C                   enddo
     C                   eval      *inlr = *on
      ************************************************
      *******************Pantalla 1*******************
      ************************************************
     C     pant01        begsr
     C   30              exfmt     dbaherc1
     C  n30              exfmt     dbaherne
     C                   exsr      apagar
1b C                   select
1x C                   when      *inkc
1x C                   when      *inkf
     C                   eval      *in04 = *off
     C                   eval      *in06 = *on
     C                   eval      x2func = 'ALTAS'
     C                   exsr      borr02
     C                   exsr      crtcmdc
     C                   eval      xxiden = 2
1x C                   when      *in27
     C                   exsr      retro
1x C                   when      not *in29
     C                   exsr      opci01
1e C                   endsl
     C                   endsr
      ************************************************
      *******************Pantalla 1*******************
      ************************************************

      ************************************************
      *******************Pantalla 2*******************
      ************************************************
     C     pant02        begsr
     C   06              setoff                                       51
     C   07              setoff                                       51
     C   04              seton                                        51
     C                   exfmt     dbaher01
     C                   exsr      apagar
1b C                   select
1x C                   when      *inkl
     C                   eval      xxiden = 1
     C                   exsr      sf1car
1x C                   when      *inka
     C                   exsr      grab01
     C                   eval      xxiden = 1
     C                   exsr      sf1car
1e C                   endsl
     C                   endsr
      ************************************************
      *******************Pantalla 2*******************
      ************************************************

      ************************************************
      *******************Pantalla 3*******************
      ************************************************
     C     pant03        begsr
     C                   seton                                        51
     C                   exfmt     dbaher01
1b C                   select
1x C                   when      *inka
     C                   callp     callher( X1CCMD
     C                                    : x1lcmd
     C                                    : @rtrn )
     C                   exsr      sf1car
     C                   eval      xxiden = 1
1x C                   when      *inkl
     C                   eval      xxiden = 1
     C                   exsr      sf1car
1e C                   endsl
     C                   endsr
      ************************************************
      *******************Pantalla 3*******************
      ************************************************

      ************************************************
      ******************* Opciones *******************
      ************************************************
     C     opci01        begsr
     C                   readc     dbahers1
     C                   eval      x2cmdc = X1CCMD
     c                   eval      x2dcmd = x1dcmd
     c                   eval      x2lcmd = x1lcmd
     C   07              setoff                                       51
1b C                   if        *in30
      *Ejecutar = x1opci = 1
2b C                   if        x1opci = 1
     C                   eval      xxiden = 3
     C                   eval      x2func = 'Ejecutar'
     C                   eval      x1opci = *zeros
     C                   update    dbahers1
     C                   endif
      *Bajas x1opci = 4
2b C                   if        x1opci = 4
     C                   eval      *in04 = *on
     C                   eval      *in06 = *off
     C                   eval      *in07 = *off
     C                   exsr      borr02
     C                   eval      xxiden = 2
     C                   eval      x2func = 'BAJAS'
     C                   eval      x1opci = *zeros
     C                   update    dbahers1
2e C                   endif
      *Modificar = x1opci = 2
2b C                   if        x1opci = 2
     C                   eval      *in06 = *off
     C                   eval      *in04 = *off
     C                   eval      *in07 = *on
     C*                  eval      x2cmdc = X1CCMD
     c*                  eval      x2dcmd = x1dcmd
     C                   eval      xxiden = 2
     C                   eval      x2func = 'Modificar'
     C                   eval      x1opci = *zeros
     C                   update    dbahers1
     C                   endif
1e C                   endif
     C                   endsr
      ************************************************
      ******************* Opciones *******************
      ************************************************

      ************************************************
      ****************  Manejo File ******************
      ************************************************
     C     borr02        begsr
     C                   eval      X1OPCI = *zeros
     C   06              eval      x2cmdc = *blanks
     c   06              eval      x2dcmd = *blanks
     C                   endsr
      ************************************************
     C     retro         begsr
     C                   eval      @lsf1 = *zeros
     C     kseth2        setll     sether
1b C                   dow       @lsf1 < 10
     C                   readpe(n) sether
2b C                   if        %eof
1v C                   leave
2x C                   else
     C                   add       1             @lsf1
2e C                   endif
1e C                   enddo
     C                   exsr      sf1car
     C                   endsr
      ************************************************
     C     apagar        begsr
     C                   eval      i = 0
     C*                   eval      *in07 = *off
     C*                   eval      *in06 = *off
     C*                   eval      *in04 = *off
     C                   endsr
      ************************************************
     C     sf1car        begsr
     C                   exsr      sf1bor
     C                   eval      i = 0
     C                   eval      @lsf1 = *zeros
     C     kseth0        setll     sether
     C                   read      sether
1b C                   dow       not %eof and
     C                             @lsf1 < 20
     C                   eval      i = i + 1
     C                   eval      cmdc(i) = %int(h1ncmd)
     C                   seton                                        8081
     C                   eval      X1DCMD = H1DCMD
     C                   eval      X1CCMD = H1CCMD
     C                   eval      x2ncmd = h1ncmd
     C                   eval      x1lcmd = h1lcmd
     C                   eval      *in30 = *on
     C                   add       1             @lsf1
     C                   write     dbahers1
     C                   read      sether
1e C                   enddo
     C                   eval      *in32 = %eof
     C                   endsr
      ************************************************
     C     grab01        begsr
     C     kseth1        chain     sether
1b C                   if        *in04 and
     C                             %found
     C   04              delete    H1RRAM
1e C                   endif
     C                   eval      H1empr = peempr
     C                   eval      H1sucu = pesucu
     C                   eval      H1CCMD = X2CMDC
     C                   eval      H1DCMD = X2DCMD
     C                   eval      h1lcmd = X2LCMD
     c                   EVAL      H1NCMD = %CHAR(ncmdc)
     C   06              write     H1RRAM
     C   07              update    H1RRAM
     C                   endsr
      ************************************************
     C     sf1bor        begsr
     C                   eval      x1opci = *zeros
     C                   eval      X1DCMD = *blanks
     C                   eval      X1CCMD = *blanks
     C                   eval      *in07 = *off
     C                   eval      *in32 = *on
     C                   eval      *in30 = *off
     C                   eval      *in31 = *off
     C                   write     dbaherc1
     C                   eval      *in32 = *off
     C                   eval      *in31 = *on
     C                   endsr
      *******************  crtcmdc *******************
     C     crtcmdc       begsr
     C                   eval      ncmdc = 01
     C                   eval      encontrado = *OFF
     C                   for       i = 1 to %elem(cmdc)
     C                   if        cmdc(i) >= ncmdc
     C                   eval      ncmdc   = cmdc(i) + 1
     C                   iter
     C                   endif
     C                   endfor
     C                   eval      encontrado = *ON
     C                   endsr
      *******************  crtcmdc *******************
      ************************************************
      ****************  Manejo File ******************
      ************************************************
     Csr   *inzsr        begsr
     C     kseth0        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C     kseth1        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    H1NCMD
     C     kseth2        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    H1NCMD
     C                   kfld                    H1CCMD
     C                   exsr      sf1car
     Csr                 endsr
