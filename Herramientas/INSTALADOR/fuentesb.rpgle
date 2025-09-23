     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H COPYRIGHT('HDI Seguros')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *
     * ------------------------------------------------------------- *
     Fsetsrc_   if   e           k disk
     Fsetsrc    uf a e           k disk    prefix(sa:2)
     F                                     rename( S1TSRC : SaTSRC )

      /free

        setll *start setsrc_ ;
        read setsrc_ ;
        dow not %eof;
               saempr = s1empr;
               sasucu = s1sucu;
               samarf = s1marf;
               saffil = s1ffil;
               saflib = s1flib;
               satlib = s1libt;
               satfil = s1filt;
               sanfue = s1tfue;
               saobjl = s1objl;
               satipo = s1tipo;
               saecha = s1echa;
               sasecu = s1secu;

               saanio = s1anio;
               safmes = s1fmes;
               safdia = s1fdia;
               sadesa = s1desa;
               saech1 = s1ech1;
               saausu = s1ausu;
               sadate = s1date;
               satime = s1time;
               saMARO = S1MARO;
               write satsrc;
          read setsrc_ ;
        enddo;
        return;
      /end-free

