     H nomain
      * ************************************************************ *
      * SVPTAB: Programa de Servicio.                                *
      *         Tabla                                                *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                  ** 21-Ago-2019 **          *
      * ************************************************************ *
      * LRG 30-01-2020 : Se agrega el procedimiento _cotizaMoneda    *
      * JSN 25/03/2020 - Se agrega los Procedimientos:               *
      *                  _getTipoMascotas().                         *
      *                  _getRazaMascotas().                         *
      *                  _getRelaMascotas().                         *
      *                  _getTipoMascotasWeb().                      *
      *                  _getRelaMascotasWeb().                      *
      * SGF 27/04/2020 - Agrego _getParentescosVida.                 *
      * LRG 10-06-2020 : Se agrega el procedimiento                  *
      *                           _getFormasDePago                   *
      *                           _getCombinacionFormaDePago         *
      * JSN 23/09/2020 - Se agrega el procedimiento:                 *
      *                   _getResBcoXCodCobW                         *
      * JSN 29/01/2021 - Se agrega los procedimientos:               *
      *                   _getCntcfp                                 *
      *                   _getCntnau                                 *
      *                   _chkAgente                                 *
      * JSN 18/03/2021 - Se agrega el procedimiento:                 *
      *                   _getTipoDePersona                          *
      *                   _getRequiereAPRC                           *
      *                   _getProvincia                              *
      * NWN 23/06/2021 - Se agrega los procedimientos:               *
      *                   _getSet001                                 *
      * FAS 13/10/2022 - Se agrega los procedimientos:               *
      *                   _chkSet102ac                               *
      *                   _getSet102ac                               *
      *                   _chkActWeb                                 *
      * VCM 19/04/2022 - Se agregan los procedimientos:              *
      *                   _getSet103                                 *
      *                   _getSet102V                                *
      *                   _getSet102V1                               *
      *                   _getNumeradorGenerico                      *
      *                   _getNumGenericoWeb                         *
      * SGF 05/02/2023 - _getNumeradorGenerico deja tomado SET902    *
      *                  porque, como corresponde, lo usa update.    *
      *                  El tema es que NADIE debe estar llamando al *
      *                  _end() jamás.                               *
      *                  Para dar retro compatibilidad, lo que hice  *
      *                  fue llamar a SPT902 que es un RPG normal y  *
      *                  que siempre hacer *INLR = *ON.              *
      * JSN 20/08/2021 - Se agrega los procedimientos:               *
      *                   _getLugarPRISMA                            *
      *                   _getCausas                                 *
      *                   _getEstados                                *
      *                   _getEstadoTiempo                           *
      *                   _getRelacionAseg                           *
      *                   _listaTipoAccidente                        *
      * NWN 30/08/2021 - Se agrega los procedimientos:               *
      *                   _ListaRamas                                *
      *                   _ListaSexos                                *
      *                   _ListaEstadoCivil                          *
      *                   _ListaPaises                               *
      *                   _ListaVehiculos                            *
      *                   _ListaCarrocerias                          *
      *                   _ListaTipoDeVehiculos                      *
      *                   _ListaUsos                                 *
      * NWN 31/08/2021 - Se agrega los procedimientos:               *
      *                   _ListaMonedas                              *
      *                   _ListaCuentasContables                     *
      *                   _ListaCompanias                            *
      *                   _ListaImpuestos                            *
      *                   _ListaCoberturas                           *
      *                   _ListaHechosGeneradores                    *
      *                   _RelacionCoberturaYHechoGenerador          *
      *                   _ListaProveedores                          *
      *                   _GetCntnap                                 *
      *                   _GetGntpro                                 *
      *                   _GetCntcau                                 *
      *                   _GetGntloc                                 *
      * NWN 18/10/2021 - Se agrega los procedimientos:               *
      *                   _chkSet001                                 *
      * DOT 02/11/2021 - Se agrega los procedimientos:               *
      *                   _getGntmon()                               *
      * DOT 20/05/2022 - Se cambio procedimieto listaFormasDePagos   *
      *                   _listaFormasDePagos solo devuelve los habi_*
      *                   litados FPMAR5 = ' '                       *
      * VCM 13/06/2023 - Se agrega los procedimientos:               *
      *                   _getPrimasMinimas                          *
      * JSN 24/04/2023 - Se agrega los procedimientos:               *
      *                   _ListaTipoDeTransportes()                  *
      *                   _ListaMedioDeTransportes()                 *
      *                   _ListaTipoDeMercaderias()                  *
      *                   _ListaRelaMercaTipoMedTransp()             *
      * VCM 08/11/2022 - Se agregan los procedimientos:              *
      *                   _getSet645                                 *
      *                   _getSubtipoAnulacion                       *
      *                   _getFormasDeAnular                         *
      * SGF 04/01/2024 - Se agregan los procedimientos:              *
      *                  SVPTAB_getProvinciaInder                    *
      *                  SVPTAB_cotizaMoneda2                        *
      *                  SVPTAB_coeficienteEntreMonedas              *
      *                  SVPTAB_getRamaReaseguro                     *
      * SGF 05/02/2024 - Se agrega el procedimiento:                 *
      *                  SVPTAB_coeficienteEntreMonedas2             *
      * IMF 18/08/2025 - Se agrega el procedimiento:                 *
      *                  SVPTAB_ListaCompaniasV2 y dsSet139_t        *
      *                                                              *
      * ************************************************************ *
     Fset2370   if   e           k disk    usropn
     Fset2371   if   e           k disk    usropn
     Fset23711  if   e           k disk    usropn
     Fgntcmo    if   e           k disk    usropn
     Fset136    if   e           k disk    usropn
     Fset13601  if   e           k disk    usropn rename(s1t136:s1t13601)
     Fset137    if   e           k disk    usropn
     Fset138    if   e           k disk    usropn
     Fset069    if   e           k disk    usropn
     Fgntfpg    if   e           k disk    usropn
     Fgntfpg02  if   e           k disk    usropn rename(g1tfpg:g1tfpg02)
     Fset919    if   e           k disk    usropn
     Fcntrba04  if   e           k disk    usropn
     Fcntcfp    if   e           k disk    usropn
     Fcntnau01  if   e           k disk    usropn
     Fsehint    if   e           k disk    usropn
     Fcntcfp02  if   e           k disk    usropn
     Fset6202   if   e           k disk    usropn
     Fset100    if   e           k disk    usropn
     Fset102    if   e           k disk    usropn
     Fgntpro01  if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     FSet102ac  if   e           k disk    usropn prefix(tt:2)
     Fset021    if   e           k disk    usropn prefix(t1:2)
     Fset103    if   e           k disk    usropn
     Fset102V   if   e           k disk    usropn
     Fset102V1  if   e           k disk    usropn
     Fset915    uf a e           k disk    usropn
     Fset405    if   e           k disk    usropn
     Fset401    if   e           k disk    usropn
     Fset402    if   e           k disk    usropn
     Fset445    if   e           k disk    usropn
     Fset444    if   e           k disk    usropn
     Fset429    if   e           k disk    usropn
     Fset442    if   e           k disk    usropn
     Fset443    if   e           k disk    usropn
     Fgntsex    if   e           k disk    usropn
     Fgntesc    if   e           k disk    usropn
     Fgntpai    if   e           k disk    usropn
     Fset280    if   e           k disk    usropn
     Fset204    if   e           k disk    usropn
     Fset205    if   e           k disk    usropn
     Fset210    if   e           k disk    usropn
     Fset211    if   e           k disk    usropn
     Fcntcge    if   e           k disk    usropn
     Fgntmon    if   e           k disk    usropn
     Fgntmon01  if   e           k disk    usropn
     Fset120    if   e           k disk    usropn
     Fgntdim    if   e           k disk    usropn
     Fset407    if   e           k disk    usropn
     Fset409    if   e           k disk    usropn
     Fset412    if   e           k disk    usropn
     Fcntnap04  if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fcntcau    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fgntlo1    if   e           k disk    usropn
     Fgnttbe    if   e           k disk    usropn
     Fset4021   if   e           k disk    usropn
     Fset426    if   e           k disk    usropn
     Fset124    if   e           k disk    usropn
     Fcnttpr    if   e           k disk    usropn
     Fgnttfc    if   e           k disk    usropn
     Fset175    if   e           k disk    usropn
     Fset749    if   e           k disk    usropn
     Fset751    if   e           k disk    usropn
     Fset762    if   e           k disk    usropn
     Fset768    if   e           k disk    usropn
     Fset645    if   e           k disk    usropn
     Fset139    if   e           k disk    usropn
     Fset646    if   e           k disk    usropn prefix(t2:2)
     Fset647    if   e           k disk    usropn prefix(t4:2)
     Fset106    if   e           k disk    usropn prefix(t6:2)

      *--- Copy H -------------------------------------------------- *
      /copy *libl/qcpybooks,svptab_h

      * ------------------------------------------------------------ *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrCode                      10i 0 const
     D  ErrText                      80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D ErrCode         s             10i 0
     D ErrText         s             80a

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)

     D Initialized     s              1N
      * ------------------------------------------------------------ *
     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

     Is1t136
     I              t@date                      @@date
     Is1t13601
     I              t@date                      @@date
     Is1t137
     I              t@date                      @@date
     Is1t138
     I              t@date                      @@date
     Is1t919
     I              t@date                      @@date
     Ic1tcfp
     I              fpdate                      @1date
     Ic1tcfp01
     I              fpdate                      @1date
     Is1t6202
     I              t@date                      @@date
     Is1t001
     I              t@date                      xxdate
     Is1t915
     I              t@date                      @@date
     I              t@tnum                      @@tnum
     Is1t210
     I              t@date                      @@date
     Is1t211
     I              t@date                      @@date
     Is1t280
     I              t@cmar                      @@cmar
     Is1t204
     I              t@cmod                      @@cmod
     Is1t645
     I              t@date                      @@date
     Is1t139
     I              t@date                      @@date


      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPTAB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPTAB_inz      B                   export
     D SVPTAB_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set2370);
         open set2370;
       endif;

       if not %open(set2371);
         open set2371;
       endif;

       if not %open(set23711);
         open set23711;
       endif;

       if not %open(gntcmo);
         open gntcmo;
       endif;

       if not %open(set136);
         open set136;
       endif;

       if not %open(set13601);
         open set13601;
       endif;

       if not %open(set137);
         open set137;
       endif;

       if not %open(set138);
         open set138;
       endif;

       if not %open(set069);
         open set069;
       endif;

       if not %open(gntfpg);
         open gntfpg;
       endif;

       if not %open(gntfpg02);
         open gntfpg02;
       endif;

       if not %open(set919);
         open set919;
       endif;

       if not %open(cntrba04);
         open cntrba04;
       endif;

       if not %open(cntcfp);
         open cntcfp;
       endif;

       if not %open(cntnau01);
         open cntnau01;
       endif;

       if not %open(sehint);
         open sehint;
       endif;

       if not %open(cntcfp02);
         open cntcfp02;
       endif;

       if not %open(set6202);
         open set6202;
       endif;

       if not %open(set100);
         open set100;
       endif;

       if not %open(set102);
         open set102;
       endif;

       if not %open(gntpro01);
         open gntpro01;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(Set102ac);
         open Set102ac;
       endif;

       if not %open(set021);
         open set021;
       endif;

       if not %open(set103);
         open set103;
       endif;

       if not %open(set102V);
         open set102V;
       endif;

       if not %open(set102V1);
         open set102V1;
       endif;

       if not %open(set915);
         open set915;
       endif;

       if not %open(set405);
         open set405;
       endif;

       if not %open(set401);
         open set401;
       endif;

       if not %open(set402);
         open set402;
       endif;

       if not %open(set445);
         open set445;
       endif;

       if not %open(set444);
         open set444;
       endif;

       if not %open(set429);
         open set429;
       endif;

       if not %open(set442);
         open set442;
       endif;

       if not %open(set443);
         open set443;
       endif;

       if not %open(gntsex);
         open gntsex;
       endif;

       if not %open(gntesc);
         open gntesc;
       endif;

       if not %open(gntpai);
         open gntpai;
       endif;

       if not %open(set280);
         open set280;
       endif;

       if not %open(set204);
         open set204;
       endif;

       if not %open(set205);
         open set205;
       endif;

       if not %open(set210);
         open set210;
       endif;

       if not %open(set211);
         open set211;
       endif;

       if not %open(set120);
         open set120;
       endif;

       if not %open(gntmon);
         open gntmon;
       endif;

       if not %open(gntmon01);
         open gntmon01;
       endif;

       if not %open(cntcge);
         open cntcge;
       endif;

       if not %open(gntdim);
         open gntdim;
       endif;

       if not %open(set407);
         open set407;
       endif;

       if not %open(set409);
         open set409;
       endif;

       if not %open(set412);
         open set412;
       endif;

       if not %open(cntnap04);
         open cntnap04;
       endif;

       if not %open(gntpro);
         open gntpro;
       endif;

       if not %open(cntcau);
         open cntcau;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(gntlo1);
         open gntlo1;
       endif;

       if not %open(gnttbe);
         open gnttbe;
       endif;

       if not %open(set4021);
         open set4021;
       endif;

       if not %open(set426);
         open set426;
       endif;

       if not %open(set124);
         open set124;
       endif;

       if not %open(cnttpr);
         open cnttpr;
       endif;

       if not %open(gnttfc);
         open gnttfc;
       endif;

       if not %open(set175);
         open set175;
       endif;

       if not %open(set749);
         open set749;
       endif;

       if not %open(set751);
         open set751;
       endif;

       if not %open(set762);
         open set762;
       endif;

       if not %open(set768);
         open set768;
       endif;

       if not %open(set645);
         open set645;
       endif;

       if not %open(set646);
         open set646;
       endif;

       if not %open(set647);
         open set647;
       endif;

       if not %open(set106);
         open set106;
       endif;

       if not %open(set139);
         open set139;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPTAB_inz      E

      * ------------------------------------------------------------ *
      * SVPTAB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPTAB_End      B                   export
     D SVPTAB_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPTAB_End      E

      * ------------------------------------------------------------ *
      * SVPTAB_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPTAB_Error    B                   export
     D SVPTAB_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPTAB_Error    E

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionarios(): Retorna Cuestionario               *
      *                                                               *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *     peDsCuC  ( output ) cantidad de cuestionario              *
      *     peTaaj   ( input  ) codigo de cuestionario    ( opcional )*
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCuestionarios...
     p                 b                   export
     D SVPTAB_getCuestionarios...
     D                 pi
     D   peDsCu                            likeds( set2370_t ) dim( 99 )
     D   peDsCuc                     10i 0
     D   peTaaj                       2  0 options( *nopass : *omit )

     D   @@DsCu        ds                  likerec( s1t2370 : *input )

      /free

       SVPTAB_inz();

       clear peDsCu;
       clear peDsCuC;

       if %parms >= 2 and %addr(peTaaj) <> *NULL;
          if SVPTAB_getCuestionario( peTaaj : peDsCu(1) );
            peDsCuC = 1;
          endif;
       else;
         clear @@DsCu;
         setll *loval set2370;
         dou %eof( set2370 );
           read set2370 @@DsCu;
           if not %eof( set2370 );
             peDsCuC += 1;
             eval-corr peDsCu( peDsCuC ) = @@DsCu;
           endif;
         enddo;
       endif;

       return;

      /end-free

     P SVPTAB_getCuestionarios...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getPreguntas(): Retorna Cuestionario                   *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *     peDsPrC  ( output ) cantidad de preguntas                 *
      *     peCosg   ( input  ) codigo de pregunta     ( opcional )   *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPreguntas...
     p                 b                   export
     D SVPTAB_getPreguntas...
     D                 pi
     D   peTaaj                       2  0 const
     D   peDsPr                            likeds( set2371_t ) dim( 200 )
     D   peDsPrc                     10i 0
     D   peCosg                       4    options( *nopass : *omit )

     D @@DsPr          ds                  likerec( s1t2371 : *input )
     D k1yspr          ds                  likerec( s1t2371 : *key   )

      /free

       SVPTAB_inz();

       clear peDsPr;
       clear @@DsPr;
       clear peDsPrC;

       if %parms >= 3 and %addr(peCosg) <> *NULL;
         if SVPTAB_getPregunta( peTaaj : peCosg : peDsPr(1) );
           peDsPrC = 1;
         endif;
       else;
         clear k1yspr;
         k1yspr.t@taaj = peTaaj;
         setll %kds(k1yspr:1) set2371;
         dou %eof( set2371 );
           reade %kds(k1yspr:1) set2371 @@DsPr;
           if not %eof( set2371 );
             peDsprC += 1;
             eval-corr peDsPr( peDsPrC ) = @@DsPr;
           endif;
         enddo;
       endif;

       return;

      /end-free

     P SVPTAB_getPreguntas...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peDsCu   ( output ) Estructura de cuestionario            *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCuestionario...
     p                 b                   export
     D SVPTAB_getCuestionario...
     D                 pi              n
     D   peTaaj                       2  0 const
     D   peDsCu                            likeds( set2370_t )

     D   @@DsCu        ds                  likerec( s1t2370 : *input )

      /free

       SVPTAB_inz();

       clear peDsCu;

       chain(n) peTaaj set2370 @@DsCu;
       if %found( set2370 );
          eval-corr peDsCu = @@DsCu;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCuestionario...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getPregunta(): Retorna Pregunta                        *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *     peCosg   ( input  ) codigo de pregunta                    *
      *     peDsPr   ( output ) Estructura de pregunta                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPregunta...
     p                 b                   export
     D SVPTAB_getPregunta...
     D                 pi              n
     D   peTaaj                       2  0 const
     D   peCosg                       4    const
     D   peDsPr                            likeds( set2371_t )

     D   @@DsPr        ds                  likerec( s1t2371 : *input )
     D   k1yspr        ds                  likerec( s1t2371 : *key )

      /free

       SVPTAB_inz();

       clear peDsPr;

       k1yspr.t@taaj = peTaaj;
       k1yspr.t@cosg = peCosg;
       chain(n) %kds( k1yspr : 2 ) set2371 @@DsPr;
       if %found( set2371 );
          eval-corr peDsPr = @@DsPr;
          return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getPregunta...
     p                 e

      * ------------------------------------------------------------- *
      * SVPTAB_chkCuestionario(): Retorna Cuestionario                *
      *                                                               *
      *     peTaaj   ( input  ) codigo de cuestionario                *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_chkCuestionario...
     P                 b                   export
     D SVPTAB_chkCuestionario...
     D                 pi              n
     D   peTaaj                       2  0 const

      /free

       SVPTAB_inz();

       setll peTaaj set2370;

       if %equal;
         return *on;
       else;
         SetError( SVPTAB_VTAAJ
                 : 'Cuestionario Inexistente' );
         return *Off;
       endif;

      /end-free

     P SVPTAB_chkCuestionario...
     P                 e

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peEnum   (input)   Número de error a setear.             *
      *     peEtxt   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peEnum                       10i 0 const
     D  peEtxt                       80a   const

      /free

       ErrCode = peEnum;
       ErrText = peEtxt;

      /end-free

     P SetError...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getPreguntaExcluyente(): Retorna Código Excluyente por *
      *                                 pregunta                      *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( input  ) Código de Pregunta                    *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPreguntaExcluyente...
     P                 b                   export
     D SVPTAB_getPreguntaExcluyente...
     D                 pi             4
     D   peTaaj                       2  0 const
     D   peCosg                       4    const

     D @@DsPr          ds                  likeds( set2371_t )

      /free

       SVPTAB_inz();

       clear @@DsPr;

       if SVPTAB_getPregunta( peTaaj
                            : peCosg
                            : @@DsPr );

         return @@DsPr.t@Coex;
       endif;

       return *blanks;

      /end-free

     P SVPTAB_getPreguntaExcluyente...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsExcluyentes(): Retorna Items Excluyentes.      *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCoex   ( output ) Vector de Código de Exclusión         *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getItemsExcluyentes...
     P                 b                   export
     D SVPTAB_getItemsExcluyentes...
     D                 pi
     D   peTaaj                       2  0 const
     D   peCoex                       4    dim(200)
     D   peCosg                       4    dim(200)

     D   k1y3711       ds                  likerec( s1t23711 : *input )

     D   x             s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       clear peCoex;

       k1y3711.t@Taaj = peTaaj;
       setll    %kds( k1y3711 : 1 ) set23711;
       reade(n) %kds( k1y3711 : 1 ) set23711;
       dow not %eof( set23711 );
         x = %lookup( t@Coex : peCoex : 1);
         if x = 0;
           x = %lookup( *blanks : peCoex : 1);
           peCoex(x) = t@Coex;
           peCosg(x) = t@Cosg;
         endif;
         reade(n) %kds( k1y3711 : 1 ) set23711;
       enddo;

      /end-free

     P SVPTAB_getItemsExcluyentes...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getItemsObligatorio(): Retorna Items Obligatorio       *
      *                                                               *
      *     peTaaj   ( input  ) Código de Cuestionario                *
      *     peCosg   ( output ) Vector de Código de Pregunta          *
      *                                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getItemsObligatorio...
     P                 b                   export
     D SVPTAB_getItemsObligatorio...
     D                 pi
     D   peTaaj                       2  0 const
     D   peCosg                       4    dim(200)

     D i               s             10i 0
     D x               s             10i 0
     D @@DsPr          ds                  likeds( set2371_t ) dim( 200 )
     D @@DsPrc         s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       clear peCosg;

       SVPTAB_getPreguntas( peTaaj
                          : @@DsPr
                          : @@DsPrC );

       for i = 1 to @@DsPrC;
         if @@DsPr(i).t@Cman = '1';
           x = %lookup( @@DsPr(i).t@Cosg : peCosg : 1);
           if x = 0;
             x = %lookup( *blanks : peCosg : 1);
             peCosg(x) = @@DsPr(i).t@Cosg;
           endif;
         endif;
       endfor;


      /end-free

     P SVPTAB_getItemsObligatorio...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_cotizaMoneda(): Retorna cotización de la moneda.      *
      *                                                              *
      *     peComo ( input  ) Código de Moneda                       *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      * Retorna : Cotizacion de Moneda / 0 = no tiene                *
      * ------------------------------------------------------------ *
     P SVPTAB_cotizaMoneda...
     P                 B                   export
     D SVPTAB_cotizaMoneda...
     D                 pi            15  6
     D   peComo                       2      const
     D   peFcot                       8  0   const

      /free

       SVPTAB_inz();

       return SVPTAB_cotizaMoneda2( peComo
                                  : SVPTAB_CMVEN
                                  : peFcot        );

      /end-free

     P SVPTAB_cotizaMoneda...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotas(): Retorna Tipo de Mascotas            *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getTipoMascotas...
     P                 b                   export
     D SVPTAB_getTipoMascotas...
     D                 pi
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

     D   @@DsTm        ds                  likerec( s1t136 : *input )

      /free

       SVPTAB_inz();

       clear peDsTm;

       setll *loval set136;
       dou %eof( set136 );
         read set136 @@DsTm;
         if not %eof( set136 );
           peDsTmC += 1;
           eval-corr peDsTm( peDsTmC ) = @@DsTm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getTipoMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRazaMascotas(): Retorna Raza de Mascotas            *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Raza de Mascotas        *
      *     peDsRmC  ( output ) Cantidad de Raza de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRazaMascotas...
     P                 b                   export
     D SVPTAB_getRazaMascotas...
     D                 pi
     D   peDsRm                            likeds( dsSet137_t ) dim(9999)
     D   peDsRmC                     10i 0

     D   @@DsRm        ds                  likerec( s1t137 : *input )

      /free

       SVPTAB_inz();

       clear peDsRm;

       setll *loval set137;
       dou %eof( set137 );
         read set137 @@DsRm;
         if not %eof( set137 );
           peDsRmC += 1;
           eval-corr peDsRm( peDsRmC ) = @@DsRm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getRazaMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotas(): Retorna Relación Tipo de Mascota y  *
      *                           Raza de Mascota                     *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRelaMascotas...
     P                 b                   export
     D SVPTAB_getRelaMascotas...
     D                 pi              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

     D @@DsRm          ds                  likerec( s1t138 : *input )
     D k1y138          ds                  likerec( s1t138 : *key )

      /free

       SVPTAB_inz();

       clear peDsRm;

       k1y138.t@Ctma = peCtma;
       setll %kds( k1y138 : 1 ) set138;
       if not %equal( set138 );
         return *off;
       endif;

       reade(n) %kds( k1y138 : 1 ) set138 @@DsRm;
       dow not %eof( set138 );
         peDsRmC += 1;
         eval-corr peDsRm( peDsRmC ) = @@DsRm;
         reade(n) %kds( k1y138 : 1 ) set138 @@DsRm;
       enddo;

       return *on;

      /end-free

     P SVPTAB_getRelaMascotas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getTipoMascotasWeb(): Retorna Tipo de Mascotas         *
      *                              habilitado en la WEB             *
      *                                                               *
      *     peDstm   ( output ) Estructura de Tipo de Mascotas        *
      *     peDstmC  ( output ) Cantidad de Tipo de Mascotas          *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getTipoMascotasWeb...
     P                 b                   export
     D SVPTAB_getTipoMascotasWeb...
     D                 pi
     D   peDsTm                            likeds( dsSet136_t ) dim(99)
     D   peDsTmC                     10i 0

     D   @@DsTm        ds                  likerec( s1t13601 : *input )

      /free

       SVPTAB_inz();

       clear peDsTm;

       setll *loval set13601;
       dou %eof( set13601 );
         read set13601 @@DsTm;
         if not %eof( set13601 );
           peDsTmC += 1;
           eval-corr peDsTm( peDsTmC ) = @@DsTm;
         endif;
       enddo;

       return;

      /end-free

     P SVPTAB_getTipoMascotasWeb...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getRelaMascotasWeb(): Retorna Relación Tipo de Mascota *
      *                              y Raza de Mascota habilitado en  *
      *                              la WEB                           *
      *                                                               *
      *     peCtma   ( input  ) Código Tipo de Mascotas               *
      *     peDsRm   ( output ) Estructura de Relación de Mascota     *
      *     peDsRmC  ( output ) Cantidad de Relación de Mascota       *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRelaMascotasWeb...
     P                 b                   export
     D SVPTAB_getRelaMascotasWeb...
     D                 pi              n
     D   peCtma                       2  0 const
     D   peDsRm                            likeds( dsSet138_t ) dim(9999)
     D   peDsRmC                     10i 0

     D x               s             10i 0
     D @@DsRm          ds                  likeds( dsSet138_t ) dim(9999)
     D @@DsRmC         s             10i 0

      /free

       SVPTAB_inz();

       x = 0;
       @@DsRmC = 0;

       clear peDsRm;
       clear @@DsRm;

       if SVPTAB_getRelaMascotas( peCtma
                                : @@DsRm
                                : @@DsRmC );

         for x = 1 to @@DsRmC;
           if @@DsRm(x).t@Mweb = '1';
             peDsRmC += 1;
             eval-corr peDsRm( peDsRmC ) = @@DsRm(x);
           endif;
         endfor;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getRelaMascotasWeb...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getParentescoVida():  Retorna tabla de parentescos     *
      *                                                               *
      *     peDsRm   ( output ) Estructura de Parentescos             *
      *     peDsRmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getParentescoVida...
     P                 b                   export
     D SVPTAB_getParentescoVida...
     D                 pi              n
     D   peT069                            likeds(set069_t) dim(999)
     D   peT069C                     10i 0

     D in069           ds                  likerec(s1t069:*input)

      /free

       SVPTAB_inz();

       setll *start set069;
       read set069 in069;
       dow not %eof;
           peT069C += 1;
           eval-corr peT069(peT069C) = in069;
        read set069 in069;
       enddo;

       return *on;

      /end-free

     P SVPTAB_getParentescoVida...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getFormasDePago(): Retorna lista con todas las formas  *
      *                           de pago                             *
      *                                                               *
      *     peTipo   ( input  ) Tipo de forma de pago                 *
      *     peDsFpg  ( output ) Estructura de Tipo de formas de pago  *
      *     peDsFpgC ( output ) Cantidad                              *
      *     peCfpg   ( input  ) Código de Forma de pago               *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getFormasDePago...
     P                 b                   export
     D SVPTAB_getFormasDePago...
     D                 pi              n
     D   peTipo                       1    const
     D   peDsFpg                           likeds( dsGntfpg_t ) dim(99)
     D   peDsFpgC                    10i 0
     D   peCfpg                       1  0 const options(*nopass:*omit)

     D   @@DsIFpg      ds                  likerec( g1tfpg : *input )
     D   @@DsIFpg2     ds                  likerec( g1tfpg02: *input )

      /free

       SVPTAB_inz();

       clear peDsFpg;
       clear peDsFpgC;

       If %parms >= 4;
         If peTipo = 'W';
            if %addr( peCfpg ) = *null;
               setll *loval gntfpg02;
               read gntfpg02 @@DsIFpg2;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
                read gntfpg02 @@DsIFpg2;
               enddo;
            else;
               setll peCfpg gntfpg02;
               reade peCfpg gntfpg02 @@DsIFpg2;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
                reade peCfpg gntfpg02 @@DsIFpg2;
               enddo;
            endif;
         else;
            If %addr( peCfpg ) = *null;
               setll *loval gntfpg;
               read gntfpg @@DsIFpg;
               dow not %eof();
                   peDsFpgC += 1;
                   eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
                read gntfpg @@DsIFpg;
               enddo;
            else;
               setll peCfpg gntfpg;
               reade peCfpg gntfpg @@DsIFpg;
               dow not %eof();
                  peDsFpgC += 1;
                  eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
                reade peCfpg gntfpg @@DsIFpg;
               enddo;
            endif;
         endif;
       else;
         if peTipo = 'W';
            setll *loval gntfpg02;
            read gntfpg02 @@DsIFpg2;
            dow not %eof();
                peDsFpgC += 1;
                eval-corr peDsFpg(peDsFpgC)= @@DsIFpg2;
             read gntfpg02 @@DsIFpg2;
            enddo;
         else;
            setll *loval gntfpg;
            read gntfpg @@DsIFpg;
            dow not %eof();
                peDsFpgC += 1;
                eval-corr peDsFpg(peDsFpgC)= @@DsIFpg;
             read gntfpg @@DsIFpg;
            enddo;
         endif;
       endif;

       if peDsFpgC = 0;
          return *off;
       endif;
       return *on;

      /end-free

     P SVPTAB_getFormasDePago...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCombinacionFormaDePago(): Retorna combianciones de  *
      *                                     formas de pagos por       *
      *                                     articulo                  *
      *     peArcd   ( input  ) Codigo de Articulo                    *
      *     peCfpg   ( input  ) Tipo de forma de pago                 *
      *     peCfp1   ( input  ) Relacion de forma de pago             *
      *     peDsCf   ( output ) Estructura de Combinaciones           *
      *     peDsCfC  ( output ) Cantidad de Combinaciones             *
      *     peTipo   ( input  ) Tipo de Solicitud                     *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCombinacionFormaDePago...
     P                 b                   export
     D SVPTAB_getCombinacionFormaDePago...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const options(*nopass:*omit)
     D   peCfp1                       1  0 const options(*nopass:*omit)
     D   peDsCf                            likeds( dsSet919_t ) dim(999)
     D                                     options(*nopass:*omit)
     D   peDsCfC                     10i 0 options(*nopass:*omit)
     D   peTipo                       1    options(*nopass:*omit)

     D   @@tipo        s              1
     D   @@DsICf       ds                  likerec( s1t919 : *input )
     D   @@DsCf        ds                  likeds( dsSet919_t ) dim(999)
     D   @@DsCfC       s             10i 0
     D   k1y919        ds                  likerec( s1t919 : *key )

      /free

       SVPTAB_inz();

       clear @@DsCf;
       clear @@DsCfC;
       @@tipo = 'T';
       if %parms >= 1;

          if %addr(peTipo) <> *null;
             @@tipo = %xlate( min : may : petipo );
             if ( @@tipo <> 'T' and @@tipo <> 'W' );
                @@tipo = 'T';
             endif;
          endif;

          Select;
            when %addr( peCfpg ) <> *null and
                 %addr( peCfp1 ) <> *null;

                 k1y919.t@arcd = peArcd;
                 k1y919.t@cfpg = peCfpg;
                 k1y919.t@cfp1 = peCfp1;
                 setll %kds( k1y919 : 3 ) set919;
                 reade %kds( k1y919 : 3 ) set919 @@DsICf;
                 dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                  reade %kds( k1y919 : 3 ) set919 @@DsICf;
                 enddo;

            when %addr( peCfpg ) <> *null and
                 %addr( peCfp1 ) =  *null;

                 k1y919.t@arcd = peArcd;
                 k1y919.t@cfpg = peCfpg;
                 setll %kds( k1y919 : 2 ) set919;
                 reade %kds( k1y919 : 2 ) set919 @@DsICf;
                 dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                  reade  %kds( k1y919 : 2 ) set919 @@DsICf;
                 enddo;

            when %addr( peCfpg ) =  *null and
                 %addr( peCfp1 ) <> *null;

                 k1y919.t@arcd = peArcd;
                 setll %kds( k1y919 : 1 ) set919;
                 reade %kds( k1y919 : 1 ) set919 @@DsICf;
                 dow not %eof();
                   if t@cfp1 = peCfp1;
                     if ( @@tipo = 'W' and
                        SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                        SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                        ( @@tipo <> 'W' and
                        SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                        SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                           @@DsCfC += 1;
                           eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                     endif;
                   endif;
                  reade %kds( k1y919 : 1 ) set919 @@DsICf;
                 enddo;
            other;
              k1y919.t@arcd = peArcd;
              setll %kds( k1y919 : 1 ) set919;
              reade %kds( k1y919 : 1 ) set919 @@DsICf;
               dow not %eof();
                   if ( @@tipo = 'W' and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                      ( @@tipo <> 'W' and
                      SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                      SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                         @@DsCfC += 1;
                         eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
                   endif;
                reade  %kds( k1y919 : 1 )set919 @@DsICf;
               enddo;
            endsl;
       else;
         k1y919.t@arcd = peArcd;
         setll %kds( k1y919 : 1 ) set919;
         reade %kds( k1y919 : 1 ) set919 @@DsICf;
          dow not %eof();
              if ( @@tipo = 'W' and
                 SVPVAL_formaDePagoWeb( @@DsICf.t@cfpg ) and
                 SVPVAL_formaDePagoWeb( @@DsICf.t@cfp1 ) ) or
                 ( @@tipo <> 'W' and
                 SVPVAL_formaDePago( @@DsICf.t@cfpg ) and
                 SVPVAL_formaDePago( @@DsICf.t@cfp1 ) );
                    @@DsCfC += 1;
                    eval-corr @@DsCf( @@DsCfC ) = @@DsICf;
              endif;
            reade %kds( k1y919 : 1 ) set919 @@DsICf;
          enddo;

       endif;

       if @@DsCfc = 0;
         return *off;
       endif;
       if %addr(peDsCf) <> *null;
          eval-corr peDsCf = @@DsCf;
       endif;
       if %addr(peDsCfC) <> *null;
          peDsCfC = @@DsCfC;
       endif;

       return *on;

      /end-free

     P SVPTAB_getCombinacionFormaDePago...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getResBcoXCodCobW: Retorna Datos de Resolución de     *
     ?*                           Banco por Código de Cobranza WEB   *
     ?*                                                              *
     ?*     peEmpr   ( input  ) Empresa                              *
     ?*     peSucu   ( input  ) Sucusal                              *
     ?*     peIvbc   ( input  ) Código del Banco                     *
     ?*     peIvsu   ( input  ) Sucursal del Banco        (opcional) *
     ?*     peComa   ( input  ) Código de Mayor Auxiliar  (opcional) *
     ?*     peNrma   ( input  ) Número de Mayor Auxiliar  (opcional) *
     ?*     peDsBa   ( output ) Estruct. Resolución Bco.  (opcional) *
     ?*     peDsBaC  ( output ) Cant. Reg. Resolución Bco.(opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPTAB_getResBcoXCodCobW...
     P                 B                   export
     D SVPTAB_getResBcoXCodCobW...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 options( *nopass : *omit )const
     D   peComa                       2    options( *nopass : *omit )const
     D   peNrma                       7  0 options( *nopass : *omit )const
     D   peDsBa                            likeds ( dsCntrba_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDsBaC                     10i 0 options( *nopass : *omit )

     D   k1yeba        ds                  likerec( c1trba04 : *key )
     D   @@DsIBa       ds                  likerec( c1trba04 : *input )
     D   @@DsBa        ds                  likeds ( dsCntrba_t ) dim( 999 )
     D   @@DsBaC       s             10i 0

      /free

       SVPTAB_inz();

       clear @@DsBa;
       @@DsBaC = 0;

       k1yeba.rbEmpr = peEmpr;
       k1yeba.rbSucu = peSucu;
       k1yeba.rbIvbc = peIvbc;

       if %parms >= 4;
         Select;
           when %addr( peIvsu ) <> *null and
                %addr( peComa ) <> *null and
                %addr( peNrma ) <> *null;

              k1yeba.rbIvsu = peIvsu;
              k1yeba.rbComa = peComa;
              k1yeba.rbNrma = peNrma;
              setll %kds( k1yeba : 6 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 6 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 6 ) cntrba04 @@DsIBa;
              enddo;

           when %addr( peIvsu ) <> *null and
                %addr( peComa ) <> *null and
                %addr( peNrma ) =  *null;

              k1yeba.rbIvsu = peIvsu;
              k1yeba.rbComa = peComa;
              setll %kds( k1yeba : 5 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 5 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 5 ) cntrba04 @@DsIBa;
              enddo;

           when %addr( peIvsu ) <> *null and
                %addr( peComa ) =  *null and
                %addr( peNrma ) =  *null;

              k1yeba.rbIvsu = peIvsu;
              setll %kds( k1yeba : 4 ) cntrba04;
              if not %equal( cntrba04 );
                return *off;
              endif;
              reade(n) %kds( k1yeba : 4 ) cntrba04 @@DsIBa;
              dow not %eof( cntrba04 );
                @@DsBaC += 1;
                eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
               reade(n) %kds( k1yeba : 4 ) cntrba04 @@DsIBa;
              enddo;

           other;
             setll %kds( k1yeba : 3 ) cntrba04;
             if not %equal( cntrba04 );
               return *off;
             endif;
             reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
             dow not %eof( cntrba04 );
               @@DsBaC += 1;
               eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
              reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
             enddo;
          endsl;
       else;
         setll %kds( k1yeba : 3 ) cntrba04;
         if not %equal( cntrba04 );
           return *off;
         endif;
         reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
         dow not %eof( cntrba04 );
           @@DsBaC += 1;
           eval-corr @@DsBa( @@DsBaC ) = @@DsIBa;
          reade(n) %kds( k1yeba : 3 ) cntrba04 @@DsIBa;
         enddo;
       endif;

       if %addr( peDsBa ) <> *null;
         eval-corr peDsBa = @@DsBa;
       endif;

       if %addr( peDsBaC ) <> *null;
         peDsBaC = @@DsBaC;
       endif;

       return *on;

      /end-free

     P SVPTAB_getResBcoXCodCobW...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getCntcfp(): Retorna datos de Forma de Pago.           *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peIvcv   ( input  ) Código del valor                      *
      *     peDsFp   ( output ) Estructura de Cntcfp                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCntcfp...
     P                 b                   export
     D SVPTAB_getCntcfp...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvcv                       2  0 const
     D   peDsFp                            likeds( dsCntcfp_t )

     D   k1ycfp        ds                  likerec( c1tcfp : *key   )
     D   @@DsIFp       ds                  likerec( c1tcfp : *input )

      /free

       SVPTAB_inz();

       clear peDsFp;

       k1ycfp.fpEmpr = peEmpr;
       k1ycfp.fpSucu = peSucu;
       k1ycfp.fpIvcv = peIvcv;
       chain %kds( k1ycfp : 3 ) cntcfp @@DsIFp;
       if %found( cntcfp );
         eval-corr peDsFp = @@DsIFp;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCntcfp...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getCntnau(): Retorna datos de Mayor Auxiliar.          *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar              *
      *     peNrma   ( input  ) Número de Mayor Auxiliar              *
      *     peDsNa   ( output ) Estructura de Cntnau                  *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCntnau...
     P                 b                   export
     D SVPTAB_getCntnau...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peDsNa                            likeds( dsCntnau_t )

     D   k1ynau        ds                  likerec( c1tnau01 : *key   )
     D   @@DsINa       ds                  likerec( c1tnau01 : *input )

      /free

       SVPTAB_inz();

       clear peDsNa;

       k1ynau.naEmpr = peEmpr;
       k1ynau.naSucu = peSucu;
       k1ynau.naComa = peComa;
       k1ynau.naNrma = peNrma;
       chain %kds( k1ynau : 4 ) cntnau01 @@DsINa;
       if %found( cntnau01 );
         eval-corr peDsNa = @@DsINa;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getCntnau...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_chkAgente(): Chequea si existe Agente en el archivo   *
      *                     SEHINT.-                                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peInta   (input)   Tipo de Agente                        *
      *     peInna   (input)   Nro de Agente                         *
      *                                                              *
      * Retorna: *on Encontro / *off No encontro                     *
      * ------------------------------------------------------------ *
     P SVPTAB_chkAgente...
     P                 B                   export
     D SVPTAB_chkAgente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peInta                       1  0 const
     D   peInna                       5  0 const

     D   k1yint        ds                  likerec( s1hint : *key )

      /free

        SVPTAB_inz();

        clear k1yint;

        k1yint.inEmpr = peEmpr;
        k1yint.inSucu = peSucu;
        k1yint.inInta = peInta;
        k1yint.inInna = peInna;
        chain %kds( k1yint : 4 ) sehint;
        if %found( sehint );
          return *on;
        endif;

        return *off;

      /end-free
     P SVPTAB_chkAgente...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_chkCntcfp02(): chequea datos de Forma de Pago.         *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peMar1   ( input  ) Código Equivalente                    *
      *     peIvcv   ( input  ) Código del valor                      *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_chkCntcfp02...
     P                 b                   export
     D SVPTAB_chkCntcfp02...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peMar1                       1    const
     D   peIvcv                       2  0 const

     D   k1yp01        ds                  likerec( c1tcfp01 : *key   )

      /free

       SVPTAB_inz();

       k1yp01.fpEmpr = peEmpr;
       k1yp01.fpSucu = peSucu;
       k1yp01.fpMar1 = peMar1;
       k1yp01.fpIvcv = peIvcv;
       chain %kds( k1yp01 : 4 ) cntcfp02;
       if %found( cntcfp02 );
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_chkCntcfp02...
     P                 e

     ?* ------------------------------------------------------------ *
     ?* SVPTAB_getTipoDePersona(): Retorna datos de Tipo de Persona  *
     ?*                                                              *
     ?*     peArcd   ( input  ) Articulo                             *
     ?*     peTipe   ( input  ) Código Tipo de Persona    (opcional) *
     ?*     peDs02   ( output ) Estruct. set6202          (opcional) *
     ?*     peDs02C  ( output ) Cant. Reg. set6202        (opcional) *
     ?*                                                              *
     ?* Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
     ?* ------------------------------------------------------------ *
     P SVPTAB_getTipoDePersona...
     P                 B                   export
     D SVPTAB_getTipoDePersona...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peTipe                       1    options( *nopass : *omit )const
     D   peDs02                            likeds ( set6202_t ) dim( 999 )
     D                                     options( *nopass : *omit )
     D   peDs02C                     10i 0 options( *nopass : *omit )

     D   k1y202        ds                  likerec( s1t6202 : *key )
     D   @@DsI02       ds                  likerec( s1t6202 : *input )
     D   @@Ds02        ds                  likeds ( set6202_t ) dim( 999 )
     D   @@Ds02C       s             10i 0

      /free

       SVPTAB_inz();

       clear @@Ds02;
       @@Ds02C = 0;

       k1y202.t@Arcd = peArcd;

       if %parms >= 2 and %addr(peTipe) <> *NULL;
         k1y202.t@Tipe = peTipe;
         setll %kds( k1y202 : 2 ) set6202;
         if not %equal( set6202 );
           return *off;
         endif;
         reade(n) %kds( k1y202 : 2 ) set6202 @@DsI02;
         dow not %eof( set6202 );
           @@Ds02C += 1;
           eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
          reade(n) %kds( k1y202 : 2 ) set6202 @@DsI02;
         enddo;
       else;
         setll %kds( k1y202 : 1 ) set6202;
         if not %equal( set6202 );
           return *off;
         endif;
         reade(n) %kds( k1y202 : 1 ) set6202 @@DsI02;
         dow not %eof( set6202 );
           @@Ds02C += 1;
           eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
          reade(n) %kds( k1y202 : 1 ) set6202 @@DsI02;
         enddo;
       endif;

       if %addr( peDs02 ) <> *null;
         eval-corr peDs02 = @@Ds02;
       endif;

       if %addr( peDs02C ) <> *null;
         peDs02C = @@Ds02C;
       endif;

       return *on;

      /end-free

     P SVPTAB_getTipoDePersona...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getPremioProd(): Retorna premio del producto del ar-  *
      *                         chivo SET100                         *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peMone   (input)   Moneda                                *
      *                                                              *
      * Retorna: t@prem                                              *
      * ------------------------------------------------------------ *
     P SVPTAB_getPremioProd...
     P                 B                   export
     D SVPTAB_getPremioProd...
     D                 pi            15  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const

     D   k1y100        ds                  likerec( s1t100 : *key )

      /free

        SVPTAB_inz();

        k1y100.t@Rama = peRama;
        k1y100.t@Xpro = peXpro;
        k1y100.t@Mone = peMone;
        chain %kds( k1y100 : 3 ) set100;
        if %found( set100 );
          return t@prem;
        endif;

        return *zeros;

      /end-free

     P SVPTAB_getPremioProd...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_getRequiereAPRC(): Retorna si la Rama y el Producto    *
      *                           requiere AP y RC                    *
      *                                                               *
      *     peRama   ( input  ) Rama                                  *
      *     peXpro   ( input  ) Producto                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getRequiereAPRC...
     P                 b                   export
     D SVPTAB_getRequiereAPRC...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peReAP                       1
     D   peReRC                       1

     D   k1y102        ds                  likerec( s1t102 : *key   )

      /free

       SVPTAB_inz();

       k1y102.t@Rama = peRama;
       k1y102.t@Xpro = peXpro;
       chain %kds( k1y102 : 2 ) set102;
       if %found( set102 );
         peReAP = t@Mar1;
         peReRC = t@Mar2;
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_getRequiereAPRC...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getProvincia(): Retorna provincia                      *
      *                                                               *
      *     peRpro   ( input  ) Provincia Index                       *
      *                                                               *
      * Retorna: PRPROC                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getProvincia...
     P                 b                   export
     D SVPTAB_getProvincia...
     D                 pi             3
     D   peRpro                       2  0 const

     D   k1ypro        ds                  likerec( g1tpro01 : *key )

      /free

       SVPTAB_inz();

       k1ypro.prRpro = peRpro;
       chain %kds( k1ypro : 1 ) gntpro01;
       if %found( gntpro01 );
         return prProc;
       endif;

       return *zeros;

      /end-free

     P SVPTAB_getProvincia...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getSet001() : Obtiene SET001                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peDs001  (output)  Estructura SET001                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet001...
     P                 B                   export
     D SVPTAB_getSet001...
     D                 pi              n
     D   peRama                       2  0 const
     D   peDs001                           likeds ( DsSET001_t )

     D k1y001          ds                  likerec( s1t001 : *key )
     D @@Ds001         ds                  likerec( s1t001 : *input )

      /free

       SVPTAB_inz();

       clear peDs001;
       k1y001.t@rama = peRama;
       chain %kds(k1y001) set001 @@Ds001;
       if %found(set001);
         eval-corr peDs001 = @@Ds001;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet001...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_chkSet102ac(): Chequea SET102AC                       *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peCact   (input)   Actividad               ( opcional )  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_chkSet102ac...
     P                 B                   export
     D SVPTAB_chkSet102ac...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCact                       5  0 options( *Nopass : *Omit ) const

     D k1y001          ds                  likerec( s1t001 : *key )
     D k1y102ac        ds                  likerec( s1t102ac : *key )
     D @CantK          s             10i 0

      /free

       SVPTAB_inz();

       k1y102ac.ttRama = peRama;
       k1y102ac.ttXpro = peXpro;
       @CantK = 2;
       if %parms >= 3 and %addr( peCact ) <> *null;
         k1y102ac.ttCact = peCact;
         @CantK = 3;
       endif;

       setll %kds( k1y102ac : @CantK ) set102ac;
       if not %equal( set102ac );
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_chkSet102ac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getSet102ac(): obtiene getSet102ac                    *
      *                                                              *
      *     peRama    (input)  Rama                                  *
      *     peXpro    (input)  Producto                              *
      *     peCact    (input)  Actividad               ( opcional )  *
      *     peDs102ac (output) Estructura SET102ac     ( opcional )  *
      *     peDs102ac (output) Cant. de Reg. SET102ac  ( opcional )  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet102ac...
     P                 B                   export
     D SVPTAB_getSet102ac...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCact                       5  0 options( *Nopass : *Omit ) const
     D   peDs102ac                         likeds ( DsSet102ac_t ) dim(9999)
     D                                     options( *Nopass : *Omit )
     D   peL102acC                   10i 0 options( *Nopass : *Omit )

     D k1y102ac        ds                  likerec( s1t102ac : *key )
     D @CantK          s             10i 0
     D @@Ds102acI      ds                  likerec( s1t102ac : *input )
     D @@Ds102ac       ds                  likeds ( DsSet102ac_t ) dim(9999)
     D @@L102acC       s             10i 0

      /free

       SVPTAB_inz();

       clear peDs102ac;
       clear @@L102acC;

       k1y102ac.ttRama = peRama;
       k1y102ac.ttXpro = peXpro;
       @CantK = 2;
       if %parms >= 3 and %addr( peCact ) <> *null;
         k1y102ac.ttCact = peCact;
         @CantK = 3;
       endif;

       setll %kds( k1y102ac : @CantK ) set102ac;
       if not %equal( set102ac );
         return *off;
       endif;

       reade(n) %kds( k1y102ac : @CantK ) set102ac @@Ds102acI;
       dow not %eof( set102ac );
         @@L102acC += 1;
         @@Ds102ac(@@L102acC).t@Rama = @@Ds102acI.ttRama;
         @@Ds102ac(@@L102acC).t@Xpro = @@Ds102acI.ttXpro;
         @@Ds102ac(@@L102acC).t@Cact = @@Ds102acI.ttCact;
         @@Ds102ac(@@L102acC).t@User = @@Ds102acI.ttUser;
         @@Ds102ac(@@L102acC).t@Date = @@Ds102acI.ttDate;
         @@Ds102ac(@@L102acC).t@Time = @@Ds102acI.ttTime;
       reade(n) %kds( k1y102ac : @CantK ) set102ac @@Ds102acI;
       enddo;

       if %addr( peDs102ac ) <> *null;
         eval-corr peDs102ac = @@Ds102ac;
       endif;

       if %addr( peL102acC ) <> *null;
         peL102acC = @@L102acC;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet102ac...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_chkActWeb(): Chequea si es una Actividad habilitada   *
      *                     para la Web                              *
      *                                                              *
      *     peCact   (input)   Actividad                             *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPTAB_chkActWeb...
     p                 b                   export
     D SVPTAB_chkActWeb...
     D                 pi              n
     D   peCact                       5  0 const

      /free

       SVPTAB_inz();

       chain(n) ( peCact ) set021;
       if %found ( set021);
         if ( t1Mweb = '1');
           return *on;
         endif;
       endif;

       return *off;

      /end-free

     P SVPTAB_chkActWeb...
     p                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getSet103() : Retorna SET103                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peDs103  (output)  Estructura SET103                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet103...
     P                 B                   export
     D SVPTAB_getSet103...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peDs103                           likeds ( DsSet103_t )

     D k1y103          ds                  likerec( s1t103 : *key )
     D @@Ds103         ds                  likerec( s1t103 : *input )

      /free

       SVPTAB_inz();

       clear peDs103;
       k1y103.t@Rama = peRama;
       k1y103.t@Xpro = peXpro;
       k1y103.t@Riec = peRiec;
       k1y103.t@Cobc = peCobc;
       k1y103.t@Mone = peMone;
       chain %kds(k1y103) set103 @@Ds103;
       if %found(set103);
         eval-corr peDs103 = @@Ds103;
       else;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet103...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getSet102v() : Retorna Parametros Emision Automatica  *
      *                       Vida Obligatorio.-                     *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peDs102v (output)  Estructura SET102v                    *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet102v...
     P                 B                   export
     D SVPTAB_getSet102v...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peDs102v                          likeds ( DsSet102v_t )

     D k1y102v         ds                  likerec( s1t102v : *key )
     D @@Ds102v        ds                  likerec( s1t102v : *input )

      /free

       SVPTAB_inz();

       clear peDs102v;
       k1y102v.v1Rama = peRama;
       k1y102v.v1Xpro = peXpro;
       chain %kds(k1y102v) set102v @@Ds102v;
       if %found(set102v);
         eval-corr peDs102v = @@Ds102v;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet102V...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getSet102V1() : Retorna Códigos de textos Preseteados *
      *                        Emision Auto Vida.-                   *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peXpro   (input)   Producto                              *
      *     peXpro   (input)   Producto                              *
      *     peXpro   (input)   Producto                              *
      *     peDs102v1(output)  Estructura SET102v1                   *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet102v1...
     P                 B                   export
     D SVPTAB_getSet102v1...
     D                 pi              n
     D   peFech                       8  0 const
     D   peIvse                       5  0 const
     D   peXpro                       3  0 const
     D   peRama                       2  0 const
     D   peTpcd                       2    const
     D   peDs102v1                         likeds ( DsSet102v1_t )

     D k1y102v1        ds                  likerec( s1t102v1 : *key )
     D @@Ds102v1       ds                  likerec( s1t102v1 : *input )

      /free

       SVPTAB_inz();

       clear peDs102v1;
       k1y102v1.v1Fech = peFech;
       k1y102v1.v1Ivse = peIvse;
       k1y102v1.v1Xpro = peXpro;
       k1y102v1.v1Rama = peRama;
       k1y102v1.v1Tpcd = peTpcd;
       chain %kds(k1y102v1) set102v1 @@Ds102v1;
       if %found(set102v1);
         eval-corr peDs102v1 = @@Ds102v1;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet102v1...
     P                 E
      * ------------------------------------------------------------- *
      * SVPTAB_getNumeradorGenerico(): Retorna Numero segun Tipo.-    *
      *                                                               *
      *     peTnum   ( input ) Tipo de Numerador                      *
      *     peNres   ( output ) Numero                                *
      *                                                               *
      * Retorna: *on                                                  *
      * ------------------------------------------------------------- *
     P SVPTAB_getNumeradorGenerico...
     P                 b                   export
     D SVPTAB_getNumeradorGenerico...
     D                 pi              n
     D   peTnum                       1    const
     D   peNres                       7  0

     D SPT902          pr                  extpgm('SPT902')
     D   peTnum                       1    const
     D   peNres                       7  0

      /free

       SVPTAB_inz();

       SPT902( peTnum : peNres );

       return *on;

      /end-free

     P SVPTAB_getNumeradorGenerico...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getNumGenericoWeb(): Retorna Numero segun Tipo Web.-   *
      *                                                               *
      *     peTnum   ( input ) Tipo de Numerador Web                  *
      *     peNres   ( output ) Numero                                *
      *                                                               *
      * Retorna: *on                                                  *
      * ------------------------------------------------------------- *
     P SVPTAB_getNumGenericoWeb...
     P                 b                   export
     D SVPTAB_getNumGenericoWeb...
     D                 pi              n
     D   peTnum                       2    const
     D   peNres                       7  0

     D k1y915          ds                  likerec( s1t915 : *key )
      /free

       SVPTAB_inz();

       k1y915.t@empr = 'A';
       k1y915.t@sucu = 'CA';
       k1y915.t@tnum = peTnum;

       chain %kds( k1y915:3 ) set915;
       if %found(set915);
          t@nres = t@nres + 1;
          update s1t915;
       else;
          t@empr = 'A';
          t@sucu = 'CA';
          @@tnum = petnum;
          t@nres = 1;
          write s1t915;
       endif;
       peNres = t@nres;

       return *on;

      /end-free

     P SVPTAB_getNumGenericoWeb...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getLugarPRISMA(): Retorna Datos de Lugar (PRISMA).    *
      *                                                              *
      *     peDsLp   ( output ) Estruct. set405                      *
      *     peDsLpC  ( output ) Cant. Reg. set405                    *
      *     peClos   ( input  ) Cód. Lugar de Ocurrencia Stro. (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_getLugarPRISMA...
     P                 B                   export
     D SVPTAB_getLugarPRISMA...
     D                 pi              n
     D   peDsLp                            likeds ( set405_t ) dim( 99 )
     D   peDsLpC                     10i 0
     D   peClos                       2    options( *nopass : *omit )

     D   @@DsLp        ds                  likerec( s1t405 : *input )

      /free

       SVPTAB_inz();

       clear peDsLp;
       clear peDsLpC;

       if %parms >= 2 and %addr(peClos) <> *NULL;
         chain(n) peClos set405 @@DsLp;
         if not %found( set405 );
           return *off;
         endif;
         peDsLpC += 1;
         eval-corr peDsLp( peDsLpC ) = @@DsLp;
       else;
         clear @@DsLp;
         setll *loval set405;
         read set405 @@DsLp;
         dow not %eof( set405 );
           peDsLpC += 1;
           eval-corr peDsLp( peDsLpC ) = @@DsLp;
           read set405 @@DsLp;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getLugarPRISMA...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getCausas(): Retorna Datos de Causas.                 *
      *                                                              *
      *     peDs01   ( output ) Estruct. set401                      *
      *     peDs01C  ( output ) Cant. Reg. set401                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCauc   ( input  ) Codigo de Causa       (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_getCausas...
     P                 B                   export
     D SVPTAB_getCausas...
     D                 pi              n
     D   peDs01                            likeds ( set401_t ) dim( 9999 )
     D   peDs01C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCauc                       4  0 options( *nopass : *omit )

     D  @@DsI01        ds                  likerec( s1t401 : *input )
     D  k1y401         ds                  likerec( s1t401 : *key   )
     D  @@Ds01         ds                  likeds ( set401_t ) dim( 9999 )
     D  @@Ds01C        s             10i 0

      /free

       SVPTAB_inz();

       clear @@Ds01;
       clear @@Ds01C;

       select;

         when %parms >= 3 and %addr(peRama) <> *NULL
                          and %addr(peCauc) <> *NULL;

           k1y401.t@Rama = peRama;
           k1y401.t@Cauc = peCauc;

           setll %kds( k1y401 : 2 ) set401;
           if not %equal( set401 );
             return *off;
           endif;
           reade(n) %kds( k1y401 : 2 ) set401 @@DsI01;
           dow not %eof( set401 );
             @@Ds01C += 1;
             eval-corr @@Ds01( @@Ds01C ) = @@DsI01;
             reade(n) %kds( k1y401 : 2 ) set401 @@DsI01;
           enddo;

         when %parms >= 2 and %addr(peRama) <> *NULL
                          and %addr(peCauc) =  *NULL;

           k1y401.t@Rama = peRama;

           setll %kds( k1y401 : 1 ) set401;
           if not %equal( set401 );
             return *off;
           endif;
           reade(n) %kds( k1y401 : 1 ) set401 @@DsI01;
           dow not %eof( set401 );
             @@Ds01C += 1;
             eval-corr @@Ds01( @@Ds01C ) = @@DsI01;
             reade(n) %kds( k1y401 : 1 ) set401 @@DsI01;
           enddo;

         other;

           setll *loval set401;
           read set401 @@DsI01;
           dow not %eof( set401 );
             @@Ds01C += 1;
             eval-corr @@Ds01( @@Ds01C ) = @@DsI01;
             read set401 @@DsI01;
           enddo;
       endsl;

       if %addr( peDs01 ) <> *null;
         eval-corr peDs01 = @@Ds01;
       endif;

       if %addr( peDs01C ) <> *null;
         peDs01C = @@Ds01C;
       endif;

       return *on;

      /end-free

     P SVPTAB_getCausas...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getEstados(): Retorna Datos del estado de Siniestro   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Surcusal                             *
      *     peDs02   ( output ) Estruct. set402                      *
      *     peDs02C  ( output ) Cant. Reg. set402                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCesi   ( input  ) Codigo de Siniestro   (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_getEstados...
     P                 B                   export
     D SVPTAB_getEstados...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs02                            likeds ( set402_t ) dim( 9999 )
     D   peDs02C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCesi                       2  0 options( *nopass : *omit )

     D  @@DsI02        ds                  likerec( s1t402 : *input )
     D  k1y402         ds                  likerec( s1t402 : *key   )
     D  @@Ds02         ds                  likeds ( set402_t ) dim( 9999 )
     D  @@Ds02C        s             10i 0

      /free

       SVPTAB_inz();

       clear @@Ds02;
       clear @@Ds02C;

       k1y402.t@Empr = peEmpr;
       k1y402.t@Sucu = peSucu;

       select;

         when %parms >= 6 and %addr(peRama) <> *NULL
                          and %addr(peCesi) <> *NULL;

           k1y402.t@Rama = peRama;
           k1y402.t@Cesi = peCesi;

           setll %kds( k1y402 : 4 ) set402;
           if not %equal( set402 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 4 ) set402 @@DsI02;
           dow not %eof( set402 );
             @@Ds02C += 1;
             eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
             reade(n) %kds( k1y402 : 4 ) set402 @@DsI02;
           enddo;

         when %parms >= 5 and %addr(peRama) <> *NULL
                          and %addr(peCesi) =  *NULL;

           k1y402.t@Rama = peRama;

           setll %kds( k1y402 : 3 ) set402;
           if not %equal( set402 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 3 ) set402 @@DsI02;
           dow not %eof( set402 );
             @@Ds02C += 1;
             eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
             reade(n) %kds( k1y402 : 3 ) set402 @@DsI02;
           enddo;

         other;

           setll %kds( k1y402 : 2 ) set402;
           if not %equal( set402 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 2 ) set402 @@DsI02;
           dow not %eof( set402 );
             @@Ds02C += 1;
             eval-corr @@Ds02( @@Ds02C ) = @@DsI02;
             reade(n) %kds( k1y402 : 2 ) set402 @@DsI02;
           enddo;
       endsl;

       if %addr( peDs02 ) <> *null;
         eval-corr peDs02 = @@Ds02;
       endif;

       if %addr( peDs02C ) <> *null;
         peDs02C = @@Ds02C;
       endif;

       return *on;

      /end-free

     P SVPTAB_getEstados...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getEstadoTiempo(): Retorna Datos de estado del tiempo *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs45   ( output ) Estruct. set445                      *
      *     peDs45C  ( output ) Cant. Reg. set445                    *
      *     peCdes   ( input  ) Cód. Estado del Tiempo.        (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_getEstadoTiempo...
     P                 B                   export
     D SVPTAB_getEstadoTiempo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs45                            likeds ( set445_t ) dim( 99 )
     D   peDs45C                     10i 0
     D   peCdes                       2  0 options( *nopass : *omit )

     D   @@Ds45        ds                  likerec( s1t445 : *input )
     D   k1y445        ds                  likerec( s1t445 : *key   )

      /free

       SVPTAB_inz();

       clear peDs45;
       clear peDs45C;

       k1y445.t@Empr = peEmpr;
       k1y445.t@Sucu = peSucu;

       if %parms >= 5 and %addr(peCdes) <> *NULL;
         k1y445.t@Cdes = peCdes;
         chain(n) %kds( k1y445 : 3 ) set445 @@Ds45;
         if not %found( set445 );
           return *off;
         endif;
         peDs45C += 1;
         eval-corr peDs45( peDs45C ) = @@Ds45;
       else;
         clear @@Ds45;
         setll %kds( k1y445 : 2 ) set445;
         reade(n) %kds( k1y445 : 2 ) set445 @@Ds45;
         dow not %eof( set445 );
           peDs45C += 1;
           eval-corr peDs45( peDs45C ) = @@Ds45;
           reade(n) %kds( k1y445 : 2 ) set445 @@Ds45;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getEstadoTiempo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getRelacionAseg(): Retorna Datos de relacion con      *
      *                           asegurado.                         *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs44   ( output ) Estruct. set444                      *
      *     peDs44C  ( output ) Cant. Reg. set444                    *
      *     peRela   ( input  ) Cód. relacion                  (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_getRelacionAseg...
     P                 B                   export
     D SVPTAB_getRelacionAseg...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs44                            likeds ( set444_t ) dim( 99 )
     D   peDs44C                     10i 0
     D   peRela                       2  0 options( *nopass : *omit )

     D   @@Ds44        ds                  likerec( s1t444 : *input )
     D   k1y444        ds                  likerec( s1t444 : *key   )

      /free

       SVPTAB_inz();

       clear peDs44;
       clear peDs44C;

       k1y444.t@Empr = peEmpr;
       k1y444.t@Sucu = peSucu;

       if %parms >= 5 and %addr(peRela) <> *NULL;
         k1y444.t@Rela = peRela;
         chain(n) %kds( k1y444 : 3 ) set444 @@Ds44;
         if not %found( set444 );
           return *off;
         endif;
         peDs44C += 1;
         eval-corr peDs44( peDs44C ) = @@Ds44;
       else;
         clear @@Ds44;
         setll %kds( k1y444 : 2 ) set444;
         reade(n) %kds( k1y444 : 2 ) set444 @@Ds44;
         dow not %eof( set444 );
           peDs44C += 1;
           eval-corr peDs44( peDs44C ) = @@Ds44;
           reade(n) %kds( k1y444 : 2 ) set444 @@Ds44;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getRelacionAseg...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_ListaRamas(): Retorna Todas las Ramas                  *
      *                                                               *
      *     peDsRa   ( output ) Estructura de Ramas                   *
      *     peDsRaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaRamas...
     P                 b                   export
     D SVPTAB_ListaRamas...
     D                 pi              n
     D   peRama                            likeds(DsSET001_t) dim(99)
     D   peRamaC                     10i 0

     D @@Ds001         ds                  likerec( s1t001 : *input )
     D rc              s              1a

      /free

       SVPTAB_inz();

       setll *start set001;
       read set001 @@Ds001;
       dow not %eof;
           peRamaC += 1;
           eval-corr peRama(peRamaC) = @@Ds001;
       read set001 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaRamas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaSexos(): Retorna Todos los Sexos                  *
      *                                                               *
      *     peDsSe   ( output ) Estructura de Sexos                   *
      *     peDsSeC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaSexos...
     P                 b                   export
     D SVPTAB_ListaSexos...
     D                 pi              n
     D   peDsSe                            likeds(DsGNTSEX_t) dim(99)
     D   peDsSeC                     10i 0

     D @@Ds001         ds                  likerec( g1tsex : *input )

      /free

       SVPTAB_inz();

       setll *start gntsex;
       read gntsex @@Ds001;
       dow not %eof;
           peDsSeC += 1;
           eval-corr peDsSe(peDsSeC) = @@Ds001;
       read gntsex @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaSexos...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaEstadoCivil : Retorna Todos los Estados Civiles   *
      *                                                               *
      *     peDsEs   ( output ) Estructura de Estado Civil            *
      *     peDsEsC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaEstadoCivil...
     P                 b                   export
     D SVPTAB_ListaEstadoCivil...
     D                 pi              n
     D   peDsEs                            likeds(DsGNTESC_t) dim(99)
     D   peDsEsC                     10i 0

     D @@Ds001         ds                  likerec( g1tesc : *input )

      /free

       SVPTAB_inz();

       setll *start gntesc;
       read gntesc @@Ds001;
       dow not %eof;
           peDsEsC += 1;
           eval-corr peDsEs(peDsEsC) = @@Ds001;
       read gntesc @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaEstadoCivil...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaPaises : Retorna Todos los Paises.                *
      *                                                               *
      *     peDsPa   ( output ) Estructura de Paises                  *
      *     peDsPaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaPaises...
     P                 b                   export
     D SVPTAB_ListaPaises...
     D                 pi              n
     D   peDsPa                            likeds(DsGNTPAI_t) dim(999)
     D   peDsPaC                     10i 0

     D @@Ds001         ds                  likerec( g1tpai : *input )

      /free

       SVPTAB_inz();

       setll *start gntpai;
       read gntpai @@Ds001;
       dow not %eof;
           peDsPaC += 1;
           eval-corr peDsPa(peDsPaC) = @@Ds001;
       read gntpai @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaPaises...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaVehiculos :  Retorna Todos los Vehículos.         *
      *                                                               *
      *     peDsVe   ( output ) Estructura de Vehículos               *
      *     peDsVeC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaVehiculos...
     P                 b                   export
     D SVPTAB_ListaVehiculos...
     D                 pi              n
     D   peDsVe                            likeds(DsSet280_t) dim(99999)
     D   peDsVeC                     10i 0
     D   peVhan                       4  0 const options( *nopass : *omit )
     D   peCmar                       9  0 const options( *nopass : *omit )
     D   peCgru                       3  0 const options( *nopass : *omit )

     D @@Ds001         ds                  likerec( s1t280 : *input )
     D k1y280          ds                  likerec( s1t280 : *key   )

      /free

       SVPTAB_inz();

       select;

       when %parms >= 2 and peVhan <> 0 and
       peCmar <> 0 and peCgru <> 0;

       k1y280.t@vhan = peVhan;
       k1y280.t@cmar = peCmar;
       k1y280.t@cgru = peCgru;
       setll %kds( k1y280 : 3 ) set280;
       reade(n) %kds( k1y280 : 3 ) set280 @@Ds001;
       dow not %eof;
           peDsVeC += 1;
           eval-corr peDsVe(peDsVeC) = @@Ds001;
       reade(n) %kds( k1y280 : 3 ) set280 @@Ds001;
       enddo;

       when %parms >= 2 and peVhan <> 0 and
       peCmar <> 0 and peCgru = 0;

       k1y280.t@vhan = peVhan;
       k1y280.t@cmar = peCmar;
       setll %kds( k1y280 : 2 ) set280;
       reade(n) %kds( k1y280 : 2 ) set280 @@Ds001;
       dow not %eof;
           peDsVeC += 1;
           eval-corr peDsVe(peDsVeC) = @@Ds001;
       reade(n) %kds( k1y280 : 2 ) set280 @@Ds001;
       enddo;

       when %parms >= 2 and peVhan <> 0 and
       peCmar = 0 and peCgru = 0;

       k1y280.t@vhan = peVhan;
       setll %kds( k1y280 : 1 ) set280;
       reade(n) %kds( k1y280 : 1 ) set280 @@Ds001;
       dow not %eof;
           peDsVeC += 1;
           eval-corr peDsVe(peDsVeC) = @@Ds001;
       reade(n) %kds( k1y280 : 1 ) set280 @@Ds001;
       enddo;

       when %parms >= 2 and peVhan = 0 and
       peCmar = 0 and peCgru = 0;

       setll *start set280;
       read set280 @@Ds001;
       dow not %eof;
           peDsVeC += 1;
           eval-corr peDsVe(peDsVeC) = @@Ds001;
       read set280 @@Ds001;
       enddo;
       endsl;


       return *on;

      /end-free

     P SVPTAB_ListaVehiculos...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCarrocerias :  Retorna todas las Carrocerias.     *
      *                                                               *
      *     peDsCa   ( output ) Estructura de Carrocerias.            *
      *     peDsCaC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaCarrocerias...
     P                 b                   export
     D SVPTAB_ListaCarrocerias...
     D                 pi              n
     D   peDsCa                            likeds(DsSet205_t) dim(99)
     D   peDsCaC                     10i 0

     D @@Ds001         ds                  likerec( s1t205 : *input )

      /free

       SVPTAB_inz();

       setll *start set205;
       read set205 @@ds001;
       dow not %eof;
           peDsCaC += 1;
           eval-corr peDsCa(peDsCaC) = @@Ds001;
       read set205 @@ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaCarrocerias...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaTipoDeVehiculos :  Retorna todos los tipos de     *
      *                                Vehículos.                     *
      *                                                               *
      *     peDsTv   ( output ) Estructura de Tipos de Vehículos      *
      *     peDsTvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaTipoDeVehiculos...
     P                 b                   export
     D SVPTAB_ListaTipoDeVehiculos...
     D                 pi              n
     D   peDsTv                            likeds(DsSet210_t) dim(99)
     D   peDsTvC                     10i 0

     D @@Ds001         ds                  likerec( s1t210 : *input )

      /free

       SVPTAB_inz();

       setll *start set210;
       read set210 @@Ds001;
       dow not %eof;
           peDsTvC += 1;
           eval-corr peDsTv(peDsTvC) = @@Ds001;
       read set210 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaTipoDeVehiculos...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaUsos : Retorna todos los Usos de Vehículos        *
      *                                                               *
      *     peDsUv   ( output ) Estructura de Usos de Vehículos       *
      *     peDsUvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaUsos...
     P                 b                   export
     D SVPTAB_ListaUsos...
     D                 pi              n
     D   peDsUv                            likeds(DsSet211_t) dim(99)
     D   peDsUvC                     10i 0

     D @@Ds001         ds                  likerec( s1t211 : *input )

      /free

       SVPTAB_inz();

       setll *start set211;
       read set211 @@Ds001;
       dow not %eof;
           peDsUvC += 1;
           eval-corr peDsUv(peDsUvC) = @@Ds001;
        read set211 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaUsos...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoAccidente() Retorna datos de tipo de         *
      *                             Accidente.                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs29   ( output ) Estruct. set429                      *
      *     peDs29C  ( output ) Cant. Reg. set429                    *
      *     peCdcs   ( input  ) Cód. Tipo de Accidente         (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoAccidente...
     P                 B                   export
     D SVPTAB_listaTipoAccidente...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs29                            likeds ( set429_t ) dim( 99 )
     D   peDs29C                     10i 0
     D   peCdcs                       2  0 options( *nopass : *omit )

     D   @@Ds29        ds                  likerec( s1t429 : *input )
     D   k1y429        ds                  likerec( s1t429 : *key   )

      /free

       SVPTAB_inz();

       clear peDs29;
       clear peDs29C;

       k1y429.t@Empr = peEmpr;
       k1y429.t@Sucu = peSucu;

       if %parms >= 5 and %addr(peCdcs) <> *NULL;
         k1y429.t@Cdcs = peCdcs;
         chain(n) %kds( k1y429 : 3 ) set429 @@Ds29;
         if not %found( set429 );
           return *off;
         endif;
         peDs29C += 1;
         eval-corr peDs29( peDs29C ) = @@Ds29;
       else;
         clear @@Ds29;
         setll %kds( k1y429 : 2 ) set429;
         reade(n) %kds( k1y429 : 2 ) set429 @@Ds29;
         dow not %eof( set429 );
           peDs29C += 1;
           eval-corr peDs29( peDs29C ) = @@Ds29;
           reade(n) %kds( k1y429 : 2 ) set429 @@Ds29;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoAccidente...
     P                 E

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCompanias :  Retorna Compañias Coaseguradoras     *
      *                                                               *
      *     peDsCm   ( output ) Estructura de Compañias Coaseguradoras*
      *     peDsCmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaCompanias...
     P                 b                   export
     D SVPTAB_ListaCompanias...
     D                 pi              n
     D   peDsCm                            likeds(dsSet120_t) dim(999)
     D   peDsCmC                     10i 0

     D @@Ds001         ds                  likerec( s1t120 : *input )

      /free

       SVPTAB_inz();

       setll *start set120;
       read set120 @@Ds001;
       dow not %eof;
           peDsCmC += 1;
           eval-corr peDsCm(peDsCmC) = @@Ds001;
       read set120 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaCompanias...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaMonedas : Retorna Monedas                         *
      *                                                               *
      *     peDsMo   ( output ) Estructura de Monedas                 *
      *     peDsMoC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaMonedas...
     P                 b                   export
     D SVPTAB_ListaMonedas...
     D                 pi              n
     D   peDsMo                            likeds(dsgntmon_t) dim(99)
     D   peDsMoC                     10i 0

     D @@Ds001         ds                  likerec( g1tmon : *input )

      /free

       SVPTAB_inz();

       setll *start gntmon;
       read gntmon @@Ds001;
       dow not %eof;
           peDsMoC += 1;
           eval-corr peDsMo(peDsMoC) = @@Ds001;
       read gntmon @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaMonedas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCuentasContables : Lista Cuentas Contables        *
      *                                                               *
      *     peDsCg   ( output ) Estructura de Cuentas Contables       *
      *     peDsCgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaCuentasContables...
     P                 b                   export
     D SVPTAB_ListaCuentasContables...
     D                 pi              n
     D   peDsCg                            likeds(dscntcge_t) dim(99999)
     D   peDsCgC                     10i 0

     D @@Ds001         ds                  likerec( c1tcge : *input )

      /free

       SVPTAB_inz();

       setll *start cntcge;
       read cntcge @@Ds001;
       dow not %eof;
           peDsCgC += 1;
           eval-corr peDsCg(peDsCgC) = @@Ds001;
       read cntcge @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaCuentasContables...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaImpuestos : Lista de Impuestos                    *
      *                                                               *
      *     peDsDm   ( output ) Estructura de Impuestos               *
      *     peDsDmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaImpuestos...
     P                 b                   export
     D SVPTAB_ListaImpuestos...
     D                 pi              n
     D   peDsDm                            likeds(dsgntdim_t) dim(99)
     D   peDsDmC                     10i 0

     D @@Ds001         ds                  likerec( g1tdim : *input )

      /free

       SVPTAB_inz();

       setll *start gntdim;
       read gntdim @@Ds001;
       dow not %eof;
           peDsDmC += 1;
           eval-corr peDsDm(peDsDmC) = @@Ds001;
       read gntdim @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaImpuestos...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaCoberturas : Lista de Coberturas                  *
      *                                                               *
      *     peDsCo   ( output ) Estructura de Coberturas              *
      *     peDsCoC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaCoberturas...
     P                 b                   export
     D SVPTAB_ListaCoberturas...
     D                 pi              n
     D   peDsCo                            likeds(dsset409_t) dim(99)
     D   peDsCoC                     10i 0

     D @@Ds001         ds                  likerec( s1t409 : *input )

      /free

       SVPTAB_inz();

       setll *start set409;
       read set409 @@Ds001;
       dow not %eof;
           peDsCoC += 1;
           eval-corr peDsCo(peDsCoC) = @@Ds001;
       read set409 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaCoberturas...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_ListaHechosGeneradores :  Lista de Hechos Generadores  *
      *                                                               *
      *     peDsHg   ( output ) Estructura de Hechos Generadores      *
      *     peDsHgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaHechosGeneradores...
     P                 b                   export
     D SVPTAB_ListaHechosGeneradores...
     D                 pi              n
     D   peDsHg                            likeds(dsset407_t) dim(99)
     D   peDsHgC                     10i 0

     D @@Ds001         ds                  likerec( s1t407 : *input )

      /free

       SVPTAB_inz();

       setll *start set407;
       read set407 @@Ds001;
       dow not %eof;
           peDsHgC += 1;
           eval-corr peDsHg(peDsHgC) = @@Ds001;
       read set407 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaHechosGeneradores...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_relacionCoberturaYHechoGen : Relacion entre Coberturas *
      *                                   y Hechos Generadores        *
      *     peDsHg   ( output ) Estructura de Relación                *
      *     peDsHgC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_relacionCoberturaYHechoGen...
     P                 b                   export
     D SVPTAB_relacionCoberturaYHechoGen...
     D                 pi              n
     D   peDsCh                            likeds(dsset412_t) dim(999)
     D   peDsChC                     10i 0
     D   peCobl                       2a   options(*nopass:*omit)

     D @@Ds001         ds                  likerec( s1t412 : *input )
     D k1y412          ds                  likerec( s1t412 : *input )

      /free

       SVPTAB_inz();

       if %parms >= 2 and %addr(peCobl) <> *NULL;
         clear k1y412;
         k1y412.t@cobl = peCobl;
         setll %kds(k1y412:1) set412;
         dou %eof( set412 );
           reade %kds(k1y412:1) set412 @@Ds001;
           if not %eof( set412 );
             peDsChC += 1;
             eval-corr peDsCh( peDsChC ) = @@Ds001;
           endif;
         enddo;
       else;
        setll *start set412;
        read set412 @@Ds001;
        dow not %eof;
            peDsChC += 1;
            eval-corr peDsCh(peDsChC) = @@Ds001;
        read set412 @@Ds001;
        enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_relacionCoberturaYHechoGen...
     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_listaProveedores : Lista Proveedores                   *
      *                                                               *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peTipo   ( input  ) Tipo de Proveedor                     *
      *     peDsPv   ( output ) Estructura de Relación                *
      *     peDsPvC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_listaProveedores...
     P                 b                   export
     D SVPTAB_listaProveedores...
     D                 pi              n
     D   peEmpr                       1a   Const
     D   peSucu                       2a   Const
     D   peTipo                       3a   Const
     D   peDsPv                            likeds(dsprovee_t) dim(50000)
     D   peDsDm                            likeds(domiprov_t) dim(50000)
     D   peDsDc                            likeds(ctcprov_t) dim(50000)
     D   peDsPvC                     10i 0


     D f               s             10i 0
     D i               s             10i 0
     D x               s             10i 0
     D k1ynau          ds                  likerec( c1tnau01 : *input )
     D peDsNp          ds                  likeds(dscntnap_t) dim(9999)
     D peDsNpC         s             10i 0
     D localidad       s             20a
     D provincia       s             20a
     D peDsGp          ds                  likeds(dsgntpro_t) dim(99)
     D peDsGpC         s             10i 0
     D peDsCa          ds                  likeds(dscntcau_t) dim(99)
     D peDsCaC         s             10i 0

      /free

       SVPTAB_inz();

       peDsPvC = 0;
       peDsCaC = 0;

       select ;
         When petipo = 'TOD';
           if svptab_getCntcau( peDsCa : peDsCaC : *omit );
           for i = 1 to peDsCaC;
       // --------------------------------------------------------------
       // Solo leo codigos mayor aux en rango 80 a 89 Proveedores de Servicio
       // --------------------------------------
             if peDsCa(i).cacoma IN %Range('80' : '89');
             k1ynau.naempr = peEmpr;
             k1ynau.nasucu = peSucu;
             k1ynau.nacoma = peDsCa(i).caComa;
             setll %kds(k1ynau:3) cntnau01;
             reade %kds(k1ynau:3) cntnau01;
             dow not %eof (cntnau01);
       // --------------------------------------------------------------
       // Solo leo proveedores en estado normal  NABLOQ='N'
       // ---------------------------------------------------------------
               if nabloq ='N';
                 peDsPvC += 1;
                 peDsPv(peDsPvc).pvempr = naempr ;
                 peDsPv(peDsPvc).pvsucu = nasucu ;
                 peDsPv(peDsPvc).pvcoma = nacoma ;
                 peDsPv(peDsPvc).pvnrma = nanrma ;
                 peDsPv(peDsPvc).pvcuit = dfcuit ;
                 peDsPv(peDsPvc).pvnomb = dfnomb ;
                 peDsPv(peDsPvc).pvtipo = petipo ;
                 if SVPTAB_getCntnap( peDsNp
                                    : peDsNpC
                                    : nacoma
                                    : nanrma
                                    : *omit ) = *on ;
                  for x = 1 to peDsNpC;
                   peDsPv(peDsPvC).pvcrcr = peDsNp(pedsNpC).nanres;
                   peDsDm(peDsPvC).pvdomi = peDsNp(pedsNpC).nadomi;
                   peDsDm(peDsPvC).pvcopo = peDsNp(pedsNpC).nacopo;
                   peDsDm(peDsPvC).pvcops = peDsNp(pedsNpC).nacops;
                   peDsDm(peDsPvC).pvloca = SVPDES_localidad( naCopo
                                                            : naCops );
                    SVPTAB_getGntpro( peDsGp : peDsGpC : loproc );
                   peDsDm(peDsPvC).pvprod = peDsGp(peDsGpC).prProd;
                   peDsDc(peDsPvC).pvtele = peDsNp(pedsNpC).nantel;
                   peDsDc(peDsPvC).pvemai = peDsNp(pedsNpC).namail;
                   peDsDc(peDsPvC).pvhora = peDsNp(pedsNpC).naaten;
                   peDsDc(peDsPvC).pvnomb = peDsNp(pedsNpC).nacont;
                  endfor;
                 else;
                   peDsPv(peDsPvc).pvcrcr = 0 ;
                   peDsDm(peDsPvC).pvdomi = dfdomi ;
                   peDsDm(peDsPvC).pvcopo = dfcopo ;
                   peDsDm(peDsPvC).pvcops = dfcops ;
                   peDsDm(peDsPvC).pvloca = loloca ;
                    SVPTAB_getGntpro( peDsGp : peDsGpC : loproc );
                   peDsDm(peDsPvC).pvprod = peDsGp(peDsGpC).prProd;
                   peDsDc(peDsPvC).pvtele = %trim(%char(dfteln)) ;
                   peDsDc(peDsPvC).pvemai = *blanks;
                   peDsDc(peDsPvC).pvhora = *blanks;
                   peDsDc(peDsPvC).pvnomb = *blanks;
                 endif;
               endif;
             reade %kds(k1ynau:3) cntnau01;
           enddo;
         endif;
       endfor;
       endif;

       // --------------------------------------------------------------
       // Si no es TODOS se fija que tipo solicita el request.
       // ---------------------------------------------------------------
       other;
         setll *start cntnap04;
         read cntnap04;
         dow not %eof(cntnap04);
       // --------------------------------------------------------------
       // Carga lo mismo para Cristaleros, Ruederos, Invest, Inspec, Liquidadore
       // Dt20220908: Agrego si encuentra proveedores de ambos (Rue y Cri) lo ll
       // ---------------------------------------------------------------
         if namar1 = 'C' and petipo = 'CRI' or
           namar1 = 'A' and petipo = 'CRI' or
           namar1 = 'R' and petipo = 'RUE' or
           namar1 = 'A' and petipo = 'RUE' or
           namar1 = 'V' and petipo = 'INV' or
           namar1 = 'I' and petipo = 'INS' or
           namar1 = 'L' and petipo = 'LIQ';

           k1ynau.naempr = peEmpr;
           k1ynau.nasucu = peSucu;
           k1ynau.nacoma = naComa;
           k1ynau.nanrma = naNrma;
           chain %kds(k1ynau:4) cntnau01;
       // --------------------------------------------------------------
       // Solo devuelvo proveedores en estado normal  NABLOQ='N'
       // ---------------------------------------------------------------
            if %found(cntnau01) and nabloq ='N';
               peDsPvC += 1;
               peDsPv(peDsPvc).pvcoma = nacoma;
               peDsPv(peDsPvc).pvnrma = nanrma;
               peDsPv(peDsPvc).pvnomb = nanomb;
               peDsPv(peDsPvc).pvcrcr = nanres;
               peDsPv(peDsPvc).pvtipo = petipo ;
               peDsDm(peDsPvC).pvdomi = nadomi;
               peDsDm(peDsPvC).pvcopo = nacopo;
               peDsDm(peDsPvC).pvcops = nacops;
               peDsDc(peDsPvC).pvtele = nantel;
               peDsDc(peDsPvC).pvemai = namail;
               peDsDc(peDsPvC).pvhora = naaten;
               peDsDc(peDsPvC).pvnomb = nacont;
               peDsDm(peDsPvC).pvloca = SVPDES_localidad( naCopo
                                                        : naCops );
               peDsPv(peDsPvc).pvempr = naempr;
               peDsPv(peDsPvc).pvsucu = nasucu;
               peDsPv(peDsPvc).pvcuit = dfcuit;
               SVPTAB_getGntpro( peDsGp : peDsGpC : loproc );
               peDsDm(peDsPvC).pvprod = peDsGp(peDsGpC).prProd;
            endif;
          endif;
         read cntnap04;
         enddo;

       endsl;

       return *on;

      /end-free

     P SVPTAB_listaProveedores...
     P                 e
      * ------------------------------------------------------------- *
      * SVPTAB_getCntnap : Recupero Proveedores de CNTNAP             *
      *                                                               *
      *     peDsNp   ( output ) Estructura de Relación                *
      *     peDsNpC  ( output ) Cantidad                              *
      *     pecoma   ( input  ) Código Mayor Auxiliar                 *
      *     peNrma   ( input  ) Número Mayor Auxiliar                 *
      *     peTipo   ( input  ) Tipo de Proveedor                     *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getCntnap...
     P                 b                   export
     D SVPTAB_getCntnap...
     D                 pi              n
     D   peDsNp                            likeds(dscntnap_t) dim(9999)
     D   peDsNpC                     10i 0
     D   peComa                       2a   options(*nopass:*omit)
     D   peNrma                       7  0 options(*nopass:*omit)
     D   peTipo                       1a   options(*nopass:*omit)

     D   k1ynap        ds                  likerec( c1tnap : *key )
     D   @@Ds001       ds                  likerec( c1tnap : *input )
     D   encon         s                   like(*in50)

      /free

       SVPTAB_inz();

       encon = *off;
       select;

       when %parms >= 2 and %addr(peComa) = *NULL;
         setll *start cntnap04;
         read cntnap04 @@Ds001;
         dow not %eof;
             peDsNpC += 1;
             eval-corr peDsNp(peDsNpC) = @@Ds001;
         encon = *on;
         read cntnap04 @@Ds001;
         enddo;

       when %parms >= 2 and %addr(peComa) <> *NULL
            and %addr(petipo) = *NULL ;
         clear k1ynap;
         k1ynap.nacoma = peComa;
         k1ynap.nanrma = peNrma;
         setll %kds(k1ynap:2) cntnap04;
         reade %kds(k1ynap:2) cntnap04 @@Ds001;
         dow not %eof;
           peDsNpC += 1;
           eval-corr peDsNp(peDsNpC) = @@Ds001;
         encon = *on;
         reade %kds(k1ynap:2) cntnap04 @@Ds001;
         enddo;

       when %parms >= 2 and %addr(peComa) <> *NULL
            and %addr(petipo) <> *NULL ;
         clear k1ynap;
         k1ynap.nacoma = peComa;
         k1ynap.nanrma = peNrma;
         setll %kds(k1ynap:2) cntnap04;
         reade %kds(k1ynap:2) cntnap04 @@Ds001;
         dow not %eof;
          if namar1 = petipo;
           peDsNpC += 1;
           eval-corr peDsNp(peDsNpC) = @@Ds001;
           encon = *on;
          endif;
         reade %kds(k1ynap:2) cntnap04 @@Ds001;
         enddo;

       endsl;

       if encon = *on;
        return *on;
        else;
        return *off;
       endif;

     P SVPTAB_getCntnap...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getGntpro() : Retorna Datos de Provincias             *
      *                                                              *
      *     peDsGp   ( output ) Estruct. GNTPRO                      *
      *     peDsGpC  ( output ) Cant. Reg. GNTPRO                    *
      *     peProc   ( input  ) Cód. de Provincia              (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_getGntpro...
     P                 B                   export
     D SVPTAB_getGntpro...
     D                 pi              n
     D   peDsGp                            likeds ( dsgntpro_t ) dim( 99 )
     D   peDsGpC                     10i 0
     D   peProc                       3a   options( *nopass : *omit )

     D   @@DsGp        ds                  likerec( g1tpro : *input )
     D   k1ypro        ds                  likerec( g1tpro : *key   )

      /free

       SVPTAB_inz();

       clear peDsGp;
       clear peDsGpC;


       if %parms >= 2 and %addr(peProc) <> *NULL;
         k1ypro.prProc = peProc;
         chain(n) %kds( k1ypro: 1 ) gntpro @@DsGp;
         if not %found( gntpro );
           return *off;
         endif;
         peDsGpC += 1;
         eval-corr peDsGp( peDsGpC ) = @@DsGP;
       else;
         clear @@DsGp;
         setll *start gntpro;
         read gntpro @@DsGp;
         dow not %eof( gntpro );
           peDsGpC += 1;
           eval-corr peDsGp( peDsGpC ) = @@DsGp;
         read gntpro @@DsGp;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getGntpro...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getCntcau() : Retorna Datos de Mayores Auxiliares     *
      *                                                              *
      *     peDsCa   ( output ) Estruct. CNTCAU                      *
      *     peDsCaC  ( output ) Cant. Reg. CNTCAU                    *
      *     peComa   ( input  ) Cód. de Mayor Auxiliar         (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_getCntcau...
     P                 B                   export
     D SVPTAB_getCntcau...
     D                 pi              n
     D   peDsCa                            likeds ( dscntcau_t ) dim( 99 )
     D   peDsCaC                     10i 0
     D   peComa                       2a   options( *nopass : *omit )

     D   @@DsCa        ds                  likerec( c1tcau : *input )
     D   k1ycau        ds                  likerec( c1tcau : *key   )

      /free

       SVPTAB_inz();

       clear peDsCa;
       clear peDsCaC;


       if %parms >= 2 and %addr(peComa) <> *NULL;
         k1ycau.cacoma = peComa;
         chain(n) %kds( k1ycau: 1 ) cntcau @@DsCa;
         if not %found( cntcau );
           return *off;
         endif;
         if @@DsCa.caesti = 'P' and @@DsCa.cacoma <> '60' and
            @@DsCa.caesti = 'P' and @@DsCa.cacoma <> '69';
         peDsCaC += 1;
         eval-corr peDsCa( peDsCaC ) = @@DsCa;
         endif;
       else;
         clear @@DsCa;
         setll *start cntcau;
         read cntcau @@DsCa;
         dow not %eof( cntcau );
         if @@DsCa.caesti = 'P' and @@DsCa.cacoma <> '60' and
            @@DsCa.caesti = 'P' and @@DsCa.cacoma <> '69';
           peDsCaC += 1;
           eval-corr peDsCa( peDsCaC ) = @@DsCa;
         endif;
         read cntcau @@DsCa;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getCntcau...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getGntloc() : Retorna Datos de Localidades            *
      *                                                              *
      *     peDsLc   ( output ) Estruct. GNTLOC                      *
      *     peDsLcC  ( output ) Cant. Reg. GNTLOC                    *
      *     peCopo   ( input  ) Cód. Postal.                   (Opc) *
      *     peCops   ( input  ) Sufijo Cód. Postal.            (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_getGntloc...
     P                 B                   export
     D SVPTAB_getGntloc...
     D                 pi              n
     D   peDsLc                            likeds ( dsgntloc_t ) dim(99999)
     D   peDsLcC                     10i 0
     D   peCopo                       5s 0 options( *nopass : *omit )
     D   peCops                       1s 0 options( *nopass : *omit )

     D   @@DsLc        ds                  likerec( g1tloc : *input )
     D   k1yloc        ds                  likerec( g1tloc : *key   )

      /free

       SVPTAB_inz();

       clear peDsLc;
       clear peDsLcC;


       if %parms >= 2 and %addr(peCopo) <> *NULL;
         k1yloc.locopo = peCopo;
         k1yloc.locops = peCops;
         chain(n) %kds( k1yloc: 2 ) gntloc @@DsLc;
         if not %found( gntloc );
           return *off;
         endif;
         peDsLcC += 1;
         eval-corr peDsLc( peDsLcC ) = @@DsLc;
       else;
         clear @@DsLc;
         setll *start gntloc;
         read gntloc @@DsLc;
         dow not %eof( gntloc );
           peDsLcC += 1;
           eval-corr peDsLc( peDsLcC ) = @@DsLc;
         read gntloc @@DsLc;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getGntloc...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_chkSet001() : Chequea SET001                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_chkSet001...
     P                 B                   export
     D SVPTAB_chkSet001...
     D                 pi              n
     D   peRama                       2  0 const

     D k1y001          ds                  likerec( s1t001 : *key )

      /free

       SVPTAB_inz();

       k1y001.t@rama = peRama;
       setll %kds(k1y001) set001 ;
       if %equal(set001);
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_chkSet001...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getGntmon() : Retorna Datos de Provincias             *
      *                                                              *
      *     peDsGp   ( output ) Estruct. GNTPRO                      *
      *     peDsGpC  ( output ) Cant. Reg. GNTPRO                    *
      *     peProc   ( input  ) Cód. de Provincia              (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_getGntmon...
     P                 B                   export
     D SVPTAB_getGntmon...
     D                 pi              n
     D   peDsMo                            likeds ( dsgntmon_t )
     D************                         options( *nopass : *omit )
     D** peDsMoC                     10i 0
     D   peComo                       2a   const options( *nopass : *omit )
     D   peMoeq                       2a   const options( *nopass : *omit )

     D   @@DsMo        ds                  likerec( g1tmon : *input )
     D   k1ymon        ds                  likerec( g1tmon : *key   )
     D   @@DsMo01      ds                  likerec( g1tmon01 : *input )
     D   k2ymon        ds                  likerec( g1tmon01 : *key   )

      /free

       SVPTAB_inz();

       clear peDsMo;
       clear @@DsMo;


       if %parms >= 2 and %addr(peComo) <> *NULL;
         k1ymon.moComo = peComo;
         chain(n) %kds( k1ymon: 1 ) gntmon @@DsMo;
         if not %found( gntmon );
           return *off;
         endif;
         eval-corr peDsMo = @@DsMo;
       else;
        if %parms >= 2 and %addr(peMoeq) <> *NULL;
         k2ymon.moMoeq = peMoeq;
         chain(n) %kds( k2ymon: 1 ) gntmon01 @@DsMo01;
         if not %found( gntmon01 );
           return *off;
         endif;
         eval-corr peDsMo = @@DsMo01;
        endif;
       endif;

       return *on;

      /end-free

     P SVPTAB_getGntmon...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getGntlo1() : Retorna Datos Loc. Calles Cap.          *
      *                                                              *
      *     peDsL1   ( output ) Estruct. GNTLO1                      *
      *     peDsL1C  ( output ) Cant. Reg. GNTLO1                    *
      *     peCopo   ( input  ) Cod. Postal                    (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_getGntlo1...
     P                 B                   export
     D SVPTAB_getGntlo1...
     D                 pi              n
     D   peDsL1                            likeds ( dsgntlo1_t ) dim(9999)
     D   peDsL1C                     10i 0
     D   peCopo                       5p 0 options( *nopass : *omit )

     D   k1ylo1        ds                  likerec( g1tlo1 : *key   )
     D   @@DsL1        ds                  likerec( g1tlo1 : *input )
     D   @@DsL1C       s             10i 0

      /free

       SVPTAB_inz();

       clear peDsL1;
       clear peDsL1C;


       if %parms = 3 and %addr(peCopo) <> *NULL;
         k1yLo1.l1Copo = peCopo;

         chain(n) %kds( k1ylo1 : 1 ) gntlo1;
         if not %found( gntlo1 );
           return *off;
         endif;

         setll %kds( k1ylo1 : 1 ) gntlo1;
         reade(n) %kds( k1ylo1 : 1 ) gntlo1 @@DsL1;
         dow not %eof( gntlo1 );
           peDsL1C += 1;
           eval-corr peDsL1 ( peDsL1C ) = @@DsL1;
           clear @@DsL1;
         reade(n) %kds( k1ylo1 : 1 ) gntlo1 @@DsL1;
         enddo;
       else;
         setll *start gntlo1;
         read gntlo1 @@DsL1;
         dow not %eof( gntlo1 );
           peDsL1C += 1;
           eval-corr peDsL1( peDsL1C ) = @@DsL1;
           clear @@DsL1;
         read gntlo1 @@DsL1;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_getGntlo1...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoColision(): Retorna datos de tipo de colision*
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs42   ( output ) Estruct. set442                      *
      *     peDs42C  ( output ) Cant. Reg. set442                    *
      *     peCtco   ( input  ) Cód. Tipo de Colision          (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoColision...
     P                 B                   export
     D SVPTAB_listaTipoColision...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs42                            likeds ( set442_t ) dim( 99 )
     D   peDs42C                     10i 0
     D   peCtco                       2  0 options( *nopass : *omit )

     D   @@Ds42        ds                  likerec( s1t442 : *input )
     D   k1y442        ds                  likerec( s1t442 : *key   )

      /free

       SVPTAB_inz();

       clear peDs42;
       clear peDs42C;

       k1y442.t@Empr = peEmpr;
       k1y442.t@Sucu = peSucu;

       if %parms >= 5 and %addr(peCtco) <> *NULL;
         k1y442.t@Ctco = peCtco;
         chain(n) %kds( k1y442 : 3 ) set442 @@Ds42;
         if not %found( set442 );
           return *off;
         endif;
         peDs42C += 1;
         eval-corr peDs42( peDs42C ) = @@Ds42;
       else;
         clear @@Ds42;
         setll %kds( k1y442 : 2 ) set442;
         reade(n) %kds( k1y442 : 2 ) set442 @@Ds42;
         dow not %eof( set442 );
           peDs42C += 1;
           eval-corr peDs42( peDs42C ) = @@Ds42;
           reade(n) %kds( k1y442 : 2 ) set442 @@Ds42;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoColision...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaLugarNoPRISMA(): Retorna datos de Lugar no PRISMA*
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDs43   ( output ) Estruct. set443                      *
      *     peDs43C  ( output ) Cant. Reg. set443                    *
      *     peClug   ( input  ) Cód. de Lugar                  (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaLugarNoPRISMA...
     P                 B                   export
     D SVPTAB_listaLugarNoPRISMA...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDs43                            likeds ( set443_t ) dim( 99 )
     D   peDs43C                     10i 0
     D   peClug                       2  0 options( *nopass : *omit )

     D   @@Ds43        ds                  likerec( s1t443 : *input )
     D   k1y443        ds                  likerec( s1t443 : *key   )

      /free

       SVPTAB_inz();

       clear peDs43;
       clear peDs43C;

       k1y443.t@Empr = peEmpr;
       k1y443.t@Sucu = peSucu;

       if %parms >= 5 and %addr(peClug) <> *NULL;
         k1y443.t@Clug = peClug;
         chain(n) %kds( k1y443 : 3 ) set443 @@Ds43;
         if not %found( set443 );
           return *off;
         endif;
         peDs43C += 1;
         eval-corr peDs43( peDs43C ) = @@Ds43;
       else;
         clear @@Ds43;
         setll %kds( k1y443 : 2 ) set443;
         reade(n) %kds( k1y443 : 2 ) set443 @@Ds43;
         dow not %eof( set443 );
           peDs43C += 1;
           eval-corr peDs43( peDs43C ) = @@Ds43;
           reade(n) %kds( k1y443 : 2 ) set443 @@Ds43;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaLugarNoPRISMA...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoBeneficiario(): Retorna datos de tipo de     *
      *                                 beneficiario                 *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDsBe   ( output ) Estruct. gnttbe                      *
      *     peDsBeC  ( output ) Cant. Reg. gnttbe                    *
      *     peTben   ( input  ) Cód. Tipo de beneficiario      (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoBeneficiario...
     P                 B                   export
     D SVPTAB_listaTipoBeneficiario...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsBe                            likeds ( dsGnttbe_t ) dim( 99 )
     D   peDsBeC                     10i 0
     D   peTben                       1    options( *nopass : *omit )

     D   @@DsBe        ds                  likerec( g1ttbe : *input )
     D   k1ytbe        ds                  likerec( g1ttbe : *key   )

      /free

       SVPTAB_inz();

       clear peDsBe;
       clear peDsBeC;

       k1ytbe.g1Empr = peEmpr;
       k1ytbe.g1Sucu = peSucu;

       if %parms >= 5 and %addr(peTben) <> *NULL;
         k1ytbe.g1Tben = peTben;
         chain(n) %kds( k1ytbe : 3 ) gnttbe @@DsBe;
         if not %found( gnttbe );
           return *off;
         endif;
         peDsBeC += 1;
         eval-corr peDsBe( peDsBeC ) = @@DsBe;
       else;
         clear @@DsBe;
         setll %kds( k1ytbe : 2 ) gnttbe;
         reade(n) %kds( k1ytbe : 2 ) gnttbe @@DsBe;
         dow not %eof( gnttbe );
           peDsBeC += 1;
           eval-corr peDsBe( peDsBeC ) = @@DsBe;
           reade(n) %kds( k1ytbe : 2 ) gnttbe @@DsBe;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoBeneficiario...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaEdoReclamo(): Retorna datos de estado de reclamo *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Surcusal                             *
      *     peDsEr   ( output ) Estruct. set4021                     *
      *     peDsErC  ( output ) Cant. Reg. set4021                   *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peCesi   ( input  ) Codigo de estado      (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaEdoReclamo...
     P                 B                   export
     D SVPTAB_listaEdoReclamo...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsEr                            likeds( dsSet4021_t ) dim( 9999 )
     D   peDsErC                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peCesi                       2  0 options( *nopass : *omit )

     D  @@DsI02        ds                  likerec( s1t4021 : *input )
     D  k1y402         ds                  likerec( s1t4021 : *key   )
     D  @@DsEr         ds                  likeds( dsSet4021_t ) dim( 9999 )
     D  @@DsErC        s             10i 0

      /free

       SVPTAB_inz();

       clear @@DsEr;
       clear @@DsErC;

       k1y402.t@Empr = peEmpr;
       k1y402.t@Sucu = peSucu;

       select;

         when %parms >= 6 and %addr(peRama) <> *NULL
                          and %addr(peCesi) <> *NULL;

           k1y402.t@Rama = peRama;
           k1y402.t@Cesi = peCesi;

           setll %kds( k1y402 : 4 ) set4021;
           if not %equal( set4021 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 4 ) set4021 @@DsI02;
           dow not %eof( set4021 );
             @@DsErC += 1;
             eval-corr @@DsEr( @@DsErC ) = @@DsI02;
             reade(n) %kds( k1y402 : 4 ) set4021 @@DsI02;
           enddo;

         when %parms >= 5 and %addr(peRama) <> *NULL
                          and %addr(peCesi) =  *NULL;

           k1y402.t@Rama = peRama;

           setll %kds( k1y402 : 3 ) set4021;
           if not %equal( set4021 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 3 ) set4021 @@DsI02;
           dow not %eof( set4021 );
             @@DsErC += 1;
             eval-corr @@DsEr( @@DsErC ) = @@DsI02;
             reade(n) %kds( k1y402 : 3 ) set4021 @@DsI02;
           enddo;

         other;

           setll %kds( k1y402 : 2 ) set4021;
           if not %equal( set4021 );
             return *off;
           endif;
           reade(n) %kds( k1y402 : 2 ) set4021 @@DsI02;
           dow not %eof( set4021 );
             @@DsErC += 1;
             eval-corr @@DsEr( @@DsErC ) = @@DsI02;
             reade(n) %kds( k1y402 : 2 ) set4021 @@DsI02;
           enddo;
       endsl;

       if %addr( peDsEr ) <> *null;
         eval-corr peDsEr = @@DsEr;
       endif;

       if %addr( peDsErC ) <> *null;
         peDsErC = @@DsErC;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaEdoReclamo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoDeRecibo(): Retorna datos de tipo de recibo  *
      *                                                              *
      *     peDs26   ( output ) Estruct. set426                      *
      *     peDs26C  ( output ) Cant. Reg. set426                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peTire   ( input  ) Cod. Tipo de Recibo   (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoDeRecibo...
     P                 B                   export
     D SVPTAB_listaTipoDeRecibo...
     D                 pi              n
     D   peDs26                            likeds ( dsSet426_t ) dim( 9999 )
     D   peDs26C                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peTire                       2  0 options( *nopass : *omit )

     D  @@DsI26        ds                  likerec( s1t426 : *input )
     D  k1y426         ds                  likerec( s1t426 : *key   )
     D  @@Ds26         ds                  likeds ( dsSet426_t ) dim( 9999 )
     D  @@Ds26C        s             10i 0

      /free

       SVPTAB_inz();

       clear @@Ds26;
       clear @@Ds26C;

       select;

         when %parms >= 4 and %addr(peRama) <> *NULL
                          and %addr(peTire) <> *NULL;

           k1y426.t@Rama = peRama;
           k1y426.t@Tire = peTire;

           setll %kds( k1y426 : 2 ) set426;
           if not %equal( set426 );
             return *off;
           endif;
           reade(n) %kds( k1y426 : 2 ) set426 @@DsI26;
           dow not %eof( set426 );
             @@Ds26C += 1;
             eval-corr @@Ds26( @@Ds26C ) = @@DsI26;
             reade(n) %kds( k1y426 : 2 ) set426 @@DsI26;
           enddo;

         when %parms >= 3 and %addr(peRama) <> *NULL
                          and %addr(peTire) =  *NULL;

           k1y426.t@Rama = peRama;

           setll %kds( k1y426 : 1 ) set426;
           if not %equal( set426 );
             return *off;
           endif;
           reade(n) %kds( k1y426 : 1 ) set426 @@DsI26;
           dow not %eof( set426 );
             @@Ds26C += 1;
             eval-corr @@Ds26( @@Ds26C ) = @@DsI26;
             reade(n) %kds( k1y426 : 1 ) set426 @@DsI26;
           enddo;

         other;

           setll *loval set426;
           read set426 @@DsI26;
           dow not %eof( set426 );
             @@Ds26C += 1;
             eval-corr @@Ds26( @@Ds26C ) = @@DsI26;
             read set426 @@DsI26;
           enddo;
       endsl;

       if %addr( peDs26 ) <> *null;
         eval-corr peDs26 = @@Ds26;
       endif;

       if %addr( peDs26C ) <> *null;
         peDs26C = @@Ds26C;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoDeRecibo...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaTextoPreseteado(): Retorna datos de texto prese- *
      *                                teado.                        *
      *                                                              *
      *     peDsTx   ( output ) Estruct. set124                      *
      *     peDsTxC  ( output ) Cant. Reg. set124                    *
      *     peRama   ( input  ) Rama                  (Opcional)     *
      *     peTpcd   ( input  ) Cod. Texto Preseteado (Opcional)     *
      *     peTpnl   ( input  ) Nro. Línea texto      (Opcional)     *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTextoPreseteado...
     P                 B                   export
     D SVPTAB_listaTextoPreseteado...
     D                 pi              n
     D   peDsTx                            likeds ( dsSet124_t ) dim( 99999 )
     D   peDsTxC                     10i 0
     D   peRama                       2  0 options( *nopass : *omit )
     D   peTpcd                       2    options( *nopass : *omit )
     D   peTpnl                       3  0 options( *nopass : *omit )

     D  @@DsITx        ds                  likerec( s1t124 : *input )
     D  k1y124         ds                  likerec( s1t124 : *key   )
     D  @@DsTx         ds                  likeds ( dsSet124_t ) dim( 99999 )
     D  @@DsTxC        s             10i 0

      /free

       SVPTAB_inz();

       clear @@DsTx;
       clear @@DsTxC;

       select;

         when %parms >= 5 and %addr(peRama) <> *NULL
                          and %addr(peTpcd) <> *NULL
                          and %addr(peTpnl) <> *NULL;

           k1y124.t@Rama = peRama;
           k1y124.t@Tpcd = peTpcd;
           k1y124.t@Tpnl = peTpnl;

           setll %kds( k1y124 : 3 ) set124;
           if not %equal( set124 );
             return *off;
           endif;
           reade(n) %kds( k1y124 : 3 ) set124 @@DsITx;
           dow not %eof( set124 );
             @@DsTxC += 1;
             eval-corr @@DsTx( @@DsTxC ) = @@DsITx;
             reade(n) %kds( k1y124 : 3 ) set124 @@DsITx;
           enddo;

         when %parms >= 4 and %addr(peRama) <> *NULL
                          and %addr(peTpcd) <> *NULL
                          and %addr(peTpnl) =  *NULL;

           k1y124.t@Rama = peRama;
           k1y124.t@Tpcd = peTpcd;

           setll %kds( k1y124 : 2 ) set124;
           if not %equal( set124 );
             return *off;
           endif;
           reade(n) %kds( k1y124 : 2 ) set124 @@DsITx;
           dow not %eof( set124 );
             @@DsTxC += 1;
             eval-corr @@DsTx( @@DsTxC ) = @@DsITx;
             reade(n) %kds( k1y124 : 2 ) set124 @@DsITx;
           enddo;

         when %parms >= 3 and %addr(peRama) <> *NULL
                          and %addr(peTpcd) =  *NULL
                          and %addr(peTpnl) =  *NULL;

           k1y124.t@Rama = peRama;

           setll %kds( k1y124 : 1 ) set124;
           if not %equal( set124 );
             return *off;
           endif;
           reade(n) %kds( k1y124 : 1 ) set124 @@DsITx;
           dow not %eof( set124 );
             @@DsTxC += 1;
             eval-corr @@DsTx( @@DsTxC ) = @@DsITx;
             reade(n) %kds( k1y124 : 1 ) set124 @@DsITx;
           enddo;

         other;

           setll *loval set124;
           read set124 @@DsITx;
           dow not %eof( set124 );
             @@DsTxC += 1;
             eval-corr @@DsTx( @@DsTxC ) = @@DsITx;
             read set124 @@DsITx;
           enddo;
       endsl;

       if %addr( peDsTx ) <> *null;
         eval-corr peDsTx = @@DsTx;
       endif;

       if %addr( peDsTxC ) <> *null;
         peDsTxC = @@DsTxC;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTextoPreseteado...
     P                 E
      * ------------------------------------------------------------ *
      * SVPTAB_chkSet426() : Valida si existe codigo de recibo.-     *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peTire   (input)   Tipo Recibo                           *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_chkSet426...
     P                 B                   export
     D SVPTAB_chkSet426...
     D                 pi              n
     D   peRama                       2  0 const
     D   peTire                       2  0 const

     D k1y426          ds                  likerec( s1t426 : *key )

      /free

       SVPTAB_inz();

       k1y426.t@rama = peRama;
       k1y426.t@tire = peTire;
       chain %kds( k1y426 : 2 ) set426;
       if %found( set426 );
         return *on;
       endif;

       return *off;

      /end-free

     P SVPTAB_chkSet426...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaFormasDePagos(): Retorna datos de Formas de Pagos*
      * Modificacion: DOT 20/05/2022: Solo lista los habilitados     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peDsFp   ( output ) Estruct. cntcfp                      *
      *     peDsFpC  ( output ) Cant. Reg. cntcfp                    *
      *     peIvcv   ( input  ) Cód. Forma de Pago             (Opc) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaFormasDePagos...
     P                 B                   export
     D SVPTAB_listaFormasDePagos...
     D                 pi              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsFp                            likeds ( dsCntcfp_t ) dim( 99 )
     D   peDsFpC                     10i 0
     D   peIvcv                       2  0 options( *nopass : *omit )

     D   @@DsFp        ds                  likerec( c1tcfp : *input )
     D   k1ycfp        ds                  likerec( c1tcfp : *key   )

      /free

       SVPTAB_inz();

       clear peDsFp;
       clear peDsFpC;

       k1ycfp.fpEmpr = peEmpr;
       k1ycfp.fpSucu = peSucu;

       if %parms >= 5 and %addr(peIvcv) <> *NULL;
         k1ycfp.fpIvcv = peIvcv;
         chain(n) %kds( k1ycfp : 3 ) cntcfp @@DsFp;
         if not %found( cntcfp ) or @@DsFp.fpmar5='1';
           return *off;
         endif;
         peDsFpC += 1;
         eval-corr peDsFp( peDsFpC ) = @@DsFp;
       else;
         clear @@DsFp;
         setll %kds( k1ycfp : 2 ) cntcfp;
         reade(n) %kds( k1ycfp : 2 ) cntcfp @@DsFp;
         dow not %eof( cntcfp );
             if @@DsFp.fpmar5 <> '1';
               peDsFpC += 1;
               eval-corr peDsFp( peDsFpC ) = @@DsFp;
             endif;
           reade(n) %kds( k1ycfp : 2 ) cntcfp @@DsFp;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaFormasDePagos...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_chkTipoProveedor(): Chequea si existe el tipo Prov.   *
      *                                                              *
      *     peTipp   ( input  ) Tipo de Proveedor                    *
      *     peTprv   ( input  ) Provee (opcional)                    *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_chkTipoProveedor...
     P                 B                   export
     D SVPTAB_chkTipoProveedor...
     D                 pi              n
     D   peTipp                       3    const
     D   peTprv                       1    const options(*nopass:*omit)

     D   @@Dspr        ds                  likerec( c1ttpr : *input )
     D   k1ytpr        ds                  likerec( c1ttpr : *key   )

      /free

       SVPTAB_inz();

       k1ytpr.tpTipp = peTipp;

       if %parms >= 1 and %addr(peTprv) <> *NULL;
         k1ytpr.tpTprv = peTprv;
         chain(n) %kds( k1ytpr : 2 ) cnttpr;
         if not %found( cnttpr );
           return *off;
         endif;
       else;
         chain(n) %kds( k1ytpr : 1 ) cnttpr;
         if not %found( cnttpr );
           return *off;
         endif;
       endif;

       return *on;

      /end-free

     P SVPTAB_chkTipoProveedor...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getTiposComprobanteAfip(): Tipos de Comprobante AFIP. *
      *                                                              *
      *     peTtfc   ( output ) Registro de GNTTFC                   *
      *     peTtfcC  ( output ) Cantidad de registros                *
      *                                                              *
      * Retorna: void                                                *
      * ------------------------------------------------------------ *
     P SVPTAB_getTiposComprobanteAfip...
     P                 b                   export
     D SVPTAB_getTiposComprobanteAfip...
     D                 pi
     D   peTtfc                            likeds(dsGntTfc_t) dim(999)
     D   peTtfcC                     10i 0

     D inTfc           ds                  likerec(g1ttfc:*input)

      /free

       SVPTAB_inz();
       clear peTtfc;
       peTtfcC = 0;

       setll *start gnttfc;
       read gnttfc inTfc;
       dow not %eof;
           peTtfcC += 1;
           eval-corr peTtfc(peTtfcC) = inTfc;
        read gnttfc inTfc;
       enddo;

      /end-free

     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getPrimasMinimas: Retorna Primas Minimas               *
      *                                                               *
      *     peDs175  ( output ) Estructura de Set175                  *
      *     peDs175C ( output ) Cantidad                              *
      *     peEmpr   ( input  ) Empresa                               *
      *     peSucu   ( input  ) Sucursal                              *
      *     peArcd   ( input  ) Código de Articulo                    *
      *     peRama   ( input  ) Código de Rama                        *
      *     peXppc   ( input  ) Código de Producto/Plan/Cobertura     *
      *     peFemi   ( input  ) Fecha de Emision                      *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_getPrimasMinimas...
     P                 b                   export
     D SVPTAB_getPrimasMinimas...
     D                 pi              n
     D   peDs175                           likeds( dsSet175_t ) dim( 99 )
     D   peDs175C                    10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 options( *nopass : *omit )
     D   peRama                       2  0 options( *nopass : *omit )
     D   peXppc                       3    options( *nopass : *omit )
     D   peFemi                       8  0 options( *nopass : *omit )

     D k1y175          ds                  likerec( s1t175 : *key )
     D @@DsI175        ds                  likerec( s1t175 : *input )
     D @@Ds175         ds                  likeds ( dsSet175_t ) dim( 99 )
     D @@Ds175C        s             10i 0

      /free

       SVPTAB_inz();

       k1y175.t@Empr = peEmpr;
       k1y175.t@Sucu = peSucu;

       select;

         when %parms >= 4 and peArcd <> *zeros
                          and peRama <> *zeros
                          and %addr(peXppc) <> *NULL
                          and %addr(peFemi) <> *NULL;

           k1y175.t@Arcd = peArcd;
           k1y175.t@Rama = peRama;
           k1y175.t@Xppc = peXppc;
           k1y175.t@Fvig = peFemi;

           setgt %kds( k1y175 : 6 ) set175;
           readpe %kds( k1y175 : 5 ) set175 @@DsI175;
           if not %found( set175 );
             return *off;
           endif;

           if peFemi > t@fvig;
              @@Ds175C = 1;
              eval-corr @@Ds175( @@Ds175C ) = @@DsI175;
           endif;

         when %parms >= 4 and peArcd <> *zeros
                          and peRama <> *zeros
                          and %addr(peXppc) =  *NULL
                          and %addr(peFemi) =  *NULL;

           k1y175.t@Arcd = peArcd;
           k1y175.t@Rama = peRama;

           setll %kds( k1y175 : 4 ) set175;
           if not %equal( set175 );
             return *off;
           endif;

           reade(n) %kds( k1y175 : 4 ) set175 @@DsI175;
           dow not %eof( set175 );
             @@Ds175C += 1;
             eval-corr @@Ds175( @@Ds175C ) = @@DsI175;
             reade(n) %kds( k1y175 : 4 ) set175 @@DsI175;
           enddo;

         other;

           setll *loval set175;
           read set175 @@DsI175;
           dow not %eof( set175 );
             @@Ds175C += 1;
             eval-corr @@Ds175( @@Ds175C ) = @@DsI175;
             read set175 @@DsI175;
           enddo;
       endsl;

       if %addr( peDs175 ) <> *null;
         eval-corr peDs175 = @@Ds175;
       endif;

       if %addr( peDs175C ) <> *null;
         peDs175C = @@Ds175C;
       endif;

       return *on;


      /end-free

     P SVPTAB_getPrimasMinimas...
     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoDeTransportes(): Retorna Lista de Tipo de    *
      *                                  Transporte.                 *
      *                                                              *
      *     peDs749  ( output ) Estruct. SET749                      *
      *     peDs749C ( output ) Cant. Reg. SET749                    *
      *     peTtra   ( input  ) Cód. de Tipo de Transporte     (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoDeTransportes...
     P                 B                   export
     D SVPTAB_listaTipoDeTransportes...
     D                 pi              n
     D   peDs749                           likeds ( dsSet749_t ) dim( 999 )
     D   peDs749C                    10i 0
     D   peTtra                       3  0 options( *nopass : *omit )

     D   @@Ds749       ds                  likerec( s1t749 : *input )
     D   k1y749        ds                  likerec( s1t749 : *key   )

      /free

       SVPTAB_inz();

       clear peDs749;
       clear peDs749C;


       if %parms >= 3 and %addr(peTtra) <> *NULL;
         k1y749.t@Ttra = peTtra;
         chain(n) %kds( k1y749: 1 ) set749 @@Ds749;
         if not %found( set749 );
           return *off;
         endif;
         peDs749C += 1;
         eval-corr peDs749( peDs749C ) = @@Ds749;
       else;
         clear @@Ds749;
         setll *start set749;
         read set749 @@Ds749;
         dow not %eof( set749 );
           peDs749C += 1;
           eval-corr peDs749( peDs749C ) = @@Ds749;
         read set749 @@Ds749;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoDeTransportes...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaMedioDeTransportes(): Retorna Lista de medios de *
      *                                   Transporte.                *
      *                                                              *
      *     peDs751  ( output ) Estruct. SET751                      *
      *     peDs751C ( output ) Cant. Reg. SET751                    *
      *     peMtra   ( input  ) Cód. de Medios de Transporte   (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaMedioDeTransportes...
     P                 B                   export
     D SVPTAB_listaMedioDeTransportes...
     D                 pi              n
     D   peDs751                           likeds ( dsSet751_t ) dim( 9 )
     D   peDs751C                    10i 0
     D   peMtra                       1  0 options( *nopass : *omit )

     D   @@Ds751       ds                  likerec( s1t751 : *input )
     D   k1y751        ds                  likerec( s1t751 : *key   )

      /free

       SVPTAB_inz();

       clear peDs751;
       clear peDs751C;


       if %parms >= 3 and %addr(peMtra) <> *NULL;
         k1y751.t@Mtra = peMtra;
         chain(n) %kds( k1y751: 1 ) set751 @@Ds751;
         if not %found( set751 );
           return *off;
         endif;
         peDs751C += 1;
         eval-corr peDs751( peDs751C ) = @@Ds751;
       else;
         clear @@Ds751;
         setll *start set751;
         read set751 @@Ds751;
         dow not %eof( set751 );
           peDs751C += 1;
           eval-corr peDs751( peDs751C ) = @@Ds751;
         read set751 @@Ds751;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaMedioDeTransportes...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaTipoDeMercaderias(): Retorna Lista de Mercaderia *
      *                                                              *
      *     peDs762  ( output ) Estruct. SET762                      *
      *     peDs762C ( output ) Cant. Reg. SET762                    *
      *     peCmer   ( input  ) Cód. de Tipo de Mercaderia     (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaTipoDeMercaderias...
     P                 B                   export
     D SVPTAB_listaTipoDeMercaderias...
     D                 pi              n
     D   peDs762                           likeds ( dsSet762_t ) dim( 999 )
     D   peDs762C                    10i 0
     D   peCmer                       3  0 options( *nopass : *omit )

     D   @@Ds762       ds                  likerec( s1t762 : *input )
     D   k1y762        ds                  likerec( s1t762 : *key   )

      /free

       SVPTAB_inz();

       clear peDs762;
       clear peDs762C;


       if %parms >= 3 and %addr(peCmer) <> *NULL;
         k1y762.t@Cmer = peCmer;
         chain(n) %kds( k1y762: 1 ) set762 @@Ds762;
         if not %found( set762 );
           return *off;
         endif;
         peDs762C += 1;
         eval-corr peDs762( peDs762C ) = @@Ds762;
       else;
         clear @@Ds762;
         setll *start set762;
         read set762 @@Ds762;
         dow not %eof( set762 );
           peDs762C += 1;
           eval-corr peDs762( peDs762C ) = @@Ds762;
         read set762 @@Ds762;
         enddo;
       endif;

       return *on;

      /end-free

     P SVPTAB_listaTipoDeMercaderias...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_listaRelaMercaTipoMedTra(): Retorna Lista de Relación *
      *                                    Mercaderia / Tipo / Medio *
      *                                    de transportes            *
      *                                                              *
      *     peDs768  ( output ) Estruct. SET768                      *
      *     peDs768C ( output ) Cant. Reg. SET768                    *
      *     peCmer   ( input  ) Cód. de Tipo de Mercaderia     (Opc) *
      *     peTtra   ( input  ) Cód. de Tipo de Transporte     (Opc) *
      *     peMtra   ( input  ) Cód. de Medio de Transporte    (Opc) *
      *     peRiec   ( input  ) Cód. de Riesgo                 (Opc) *
      *                                                              *
      * Retorna: *on = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     P SVPTAB_listaRelaMercaTipoMedTransp...
     P                 B                   export
     D SVPTAB_listaRelaMercaTipoMedTransp...
     D                 pi              n
     D   peDs768                           likeds ( dsSet768_t ) dim( 999 )
     D   peDs768C                    10i 0
     D   peCmer                       3  0 options( *nopass : *omit )
     D   peTtra                       3  0 options( *nopass : *omit )
     D   peMtra                       1  0 options( *nopass : *omit )
     D   peRiec                       3    options( *nopass : *omit )

     D   @@Ds768       ds                  likerec( s1t768 : *input )
     D   k1y768        ds                  likerec( s1t768 : *key   )

      /free

       SVPTAB_inz();

       clear peDs768;
       clear peDs768C;

       select;
         when %parms >= 6 and %addr( peCmer ) <> *NULL
                          and %addr( peTtra ) <> *NULL
                          and %addr( peMtra ) <> *NULL
                          and %addr( peRiec ) <> *NULL;

           k1y768.t@Cmer = peCmer;
           k1y768.t@Ttra = peTtra;
           k1y768.t@Mtra = peMtra;
           k1y768.t@Riec = peRiec;
           setll %kds( k1y768 : 4 ) set768;
           if not %equal( set768 );
             return *off;
           endif;
           reade(n) %kds( k1y768: 4 ) set768 @@Ds768;
           dow not %eof( set768 );
             peDs768C += 1;
             eval-corr peDs768( peDs768C ) = @@Ds768;
             reade(n) %kds( k1y768: 4 ) set768 @@Ds768;
           enddo;

         when %parms >= 5 and %addr( peCmer ) <> *NULL
                          and %addr( peTtra ) <> *NULL
                          and %addr( peMtra ) <> *NULL
                          and %addr( peRiec ) =  *NULL;

           k1y768.t@Cmer = peCmer;
           k1y768.t@Ttra = peTtra;
           k1y768.t@Mtra = peMtra;
           setll %kds( k1y768 : 3 ) set768;
           if not %equal( set768 );
             return *off;
           endif;
           reade(n) %kds( k1y768: 3 ) set768 @@Ds768;
           dow not %eof( set768 );
             peDs768C += 1;
             eval-corr peDs768( peDs768C ) = @@Ds768;
             reade(n) %kds( k1y768: 3 ) set768 @@Ds768;
           enddo;

         when %parms >= 4 and %addr( peCmer ) <> *NULL
                          and %addr( peTtra ) <> *NULL
                          and %addr( peMtra ) =  *NULL
                          and %addr( peRiec ) =  *NULL;

           k1y768.t@Cmer = peCmer;
           k1y768.t@Ttra = peTtra;
           setll %kds( k1y768 : 2 ) set768;
           if not %equal( set768 );
             return *off;
           endif;
           reade(n) %kds( k1y768: 2 ) set768 @@Ds768;
           dow not %eof( set768 );
             peDs768C += 1;
             eval-corr peDs768( peDs768C ) = @@Ds768;
             reade(n) %kds( k1y768: 2 ) set768 @@Ds768;
           enddo;

         when %parms >= 3 and %addr( peCmer ) <> *NULL
                          and %addr( peTtra ) =  *NULL
                          and %addr( peMtra ) =  *NULL
                          and %addr( peRiec ) =  *NULL;

           k1y768.t@Cmer = peCmer;
           setll %kds( k1y768 : 1 ) set768;
           if not %equal( set768 );
             return *off;
           endif;
           reade(n) %kds( k1y768: 1 ) set768 @@Ds768;
           dow not %eof( set768 );
             peDs768C += 1;
             eval-corr peDs768( peDs768C ) = @@Ds768;
             reade(n) %kds( k1y768: 1 ) set768 @@Ds768;
           enddo;

         other;

           clear @@Ds768;
           setll *start set768;
           read set768 @@Ds768;
           dow not %eof( set768 );
             peDs768C += 1;
             eval-corr peDs768( peDs768C ) = @@Ds768;
             read set768 @@Ds768;
           enddo;
       endsl;

       return *on;

      /end-free

     P SVPTAB_listaRelaMercaTipoMedTransp...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getSet645() : Retorna SET645                          *
      *                                                              *
      *     peCfan   (input)   Codigo Forma de Anulacion             *
      *     peDs645  (output)  Estructura SET645                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet645...
     P                 B                   export
     D SVPTAB_getSet645...
     D                 pi              n
     D   peCfan                       1  0 const
     D   peDs645                           likeds ( DsSet645_t )

     D @@Ds645         ds                  likerec( s1t645 : *input )

      /free

       SVPTAB_inz();

       clear peDs645;
       chain peCfan set645 @@Ds645;
       if %found(set645);
         eval-corr peDs645 = @@Ds645;
       else;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet645...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getSubtipoAnulacion() : Retorna Subtipos de Anulacion *
      *                                a partir de un articulo       *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peDsAn   (output)  Estructura Subtipo Anulacion          *
      *     peDsAnC  (output)  Cantidad de Registros                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSubtipoAnulacion...
     P                 B                   export
     D SVPTAB_getSubtipoAnulacion...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peDsAn                            likeds(DsSet646_t ) dim(10)
     D   peDsAnC                     10i 0

      /free

       SVPTAB_inz();

       clear peDsAn;
       peDsAnC = *zeros;

       setll peArcd set646;
       reade peArcd set646;
       dow not %eof( set646 );
           if SVPVAL_tipoDeOperacionWeb( t2tiou : t2stou : t2stos );
              peDsAnC += 1;
              peDsAn(peDsAnC).t@arcd = t2arcd;
              peDsAn(peDsAnC).t@tiou = t2tiou;
              peDsAn(peDsAnC).t@stou = t2stou;
              peDsAn(peDsAnC).t@stos = t2stos;
              peDsAn(peDsAnC).t@mar1 = t2mar1;
              peDsAn(peDsAnC).t@mar2 = t2mar2;
              peDsAn(peDsAnC).t@mar3 = t2mar3;
              peDsAn(peDsAnC).t@mar4 = t2mar4;
              peDsAn(peDsAnC).t@mar5 = t2mar5;
              peDsAn(peDsAnC).t@date = t2date;
              peDsAn(peDsAnC).t@time = t2time;
              peDsAn(peDsAnC).t@user = t2user;
           endif;
         reade peArcd set646;
       enddo;

       return (peDsAnC > 0);

      /end-free

     P SVPTAB_getSubtipoAnulacion...
     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_getFormasDeAnular(): Formas de anular por articulo y  *
      *                             operacion.                       *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peTiou   (input)   Tipo de Operacion                     *
      *     peStou   (input)   Subtipo de operacion                  *
      *     peDsFa   (output)  Formas de Anular                      *
      *     peDsFaC  (output)  Cantidad de Registros                 *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     P SVPTAB_getFormasDeAnular...
     P                 b                   export
     D SVPTAB_getFormasDeAnular...
     D                 pi              n
     D   peArcd                       6  0 const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peDsFa                            likeds(DsSet647_t) dim(10)
     D   peDsFaC                     10i 0

      /free

       SVPTAB_inz();
       clear peDsFa;
       peDsFaC = 0;

       setll (peArcd:peTiou:peStou) set647;
       reade (peArcd:peTiou:peStou) set647;
       dow not %eof;
           peDsFaC += 1;
           peDsFa(peDsFac).t@arcd = t4arcd;
           peDsFa(peDsFac).t@tiou = t4tiou;
           peDsFa(peDsFac).t@stou = t4stou;
           peDsFa(peDsFac).t@cfan = t4cfan;
           peDsFa(peDsFac).t@mar1 = t4mar1;
           peDsFa(peDsFac).t@mar2 = t4mar2;
           peDsFa(peDsFac).t@mar3 = t4mar3;
           peDsFa(peDsFac).t@mar4 = t4mar4;
           peDsFa(peDsFac).t@mar5 = t4mar5;
           peDsFa(peDsFac).t@date = t4date;
           peDsFa(peDsFac).t@time = t4time;
           peDsFa(peDsFac).t@user = t4user;
        reade (peArcd:peTiou:peStou) set647;
       enddo;

       return *on;

      /end-free

     P                 e

      * ------------------------------------------------------------- *
      * SVPTAB_getProvinciaInder(): Retorna provincia Inder           *
      *                                                               *
      *     peProc   ( input  ) Provincia GAUS                        *
      *                                                               *
      * Retorna: PRRPRO                                               *
      * ------------------------------------------------------------- *
     P SVPTAB_getProvinciaInder...
     P                 b                   export
     D SVPTAB_getProvinciaInder...
     D                 pi             2  0
     D   peProc                       3a   const

      /free

       SVPTAB_inz();

       chain peProc gntpro;
       if %found;
          return prRpro;
       endif;

       return *zeros;

      /end-free

     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_cotizaMoneda(): Retorna cotización de la moneda.      *
      *                                                              *
      *     peComo ( input  ) Código de Moneda                       *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      *                                                              *
      * Retorna : Cotizacion de Moneda / 1 = no tiene                *
      * ------------------------------------------------------------ *
     P SVPTAB_cotizaMoneda2...
     P                 B                   export
     D SVPTAB_cotizaMoneda2...
     D                 pi            15  6
     D   peComo                       2      const
     D   peTcam                       1a     const
     D   peFcot                       8  0   const

     D k1ycmo          ds                  likerec(g1tcmo:*key)

     D                 ds
     D feccmo                  1      8  0
     D feccoa                  1      4  0
     D feccom                  5      6  0
     D feccod                  7      8  0

      /free

       SVPTAB_inz();

       chain peComo gntmon;
       if not %found;
          return 1;
       endif;

       if (momoeq = 'AU');
          return 1;
       endif;

       feccmo = peFcot;
       k1ycmo.mocomo = peComo;
       k1ycmo.mofcoa = feccoa;
       k1ycmo.mofcom = feccom;
       k1ycmo.mofcod = feccod;

       setgt %kds( k1ycmo ) gntcmo;
       readpe peComo gntcmo;

       if not %eof ( gntcmo );

          select;
           when peTcam = SVPTAB_CMVEN;
                return mocotv;
           when peTcam = SVPTAB_CMCOM;
                return mocotc;
           other;
                return 1;
          endsl;

       endif;

       return 1;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * SVPTAB_coeficienteEntreMonedas(): Coeficiente entre dos mone-*
      *                        das para convertir.                   *
      *                                                              *
      *     peComi ( input  ) Código de Moneda ORIGEN                *
      *     peComo ( input  ) Código de Moneda DESTINO               *
      *     peTcam ( input  ) Tipo de Cambio                         *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      *                                                              *
      * Retorna : Coeficiente                                        *
      * ------------------------------------------------------------ *
     P SVPTAB_coeficienteEntreMonedas...
     P                 b                     export
     D SVPTAB_coeficienteEntreMonedas...
     D                 pi             7  4
     D   peComi                       2      const
     D   peComo                       2      const
     D   peTcam                       1a     const
     D   peFcot                       8  0   const

     D cotOri          s             15  6
     D cotDes          s             15  6
     D aux299          s             29  9

      /free

       SVPTAB_inz();

       cotOri = SVPTAB_cotizaMoneda2( peComi
                                    : 'V'
                                    : peFcot  );

       cotDes = SVPTAB_cotizaMoneda2( peComo
                                    : 'V'
                                    : peFcot  );

       aux299 = cotOri / cotDes;
       return %dech(aux299:7:4);

      /end-free

     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getRamaReaseguro(): Obtiene rama para reaseguro.      *
      *                                                              *
      *     peRama ( input  ) Rama Nominal                           *
      *     peRiec ( input  ) Riesgo                                 *
      *     peXcob ( input  ) Cobertura                              *
      *                                                              *
      * Retorna : Rama para Reaseguro                                *
      * ------------------------------------------------------------ *
     P SVPTAB_getRamaReaseguro...
     P                 b                   export
     D SVPTAB_getRamaReaseguro...
     D                 pi             2  0
     D   peRama                       2  0 const
     D   peRiec                       3a   const
     D   peXcob                       3  0 const

      /free

       SVPTAB_inz();

       chain (peRama:peRiec:peXcob) set106;
       if not %found;
          return 0;
       endif;

       return t6rmrs;

      /end-free

     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_coeficienteEntreMonedas(): Coeficiente entre dos mone-*
      *                        das para convertir.                   *
      *                                                              *
      *     peComi ( input  ) Código de Moneda ORIGEN                *
      *     peComo ( input  ) Código de Moneda DESTINO               *
      *     peTcam ( input  ) Tipo de Cambio                         *
      *     peFcot ( input  ) Fecha de Cotización (aaaammdd)         *
      *                                                              *
      * Retorna : Coeficiente                                        *
      * ------------------------------------------------------------ *
     P SVPTAB_coeficienteEntreMonedas2...
     P                 b                     export
     D SVPTAB_coeficienteEntreMonedas2...
     D                 pi            15  6
     D   peComi                       2      const
     D   peComo                       2      const
     D   peTcam                       1a     const
     D   peFcot                       8  0   const

     D cotOri          s             15  6
     D cotDes          s             15  6
     D aux299          s             29  9

      /free

       SVPTAB_inz();

       cotOri = SVPTAB_cotizaMoneda2( peComi
                                    : 'V'
                                    : peFcot  );

       cotDes = SVPTAB_cotizaMoneda2( peComo
                                    : 'V'
                                    : peFcot  );

       aux299 = cotOri / cotDes;
       return %dech(aux299:15:6);

      /end-free

     P                 e

      * ------------------------------------------------------------ *
      * SVPTAB_getSet103s() : Retorna SET103                          *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Producto                              *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peDs103  (output)  Estructura SET103                     *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *

     P SVPTAB_getSet103s...
     P                 B                   export
     D SVPTAB_getSet103s...
     D                 pi              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peDs103                           likeds ( DsSet1s3_t )

     D k1y103          ds                  likerec( s1t103 : *key )
     D @@Ds103         ds                  likerec( s1t103 : *input )

      /free

       SVPTAB_inz();

       clear peDs103;
       k1y103.t@Rama = peRama;
       k1y103.t@Xpro = peXpro;
       k1y103.t@Riec = peRiec;
       k1y103.t@Cobc = peCobc;
       k1y103.t@Mone = peMone;
       chain %kds(k1y103) set103 @@Ds103;
       if %found(set103);
         eval-corr peDs103 = @@Ds103;
       else;
         return *off;
       endif;

       return *on;

      /end-free

     P SVPTAB_getSet103s...
     P                 E
      * ------------------------------------------------------------- *
      * SVPTAB_ListaCompaniasV2 :  Retorna Compañias Coaseguradoras   *
      *                                                               *
      *     peDsCm   ( output ) Estructura de Compañias Coaseguradoras*
      *     peDsCmC  ( output ) Cantidad                              *
      *                                                               *
      * Retorna: *on = Si existe / *off = No existe                   *
      * ------------------------------------------------------------- *
     P SVPTAB_ListaCompaniasV2...
     P                 b                   export
     D SVPTAB_ListaCompaniasV2...
     D                 pi              n
     D   peDsCm                            likeds(dsSet139_t) dim(999)
     D   peDsCmC                     10i 0

     D @@Ds001         ds                  likerec( s1t139 : *input )

      /free

       SVPTAB_inz();

       setll *start set139;
       read set139 @@Ds001;
       dow not %eof;
           peDsCmC += 1;
           eval-corr peDsCm(peDsCmC) = @@Ds001;
       read set139 @@Ds001;
       enddo;

       return *on;

      /end-free

     P SVPTAB_ListaCompaniasV2...
     P                 e
