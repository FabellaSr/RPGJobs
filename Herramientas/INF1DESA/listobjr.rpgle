     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('INF1DESA/HERBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     * ------------------------------------------------------------- *
     * - ----------------------------------------------------------- *
     * - ----------------------------------------------------------- *
      *   Copys
     * - ----------------------------------------------------------- *
      /copy inf1desa/qcpybooks,SVPHER_H
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
      *Recibe estructura de objetos, cantidad de objetos y
      *numero de instalacion.
     D LISTOBJR        pr
     D   peObjs                            likeds(objetos_t) dim(100)
     D   peCobj                       2a     const
     D   peInst                            like(O1INST) const
     D LISTOBJR        pi
     D   peObjs                            likeds(objetos_t) dim(100)
     D   peCobj                       2a     const
     D   peInst                            like(O1INST) const

     * - ----------------------------------------------------------- *
      *   Que trabajo es este?
     * - ----------------------------------------------------------- *
     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  job                          10a   overlay(PsDs:244)
     D  CurUsr                       10a   overlay(PsDs:358)

     * - ----------------------------------------------------------- *
      *   Variables para manejo del pgm
     * - ----------------------------------------------------------- *
     D finPgm          s               n   inz(*off)
     D pasoNro         S              1  0 inz(1)
     D rtn             s               n   inz(*off)
     * ------------------------------------------------------------- *
      *   Cuerpo Principal
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
        if peCobj <> *blanks;
            SVPHER_grabaObjAInst(peObjs:
                                 peInst:
                                 PsDs.CurUsr:
                                 %int(peCobj));
        else;
            //hago saltar pantalla de que no hay obj en esa lib
        endif;
        /end-free

