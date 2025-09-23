     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     H bnddir('INF1DESA/HERBDIR')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     * ------------------------------------------------------------- *
     * - ----------------------------------------------------------- *
     * - ----------------------------------------------------------- *
     DLISTOBJS         PR                  extpgm('LISTOBJS')
     Dpefecd                          8    const
     Dpefech                          8    const
        /free
        *inlr = *on;

            LISTOBJS('DESA1509':'DESA1509');

        /end-free

