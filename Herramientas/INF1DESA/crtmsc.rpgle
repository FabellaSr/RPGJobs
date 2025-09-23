     H decedit('0,') datedit(*dmy/) option(*nodebugio:*srcstmt)
     H actgrp(*caller) dftactgrp(*no) expropts(*resdecpos)
     * **************************************************************** *
     *                                                                  *
     * **************************************************************** *
     *                                                                  *
     * **************************************************************** *
     FCRTMSFM   cf   e             workstn sfile(CRTMSS1:recnum)
     * **************************************************************** *
     D CRTMSC          pr                  extpgm('CRTMSC')
     D                               10a
     D                               10a
     D                                 n
     D CRTMSC          pi
     D  peCcmd                       10a
     D  peLcmd                       10a
     D  peRtnr                         n

     * *Area de datos de errores ************************************** *
     D dtaError       uds                  dtaara(dtaError)
     D errores                 1      7

     * *Mensajes ***************************************************** *
     D msgtabla        S             79    dim(14) ctdata perrcd(1)

     * *VARIABLES ***************************************************** *
     D recnum          s             10i 0
     D idx             s             10i 0 inz(1)
     D mensaje         s             50a
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
     C                   if        pePro = *off
     C                   exsr      borrasf1
     C                   exsr      cargasf1
     C                   exsr      pant01
     C                   else
     C                   exfmt     CRTMSCER
     C                   endif
     C                   eval      *inlr = *on
     * **************************************************************** *
     C     borrasf1      begsr
     C                   write     crtmsc1
     C                   endsr
     * **************************************************************** *
     C     cargasf1      begsr
     C                   eval      recnum = *zeros
1b C                   dow       not %eof and recnum < 7
     C                   select
     C                   when      idx = 1
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(1)
     C                   else
     C                   eval      mensaje = MsgTabla(2)
     C                   endif
     C                   when      idx = 2
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(3)
     C                   else
     C                   eval      mensaje = MsgTabla(4)
     C                   endif
     C                   when      idx = 3
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(5)
     C                   else
     C                   eval      mensaje = MsgTabla(6)
     C                   endif
     C                   when      idx = 4
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(7)
     C                   else
     C                   eval      mensaje = MsgTabla(8)
     C                   endif
     C                   when      idx = 5
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(9)
     C                   else
     C                   eval      mensaje = MsgTabla(10)
     C                   endif
     C                   when      idx = 6
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(11)
     C                   else
     C                   eval      mensaje = MsgTabla(12)
     C                   endif
     C                   when      idx = 7
     C                   if        %subst(errores: idx: 1) = '1'
     C                   eval      mensaje = MsgTabla(13)
     C                   else
     C                   eval      mensaje = MsgTabla(14)
     C                   endif
     C                   endsl
     C                   eval      XCONTA = %char(idx)
     C                   eval      XERROR = mensaje
     C                   eval      idx += 1
     C                   eval      recnum = recnum + 1
     C                   write     crtmss1
1e C                   enddo
     C                   endsr
     * **************************************************************** *
     C     pant01        begsr
     C                   eval      *in30 = *on
     C                   eval      *in31 = *on
     C                   write     crtmsca
     C                   exfmt     CRTMSC1
     C                   endsr
** MsgTabla .-
SRCPF del fuente no existe.
SRCPF ok
Lib de config no existe
Lib de config ok
El fuente no existe.
Fuente ok
El _H no existe
_H ok
BND no existe
BND ok
Error al compilar MODULO
Modulo ok
Error al compilar SRVPGM
Srvpgm ok
