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
      /copy DESA_0836/qcpybooks,SVPJSON_h
      * ------------------------------------------------------------ *
      * SVPJSON_inicio() : Inicializamos un JSON                     *
      *                                                              *
      *     pxInicio   ( output  ) { de inicio                       *
      * ------------------------------------------------------------ *
     P SVPJSON_inicio...
     P                 b                   export
     D SVPJSON_inicio...
     D                 pi              n
     D pxInicio                     500
      /free
         pxInicio = '{';
         return *on;
      /end-free
     P SVPJSON_inicio...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_fin: Finaliza el documento SVPJSON                   *
      *                                                              *
      *                                                              *
      *                                                              *
      * Retorna: el carácter de cierre de raíz: }                    *
      * ------------------------------------------------------------ *
     P SVPJSON_fin...
     P                 b                   export
     D SVPJSON_fin...
     D                 pi              n
     D pxFin                        500
      /free
         pxFin = '}';
         return *on;
      /end-free
     P SVPJSON_fin...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_agregoCampo: Agrega campo                            *
      *                                                              *
      *   peNombre     (input) Nombre del campo (sin comillas)       *
      *   peValor      (input) Contenido del campo ( en "")          *
      *   pxEsUltimo   (input) Indicador si es el último campo       *
      *                                                              *
      * Retorna: VARCHAR(32767) con texto del campo JSON             *
      * Ej:  "campo": "valor" [,]                                    *
      * ------------------------------------------------------------ *
     P SVPJSON_agregoCampo...
     P                 b                   export
     D SVPJSON_agregoCampo...
     D                 pi              n
     D  peNombre                    100a   const
     D  peValor                     500    const
     D  peEsUltimo                     n   const
     D  pxCampo                     500
      /free
        if peEsUltimo;
          pxCampo = '"' + %trim(peNombre) + '": "' + %trim(peValor) + '"';
        else;
          pxCampo = '"' + %trim(peNombre) + '": "' + %trim(peValor) + '",';
        endif;
        return *on;
      /end-free

     P SVPJSON_agregoCampo...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_campoNull: Agrega un campo con valor null            *
      *                                                              *
      *     peNombre (input) Nombre del campo                        *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *                                                              *
      * Retorna: texto con formato: "campo": null o "campo": null,   *
      * ------------------------------------------------------------ *
     P SVPJSON_campoNull...
     P                 b                   export
     D SVPJSON_campoNull...
     D                 pi              n
     D   peNombre                   100a     const
     D   peUltimo                      n     const
     D  pxCampo                     500
      /free
         if peUltimo;
            pxCampo = '"' + %trim(peNombre) + '": null';
         else;
            pxCampo = '"' + %trim(peNombre) + '": null,';
         endif;
         return *on;
      /end-free

     P SVPJSON_campoNull...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_openObject: Abre un nuevo objeto SVPJSON                   *
      *                                                              *
      *     peNombre (input) Nombre del objeto                       *
      *                                                              *
      * Retorna: texto con apertura de objeto: "nombre": {          *
      * ------------------------------------------------------------ *
     P SVPJSON_nuevoObjeto...
     P                 b                   export
     D SVPJSON_nuevoObjeto...
     D                 pi              n
     D   peNombre                   100a     const
     D  pxCampo                     500
      /free
         pxCampo = '"' + %trim(peNombre) + '": {';
         return *on;
      /end-free
     P SVPJSON_nuevoObjeto...
     P                 e
      * ------------------------------------------------------------ *
      * SVPJSON_cerrarObj: Cierra un objeto SVPJSON                  *
      *                                                              *
      *     peUltimo (input) Indicador: *ON si es el último campo    *
      *                                                              *
      * Retorna: texto con cierre del objeto: } o },                 *
      * ------------------------------------------------------------ *
     P SVPJSON_cerrarObj...
     P                 b                   export
     D SVPJSON_cerrarObj...
     D                 pi              n
     D   peUltimo                      N    const
     D  pxCampo                     500

      /free
         if peUltimo;
            pxCampo = '}';
         else;
            pxCampo = '},';
         endif;
         return *on;
      /end-free

     P SVPJSON_cerrarObj...
     P                 e
