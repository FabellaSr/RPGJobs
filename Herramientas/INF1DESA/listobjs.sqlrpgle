     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * ------------------------------------------------------------ *
      * ------------------------------------------------------------ *
      *                                                              *
     * - ----------------------------------------------------------- *
      *   Copys
     * - ----------------------------------------------------------- *
      /copy inf1desa/qcpybooks,SVPHER_H
     * - ----------------------------------------------------------- *
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
     D LISTOBJS        pr
     D   peLibj                       8a     const
     D   peInst                       8a     const
     D LISTOBJS        pi
     D   peLibj                       8a     const
     D   peInst                       8a     const
      * ------------------------------------------------------------ *
       DCL-C SQL_NUM CONST(3); // Número de columnas
       EXEC SQL INCLUDE SQLDA;

      * ------------------------------------------------------------ *
     D OBJETOS         DS                  likeds(objetos_t) dim(100)

     D LISTOBJR        pr                  extpgm('LISTOBJR')
     D   psObjs                            likeds(objetos_t) const dim(100)
     D   psCobj                       2a     const
     D   psInst                       8a     const

     D IND_ARRAY       S            100a
     D rows            S             10a
     D ROWS_FETCHED    S             10i 0
      /free

       *inlr = *ON;
          // setup number of sqlda entries and length of the sqlda
          sqld = 3;
          sqln = 3;
          sqldabc = 336;
          // setup the first entry in the sqlda
          sqltype = 453;
          sqllen = 10;
          sql_var(1) = sqlvar;
          // setup the second entry in the sqlda
          sqltype = 453;
          sqllen = 10;
          sql_var(2) = sqlvar;
          // setup the 3 entry in the sqlda
          sqltype = 453;
          sqllen = 10;
          sql_var(3) = sqlvar;
       exec sql
            set option
            commit=*none,
            datfmt=*iso;
       exec sql
            declare c1 scroll cursor for
            SELECT OBJNAME,OBJTYPE,OBJLIB from
            TABLE(QSYS2.OBJECT_STATISTICS(:peLibj , '*ALL'));
       exec sql
            open c1;

       exec sql fetch C1 FOR 100 rows
       USING DESCRIPTOR :SQLDA
       INTO :OBJETOS :IND_ARRAY;
       IF SQLERRD(3) <> 0;
          ROWS_FETCHED = SQLERRD(3);
          rows = %char(ROWS_FETCHED);
          CALLP LISTOBJR(OBJETOS:rows:peInst);
       ENDIF;

       exec sql close c1;
       ROWS_FETCHED = SQLERRD(3);
       rows = %char(ROWS_FETCHED);
       CALLP LISTOBJR(OBJETOS:rows:peInst);
       return;

      /end-free
