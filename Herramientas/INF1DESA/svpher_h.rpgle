      /if defined(SVPHER_H)
      /eof
      /endif
      /define SVPHER_H

      * Descuento no pertenece a la Caracteristica...
     D SVPHER_DESNC    c                   const(0001)
      * Caracteristica no Existente...
     D SVPHER_CARNE    c                   const(0002)
     * - ----------------------------------------------------------- *
      *   Archivos
     * - ----------------------------------------------------------- *
     Fsetobj    uf a e           k disk
      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPHER_ERDST_t  ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a
      * --------------------------------------------------- *
      * Estrucutura de objetos (para entrada)
      * --------------------------------------------------- *
     D OBJETOS_T       DS                  qualified
     D                                     based(template)
     D   peObjn                      10A
     D   peObjt                      10A
     D   peObjl                      10A
      * ------------------------------------------------------------ *
      * SVPHER_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPHER_inz      pr

      * ------------------------------------------------------------ *
      * SVPHER_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPHER_end      pr

      * ------------------------------------------------------------ *
      * SVPHER_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPHER_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPHER_insertEnSetObj(): Setea los objetos a instalar        *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPHER_grabaObjAInst...
     D                 pr              n
     D   peLobj                            likeds(objetos_t) DIM(100)
     D   peInst                            like(O1INST) const
     D   peUser                      10a   const
     D   peCobj                      10i 0 const
