      /if defined(SVPCALC_H)
      /eof
      /endif
      /define SVPCALC_H
       /copy *libl/qcpybooks,wsstruc_h

     * ---------------------------------------------------- *
      * Estrucutura para recibr datos post/get
     * ---------------------------------------------------- *
     D wspcal_t        ds                  qualified template
     D  base                               likeds(paramBaseA)
     D   peNum1                       5  0
     D   peNum2                       5  0
     D   peTcal                       1a
     * ---------------------------------------------------- *
      * Estrucutura para operandos
     * ---------------------------------------------------- *
     D operandos_t     DS                  qualified template
     D   peNum1                       5  0
     D   peNum2                       5  0
     D   peResu                       5  0
     D   peTcal                      10a
     D   peFecl                       8  0
     * ---------------------------------------------------- *
      * Estrucutura para fechas
     * ---------------------------------------------------- *
     D                 ds                  inz
     D    fech                 1      8  0
     D    FECA                 1      4  0
     D    FECM                 5      6  0
     D    FECD                 7      8  0

      * ------------------------------------------------------------ *
      * SVPCALC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCALC_inz     pr
      * ------------------------------------------------------------ *
      * SVPCALC_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCALC_end     pr
      * ------------------------------------------------------------ *
      * SVPCALC_suma(): Suma                                         *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPCALC_suma...
     D                 pr              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const
      * ------------------------------------------------------------ *
      * SVPCALC_sumav1(): Suma                                       *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPCALC_sumaV1...
     D                 pr              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const
     D   resultado                    5  0 options( *nopass : *omit )
      * ------------------------------------------------------------ *
      * SVPCALC_multi(): Suma                                         *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPCALC_multi...
     D                 pr              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const
     D   resultado                    5  0 options( *nopass : *omit )
      * ------------------------------------------------------------ *
      * SVPCALC_perimetroRect(): Perimetro                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPCALC_perimetroRect...
     D                 pr              n
     D   base                         5  0 const
     D   altura                       5  0 const
     D   fechacl                      8  0 const
     D   resultado                    5  0 options( *nopass : *omit )
      * ------------------------------------------------------------ *
      * SVPCALC_marcar(): Marca Registro                             *
      *    pensec  (  input  )  secuencia                            *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D SVPCALC_marcar...
     D                 pr              n
     D   pesecu                       2  0 const
