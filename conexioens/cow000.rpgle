     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt:*noshowcpy)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COW000: Consulta General de Cotizaciones                     *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                               *06/01/2016   *
      * ------------------------------------------------------------ *
      * SGF 02/08/2016: Agrego acceso a SET607 para llamada a PAR116R*
      * SGF 03/08/2016: Mantener posicionamiento cuando se ingresa a *
      *                 alguna opción.                               *
      * JSN 23/03/2021: Se agrega tipo de persona 'CONSORCIO'        *
      * ************************************************************ *
     Fctw000    if   e           k disk
     Fctw00001  if   e           k disk    rename(c1w000:c1w0001)
     Fctw00002  if   e           k disk    rename(c1w000:c1w0002)
     Fctw00003  if   e           k disk    rename(c1w000:c1w0003)
     Fctw00004  if   e           k disk    rename(c1w000:c1w0004)
     Fctw00006  if   e           k disk    rename(c1w000:c1w0006)
     Fctwest    if   e           k disk
     Fctwmsg    if a e           k disk
     Fgntpgm    if   e           k disk
     Fcow000fm  cf   e             workstn sfile(cow000cs1:recnum)
     Fpahed0    if   e           k disk
     Fpawpc0    if   e           k disk
     Fpahec0    if   e           k disk
     Fsehni2    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fset607    if   e           k disk
     Fset912    if   e           k disk

      * Copy ------------------------------------------------------- *
      /copy hdiile/qcpybooks,svpdes_h
      /copy hdiile/qcpybooks,svpws_h
      /copy hdiile/qcpybooks,prwsnd_h

      * Prototypes Externo ----------------------------------------- *
     D COW000B         pr                  EXTPGM('COW000B')
     D     fun                       10i 0

     D COW0001         pr                  EXTPGM('COW0001')
     D    empr                        1    const
     D    sucu                        2    const
     D    nivt                        1  0 const
     D    nivc                        5  0 const
     D    nctw                        7  0 const

     DCOW001           pr                  extpgm('COW001')
     D   empr                         1    const
     D   sucu                         2    const
     D   arcd                         6  0 const
     D   spoL                         9  0 const

     D COW310Y         pr                  extpgm('COW310Y')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW310V         pr                  extpgm('COW310V')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW000M         pr                  extpgm('COW000M')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW000MG        pr                  extpgm('COW000MG')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const
     D  peIndi                        2  0 const
     D  peRetu                         n

     D PAR116R         pr                  extpgm('PAR116R')
     D  peArcd                        6  0
     D  peSpol                        9  0
     D  peAsen                        7  0
     D  peNomb                       40
     D  peCert                        9  0
     D  peT607                             likeRec( s1t607 )
     D  peFpgm                        3

     D getPoli         pr             7

      * Variables -------------------------------------------------- *
     D @@base          ds                  likeds(paramBase)

     D pempr           s              1
     D psucu           s              2
     D pnivt           s              1  0
     D pnivc           s              5  0
     D pnctw           s              7  0
     D parcd           s              6  0
     D pspol           s              9  0
     D psoln           s              7  0
     D pfctw           s              8  0
     D pfpro           s              8  0
     D uempr           s              1
     D usucu           s              2
     D univt           s              1  0
     D univc           s              5  0
     D unctw           s              7  0
     D uarcd           s              6  0
     D uspol           s              9  0
     D usoln           s              7  0
     D ufctw           s              8  0
     D ufpro           s              8  0

     D xxiden          s              1  0
     D recnum          s             10i 0

     D @@retu          s               n
     D @@fpgm          s              3

     D @@indi          s             10i 0

     D@@t607         e ds                  extname(set607)

      * Local Usuario ---------------------------------------------- *
     D PsDs           sds                  qualified
     D  CurUsr                       10a   overlay(PsDs:358)

      * Local Data Ara --------------------------------------------- *
     D                uds
     D  usempr               401    401
     D  ussucu               402    403

      * Inicio Programa -------------------------------------------- *
     C                   eval      *inlr = *on
     C                   seton                                        40
     C                   setoff                                       414243
     C                   setoff                                       4445
     C                   call      'SP0000'
     C                   parm                    xxemsu
     C     k1t607        chain     set607
     * Seguridad...
     C                   eval      pgausu = PsDs.CurUsr
     C                   eval      pgipgm = 'COW000A'
     C                   eval      pgtsbs = 97
     C     k1ypgm        chain     gntpgm                             10
     C                   if        pgtcon = 'N' or *in10
     C                   write     cow000cca
     C                   exfmt     cow000c03
     C                   eval      *inkc = *on
     C                   endif

     C                   eval      xxiden = 1
     C                   exsr      sf1car
     C                   dow       not *inkc
     C                   select
     C                   when      xxiden = 1
     C                   exsr      pant01
     C                   endsl
     C                   enddo
     C                   callp     SVPWS_end ()
     C                   callp     PRWSND_end ()
     C                   return
      * ************************************************************ *
     C     sf1car        begsr
     C                   exsr      sf1bor
     C                   exsr      setllRec
     C                   exsr      readRec
     C                   dow       not %eof and recnum < 12
     C                   eval      x1nivt = w0nivt
     C                   eval      x1nivc = w0nivc
     C                   eval      x1nctw = w0nctw
     C                   eval      x1arcd = w0arcd
     C                   eval      x1spol = w0spol
     C                   eval      x1poli = getPoli()
     C                   eval      x1dest = SVPDES_estadoCot ( w0cest : w0cses )
     C                   eval      x1soln = w0soln
     C                   eval      x1spo1 = w0spo1
     C                   eval      x1sspo = w0sspo
     C                   eval      x1cest = w0cest
     C                   eval      x1cses = w0cses
     C                   eval      recnum += 1
     C                   eval      *in30 = *on
     C                   write     cow000cs1
     C                   if        recnum = 1
     C                   eval      pempr = w0empr
     C                   eval      psucu = w0sucu
     C                   eval      pnivt = w0nivt
     C                   eval      pnivc = w0nivc
     C                   eval      pnctw = w0nctw
     C                   eval      parcd = w0arcd
     C                   eval      pspol = w0spol
     C                   eval      psoln = w0soln
     C                   eval      pfctw = w0fctw
     C                   eval      pfpro = w0fpro
     C                   endif
     C                   eval      uempr = w0empr
     C                   eval      usucu = w0sucu
     C                   eval      univt = w0nivt
     C                   eval      univc = w0nivc
     C                   eval      unctw = w0nctw
     C                   eval      uarcd = w0arcd
     C                   eval      uspol = w0spol
     C                   eval      usoln = w0soln
     C                   eval      ufctw = w0fctw
     C                   eval      ufpro = w0fpro
     C                   exsr      readRec
     C                   enddo
     C                   eval      *in32 = %eof
     C                   endsr
      * ************************************************************ *
     C     sf1bor        begsr
     C                   eval      x1opci = *blanks
     C                   eval      xxnivt = *Zeros
     C                   eval      xxnivc = *Zeros
     C                   eval      xxnctw = *Zeros
     C                   eval      xxarcd = *Zeros
     C                   eval      xxspol = *Zeros
     C                   setoff                                       3031
     C                   seton                                        32
     C                   write     cow000cc1
     C                   setoff                                       32
     C                   seton                                        31
     C                   eval      recnum = *Zeros
     C                   endsr
      * ************************************************************ *
     C     avanc         begsr
     C                   exsr      setgtRec
     C                   exsr      readRec
     C                   if        %eof
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   eval      usoln = psoln
     C                   eval      ufctw = pfctw
     C                   eval      ufpro = pfpro
     C                   else
     C                   eval      uempr = w0empr
     C                   eval      usucu = w0sucu
     C                   eval      univt = w0nivt
     C                   eval      univc = w0nivc
     C                   eval      unctw = w0nctw
     C                   eval      uarcd = w0arcd
     C                   eval      uspol = w0spol
     C                   eval      usoln = w0soln
     C                   eval      ufctw = w0fctw
     C                   eval      ufpro = w0fpro
     C                   endif
     C                   exsr      sf1car
     C                   endsr
      * ************************************************************ *
     C     retro         begsr
     C                   eval      recnum = *zeros
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   eval      usoln = psoln
     C                   eval      ufctw = pfctw
     C                   eval      ufpro = pfpro
     C                   exsr      setllRec
     C                   dow       recnum < 12
     C                   exsr      readpRec
     C                   if        %eof
     C                   leave
     C                   else
     C                   add       1             recnum
     C                   endif
     C                   eval      uempr = w0empr
     C                   eval      usucu = w0sucu
     C                   eval      univt = w0nivt
     C                   eval      univc = w0nivc
     C                   eval      unctw = w0nctw
     C                   eval      uarcd = w0arcd
     C                   eval      uspol = w0spol
     C                   eval      usoln = w0soln
     C                   eval      ufctw = w0fctw
     C                   eval      ufpro = w0fpro
     C                   enddo
     C                   exsr      sf1car
     C                   endsr
      * ************************************************************ *
     C     pant01        begsr
     C                   write     cow000cca
     C                   write     cow000cp1
     C  n30              write     cow000cne
     C                   exfmt     cow000cc1
     C                   setoff                                       50
     C                   select
     C                   when      *inkc
     C                   when      *inkb
     C                   eval      uempr = *Blanks
     C                   eval      usucu = *Blanks
     C                   eval      univt = *Zeros
     C                   eval      univc = *Zeros
     C                   eval      unctw = *Zeros
     C                   eval      uarcd = *Zeros
     C                   eval      uspol = *Zeros
     C                   eval      usoln = *Zeros
     C                   eval      ufctw = *Zeros
     C                   eval      ufpro = *Zeros
     C                   callp     COW000B ( @@indi )
     C                   setoff                                       404142
     C                   setoff                                       434445
     C                   select
     C                   when      ( @@indi = 40 )
     C                   seton                                        40
     C                   when      ( @@indi = 41 )
     C                   seton                                        41
     C                   when      ( @@indi = 42 )
     C                   seton                                        42
     C                   when      ( @@indi = 43 )
     C                   seton                                        43
     C                   when      ( @@indi = 44 )
     C                   seton                                        44
     C                   when      ( @@indi = 45 )
     C                   seton                                        45
     C                   endsl
     C                   exsr      sf1car
     C                   when      *in27
     C                   exsr      retro
     C                   when      *in28
     C                   exsr      avanc
     C                   when      not *in29 and
     C                             (xxnivt <> 0 or xxnivc <> 0
     C                              or xxnctw <> 0 or xxarcd <> 0
     C                              or xxspol <> 0)
     C                   exsr      opci01
     C                   eval      uempr = usempr
     C                   eval      usucu = ussucu
     C                   eval      univt = xxnivt
     C                   eval      univc = xxnivc
     C                   eval      unctw = xxnctw
     C                   eval      uarcd = xxarcd
     C                   eval      uspol = xxspol
     C                   exsr      sf1car
     C                   other
     C                   exsr      opci01
     C                   exsr      sf1car
     C                   endsl
     C                   endsr
      * ************************************************************ *
     C     pant02        begsr
     C                   write     cow000cca
     C                   write     cow000cp2
     C                   exfmt     cow000c01
     C                   select
     C                   when      *inkl
     C                   eval      *inkl = *Off
     C                   other
     C                   endsl
     C                   endsr
      * ************************************************************ *
     C     opci01        begsr
     C                   if        *in30
     C                   readc     cow000cs1
     C                   select
     C                   when      x1opci = '1'
     C                   callp     COW0001 ( usempr : ussucu : x1nivt
     C                                     : x1nivc : x1nctw )
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
      * Rechazar:
      *  Para rechazar una propuesta la misma debe ser propuesta y además
      *  debe estar aún en el PAWPC0 (suspendida).
      *  Además no debe estar el paso 15 (numeración completado)
     C                   when      x1opci = '4'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   if        x1soln <> 0
     C     k1wpc0        chain     pawpc0
     C                   if        %found
     C                   if        w0wp15 = 0
     C                   callp     COW310Y( usempr
     C                                    : ussucu
     C                                    : x1nivt
     C                                    : x1nivc
     C                                    : x1nctw  )
     C                   else
     C                   eval      xxmsgs = 'No puede Rechazarse la '
     C                                    + 'Solicitud.'
     C                   exfmt     cow000cer
     C                   endif
     C                   endif
     C                   else
     C                   eval      xxmsgs = 'La Cotizacion no se encuentra '
     C                                    + 'en proceso de Emision.'
     C                   exfmt     cow000cer
     C                   endif
      * Visualizar Pasos del COW310
      *  Sólo se visualizan pasos para SuperPólizas que el COW310
      *  haya pasado....
     C                   when      x1opci = 'P'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   if        x1spol <> 0
     C                   endif
     C                   when      x1opci = '2'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C     k1yec0        chain     pahec0
     C                   if        %found
     C     c0asen        chain     gnhdaf
     C                   callp     PAR116R ( x1arcd : x1spol : c0asen
     C                                     : dfnomb : c0cert : @@t607
     C                                     : @@fpgm )
     C                   else
     C                   eval      xxmsgs = 'La SuperPoliza es Inexistente'
     C                   exfmt     cow000cer
     C                   endif
      * Visualizar Mensajes
     C                   when      x1opci = 'M'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   callp     COW000M( usempr
     C                                    : ussucu
     C                                    : x1nivt
     C                                    : x1nivc
     C                                    : x1nctw  )
      * Vencida:
      *  Sólo puede marcarse como vencida una COTIZACION
     C                   when      x1opci = 'V'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   if        x1soln = 0 and x1spol = 0
     C                   if        x1cest = 1 and x1cses = 9
     C                   else
     C                   callp     COW310V( usempr
     C                                    : ussucu
     C                                    : x1nivt
     C                                    : x1nivc
     C                                    : x1nctw  )
     C                   endif
     C                   endif
      * Consultar
     C                   when      x1opci = '5'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   exsr      obt02
     C                   exsr      pant02
      * Enviar:
      *  Sólo enviarse PROPUESTA o COTIZACION
     C                   when      x1opci = 'E'
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   if        x1soln <> 0
     C                   callp     COW000MG ( usempr : ussucu : x1nivt
     C                                      : x1nivc : x1nctw : 06 : @@retu)
     C                   if        @@retu
     C                   eval      @@base.peEmpr = usempr
     C                   eval      @@base.peSucu = ussucu
     C                   eval      @@base.peNivt = x1nivt
     C                   eval      @@base.peNivc = x1nivc
     C                   eval      @@base.peNit1 = x1nivt
     C                   eval      @@base.peNiv1 = x1nivc
     C                   callp     PRWSND_sndDtaQ ( @@base : x1nctw )
     C                   endif
     C                   else
     C                   eval      xxmsgs = 'La Cotizacion no se encuentra '
     C                                    + 'en proceso de Emision.'
     C                   exfmt     cow000cer
     C                   endif
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
      * Confirmar:
      *  Sólo puede confirmarse una Solicitud (SOLN<>0), que esté suspendi-
      *  da en PAWPC0 y que además tenga la marca de que el COW310 terminó
      *  (ma99 = '1')
      *  En caso de estar en PAWPC0, no puede estar suspendida especial.
     C                   when      x1opci = '9'
     C                   if        x1cest = 7 and x1cses = 4
     C                   eval      xxmsgs = 'La Propuesta debe continuarse '
     C                                    + 'desde SpeedWay.'
     C                   exfmt     cow000cer
     C                   leavesr
     C                   endif
     C                   eval      uempr = pempr
     C                   eval      usucu = psucu
     C                   eval      univt = pnivt
     C                   eval      univc = pnivc
     C                   eval      unctw = pnctw
     C                   eval      uarcd = parcd
     C                   eval      uspol = pspol
     C                   if        x1soln <> 0
     C     k1wpc0        chain     pawpc0
     C                   if        %found
     C                   if        w0marp = '0'
     C     k1west        chain     ctwest
     C                   if        %found
     C                   if        t@ma99 = '1'
     C                   callp     COW001 ( usempr : ussucu
     C                                    : x1arcd : x1spol )
     C                   exsr      gramsg
     C                   endif
     C                   else
     C                   eval      xxmsgs = 'La Cotizacion ya se encuentra '
     C                                    + 'Emitida.'
     C                   exfmt     cow000cer
     C                   endif
     C                   endif
     C                   else
     C                   eval      xxmsgs = 'La Cotizacion no se encuentra '
     C                                    + 'en proceso de Emision.'
     C                   exfmt     cow000cer
     C                   endif
     C                   else
     C                   eval      xxmsgs = 'La Cotizacion no se encuentra '
     C                                    + 'en proceso de Emision.'
     C                   exfmt     cow000cer
     C                   endif
     C                   endsl
     C                   endif
     C                   endsr
      * ************************************************************ *
     C     gramsg        begsr
     C     k1wmsg        setgt     ctwmsg
     C     k1wmsg        readpe    ctwmsg
     C                   if        %eof
     C                   eval      msivse  = 1
     C                   else
     C                   eval      msivse += 1
     C                   endif
     C                   eval      msempr = usempr
     C                   eval      mssucu = ussucu
     C                   eval      msnivt = x1nivt
     C                   eval      msnivc = x1nivc
     C                   eval      msnctw = x1nctw
     C                   eval      mscpgm = 'COW000'
     C                   eval      mstxmg = 'Propuesta Confirmada por '
     C                                    + 'opción EXPRESS de COW000'
     C                   eval      msmar1 = '0'
     C                   eval      msmar2 = '0'
     C                   eval      msmar3 = '0'
     C                   eval      msmar4 = '0'
     C                   eval      msmar5 = '0'
     C                   eval      msuser = PsDs.CurUsr
     C                   eval      msdate = %dec(%date():*iso)
     C                   eval      mstime = %dec(%time():*iso)
     C                   write     c1wmsg
     C                   endsr
      * ************************************************************ *
     C     *inzsr        begsr
     C     k1t607        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    psds.curusr
     C     k1y000        klist
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C                   kfld                    unctw
     C     k1y00001      klist
     C                   kfld                    unctw
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C     k1y00002      klist
     C                   kfld                    ufctw
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C                   kfld                    unctw
     C     k1y00003      klist
     C                   kfld                    uarcd
     C                   kfld                    uspol
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C                   kfld                    unctw
     C     k1y00004      klist
     C                   kfld                    usoln
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C                   kfld                    unctw
     C     k1y00006      klist
     C                   kfld                    ufpro
     C                   kfld                    uempr
     C                   kfld                    usucu
     C                   kfld                    univt
     C                   kfld                    univc
     C                   kfld                    unctw
     C     k2y000        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   kfld                    x1nctw
     C     k2y00001      klist
     C                   kfld                    x1nctw
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C*    k2y00002      klist
     C*                  kfld                    x1fctw
     C*                  kfld                    usempr
     C*                  kfld                    ussucu
     C*                  kfld                    x1nivt
     C*                  kfld                    x1nivc
     C*                  kfld                    x1nctw
     C     k2y00003      klist
     C                   kfld                    x1arcd
     C                   kfld                    x1spol
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   kfld                    x1nctw
     C     k2y00004      klist
     C                   kfld                    x1soln
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   kfld                    x1nctw
     C*    k2y00006      klist
     C*                  kfld                    x1fpro
     C*                  kfld                    usempr
     C*                  kfld                    ussucu
     C*                  kfld                    x1nivt
     C*                  kfld                    x1nivc
     C*                  kfld                    x1nctw
     C     k1yec0        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1arcd
     C                   kfld                    x1spol
     C     k1ypgm        klist
     C                   kfld                    pgausu
     C                   kfld                    pgtsbs
     C                   kfld                    pgipgm
     C     k1wpc0        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1arcd
     C                   kfld                    x1spol
     C     k1west        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   kfld                    x1nctw
     C     k1wmsg        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   kfld                    x1nctw
     C     k1yed0        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1arcd
     C                   kfld                    x1spol
     C     k1yni2        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1nivt
     C                   kfld                    x1nivc
     C                   endsr
      * ************************************************************ *
     C     readRec       begsr
     C   40              read      ctw000
     C   41              read      ctw00001
     C   42              read      ctw00002
     C   43              read      ctw00003
     C   44              read      ctw00004
     C   45              read      ctw00006
     C                   endsr
      * ************************************************************ *
     C     readpRec      begsr
     C   40              readp     ctw000
     C   41              readp     ctw00001
     C   42              readp     ctw00002
     C   43              readp     ctw00003
     C   44              readp     ctw00004
     C   45              readp     ctw00006
     C                   endsr
      * ************************************************************ *
     C     setllRec      begsr
     C   40k1y000        setll     ctw000
     C   41k1y00001      setll     ctw00001
     C   42k1y00002      setll     ctw00002
     C   43k1y00003      setll     ctw00003
     C   44k1y00004      setll     ctw00004
     C   45k1y00006      setll     ctw00006
     C                   endsr
      * ************************************************************ *
     C     setgtRec      begsr
     C   40k1y000        setgt     ctw000
     C   41k1y00001      setgt     ctw00001
     C   42k1y00002      setgt     ctw00002
     C   43k1y00003      setgt     ctw00003
     C   44k1y00004      setgt     ctw00004
     C   45k1y00006      setgt     ctw00006
     C                   endsr
      * ************************************************************ *
     C     obt02         begsr
     C     k2y000        chain     ctw000
     C                   select
     C                   when      w0tipe = 'F'
     C                   eval      x0tipe = 'FISICA'
     C                   when      w0tipe = 'J'
     C                   eval      x0tipe = 'JURIDICA'
     C                   when      w0tipe = 'C'
     C                   eval      x0tipe = 'CONSORCIO'
     C                   endsl
     C     k1yni2        chain     sehni2
     C     n2nrdf        chain     gnhdaf
     C                   eval      x0nomb = dfnomb
     C     w0nrpp        chain     set912
     C                   eval      x0dppg = t@dppg
     C                   eval      x0come = %dec(w0come:9:6)
     C                   endsr
      * ************************************************************ *
     P getPoli         b
     D getPoli         pi             7
     D @@rama          s              2  0
     D @@poli          s              7  0

     C     k1yed0        setll     pahed0
     C     k1yed0        reade     pahed0
     C                   if        %eof
     C                   return    *Blanks
     C                   else
     C                   eval      @@poli = d0poli
     C                   endif

     C                   eval      @@rama = d0rama
     C     k1yed0        reade     pahed0
     C                   dow       not %eof
     C                   if        d0rama <> @@rama
     C                   return    'COMBO'
     C                   endif
     C     k1yed0        reade     pahed0
     C                   enddo
     C                   return    %char ( @@poli )
     P getPoli         e
