     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPCALC: Calculadora                                         *
      * ------------------------------------------------------------ *
      * Fabella Ivan                                                 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *
      *--- Copy H -------------------------------------------------- *
      /copy calculador/qcpybooks,SVPCALC_H
     * - ----------------------------------------------------------- *
      *   Archivos
     * - ----------------------------------------------------------- *
     Fsetdat    uf a e           k disk

     D Initialized     s              1N
     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
      * ------------------------------------------------------------ *
      * SVPCALC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCALC_inz     B                   export
     D SVPCALC_inz     pi

      /free
       if not %open(setdat);
         open setdat;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPCALC_inz     E

      * ------------------------------------------------------------ *
      * SVPCALC_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPCALC_End     B                   export
     D SVPCALC_End     pi
      /free
       close *all;
       initialized = *OFF;
       return;
      /end-free

     P SVPCALC_End     E
      * ------------------------------------------------------------ *
      * SVPCALC_multi(): Multiplica                                  *
      *    peNum1  (  input  )  Empresa                              *
      *    peNum2  (  input  )  Empresa                              *
      *    fechacl (  input  )  Empresa                              *
      *    result  (  output  )  Empresa                             *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P SVPCALC_multi...
     P                 B                   export
     D SVPCALC_multi...
     D                 pi              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const
     D   result                       5  0 options( *nopass : *omit )


     D   peOper        ds                   likeds(operandos_t)
      /free
        SVPCALC_inz();
        peOper.peNum1 = penum1;
        peOper.peNum2 = penum2;
        result = peNum1 * peNum2;
        peOper.peResu = result;
        peOper.peTcal = 'Multiplicacion';
        peOper.peFecl = fechacl;
        return SVPCALC_grabaResultados(peOper);
      /end-free
     P SVPCALC_multi...
     P                 E

      * ------------------------------------------------------------ *
      * SVPCALC_suma(): Suma   Deprecado                             *
      *    peNum1  (  input  )  Empresa                              *
      *    peNum2  (  input  )  Empresa                              *
      *    fechacl (  input  )  Empresa                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P SVPCALC_suma...
     P                 B                   export
     D SVPCALC_suma...
     D                 pi              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const


      /free
        SVPCALC_inz();
       // peOper.peNum1 = penum1;
       // peOper.peNum2 = penum2;
       // peOper.peResu = peNum1 + peNum2;
       // peOper.peTcal = 'Suma';
       // peOper.peFecl = fechacl;
        return SVPCALC_sumaV1(peNum1:penum2:fechacl:*omit);
       //return *on;
      /end-free
     P SVPCALC_suma...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCALC_sumaV1(): Suma deprecada                             *
      *    peNum1  (  input  )  Empresa                              *
      *    peNum2  (  input  )  Empresa                              *
      *    fechacl (  input  )  Empresa                              *
      *    result  (  output  )  Empresa                             *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P SVPCALC_sumaV1...
     P                 B                   export
     D SVPCALC_sumaV1...
     D                 pi              n
     D   peNum1                       5  0 const
     D   peNum2                       5  0 const
     D   fechacl                      8  0 const
     D   resultado                    5  0 options( *nopass : *omit )

     D   peOper        ds                   likeds(operandos_t)
      /free
        SVPCALC_inz();
        peOper.peNum1 = penum1;
        peOper.peNum2 = penum2;
        resultado = peNum1 + peNum2;
        peOper.peResu = resultado;
        peOper.peTcal = 'Suma';
        peOper.peFecl = fechacl;
        return SVPCALC_grabaResultados(peOper);
      /end-free
     P SVPCALC_sumaV1...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCALC_perimetroRect(): Calcula el perímetro de 1 rectángulo*
      *    peNum1  (  input  )  Empresa                              *
      *    peNum2  (  input  )  Empresa                              *
      *    fechacl (  input  )  Empresa                              *
      *    result  (  output  )  Empresa                             *
      * Retorna: on si se grabó correctamente, off si falló          *
      * ------------------------------------------------------------ *
     P SVPCALC_perimetroRect...
     P                 B                   export
     D SVPCALC_perimetroRect...
     D                 pi              n
     D   base                         5  0 const
     D   altura                       5  0 const
     D   fechacl                      8  0 const
     D   resultado                    5  0 options( *nopass : *omit )

     D   peOper        ds                  likeds(operandos_t)
     D   baseCalculo   S              5  0
      /free
        SVPCALC_inz();
        baseCalculo = 2;
        peOper.peNum1 = base;
        peOper.peNum2 = altura;
        SVPCALC_sumav1(base:altura:fechacl:resultado);
        SVPCALC_multi(baseCalculo:resultado:fechacl:resultado);
        peOper.peResu = resultado;
        peOper.peTcal = 'Perimetro';
        peOper.peFecl = fechacl;
        return SVPCALC_grabaResultados(peOper);
      /end-free
     P SVPCALC_perimetroRect...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCALC_grabaResultados(): Graba los resultados en tabla     *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPCALC_grabaResultados...
     P                 B                   export
     D SVPCALC_grabaResultados...
     D                 pi              n
     D   peOper                            likeds(operandos_t)

     D k1tdat          ds                  likerec( S1TDAT : *Key )
     D @@Dsdat         ds                  likerec( S1TDAT : *input  )
     D retorno         S               n
      /free
        retorno = *off;
        clear @@Dsdat;
        k1tdat.s1empr = 'A';
        k1tdat.s1sucu = 'CA';
        setgt %kds(k1tdat:2) setdat;
        readpe(n) %kds(k1tdat:2) setdat @@Dsdat;
        if @@Dsdat.s1secu <> *zeros;
          k1tdat.s1secu = @@Dsdat.s1secu + 1;
        else;
          k1tdat.s1secu = 1;
        endif;

        chain %kds ( k1tdat ) setdat;
        if not %found;
          s1empr = 'A';
          s1sucu = 'CA';
          s1num1 = peOper.peNum1;
          s1num2 = peOper.peNum2;
          s1resu = peOper.peResu;
          s1tcal = peOper.petcal;
          s1marp = '0';
          s1secu = k1tdat.s1secu;
          //FECHA MAQUINA
          S1ECHA = %dec(%date():*iso);
          fech   = %dec(%date():*iso);
          s1anio = feca;
          s1fmes = fecm;
          S1fdia = fecd;
          //FECHA RECIBIDA
          S1ECH1 = peOper.peFecl;
          //AUDITORIAS
          s1ausu = @PsDs.CurUsr;
          s1date = udate;
          s1time = %dec(%time);
          write s1tdat;
          retorno = *on;
        endif;
        return retorno;
      /end-free
     P SVPCALC_grabaResultados...
     P                 E
      * ------------------------------------------------------------ *
      * SVPCALC_marcar(): Marca Registro                             *
      *    pensec  (  input  )  secuencia                            *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P SVPCALC_marcar...
     P                 B                   export
     D SVPCALC_marcar...
     D                 pi              n
     D   pesecu                       2  0 const

     D k1tdat          ds                  likerec( S1TDAT : *Key )
     D retorno         S               n
      /free
        SVPCALC_inz();
        retorno = *off;
        k1tdat.s1empr = 'A';
        k1tdat.s1sucu = 'CA';
        k1tdat.s1secu = pesecu;
        chain %kds ( k1tdat ) setdat;
        if %found;
          S1MARP ='1';
          update s1tdat;
          retorno = *on;
        endif;
        return retorno;
      /end-free

     P SVPCALC_marcar...
     P                 E
