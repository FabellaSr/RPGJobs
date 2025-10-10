     H option(*nodebugio: *srcstmt: *noshowcpy)
     H actgrp(*caller) dftactgrp(*no)
     H alwnull(*usrctl)
     H COPYRIGHT('HDI Seguros')
     H bnddir('CALCULADOR/BNDIRCALC')
     * - ----------------------------------------------------------- *
     *  Sistema  .:  as400                                           *
     *  Objetivo .: Calculadora                                      *
     * ------------------------------------------------------------- *
     *  Autor    .: Fabella Ivan M.                 Fecha : 00-00-00 *
     * - ----------------------------------------------------------- *
      /copy calculador/qcpybooks,SVPCALC_H
     * - ----------------------------------------------------------- *
      *   Se llama...
     * - ----------------------------------------------------------- *
     D CALCULADO       pr
     D                                5  0
     D                                5  0
     D                                1a
     D                                8  0
     D                                5  0
     D                                1a
     D CALCULADO       pi
     D num1                           5  0
     D num2                           5  0
     D calc                           1a
     D fecl                           8  0
     D resu                           5  0
     D fin                            1a
     * - ----------------------------------------------------------- *
      *   Cuerpo Principal.
     * - ----------------------------------------------------------- *
        /free
        *inlr = *on;
        fin = *off;
        select;
            //suma
            when calc = 'S';
                suma();
            //resta
            when calc = 'R';
                resta();
            //Multiplicacion
            when calc = 'M';
                //mult();
            //Division
            when calc = 'D';
                //div();
            //Perimetro
            when calc = 'P';
                perimetro();
            OTHER ;
        endsl;
        srclos();
        /end-free
     * - ----------------------------------------------------------- *
      *   suma
     * - ----------------------------------------------------------- *
        dcl-proc suma;
           fin = SVPCALC_sumav1(num1:num2:fecl:resu);
        end-proc;
     * - ----------------------------------------------------------- *
      *   resta
     * - ----------------------------------------------------------- *
        dcl-proc resta;
            resu = num1-num2;
        end-proc;
     * - ----------------------------------------------------------- *
      *   multiplicacion
     * - ----------------------------------------------------------- *
        dcl-proc mult;
            resu = num1*num2;
        end-proc;
     * - ----------------------------------------------------------- *
      *   division
     * - ----------------------------------------------------------- *
        dcl-proc div;
            resu = num1/num2;
        end-proc;
     * - ----------------------------------------------------------- *
      *   perimetro
     * - ----------------------------------------------------------- *
        dcl-proc perimetro;
            fin = SVPCALC_perimetroRect(num1:num2:fecl:resu);
        end-proc;
     * - ----------------------------------------------------------- *
      *   Cierro.
     * - ----------------------------------------------------------- *
        dcl-proc srclos;
         SVPCALC_end();
        end-proc;
