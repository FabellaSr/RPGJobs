      /if defined(SVPJSON_H)
      /eof
      /endif
      /define SVPJSON_H
            dcl-s auxJson   char(32767) ;
            dcl-s primeraVez ind inz(*on);
            dcl-s elUltimo   ind inz(*off);
            dcl-s esArray    ind inz(*off);
            dcl-s cantidadC int(10) inz(50);
            //Cada propiedad sera de 50 caracteres.
            //Un total de 30 campos posibles.
            dcl-s propiedad char(50) dim(30);
            dcl-ds k1tpec  likerec(g@tpec:*key);
            dcl-ds k1wpec  likerec(p@wpec:*key);
            dcl-ds k1tpca  likerec(a@tpca:*key);

      * ------------------------------------------------------------ *
      * SVPJSON_inicio() : Inicializamos un JSON                     *
      *                                                              *
      *     pxInicio   ( output  ) { de inicio                       *
      * ------------------------------------------------------------ *
     D SVPJSON_inz     PR
      * ------------------------------------------------------------ *
      * SVPJSON_inicio() : Inicializamos un JSON                     *
      *                                                              *
      *     pxInicio   ( output  ) { de inicio                       *
      * ------------------------------------------------------------ *
     D SVPJSON_inicio...
     D                 pr              n
     D pxInicio                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_fin: Finaliza el documento JSON                         *
      *                                                              *
      * No recibe parámetros                                         *
      *                                                              *
      * Retorna: VARCHAR(32767) con cierre de llaves finales }      *
      * ------------------------------------------------------------ *
     D SVPJSON_fin...
     D                 pr              n
     D pxFinJs                    32767
      * ------------------------------------------------------------ *
      * SVPJSON_agregoCampoNumerico: Agrega campo  Numerico          *
      *                                                              *
      *   peNombre     (input) Nombre del campo (sin comillas)       *
      *   peValor      (input) Contenido del campo ( en "")          *
      *   pxEsUltimo   (input) Indicador si es el último campo       *
      *   pxCampo      (output)Cadena                                *
      * ------------------------------------------------------------ *
     D SVPJSON_agregoCampoNumerico...
     D                 pr              n
     D  peNombre                    100a   const
     D  peValor                   32767    const
     D  peEsUltimo                     n   const
     D  pxCampo                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_agregoCampoString: Agrega campo String               *
      *                                                              *
      *   peNombre     (input) Nombre del campo (sin comillas)       *
      *   peValor      (input) Contenido del campo ( en "")          *
      *   pxEsUltimo   (input) Indicador si es el último campo       *
      *   pxCampo      (output)Cadena                                *
      * ------------------------------------------------------------ *
     D SVPJSON_agregoCampoString...
     D                 pr              n
     D  peNombre                    100a   const
     D  peValor                   32767    const
     D  peEsUltimo                     n   const
     D  pxCampo                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_campoNull: Agrega un campo con valor null            *
      *                                                              *
      *     peNombre (input) Nombre del campo                        *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *                                                              *
      * Retorna: texto con formato: "campo": null o "campo": null,   *
      * ------------------------------------------------------------ *
     D SVPJSON_campoNull...
     D                 pr              n
     D   peNombre                   100a     const
     D   peUltimo                      n     const
     D  pxCampo                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_nuevoObjeto: Abre un nuevo objeto dentro del JSON    *
      *                                                              *
      *   nombre     (input) Nombre del objeto                       *
      *                                                              *
      * Retorna: VARCHAR(32767) con { de apertura                    *
      * Ej:  "nombre": {                                             *
      * ------------------------------------------------------------ *
     D SVPJSON_nuevoObjeto...
     D                 pr              n
     D   peNombre                   100a     const
     D  pxCampo                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto JSON                     *
      *                                                              *
      *   esUltimo   (input) Si es el último campo/objeto            *
      *                                                              *
      * Retorna: VARCHAR(32767) con cierre del objeto                *
      * Ej:  } o },                                                  *
      * ------------------------------------------------------------ *
     D SVPJSON_cerrarObj...
     D                 pr              n
     D   peUltimo                      N    const
     D  pxCampo                   32767

      * ------------------------------------------------------------ *
      * SVPJSON_nuevoObjetoLista: Abre un nuevo objeto               *
      *                                                              *
      *   nombre     (input) Nombre del objeto                       *
      *                                                              *
      * Retorna: VARCHAR(32767) con { de apertura                    *
      * Ej:  "nombre": {                                             *
      * ------------------------------------------------------------ *
     D SVPJSON_nuevoObjetoLista...
     D                 pr              n
     D   peNombre                   100a     const
     D  pxCampo                   32767
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObjLista: Cierra un objeto JSON                *
      *                                                              *
      *   esUltimo   (input) Si es el último campo/objeto            *
      *                                                              *
      * Retorna: VARCHAR(32767) con cierre del objeto                *
      * Ej:  } o },                                                  *
      * ------------------------------------------------------------ *
     D SVPJSON_cerrarObjLista...
     D                 pr              n
     D   peUltimo                      N    const
     D  pxCampo                   32767
      * ============================================================ *
      *  NUEVAS RUTINAS DEL CONSTRUCTOR                              *
      * ============================================================ *

      * - ---------------------------------------------------------- *
      *    Objetos lista / array raíz                                *
      * - ---------------------------------------------------------- *
     D SVPJSON_objetosArray...
     D                 PR              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  pxCampo                   32767
      * - ---------------------------------------------------------- *
      *    Arrays anidados dentro de un objeto                       *
      * - ---------------------------------------------------------- *
     D SVPJSON_oobjetosArrayAnidados...
     D                 PR              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  peNomb                       20A
      * - ---------------------------------------------------------- *
      *    Lista de objetos simples (array de objetos)               *
      * - ---------------------------------------------------------- *
     D SVPJSON_oobjetosLista...
     D                 PR              n
     D  peEmpr                        1A
     D  peSucu                        2A
     D  peNomj                       20A
     D  peNomo                       20A
      * - ---------------------------------------------------------- *
      *    Carga propiedades (corta p@camp en bloques de 50)         *
      * - ---------------------------------------------------------- *
     D cargaProp       PR              n

      * - ---------------------------------------------------------- *
      *    Seteo según tipo de dato                                  *
      * - ---------------------------------------------------------- *
     D SVPJSON_osetTipoDato...
     D                 PR              n
     D   str                         50a   varying const
     D   pos                         10i 0 const
