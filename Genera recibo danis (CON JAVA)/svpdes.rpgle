     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPDES: Devolver datos Varios.                               *
      * ------------------------------------------------------------ *
      * Barranco Julio                       18-Ago-2015             *
      * ------------------------------------------------------------ *
      * ************************************************************ *
      * Modificaciones:                                              *
      * LRG 24-01-2018 - Nuevo Procedimiento(): getTipoDeVehiculo()  *
      * JSN 29-01-2018 - Nuevo Procedimiento(): coberturaVehiculo()  *
      *                                         TipoDeTelefono()     *
      * LRG 30-01-2018 - Nuevo Procedimiento(): SVPDES_getMail()     *
      * EXT 04-12-2018 - Nuevo Procedimiento(): banco()              *
      *                                         sucursalBanco()      *
      * JSN 03-05-2019 - Nuevo Procedimiento(): planDePago()         *
      * LRG 05-09-2019 - Nuevos Procedimiento(): _cuestionario       *
      *                                          _pregunta           *
      * LRG 11-10-2019 - Nuevo Procedimiento(): Rama()               *
      * JSN 19-12-2019 - Nuevos Procedimientos(): _Marca             *
      *                                           _Modelo            *
      * SGF 24-03-2020 - Nuevos Procedimientos(): _tipoDeMascota     *
      *                                           _razaDeMascota     *
      * JSN 25-08-2020 - Nuevo Procedimiento(): _estadoDeFactura     *
      * JSN 19-01-2021 - Nuevo Procedimiento(): _estadoOrdenDePago   *
      * JSN 18-03-2021 - Nuevo Procedimiento(): _tipoDePersona       *
      * NWN 20-04-2021 - Nuevo Procedimiento(): _estadoDelTiempo     *
      * JSN 24-06-2021 - Nuevo Procedimiento(): _nombCortoEmpTdc     *
      * SGF 23-02-2022 - Agrego: capituloVariante() y                *
      *                  tarifaDiferencial().                        *
      * JSN 16-06-2022 - Se agrega estado Factura Rechazada en el    *
      *                  procedimiento _estadoDeFactura.             *
      * JSN 25-04-2023 - Se agregan los procedimientos:              *
      *                   _tipoDeTransporte                          *
      *                   _medioDeTransporte                         *
      *                   _tipoDeMercaderia                          *
      * SGF 12-08-2023 - Se agrega procedimiento: _formaDeAnular     *
      *                                                              *
      * IMF 28-06-2024 - Se agrega procedimiento: _subModelo         *
      * ************************************************************ *
     Fset021    if   e           k disk    usropn
     Fset101    if   e           k disk    usropn
     Fset102    if   e           k disk    usropn
     Fset104    if   e           k disk    usropn
     Fset107    if   e           k disk    usropn
     Fset160    if   e           k disk    usropn
     Fset210    if   e           k disk    usropn
     Fset250    if   e           k disk    usropn
     Fset251    if   e           k disk    usropn
     Fset620    if   e           k disk    usropn
     Fset831    if   e           k disk    usropn
     Fset832    if   e           k disk    usropn
     Fset916    if   e           k disk    usropn
     Fset901    if   e           k disk    usropn
     Fgntmon    if   e           k disk    usropn
     Fgntiv1    if   e           k disk    usropn
     Fgntloc    if   e           k disk    usropn
     Fgntcmo    if   e           k disk    usropn
     Fgntfpg    if   e           k disk    usropn
     Fgntnac    if   e           k disk    usropn
     Fgntpai    if   e           k disk    usropn
     Fgntprf    if   e           k disk    usropn
     Fgnttdo    if   e           k disk    usropn
     Fgnttis    if   e           k disk    usropn
     Fgntpro    if   e           k disk    usropn
     Fgntsex    if   e           k disk    usropn
     Fgntesc    if   e           k disk    usropn
     Fset225    if   e           k disk    usropn prefix(t225_)
     Fgnttte    if   e           k disk    usropn
     Fgnttce    if   e           k disk    usropn
     Fcntbco    if   e           k disk    usropn
     Fcntbcs    if   e           k disk    usropn
     Fset912    if   e           k disk    usropn
     Fset001    if   e           k disk    usropn
     Fset201    if   e           k disk    usropn
     Fset202    if   e           k disk    usropn
     Fset136    if   e           k disk    usropn
     Fset137    if   e           k disk    usropn
     Fset445    if   e           k disk    usropn
     Fset444    if   e           k disk    usropn
     Fset211    if   e           k disk    usropn
     Fgnttc1    if   e           k disk    usropn
     Fset208    if   e           k disk    usropn
     Fset215    if   e           k disk    usropn
     Fset749    if   e           k disk    usropn
     Fset751    if   e           k disk    usropn
     Fset762    if   e           k disk    usropn
     Fset645    if   e           k disk    usropn prefix(t645_)

      *--- Copy H -------------------------------------------------- *

      /copy desa213/qcpybooks,svpdes_h

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     Is1t021
     I              t@date                      w@date
     Is1t901
     I              t@date                      x@date
     Is1t916
     I              t@date                      y@date
     Is1t160
     I              t@date                      z@date
     Is1t210
     I              t@date                      h@date
     Is1t136
     I              t@date                      m@date
     Is1t137
     I              t@date                      n@date
     Is1t211
     I              t@date                      o@date
     Is1t749
     I              t@fech                      a@date
     Is1t751
     I              t@fech                      b@date
     Is1t762
     I              t@fech                      c@date
     Is1t645
     I              t@date                      @@date

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPDES_articulo: Recupera la descripción del articulo.       *
      *                                                              *
      *     peArcd   (input)   Código de Articulo                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPDES_articulo...
     P                 B                   export
     D SVPDES_articulo...
     D                 pi            30
     D   peArcd                       6  0 const

     D k1y620          ds                  likerec(s1t620:*key)

      /free

       SVPDES_inz();

       k1y620.t@arcd = peArcd;
       chain %kds( k1y620 ) set620;

       if %found( set620 );

         return t@arno;

       endif;

       return *blanks;

      /end-free

     P SVPDES_articulo...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_moneda: Recupera la descripción de la moneda.         *
      *                                                              *
      *     peComo   (input)   Código de Moneda.                     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     P SVPDES_moneda...
     P                 B                   export
     D SVPDES_moneda...
     D                 pi            30
     D   peComo                       2    const

     D k1ymon          ds                  likerec(g1tmon:*key)

      /free

       SVPDES_inz();

       k1ymon.mocomo = peComo;

       chain %kds( k1ymon ) gntmon;
       if %found( gntmon );

         return monmol;

       endif;

       return *blanks;

      /end-free

     P SVPDES_moneda...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDES_tipoDeOperacion(): Retorna la descripción del tipo de *
      *                           operación                          *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peTiou  -  Tipo Operación                     *
      *                peStou  -  SubTipo Operación                  *
      *                peStos  -  Operación Moneda                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_tipoDeOperacion...
     P                 B                   export
     D SVPDES_tipoDeOperacion...
     D                 pi            20
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D
     D k1y901          ds                  likerec(s1t901:*key)
     D

      /free

       SVPDES_inz();

       k1y901.t@tiou = peTiou;
       k1y901.t@stou = peStou;

       setll %kds( k1y901 ) set901;
       reade %kds( k1y901 ) set901;
       dow not %eof( set901 );

         if t@stos = peStos;

           return t@dsop;

         endif;

         reade %kds( k1y901 ) set901;
       enddo;

       return *blanks;

      /end-free

     P SVPDES_tipoDeOperacion...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_estadoCot(): Retorna la descripción del estado de     *
      *                     cotización.                              *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCest  -  Codigo de Estado                   *
      *                peCses  -  Codigo de SubEstado                *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_estadoCot...
     P                 B                   export
     D SVPDES_estadoCot...
     D                 pi            20
     D   peCest                       1  0   const
     D   peCses                       2  0   const
     D
     D k1y916          ds                  likerec(s1t916:*key)
     D

      /free

       SVPDES_inz();

       k1y916.t@cest = peCest;
       k1y916.t@cses = peCses;

       chain %kds( k1y916 ) set916;

       if %found( set916 );

           return t@dest;

       endif;

       return *blanks;

      /end-free

     P SVPDES_estadoCot...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_codigoIva(): Retorna la descripción del código de     *
      *                     iva.                                     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCiva  -  Codigo de Iva.                     *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_codigoIva...
     P                 B                   export
     D SVPDES_codigoIva...
     D                 pi            30
     D   peCiva                       1  0   const
     D
     D k1yiv1          ds                  likerec(g1tiv1:*key)
     D

      /free

       SVPDES_inz();

       k1yiv1.i1civa = peCiva;

       chain %kds( k1yiv1 ) gntiv1;

       if %found( gntiv1 );

           return i1ncil;

       endif;

       return *blanks;

      /end-free

     P SVPDES_codigoIva...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_localidad(): Retorna la descripción de la localidad.  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCopo  -  Codigo Postal                      *
      *                peCops  -  SubFijo Postal                     *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_localidad...
     P                 B                   export
     D SVPDES_localidad...
     D                 pi            25
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D
     D k1yloc          ds                  likerec(g1tloc:*key)
     D

      /free

       SVPDES_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;

       chain %kds( k1yloc ) gntloc;

       if %found( gntloc );

           return loloca;

       endif;

       return *blanks;

      /end-free

     P SVPDES_localidad...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_formaPago(): Retorna la descripción de la forma de    *
      *                     pago.                                    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peCfpg  -  Código Forma de Pago               *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_formaPago...
     P                 B                   export
     D SVPDES_formaPago...
     D                 pi            20
     D   peCfpg                       1  0   const
     D
     D k1yfpg          ds                  likerec(g1tfpg:*key)
     D

      /free

       SVPDES_inz();

       k1yfpg.fpcfpg = peCfpg;

       chain %kds( k1yfpg ) gntfpg;
       if %found( gntfpg );

           return fpdefp;

       endif;

       return *blanks;

      /end-free

     P SVPDES_formaPago...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_codRiesgo(): Devuelve la descripción del Riesgo       *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peRiec   (input)   Código del Riesgo                     *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPDES_codRiesgo...
     P                 B                   export
     D SVPDES_codRiesgo...
     D                 pi            25
     D   peRama                       2  0 const
     D   peRiec                       3    const
     D
     D k1y104          ds                  likerec(s1t104:*key)

      /free

       SVPDES_inz();

       k1y104.t@rama = peRama;
       k1y104.t@riec = peRiec;

       chain %kds( k1y104 ) set104;
       if %found( set104 );

         return t@ried;

       endif;

       return *blanks;

      /end-free

     P SVPDES_codRiesgo...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_cobCorto():  Devuelve la descripción de la Cobertura  *
      *                     (descripción corta)                      *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peCobc   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPDES_cobCorto...
     P                 B                   export
     D SVPDES_cobCorto...
     D                 pi            20
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D
     D k1y107          ds                  likerec(s1t107:*key)

      /free

       SVPDES_inz();

       k1y107.t@rama = peRama;
       k1y107.t@cobc = peCobc;

       chain %kds( k1y107 ) set107;
       if %found( set107 );

         return t@cobd;

       endif;

       return *blanks;

      /end-free

     P SVPDES_cobCorto...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_cobLargo():  Devuelve la descripción de la Cobertura  *
      *                     (descripción larga)                      *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peCobc   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPDES_cobLargo...
     P                 B                   export
     D SVPDES_cobLargo...
     D                 pi            40
     D   peRama                       2  0 const
     D   peCobc                       3  0 const
     D
     D k1y107          ds                  likerec(s1t107:*key)

      /free

       SVPDES_inz();

       k1y107.t@rama = peRama;
       k1y107.t@cobc = peCobc;

       chain %kds( k1y107 ) set107;
       if %found( set107 );

         return t@cobl;

       endif;

       return *blanks;

      /end-free

     P SVPDES_cobLargo...
     P                 E
      * -------------------------------------------------------------- *
      * SVPDES_codCaracteristica(): Descripción de la característica   *
      *                             del bien.                          *
      *                                                                *
      *     peEmpr   (input)   Código de Empresa                       *
      *     peSucu   (input)   Código de Sucursal                      *
      *     peRama   (input)   Rama                                    *
      *     peCcba   (input)   Cod.Caracteristica del Bien             *
      *                                                                *
      * -------------------------------------------------------------- *

     P SVPDES_codCaracteristica...
     P                 B                   export
     D SVPDES_codCaracteristica...
     D                 pi            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peCcba                       3  0 const
     D
     D k1y160          ds                  likerec(s1t160:*key)

      /free

       SVPDES_inz();

       k1y160.t@empr = peEmpr;
       k1y160.t@sucu = peSucu;
       k1y160.t@rama = peRama;
       k1y160.t@ccba = peCcba;

       chain %kds( k1y160 ) set160;
       if %found( set160 );

         return t@dcba;

       endif;

       return *blanks;

      /end-free

     P SVPDES_codCaracteristica...
     P                 E
      * -------------------------------------------------------------- *
      * SVPDES_codBonificacion():   Descripción de la bonificacion     *
      *                             del vehículo.                      *
      *                                                                *
      *     peEmpr   (input)   Código de Empresa                       *
      *     peSucu   (input)   Código de Sucursal                      *
      *     peArcd   (input)   Código de Articulo                      *
      *     peRama   (input)   Rama                                    *
      *     peCcbp   (input)   Código de Componente Bonifi             *
      *                                                                *
      * -------------------------------------------------------------- *

     P SVPDES_codBonificacion...
     P                 B                   export
     D SVPDES_codBonificacion...
     D                 pi            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peCcbp                       3  0 const
     D
     D k1y250          ds                  likerec(s1t250:*key)

      /free

       SVPDES_inz();


       k1y250.stEmpr = peEmpr;
       k1y250.stSucu = peSucu;
       k1y250.stArcd = peArcd;
       k1y250.stRama = peRama;
       k1y250.stCcbp = peCcbp;

       chain %kds( k1y250 : 5 ) set250;
       if %found( set250 );

         return stdcbp;

       endif;

       return *blanks;

      /end-free

     P SVPDES_codBonificacion...
     P                 E
      * -------------------------------------------------------------- *
      * SVPDES_codBonificacionRV():   Descripción de la bonificacion   *
      *                             de vivienda.                       *
      *                                                                *
      *     peEmpr   (input)   Código de Empresa                       *
      *     peSucu   (input)   Código de Sucursal                      *
      *     peCcbp   (input)   Código de Componente Bonifi             *
      *                                                                *
      * -------------------------------------------------------------- *
     P SVPDES_codBonificacionRV...
     P                 B                   export
     D SVPDES_codBonificacionRV...
     D                 pi            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCcbp                       3  0 const
     D
     D k1y251          ds                  likerec(s1t251:*key)

      /free

       SVPDES_inz();


       k1y251.t@Empr = peEmpr;
       k1y251.t@Sucu = peSucu;
       k1y251.t@Ccbp = peCcbp;

       chain %kds( k1y251 ) set251;
       if %found( set251 );

         return t@dcbp;

       endif;

       return *blanks;

      /end-free

     P SVPDES_codBonificacionRV...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_nacionalidad() Retorna nacionalidad                   *
      *                                                              *
      *     peCnac  (input)  - Codigo de Nacionalidad                *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_nacionalidad...
     P                 B                   export
     D SVPDES_nacionalidad...
     D                 pi            30
     D   peCnac                       3  0   const

       SVPDES_inz();

       chain peCnac gntnac;

       if %found( gntnac );

           return acdnac;

       endif;

       return *blanks;

     P SVPDES_nacionalidad...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_paisDeNac(): Retorna Pais de Naciomiento              *
      *                                                              *
      *     pePain  (input)  - Pais de Nacimiento                    *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_paisDeNac...
     P                 B                   export
     D SVPDES_paisDeNac...
     D                 pi            30
     D   pePain                       5  0   const

       SVPDES_inz();

       chain pePain gntpai;

       if %found( gntpai );

           return papaid;

       endif;

       return *blanks;

     P SVPDES_paisDeNac...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_profesion(): Retorna Profesion                        *
      *                                                              *
      *     peCprf  (input)  - Codigo de Profesion                   *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_profesion...
     P                 B                   export
     D SVPDES_profesion...
     D                 pi            25
     D   peCprf                       3  0   const

       SVPDES_inz();

       chain peCprf gntprf;

       if %found( gntprf );

           return prdprf;

       endif;

       return *blanks;

     P SVPDES_profesion...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_tipoDocumento(): Retorna tipo de Documento            *
      *                                                              *
      *     peTido  (input)  - Codigo de Docuemnto                   *
      *     peDatd  (input)  - A Docuento                            *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_tipoDocumento...
     P                 B                   export
     D SVPDES_tipoDocumento...
     D                 pi            20
     D   peTido                       2  0   const
     D   peDatd                       3      options(*omit:*nopass)

       SVPDES_inz();

       chain peTido gnttdo;

       if %found( gnttdo );

           if %parms >= 2 and %addr(peDatd) <> *Null;
             peDatd = gndatd;
           endif;

           return gndtdo;

       endif;

       if %parms >= 2 and %addr(peDatd) <> *Null;
         peDatd = *Blanks;
       endif;

       return *blanks;

     P SVPDES_tipoDocumento...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_tipoSociedad():  Retorna tipo de Sociedad             *
      *                                                              *
      *     peTiso  (input)  - Codigo de Sociedad                    *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_tipoSociedad...
     P                 B                   export
     D SVPDES_tipoSociedad...
     D                 pi            25
     D   peTiso                       2  0   const

       SVPDES_inz();

       chain peTiso gnttis;

       if %found( gnttis );

           return gndtis;

       endif;

       return *blanks;

     P SVPDES_tipoSociedad...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDES_inz      B                   export
     D SVPDES_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set021);
         open set021;
       endif;

       if not %open(set101);
         open set101;
       endif;

       if not %open(set102);
         open set102;
       endif;

       if not %open(set104);
         open set104;
       endif;

       if not %open(set107);
         open set107;
       endif;

       if not %open(set160);
         open set160;
       endif;

       if not %open(set620);
         open set620;
       endif;

       if not %open(set210);
         open set210;
       endif;

       if not %open(set250);
         open set250;
       endif;

       if not %open(set251);
         open set251;
       endif;

       if not %open(gntmon);
         open gntmon;
       endif;

       if not %open(set901);
         open set901;
       endif;

       if not %open(gntiv1);
         open gntiv1;
       endif;

       if not %open(gntloc);
         open gntloc;
       endif;

       if not %open(set831);
         open set831;
       endif;

       if not %open(set832);
         open set832;
       endif;

       if not %open(set916);
         open set916;
       endif;

       if not %open(gntcmo);
         open gntcmo;
       endif;

       if not %open(gntfpg);
         open gntfpg;
       endif;

       if not %open(gntnac);
         open gntnac;
       endif;

       if not %open(gntpai);
         open gntpai;
       endif;

       if not %open(gntprf);
         open gntprf;
       endif;

       if not %open(gnttdo);
         open gnttdo;
       endif;

       if not %open(gnttis);
         open gnttis;
       endif;

       if not %open(gntpro);
         open gntpro;
       endif;

       if not %open(gntsex);
         open gntsex;
       endif;

       if not %open(gntesc);
         open gntesc;
       endif;

       if not %open(set225);
         open set225;
       endif;

       if not %open(gnttte);
         open gnttte;
       endif;

       if not %open(gnttce);
         open gnttce;
       endif;

       if not %open(cntbco);
         open cntbco;
       endif;

       if not %open(cntbcs);
         open cntbcs;
       endif;

       if not %open(set912);
         open set912;
       endif;

       if not %open(set001);
         open set001;
       endif;

       if not %open(set201);
         open set201;
       endif;

       if not %open(set202);
         open set202;
       endif;

       if not %open(set136);
         open set136;
       endif;

       if not %open(set137);
         open set137;
       endif;

       if not %open(set445);
         open set445;
       endif;

       if not %open(set444);
         open set444;
       endif;

       if not %open(set211);
         open set211;
       endif;

       if not %open(gnttc1);
         open gnttc1;
       endif;

       if not %open(set208);
         open set208;
       endif;

       if not %open(set215);
         open set215;
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

       if not %open(set645);
         open set645;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPDES_inz      E

      * ------------------------------------------------------------ *
      * SVPDES_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPDES_End      B                   export
     D SVPDES_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPDES_End      E

      * ------------------------------------------------------------ *
      * SVPDES_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPDES_Error    B                   export
     D SVPDES_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPDES_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_provinciaInder(): Descripcion                          *
      *                                                               *
      *     peProc   (input)   Provincia                              *
      *                                                               *
      * Retorna: *On / *Off                                           *
      * ------------------------------------------------------------- *
     P SVPDES_provinciaInder...
     P                 b                   export
     D SVPDES_provinciaInder...
     D                 pi            20
     D   peProc                       2  0 const

       SVPDES_inz();

       setll *Start gntpro;
       read gntpro;

       dow not %eof ( gntpro );

         if prrpro = peProc;
           return prprod;
         endif;

         read gntpro;

       enddo;

       return *Blanks;

     P SVPDES_provinciaInder...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_producto(): Descripcion de Producto                    *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peXpro   (input)   Producto                               *
      *                                                               *
      * Retorna: Descripcion de Producto                              *
      * ------------------------------------------------------------- *
     P SVPDES_producto...
     P                 B                   export
     D SVPDES_producto...
     D                 pi            20
     D   peRama                       2  0 const
     D   peXpro                       3  0 const

     D k1y102          ds                  likerec(s1t102:*key)

       SVPDES_inz();

       k1y102.t@rama = peRama;
       k1y102.t@xpro = peXpro;

       chain %kds( k1y102 ) set102;

       if %found( set102 );

           return t@prds;

       endif;

       return *blanks;

     P SVPDES_producto...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_clasificacionRiesgo(): Clasificacion de Riesgo         *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peClfr   (input)   Clacificacion                          *
      *                                                               *
      * Retorna: Descripcion de Clasificacion de Riesgo               *
      * ------------------------------------------------------------- *
     P SVPDES_clasificacionRiesgo...
     P                 B                   export
     D SVPDES_clasificacionRiesgo...
     D                 pi            30
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peClfr                       4    const

     D k1y831          ds                  likerec(s1t831:*key)

       SVPDES_inz();

       k1y831.t@empr = peEmpr;
       k1y831.t@sucu = peSucu;
       k1y831.t@clfr = peClfr;

       chain %kds( k1y831 ) set831;

       if %found( set831 );

           return t@dlfr;

       endif;

       return *blanks;

     P SVPDES_clasificacionRiesgo...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_agravioRiesgo(): Agravio de Riesgo                     *
      *                                                               *
      *     peEmpr   (input)   Empresa                                *
      *     peSucu   (input)   Sucursal                               *
      *     peCagr   (input)   Agravio                                *
      *                                                               *
      * Retorna: Agravio de Riesgo                                    *
      * ------------------------------------------------------------- *
     P SVPDES_agravioRiesgo...
     P                 B                   export
     D SVPDES_agravioRiesgo...
     D                 pi            30
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCagr                       2  0 const

     D k1y832          ds                  likerec(s1t832:*key)

       SVPDES_inz();

       k1y832.t@empr = peEmpr;
       k1y832.t@sucu = peSucu;
       k1y832.t@cagr = peCagr;

       chain %kds( k1y832 ) set832;

       if %found( set832 );

           return t@dagr;

       endif;

       return *blanks;

     P SVPDES_agravioRiesgo...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_tarifaRv() Tarifa RV                                   *
      *                                                               *
      *     peRama   (input)   Rama                                   *
      *     peCtar   (input)   Cap Tarifa                             *
      *     peCta1   (input)   Cap Tarifa 1                           *
      *     peCta2   (input)   Cap Tarifa 2                           *
      *                                                               *
      * Retorna: Tarifa RV                                            *
      * ------------------------------------------------------------- *
     P SVPDES_tarifaRv...
     P                 B                   export
     D SVPDES_tarifaRv...
     D                 pi            20
     D   peRama                       2  0 const
     D   peCtar                       4  0 const
     D   peCta1                       2    const
     D   peCta2                       2    const

     D k1y101          ds                  likerec(s1t101:*key)

       SVPDES_inz();

       k1y101.t@rama = peRama;
       k1y101.t@ctar = peCtar;
       k1y101.t@cta1 = peCta1;
       k1y101.t@cta2 = peCta2;

       chain %kds( k1y101 ) set101;

       if %found( set101 );

           return t@ctds;

       endif;

       return *blanks;

     P SVPDES_tarifaRv...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_actividad(): Actividad                                 *
      *                                                               *
      *     peActi   (input)   Actividad                              *
      *                                                               *
      * Retorna: Avtividad                                            *
      * ------------------------------------------------------------- *
     P SVPDES_actividad...
     P                 B                   export
     D SVPDES_actividad...
     D                 pi            50
     D   peActi                       5  0 const

       SVPDES_inz();

       chain peActi set021;

       if %found( set021 );

           return t@acti;

       endif;

       return *blanks;

     P SVPDES_actividad...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_estadoCivil (): Descripcion Estado Civil               *
      *                                                               *
      *     peEsci   (input)   Código de estado Civil                 *
      *                                                               *
      * Retorna: Descripcion                                          *
      * ------------------------------------------------------------- *
     P SVPDES_estadoCivil...
     P                 B                   export
     D SVPDES_estadoCivil...
     D                 pi            20
     D   peEsci                       1  0 const

       SVPDES_inz();

       chain peEsci gntesc;

       if %found( gntesc );

           return esdesc;

       endif;

       return *blanks;

     P SVPDES_estadoCivil...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_sexo() Descripcion                                     *
      *                                                               *
      *     peSexo   (input)   Código de Sexo                         *
      *                                                               *
      * Retorna: Descripcion                                          *
      * ------------------------------------------------------------- *
     P SVPDES_sexo...
     P                 B                   export
     D SVPDES_sexo...
     D                 pi            20
     D   peSexo                       1  0 const

       SVPDES_inz();

       chain peSexo gntsex;

       if %found( gntsex );

           return sedsex;

       endif;

       return *blanks;

     P SVPDES_sexo...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_getTipoDeVehiculo(): Retorna Descripcion de Tipo de    *
      *                             Vehiculo                          *
      *                                                               *
      *     peTipo   (input)   Código de tipo de Vehiculo             *
      *                                                               *
      * Retorna: Descripcion / Blancos                                *
      * ------------------------------------------------------------- *
     P SVPDES_getTipoDeVehiculo...
     P                 B                   export
     D SVPDES_getTipoDeVehiculo...
     D                 pi            15
     D   peTipo                       2  0 const

       SVPDES_inz();

       chain peTipo set210;

       if %found( set210 );

           return t@vhdt;

       endif;

       return *blanks;

     P SVPDES_getTipoDeVehiculo...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_coberturaVehiculo() Descripción de Cobertura de       *
      *                            Vehiculo.                         *
      *                                                              *
      *     peCobl   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPDES_coberturaVehiculo...
     P                 B                   export
     D SVPDES_coberturaVehiculo...
     D                 pi            20
     D   peCobl                       2    const
     D
     D k1y225          ds                  likerec(s1t225:*key)

      /free

       SVPDES_inz();

       k1y225.t225_t@cobl = peCobl;

       chain %kds( k1y225 ) set225;
       if %found( set225 );

         return t225_t@cobd;

       endif;

       return *blanks;

      /end-free

     P SVPDES_coberturaVehiculo...
     P                 E
      * ------------------------------------------------------------ *
      * SVPDES_TipoDeTelefono() Descripción de Tipo de Telefono      *
      *                                                              *
      *     peCobl   (input)   Código de Cobertura                   *
      *                                                              *
      * ------------------------------------------------------------ *

     P SVPDES_TipoDeTelefono...
     P                 B                   export
     D SVPDES_TipoDeTelefono...
     D                 pi            20
     D   peTipt                       2    const

      /free

       SVPDES_inz();

       chain peTipt gnttte;
       if %found( gnttte );
         return teDtip;
       endif;

       return *blanks;


      /end-free

     P SVPDES_TipoDeTelefono...
     P                 E
      * --------------------------------------------------------------*
      * SVPDES_getMail():Retorna Descripcion de Correo Electronico    *
      *                                                               *
      *     peTipt   (input)   Código de tipo de Correo               *
      *                                                               *
      * Retorna: Descripcion si existe                                *
      *          Blancos No existe                                    *
      * ------------------------------------------------------------- *
     P SVPDES_getMail...
     P                 B                   export
     D SVPDES_getMail...
     D                 pi            40
     D   peTipt                       2  0 const

       SVPDES_inz();

       chain peTipt gnttce;

       if %found( gnttce );

           return cedtce;

       endif;

       return *blanks;

     P SVPDES_getMail...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDES_monedaAbreviada: Retorna Abreviatura de moneda.       *
      *                                                              *
      *     peComo   (input)   Moneda                                *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_monedaAbreviada...
     P                 b                     export
     D SVPDES_monedaAbreviada...
     D                 pi             5
     D   peComo                       2      const

     D k1ymon          ds                  likerec(g1tmon:*key)

      /free

       SVPDES_inz();

       k1ymon.mocomo = peComo;

       chain %kds( k1ymon ) gntmon;
       if %found( gntmon );

         return monmoc;

       endif;

       return *blanks;

      /end-free


     P SVPDES_monedaAbreviada...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_banco(): Retorna Banco                                 *
      *                                                               *
      *     peIvbc   (input)   Código de Banco                        *
      *                                                               *
      * Retorna: Descripcion si existe                                *
      *          Blancos No existe                                    *
      * ------------------------------------------------------------- *
     P SVPDES_Banco...
     P                 B                   export
     D SVPDES_Banco...
     D                 pi            40
     D   peIvbc                       3  0 const

       SVPDES_inz();

       chain peIvbc cntbco;

       if %found( cntbco );

           return bcnomb;

       endif;

       return *blanks;

     P SVPDES_banco...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_sucursalBanco(): Retorna Sucursal de Banco             *
      *                                                               *
      *     peIvbc   (input)   Código de Banco                        *
      *     peIvsu   (input)   Código de Sucursal Bancop              *
      *                                                               *
      * Retorna: Descripcion si existe                                *
      *          Blancos No existe                                    *
      * ------------------------------------------------------------- *
     P SVPDES_sucursalBanco...
     P                 B                   export
     D SVPDES_sucursalBanco...
     D                 pi            40
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const

       SVPDES_inz();

       chain ( peIvbc : peIvsu ) cntbcs;

       if %found( cntbcs );

           return sbnomb;

       endif;

       return *blanks;

     P SVPDES_SucursalBanco...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDES_planDePago(): Retorna la descripción de plan de Pago. *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peNrpp  -  Código Plan de Pago                *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPDES_planDePago...
     P                 B                   export
     D SVPDES_planDePago...
     D                 pi            30
     D   peNrpp                       3  0   const
     D
     D k1y912          ds                  likerec(s1t912:*key)
     D

      /free

       SVPDES_inz();

       k1y912.t@Nrpp = peNrpp;

       chain %kds( k1y912 : 1 ) set912;
       if %found( set912 );

         return t@Dppg;

       endif;

       return *blanks;

      /end-free

     P SVPDES_planDePago...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDES_cuestionario() : Retorna descripción de cuestiondio.  *
      *                                                              *
      *  peTaaj ( input ) Código de cuestionario                     *
      *                                                              *
      * Retorna : Descripcion de un cuestionario                     *
      * ------------------------------------------------------------ *
     P SVPDES_cuestionario...
     P                 B                   export
     D SVPDES_cuestionario...
     D                 pi            30
     D   peTaaj                       2  0   const
     D
     D   @@DsCu        ds                    likeds( set2370_t )

      /free

       SVPDES_inz();

       SVPTAB_getCuestionario( peTaaj : @@DsCu);

       return @@DsCu.t@tabn;

      /end-free

     P SVPDES_cuestionario...
     P                 E

      * ------------------------------------------------------------ *
      * SVPDES_pregunta(): Retorna descripción de una pregunta       *
      *                                                              *
      *  peTaaj ( input ) Código de cuestionario                     *
      *  pecosg ( input ) Código de pregunta                         *
      *                                                              *
      * Retorna : Descripcion de un cuestionario                     *
      * ------------------------------------------------------------ *
     P SVPDES_pregunta...
     P                 B                   export
     D SVPDES_pregunta...
     D                 pi            79
     D   peTaaj                       2  0   const
     D   peCosg                       4      const
     D
     D   @@DsPr        ds                    likeds( set2371_t )

      /free

       SVPDES_inz();

       SVPTAB_getpregunta( peTaaj : peCosg : @@DsPr);

       return @@DsPr.t@cosd;

      /end-free

     P SVPDES_pregunta...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_rama(): Retorna nombre de Rama                         *
      *                                                               *
      *     peRama   (input)   Código de Rama                         *
      *                                                               *
      * Retorna: Descripcion de la Rama si encuentra                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_rama...
     P                 B                   export
     D SVPDES_rama...
     D                 pi            20
     D   peRama                       2  0 const

       SVPDES_inz();

       chain ( peRama ) set001;

       if %found( set001 );
         return t@ramd;
       endif;

       return *blanks;

     P SVPDES_rama...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_marca: Retorna Descripción de Marca de Vehículo.       *
      *                                                               *
      *     peVhmc   (input)   Código de Marca                        *
      *                                                               *
      * Retorna: Descripción de la Marca si encuentra                 *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_marca...
     P                 B                   export
     D SVPDES_marca...
     D                 pi            15
     D   peVhmc                       3    const

       SVPDES_inz();

       chain ( peVhmc ) set201;

       if %found( set201 );
         return t@Vhmd;
       endif;

       return *blanks;

     P SVPDES_marca...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_modelo: Retorna Descripción de Modelo de Vehículo.     *
      *                                                               *
      *     peVhmo   (input)   Código de Modelo                       *
      *                                                               *
      * Retorna: Descripción del Modelo si encuentra                 *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_modelo...
     P                 B                   export
     D SVPDES_modelo...
     D                 pi            15
     D   peVhmo                       3    const

       SVPDES_inz();

       chain ( peVhmo ) set202;

       if %found( set202 );
         return t@Vhdm;
       endif;

       return *blanks;

     P SVPDES_modelo...
     P                 E

      * --------------------------------------------------------------*
      * SVPDES_tipoDeMascota: Descripcion del tipo de mascota.        *
      *                                                               *
      *     peCtma   (input)   Código de Tipo de Mascota              *
      *                                                               *
      * Retorna: Descripción del tipo de mascota si encuentra         *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_tipoDeMascota...
     P                 b                   export
     D SVPDES_tipoDeMascota...
     D                 pi            40
     D   peCtma                       2  0 const

      /free

       SVPDES_inz();

       chain peCtma set136;
       if %found;
          return t@dtma;
       endif;

       return *blanks;

      /end-free

     P SVPDES_tipoDeMascota...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_razaDeMascota: Descripcion de la raza de mascota.      *
      *                                                               *
      *     peCraz   (input)   Código de raza de mascota              *
      *                                                               *
      * Retorna: Descripción de la raza de la mascota si encuentra    *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_razaDeMascota...
     P                 b                   export
     D SVPDES_razaDeMascota...
     D                 pi            40
     D   peCraz                       4  0 const

      /free

       SVPDES_inz();

       chain peCraz set137;
       if %found;
          return t@draz;
       endif;

       return *blanks;

      /end-free

     P SVPDES_razaDeMascota...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_estadoDeFactura: Descripcion de estado de factura Web  *
      *                                                               *
      *     peEsta   (input)   Código de Estado de Factura            *
      *                                                               *
      * Retorna: Descripción de Estado de la Factura Web /            *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_estadoDeFactura...
     P                 b                   export
     D SVPDES_estadoDeFactura...
     D                 pi            40
     D   peEsta                       1    const

      /free

       SVPDES_inz();

       select;
         when peEsta = '1';
           return 'Factura Ingresada';
         when peEsta = '2';
           return 'Factura Descargada - Enviada a analizar';
         when peEsta = '3';
           return 'Factura imputada en la compañia';
         when peEsta = 'E';
           return 'Factura con inconvenientes';
         when peEsta = 'R';
           return 'Rechazada - Comuníquese con Contaduría';
       endsl;

       return *blanks;

      /end-free

     P SVPDES_estadoDeFactura...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_estadoOrdenDePago : Descripción de estado de orden de  *
      *                            pago                               *
      *                                                               *
      *     peEsta   (input)   Código de Estado                       *
      *                                                               *
      * Retorna: Descripción de Estado de Orden de Pago /             *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_estadoOrdenDePago...
     P                 b                   export
     D SVPDES_estadoOrdenDePago...
     D                 pi            40
     D   peEsta                       1    const

      /free

       SVPDES_inz();

       select;
         when peEsta = '0';
           return 'Impaga';
         when peEsta = '1';
           return 'En proc.pago';
         when peEsta = '2';
           return 'En proceso nro.cpte.pago';
         when peEsta = '3';
           return 'Pagada';
         when peEsta = '8';
           return 'Anulada';
         when peEsta = '9';
           return 'Impaga no autorizada';
       endsl;

       return *blanks;

      /end-free

     P SVPDES_estadoOrdenDePago...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_tipoDePersona: Descripcion del tipo de persona.        *
      *                                                               *
      *     petipe   (input)   Código de Tipo de Persona              *
      *                                                               *
      * Retorna: Descripción del tipo de persona si encuentra         *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_tipoDePersona...
     P                 b                   export
     D SVPDES_tipoDePersona...
     D                 pi            15
     D   peTipe                       1    const

      /free

       SVPDES_inz();

       select;
         when peTipe = 'F';
           return 'FISICA';
         when peTipe = 'J';
           return 'JURIDICA';
         when peTipe = 'C';
           return 'CONSORCIO';
       endsl;

       return *blanks;

      /end-free

     P SVPDES_tipoDePersona...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_estadoDelTiempo: Descripcion de estado del Tiempo      *
      *                                                               *
      *     peEmpr   (input)   Código de Empresa                      *
      *     peSucu   (input)   Código de Sucursal                     *
      *     peCdes   (input)   Código de Estado del Tiempo            *
      *                                                               *
      * Retorna: Descripción de Estado del Tiempo  /                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_estadoDelTiempo...
     P                 b                   export
     D SVPDES_estadoDelTiempo...
     D                 pi            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCdes                       2  0 const

     D k1y445          ds                  likerec(s1t445:*key)

      /free


       SVPDES_inz();

       k1y445.t@empr = peEmpr;
       k1y445.t@sucu = peSucu;
       k1y445.t@cdes = peCdes;

       chain %kds( k1y445 ) set445;
       if %found;
          return t@ddes;
       endif;

       return *blanks;

      /end-free

     P SVPDES_estadoDelTiempo...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_getProvinciaPorLocalidad() Devuelve el codigo de       *
      *                                   Provincia.                  *
      *     peCopo   (input)   Código Postal                          *
      *     peCops   (input)   Sufijo Codigo Postal                   *
      *                                                               *
      * Retorna: Codigo de Provincia /                                *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_getProvinciaPorLocalidad...
     P                 b                   export
     D SVPDES_getProvinciaPorLocalidad...
     D                 pi             2  0
     D   peCopo                       5  0 const
     D   peCops                       1  0 const

     D k1yloc          ds                  likerec(g1tloc:*key)
     D k1ypro          ds                  likerec(g1tpro:*key)

      /free


       SVPDES_inz();

       k1yloc.locopo = peCopo;
       k1yloc.locops = peCops;
       chain %kds( k1yloc ) gntloc;
       if %found;
        k1ypro.prproc = loproc;
        chain %kds( k1ypro ) gntpro;
        if %found;
          return prrpro;
        endif;
       endif;

       return *zeros;

      /end-free

     P SVPDES_getProvinciaPorLocalidad...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_relacionConAsegurado: Descripción de Relación con      *
      *                              el Asegurado                     *
      *     peEmpr   (input)   Código de Empresa                      *
      *     peSucu   (input)   Código de Sucursal                     *
      *     peRela   (input)   Código de Relación                     *
      *                                                               *
      * Retorna: Descripción de Relacion con Asegurado /              *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_relacionConAsegurado...
     P                 b                   export
     D SVPDES_relacionConAsegurado...
     D                 pi            25
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRela                       2  0 const

     D k1y444          ds                  likerec(s1t444:*key)

      /free


       SVPDES_inz();

       k1y444.t@empr = peEmpr;
       k1y444.t@sucu = peSucu;
       k1y444.t@Rela = peRela;

       chain %kds( k1y444 ) set444;
       if %found;
          return t@reld;
       endif;

       return *blanks;

      /end-free

     P SVPDES_relacionConAsegurado...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_usoDelVehiculo: Descripcion Uso del Vehiculo           *
      *                              el Asegurado                     *
      *     peVhuv   (input)   Código de Uso del Vehículo             *
      *                                                               *
      * Retorna: Descripción de Uso del Vehículo /                    *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_usoDelVehiculo...
     P                 b                   export
     D SVPDES_usoDelVehiculo...
     D                 pi            25
     D   peVhuv                       2  0 const

     D k1y211          ds                  likerec(s1t211:*key)

      /free


       SVPDES_inz();

       k1y211.t@vhuv = peVhuv;
       chain %kds( k1y211 ) set211;
       if %found;
          return t@vhdu;
       endif;

       return *blanks;

      /end-free

     P SVPDES_usoDelVehiculo...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_nombCortoEmpTdc(): Nombre Corto de la Empresa Tarjeta  *
      *                           de Credito.                         *
      *                                                               *
      *     peCtcu   (input)   Código de Empresa TDC                  *
      *                                                               *
      * Retorna: Nombre de Empresa /                                  *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_nombCortoEmpTdc...
     P                 b                   export
     D SVPDES_nombCortoEmpTdc...
     D                 pi            10
     D   peCtcu                       3  0 const

      /free

       SVPDES_inz();

       chain peCtcu gnttc1;
       if %found(gnttc1);
         select;
           when t1Ctce = 'AE';
             return 'AMEX';
           when t1Ctce = 'DC';
             return 'DINERS';
           when t1Ctce = 'AG';
             return 'MASTER';
           when t1Ctce = 'VI';
             return 'VISA';
           when t1Ctce = 'CA';
             return 'CABAL';
         endsl;
       endif;

       return *blanks;

      /end-free

     P SVPDES_nombCortoEmpTdc...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_capituloVariante(): Descripcion de capitulo/variantes  *
      *                                                               *
      *     peVhca   (input)   Capitulo                               *
      *     peVhv1   (input)   Variante RC                            *
      *     peVhv2   (input)   Variante AIR                           *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_capituloVariante...
     P                 b                   export
     D SVPDES_capituloVariante...
     D                 pi            20a
     D   peVhca                       2  0 const
     D   peVhv1                       1  0 const
     D   peVhv2                       1  0 const

      /free

       SVPDES_inz();

       chain (peVhca:peVhv1:peVhv2) set215;
       if %found;
          return t@cvde;
       endif;

       return *blanks;

      /end-free

     P                 e

      * --------------------------------------------------------------*
      * SVPDES_tarifaDiferencial(): Descripcion de marca de tarifa dif*
      *                                                               *
      *     peMtdf   (input)   Marca de Tarifa Diferencial            *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_tarifaDiferencial...
     P                 b                   export
     D SVPDES_tarifaDiferencial...
     D                 pi            20a
     D   peMtdf                       1a   const

      /free

       SVPDES_inz();

       chain peMtdf set208;
       if %found;
          return t@mtdd;
       endif;

       return *blanks;

      /end-free

     P                 e

      * --------------------------------------------------------------*
      * SVPDES_tipoDeTransporte(): Descripcion de tipo de Transporte  *
      *                                                               *
      *     peTtra   (input)   Código de Tipo de Transportes          *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_tipoDeTransporte...
     P                 b                   export
     D SVPDES_tipoDeTransporte...
     D                 pi            30a
     D   peTtra                       3  0 const

      /free

       SVPDES_inz();

       chain peTtra set749;
       if %found;
          return t@dtra;
       endif;

       return *blanks;

      /end-free

     P SVPDES_tipoDeTransporte...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_medioDeTransporte(): Descripcion de medio de Transporte*
      *                                                               *
      *     peMtra   (input)   Código de Medio de Transportes         *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_medioDeTransporte...
     P                 b                   export
     D SVPDES_medioDeTransporte...
     D                 pi            30a
     D   peMtra                       1  0 const

      /free

       SVPDES_inz();

       chain peMtra set751;
       if %found;
          return t@dmtr;
       endif;

       return *blanks;

      /end-free

     P SVPDES_medioDeTransporte...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_tipoDeMercaderia(): Descripcion de tipo de Mercaderia  *
      *                                                               *
      *     peCmer   (input)   Código de Tipo de Mercaderias          *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_tipoDeMercaderia...
     P                 b                   export
     D SVPDES_tipoDeMercaderia...
     D                 pi            30a
     D   peCmer                       3  0 const

      /free

       SVPDES_inz();

       chain peCmer set762;
       if %found;
          return t@dmer;
       endif;

       return *blanks;

      /end-free

     P SVPDES_tipoDeMercaderia...
     P                 e

      * --------------------------------------------------------------*
      * SVPDES_formaDeAnular(): Descripcion de forma de anular        *
      *                                                               *
      *     peCfan   (input)   Forma de Anular                        *
      *                                                               *
      * Retorna: Descripcion o *blanks                                *
      * ------------------------------------------------------------- *
     P SVPDES_formaDeAnular...
     P                 b                   export
     D SVPDES_formaDeAnular...
     D                 pi            40a
     D   peCfan                       1  0 const

      /free

       SVPDES_inz();

       chain peCfan set645;
       if not %found;
          return *blanks;
       endif;

       return t645_t@dfan;

      /end-free

     P                 e

      * --------------------------------------------------------------*
      * SVPDES_subModelo: Retorna Descripción de SubModelo de         *
      *                   Vehículo.                                   *
      *                                                               *
      *     peVhcs   (input)   Código de Modelo                       *
      *                                                               *
      * Retorna: Descripción del subModelo si encuentra               *
      *          Blancos No encuentra                                 *
      * ------------------------------------------------------------- *
     P SVPDES_subModelo...
     P                 B                   export
     D SVPDES_subModelo...
     D                 pi            15
     D   peVhcs                       3    const

       SVPDES_inz();

       chain ( peVhcs ) set202;

       if %found( set202 );
         return t@Vhcs;
       endif;

       return *blanks;

     P SVPDES_subModelo...
     P                 E

