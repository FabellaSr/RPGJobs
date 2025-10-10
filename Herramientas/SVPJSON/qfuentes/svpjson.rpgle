     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPSVPJSON:                                                     *
      * ------------------------------------------------------------ *
      * Fabella Ivan                                                 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *
      *--- Copy H -------------------------------------------------- *
     Fgntpec    if   e           k disk    usropn
     Fpawpec    if   e           k disk    usropn
     Fgntpca    if   e           k disk    usropn
      /copy DESA_0836/qcpybooks,SVPJSON_h
     D Initialized     s              1N
      * ------------------------------------------------------------ *
      * SVPTAB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPJSON_inz...
     P                 b                   export

      /free
       if not %open(gntpec);
         open gntpec;
       endif;

       if not %open(pawpec);
         open pawpec;
       endif;

       if not %open(gntpca);
         open gntpca;
       endif;

       initialized = *ON;

       return;

      /end-free

     P SVPJSON_inz     E
      * ------------------------------------------------------------ *
      * SVPJSON_inicio() : Inicializamos un JSON                     *
      *                                                              *
      *     pxInicio   ( output  ) { de inicio                       *
      * ------------------------------------------------------------ *
     P SVPJSON_inicio...
     P                 b                   export
     D SVPJSON_inicio...
     D                 pi              n
     D pxInicio                   32767
      /free
         pxInicio = '{';
         return *on;
      /end-free
     P SVPJSON_inicio...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_fin: Finaliza el documento SVPJSON                   *
      *     pxInicio   ( output  ) { de fin                          *
      * ------------------------------------------------------------ *
     P SVPJSON_fin...
     P                 b                   export
     D SVPJSON_fin...
     D                 pi              n
     D pxFin                      32767
      /free
         pxFin = '}';
         return *on;
      /end-free
     P SVPJSON_fin...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_agregoCampoString: Agrega campo String               *
      *                                                              *
      *   peNombre     (input) Nombre del campo (sin comillas)       *
      *   peValor      (input) Contenido del campo ( en "")          *
      *   pxEsUltimo   (input) Indicador si es el último campo       *
      *   pxCampo      (output)Cadena                                *
      * ------------------------------------------------------------ *
     P SVPJSON_agregoCampoString...
     P                 b                   export
     D SVPJSON_agregoCampoString...
     D                 pi              n
     D  peNombre                    100a   const
     D  peValor                   32767    const
     D  peEsUltimo                     n   const
     D  pxCampo                   32767
      /free
        if peEsUltimo;
          pxCampo = %trimr(pxCampo) + '"' +
                    %trim(peNombre) + '": "' +
                    %trim(peValor)  + '"';
        else;
          pxCampo = %trimr(pxCampo) + '"' +
                    %trim(peNombre) + '": "' +
                    %trim(peValor) + '",';
        endif;
        return *on;
      /end-free

     P SVPJSON_agregoCampoString...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_agregoCampoNumerico: Agrega campo  Numerico          *
      *                                                              *
      *   peNombre     (input) Nombre del campo (sin comillas)       *
      *   peValor      (input) Contenido del campo ( en "")          *
      *   pxEsUltimo   (input) Indicador si es el último campo       *
      *   pxCampo      (output)Cadena                                *
      * ------------------------------------------------------------ *
     P SVPJSON_agregoCampoNumerico...
     P                 b                   export
     D SVPJSON_agregoCampoNumerico...
     D                 pi              n
     D  peNombre                    100a   const
     D  peValor                   32767    const
     D  peEsUltimo                     n   const
     D  pxCampo                   32767
      /free
        if peEsUltimo;
          pxCampo = %trimr(pxCampo) + '"' +
                    %trim(peNombre) + '": ' +
                    %trim(peValor)  ;
        else;
          pxCampo = %trimr(pxCampo) + '"' +
                    %trim(peNombre) + '": ' +
                    %trim(peValor) + ',';
        endif;
        return *on;
      /end-free

     P SVPJSON_agregoCampoNumerico...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_campoNull: Agrega un campo con valor null            *
      *                                                              *
      *     peNombre (input) Nombre del campo                        *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_campoNull...
     P                 b                   export
     D SVPJSON_campoNull...
     D                 pi              n
     D   peNombre                   100a     const
     D   peUltimo                      n     const
     D  pxCampo                   32767
      /free
         if peUltimo;
            pxCampo = %trimr(pxCampo) + '"' +
                      %trim(peNombre) + '": null';
         else;
            pxCampo = %trimr(pxCampo) + '"' +
                      %trim(peNombre) + '": null,';
         endif;
         return *on;
      /end-free

     P SVPJSON_campoNull...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_nuevoObjeto: Abre un nuevo objeto SVPJSON            *
      *                                                              *
      *     peNombre (input) Nombre del objeto                       *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_nuevoObjeto...
     P                 b                   export
     D SVPJSON_nuevoObjeto...
     D                 pi              n
     D   peNombre                   100a     const
     D  pxCampo                   32767
      /free
         pxCampo = %trimr(pxCampo) + '"' +
                   %trim(peNombre) + '": {';
         return *on;
      /end-free
     P SVPJSON_nuevoObjeto...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_cerrarObj...
     P                 b                   export
     D SVPJSON_cerrarObj...
     D                 pi              n
     D   peUltimo                      N    const
     D  pxCampo                   32767

      /free
         if peUltimo;
            pxCampo = %trimr(pxCampo) + '}';
         else;
            pxCampo = %trimr(pxCampo) + '},';
         endif;
         return *on;
      /end-free

     P SVPJSON_cerrarObj...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_openObject: Abre un nuevo objeto SVPJSON             *
      *                                                              *
      *     peNombre (input) Nombre del objeto                       *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_nuevoObjetoLista...
     P                 b                   export
     D SVPJSON_nuevoObjetoLista...
     D                 pi              n
     D   peNombre                   100a     const
     D  pxCampo                   32767
      /free
         pxCampo = %trimr(pxCampo) + '"' +
                   %trim(peNombre) + '": [{';
         return *on;
      /end-free
     P SVPJSON_nuevoObjetoLista...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_cerrarObjLista...
     P                 b                   export
     D SVPJSON_cerrarObjLista...
     D                 pi              n
     D   peUltimo                      N    const
     D  pxCampo                   32767

      /free
         if peUltimo;
            pxCampo = %trimr(pxCampo) + '}]';
         else;
            pxCampo = %trimr(pxCampo) + '}],';
         endif;
         return *on;
      /end-free

     P SVPJSON_cerrarObjLista...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_objetosArray...
     P                 b                   export
     D SVPJSON_objetosArray...
     D                 pi              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  pxCampo                   32767
      /free
         SVPJSON_inz();
         auxJson    = *blanks;
         auxJson    = pxCampo;
         primeraVez = *on;
         esArray    = *off;
         elUltimo   = *off;
         k1wpec.p@orde = 1;
         k1wpec.p@NOMJ = %trim(peNomj);
         setll %kds(k1wpec:2) pawpec;
         reade %kds(k1wpec:2) pawpec;
         //Leo las propiedades del primer read.
         SVPJSON_cargaProp();
         dow not %eof(pawpec);
         //Dependiendo el tipo hacemos una cosa u otra.
            select;
               when p@tipo = '0';
                  SVPJSON_objetosLista( peEmpr
                                      : peSucu
                                      : p@nomj
                                      : p@nomb );
               when p@tipo = '1';
                  SVPJSON_nuevoObjeto( %trim(p@nomb) : auxJson );
                  SVPJSON_objetosArrayAnidados( peEmpr
                                              : peSucu
                                              : p@nomj
                                              : p@nomb );
            endsl;
            primeraVez = *on;
            k1wpec.p@orde += 1;
            reade %kds(k1wpec:2) pawpec;
            if not %eof(pawpec);
               if not esArray;
                  SVPJSON_cerrarObjLista( *off : auxJson );
               else;
                  SVPJSON_cerrarObj( *off : auxJson );
                  esArray = *off;
               endif;
               //Vuelvo a leer las propiedades.
               SVPJSON_cargaProp();
            else;
               if not esArray;
                  SVPJSON_cerrarObjLista( *on : auxJson );
               else;
                  SVPJSON_cerrarObj( *on : auxJson );
                  esArray = *on;
               endif;
               if P@ULTI = '1';
                  SVPJSON_cerrarObj( *on : auxJson );
               endif;
            endif;
         enddo;
         pxCampo = auxJson;
         return *on;
      /end-free
     P SVPJSON_objetosArray...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_objetosArrayAnidados...
     P                 b                   export
     D SVPJSON_objetosArrayAnidados...
     D                 pi              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  peNomb                       20A
      /free
         primeraVez = *on;
         elUltimo = *off;
         k1tpca.a@empr = peEmpr;
         k1tpca.a@sucu = peSucu;
         k1tpca.a@noar = peNomb;
         k1tpca.a@noaj = peNomj;
         k1tpca.a@nrob = 1;
         setll %kds(k1tpca:5) gntpca;
         reade %kds(k1tpca:5) gntpca;
         dow not %eof(gntpca);
            elUltimo = (*on = (A@ULTP = '1'));
            if primeraVez;
               if A@MAR3 <> '1';
                  SVPJSON_nuevoObjetoLista( a@nomo : auxJson );
               endif;
               primeraVez = *off;
            endif;
            SVPJSON_setTipoDato(a@nomp : a@nrop);
            select;
               when A@ULOB = '1';
                 // SVPJSON_cerrarObjLista( *on : auxJson );
                 // SVPJSON_cerrarObj( *on : auxJson );
                  primeraVez = *on;
               when A@ULTP = '1' and A@ULOB = '0' and A@MAR3 <> '1';
                  SVPJSON_cerrarObjLista( *off : auxJson );
                  primeraVez = *on;
               when A@MAR3 = '1';
                  k1tpca.a@nrob += 1;
                  primeraVez = *on;
            endsl;
            //Si es la ultima propuedad paso al siguiente
            if A@ULTP = '1';
               k1tpca.a@nrob += 1;
            endif;
            reade %kds(k1tpca:5) gntpca;
         enddo;
         return *on;
      /end-free
     P SVPJSON_objetosArrayAnidados...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_objetosLista...
     P                 b                   export
     D SVPJSON_objetosLista...
     D                 pi              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  peNomo                       20A
      /free
         k1tpec.g@empr = peEmpr;
         k1tpec.g@sucu = peSucu;
         k1tpec.g@nomj = peNomj;
         k1tpec.g@nomo = peNomo;
         k1tpec.g@nrop = 1;
         setll %kds(k1tpec:4) gntpec;
         reade %kds(k1tpec:4) gntpec;
         dow not %eof(gntpec);
            elUltimo = (*on = (g@mar1 = '1'));
            if primeraVez;
               SVPJSON_nuevoObjetoLista( p@nomb : auxJson );
               primeraVez = *off;
            endif;
            SVPJSON_setTipoDato( g@nomp : g@nrop );
            k1tpec.g@nrop += 1;
            reade %kds(k1tpec:4) gntpec;
         enddo;
         return *on;
      /end-free
     P SVPJSON_objetosLista...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_cargaProp...
     P                 b                   export
     D SVPJSON_cargaProp...
     D                 pi              n
        dcl-s i int(10) inz(1);
      /free
         for i = 1 to %elem(propiedad);
            propiedad(i) = *blanks;
         endfor;
         for i = 1 to %elem(propiedad);
            propiedad(i) = %subst( p@camp
                                 : ((i - 1) * cantidadC) + 1
                                 : cantidadC                );
         endfor;
         return *on;
      /end-free
     P SVPJSON_cargaProp...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *     pxCampo  (output)Cadena                                  *
      * ------------------------------------------------------------ *
     P SVPJSON_setTipoDato...
     P                 b                   export
     D SVPJSON_setTipoDato...
     D                 pi              n
     D  str                          50a   varying const
     D  pos                          10i 0 const
      /free
         select;
            when g@tipd = 'N';
               if propiedad(%int(pos)) <> *blanks;
                  SVPJSON_agregoCampoNumerico( str
                                             : propiedad(%int(pos))
                                             : elUltimo
                                             : auxJson            );
               else;
                  SVPJSON_campoNull( str
                                 : elUltimo
                                 : auxJson );
               endif;
            when g@tipd = 'S';
               SVPJSON_agregoCampoString( str
                                        : %trim(propiedad(%int(pos)))
                                        : elUltimo
                                        : auxJson                   );
         endsl;
         return *on;
      /end-free
     P SVPJSON_setTipoDato...
     P                 e
