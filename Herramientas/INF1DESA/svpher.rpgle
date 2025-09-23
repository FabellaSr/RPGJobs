     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPHER: Programa de Servicio.                                *
      *         Accesorios Transportes                               *
      * ------------------------------------------------------------ *
      * Fabella Ivan                                                 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *
      *--- Copy H -------------------------------------------------- *
      /copy inf1desa/qcpybooks,SVPHER_H
      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N


      * ------------------------------------------------------------ *
      * SVPAEM_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAEM_inz      B                   export
     D SVPAEM_inz      pi

      /free

       if not %open(setobj);
         open setobj;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPAEM_inz      E

      * ------------------------------------------------------------ *
      * SVPAEM_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPAEM_End      B                   export
     D SVPAEM_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPAEM_End      E

      * ------------------------------------------------------------ *
      * SVPAEM_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPAEM_Error    B                   export
     D SVPAEM_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPAEM_Error    E

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
      * ------------------------------------------------------------ *
      * SVPHER_insertEnSetObj(): Setea los objetos a instalar        *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P SVPHER_grabaObjAInst...
     P                 B                   export
     D SVPHER_grabaObjAInst...
     D                 pi              n
     D   peLobj                            likeds(objetos_t) DIM(100)
     D   peInst                            like(O1INST) const
     D   peUser                      10a   const
     D   peCobj                      10i 0 const
      /free
        SVPAEM_inz();
        return *on;
      /end-free
     P SVPHER_grabaObjAInst...
     P                 E
