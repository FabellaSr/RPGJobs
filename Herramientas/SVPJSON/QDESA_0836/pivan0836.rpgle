     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
      * ************************************************************ *
      * PIVAN0836 :  *
      * ------------------------------------------------------------ *
      * Fabella Ivan M. *07-04-2025                                  *
      * ************************************************************ *
     Fgntpec    uf a e           k disk    usropn
     Fpawpec    uf a e           k disk    usropn
     Fgntpca    uf a e           k disk    usropn
      /copy *libl/qcpybooks,pmsg_h
      /copy *libl/qcpybooks,psys_h
      /copy *libl/qcpybooks,ceetrec_h
      /copy *libl/qcpybooks,spwliblc_h
      /copy *libl/qcpybooks,curlib_h
      /copy *libl/qcpybooks,getsysv_h
     D @PsDs          sds                  qualified
     D  this                         10a   overlay(@PsDs:1)
     D  CurUsr                       10a   overlay(@PsDs:358)
     D curlib          s             10a
     D AS400Sys        s             10a
     D this            s             10a
     D k1ticc          ds                  likerec(G@Tpec:*key)
     D k1wicc          ds                  likerec(P@Wpec:*key)
     D k1wpca          ds                  likerec(A@TPCA:*key)
     * - ----------------------------------------------------------- *
     * Estrucutura para fecha de Fin de vigencia
     * - ----------------------------------------------------------- *
     D                 ds                  inz
     D    campo                1   2000
     D    camp1                1     50
     D    camp2               51    100
     D    camp3              101    150
     D    camp4              151    200
     D    camp5              201    250
     D    camp6              251    300
     D    camp7              301    350
     D    camp8              351    400
     D    camp9              401    450
     D    camp10             451    500
     D    camp11             501    550
     D    camp12             551    600
     D    camp13             601    650
     D    camp14             651    700
     D    camp15             701    750
     D    camp16             751    800
     D    camp17             801    850
      /free
         *inlr = *on;
         this = @PsDs.this;
         // ---------------------------
         // En qué máquina estoy
         // ---------------------------
         AS400Sys = rtvSysName();
         if ( AS400Sys = *blanks );
         PATCH_comp( %trim(this) + ' Error: no se pudo determinar '
                     + 'nombre de Sistema' );
         CEETREC( *omit: 1 );
         endif;
         // ---------------------------
         // Salvo CURLIB
         // ---------------------------
         curlib = getCurLib();
         // ---------------------------
         // Elimino CURLIB
         // ---------------------------
         rmvCurLib();

         // ---------------------------
         // Armo LIBL
         // ---------------------------
         spwliblc('P');
         open pawpec;
         open gntpec;
         open gntpca;
         k1wpca.A@NOAJ = 'JSONCONTADURIA';
         k1wicc.P@NOMJ = 'JSONCONTADURIA';
         k1ticc.G@NOMJ = 'JSONCONTADURIA';
         A@NOAJ = 'JSONCONTADURIA';
         P@NOMJ = 'JSONCONTADURIA';
         G@NOMJ = 'JSONCONTADURIA';
         exsr graboNombreColumnasSimples;
         exsr graboContenidoColumnas;
         //estDeCapMin
         campo = *blanks;
         k1wicc.P@ORDE = 4;
         k1wicc.P@NOMB = 'estDeCapMin';
         chain %kds(k1wicc) pawpec;
            camp1 = 'PN123456';
            camp2 = 'PN123456';
            p@nomb = 'estDeCapMin';
            p@ORDE = 4;
            p@camp = %trim(campo);
            p@TIPO = '0';
            P@ULTI = '1';
         if not %found;
            write p@wpec;
         else;
            update p@wpec;
         endif;
         P@ULTI = '0';

         //Datos en los campos
         campo = *blanks;
         k1wicc.P@ORDE = 1;
         k1wicc.P@NOMB = 'estadoEvolPatNeto';
         chain %kds(k1wicc) pawpec;
            camp1 = 'Codigo Prueba';
            camp2 = '7000.50';
            camp3 = '';
            camp4 = '';
            camp5 = '';
            camp6 = '';
            camp7 = '';
            camp8 = '';
            camp9 = '';
            p@nomb = 'estadoEvolPatNeto';
            p@ORDE = 1;
            p@camp = %trim(campo);
            p@TIPO = '0';
         if not %found;
            write p@wpec;
         else;
            update p@wpec;
         endif;



         k1wpca.a@EMPR = 'A';
         k1wpca.a@SUCU = 'CA';
         k1wpca.a@NOAR = 'estadoCober';
         chain %kds(k1wpca:4) gntpca;
         if not %found;
            A@EMPR = 'A';
            A@SUCU = 'CA';
            //A partir de aca todo el array
            //a@NOAR = 'estadoCober';
            a@NOAR = 'estadoCober';
            //nomo = primer objeto invExc
            A@NOMO = 'invExc';
            A@NOMP = 'codSSN';
            A@NROP = 1;
            A@TIPD = 'S';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 1;
            write A@TPCA;
            A@NOMP = 'valorContable';
            A@NROP = 2;
            A@TIPD = 'N';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 1;
            write A@TPCA;
            A@NOMP = 'tipoExceso';
            A@NROP = 3;
            A@TIPD = 'S';
            A@ULTP = '1';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 1;
            write A@TPCA;
            //Segundo obj PFExc
            A@NOMO = 'PFExc';
            A@NOMP = 'codBanco';
            A@NROP = 4;
            A@TIPD = 'S';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 2;
            write A@TPCA;
            A@NOMP = 'valorContable';
            A@NROP = 5;
            A@TIPD = 'N';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 2;
            write A@TPCA;
            A@NOMP = 'tipoExceso';
            A@NROP = 6;
            A@TIPD = 'S';
            A@ULTP = '1';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 2;
            write A@TPCA;
            //Primera propiedad dentro
            //del array
            A@NOMP = 'premCobrEvNoComp';
            A@NOMO = 'premCobrEvNoComp';
            A@NROP = 7;
            A@TIPD = 'N';
            A@MAR3 = '1';
            A@ULTP = '0';
            A@ULOB = '0';
            A@NROB = 3;
            write A@TPCA;
            //SERGUNDA propiedad dentro
            //del array
            A@NOMP = 'premCobrVidaNoComp';
            A@NOMO = 'premCobrVidaNoComp';
            A@NROP = 8;
            A@TIPD = 'N';
            A@MAR3 = '1';
            A@ULTP = '0';
            A@ULOB = '0';
            A@NROB = 4;
            write A@TPCA;
            //tercera propiedad dentro
            //del array
            A@NOMP = 'excInm';
            A@NOMO = 'excInm';
            A@NROP = 9;
            A@TIPD = 'N';
            A@MAR3 = '1';
            A@ULTP = '0';
            A@ULOB = '0';
            A@NROB = 5;
            write A@TPCA;
            //cuarta propiedad dentro
            //del array
            A@NOMP = 'excPresHip';
            A@NOMO = 'excPresHip';
            A@NROP = 10;
            A@TIPD = 'N';
            A@MAR3 = '1';
            A@ULTP = '0';
            A@ULOB = '0';
            A@NROB = 6;
            write A@TPCA;
            //quinta propiedad dentro
            //del array
            A@NOMP = 'excPresPren';
            A@NOMO = 'excPresPren';
            A@NROP = 11;
            A@TIPD = 'N';
            A@MAR3 = '1';
            A@ULTP = '0';
            A@ULOB = '0';
            A@NROB = 7;
            write A@TPCA;
            //Octavo objeto
            A@NOMO = 'otrosMenosLoc';
            A@NOMP = 'concepto';
            A@NROP = 12;
            A@TIPD = 'S';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 8;
            write A@TPCA;
            A@NOMP = 'valorContable';
            A@NROP = 13;
            A@TIPD = 'N';
            A@ULTP = '1';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 8;
            write A@TPCA;
            //Noveno objeto
            A@NOMO = 'otrosMasLoc';
            A@NOMP = 'concepto';
            A@NROP = 14;
            A@TIPD = 'S';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 9;
            write A@TPCA;
            A@NOMP = 'valorContable';
            A@NROP = 15;
            A@TIPD = 'N';
            A@ULTP = '1';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 9;
            write A@TPCA;
            //Ultimo objeto
            A@NOMO = 'otrosMenosDeudasYCt';
            A@NOMP = 'concepto';
            A@NROP = 16;
            A@TIPD = 'S';
            A@ULTP = '0';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '0';
            A@NROB = 10;
            write A@TPCA;
            A@NOMP = 'valorContable';
            A@NROP = 17;
            A@TIPD = 'N';
            A@ULTP = '1';
            A@ULTA = '0';
            A@MAR3 = '0';
            A@ULOB = '1';
            A@NROB = 10;
            write A@TPCA;
         endif;


         begsr graboConfiguracionDeLasColumnas;
         //Aca grabo configuracion de las columnas.
         //Cual es el ultimo, el tipo de dato, si es una propiedad
         //o un objeto array...
         //En la

         endsr;
         begsr graboContenidoColumnas;
         //Aca grabo datos para probar.
         //se supone que estos datos vienen en el excel.
            campo = *blanks;
            k1wicc.P@ORDE = 3;
            k1wicc.P@NOMB = 'estadoCober';
            chain %kds(k1wicc) pawpec;
               camp1  = 'Codigo ssn';
               camp2  = '7000.50';
               camp3  = 'Tipo exceso';
               camp4  = 'codigo banco';
               camp5  = '1000.25';
               camp6  = 'tipo Exceso2';
               camp7  = '10';
               camp8  = '20';
               camp9  = '30';
               camp10 = '40';
               camp11 = '50';
               camp12 = 'Concepto';
               camp13 = '100';
               camp14 = 'concepto2';
               camp15 = '200';
               camp16 = 'concepto3';
               camp17 = '300';
               p@nomb = 'estadoCober';
               p@camp = %trim(campo);
               p@TIPO = '1';
               p@ORDE = 3;
            if not %found;
               write p@wpec;
            else;
               update p@wpec;
            endif;
            //disponibilidades
            campo = *blanks;
            k1wicc.P@ORDE = 2;
            k1wicc.P@NOMB = 'disponibilidades';
            chain %kds(k1wicc) pawpec;
               camp1 = 'Codigo Banco';
               camp2 = 'Tipo Cuenta';
               camp3 = '10101';
               camp4 = 'DOLAR';
               camp5 = 'codigo afectacion';
               camp6 = '10000.70';
               camp7 = '9000.70';
               camp8 = '10000.70';
               camp9 = 'Financiera';
               p@nomb = 'disponibilidades';
               p@camp = %trim(campo);
               p@TIPO = '0';
               p@ORDE = 2;
            if not %found;
               write p@wpec;
            else;
               update p@wpec;
            endif;
         endsr;
         //grabo el nombre que tendran las columnas
         begsr graboNombreColumnasSimples;
            //Aca grabo los datos de los objetos que tienen
            //objetos simples. Por ejemplo:
            //"estDeCapMin": [{"PN123456": "PN123456","PN123456": "PN123456"}]}}
            //Como se ve, estDeCapMin es un
            k1ticc.G@EMPR = 'A';
            k1ticc.G@SUCU = 'CA';
            k1ticc.G@NOMO = 'estDeCapMin';
            chain %kds(k1ticc:4) gntpec;
            if not %found;
               G@EMPR = 'A';
               G@SUCU = 'CA';
               G@NOMO = 'estDeCapMin';
               //PROPIEDADES
               G@NOMP = 'PN123456';
               G@NROP = 1;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'PN123456';
               G@NROP = 2;
               G@TIPD = 'S';
               G@MAR1 = '1';
               write g@tpec;
            ENDIF;
            //Configuracion
            k1ticc.G@EMPR = 'A';
            k1ticc.G@SUCU = 'CA';
            k1ticc.G@NOMO = 'estadoEvolPatNeto';
            chain %kds(k1ticc:4) gntpec;
            if not %found;
               G@EMPR = 'A';
               G@SUCU = 'CA';
               G@NOMO = 'estadoEvolPatNeto';
               //PROPIEDADES
               G@NOMP = 'codigo';
               G@NROP = 1;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'capAccCirculacion';
               G@NROP = 2;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'capAccEmitir';
               G@NROP = 3;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'aportesNoCap';
               G@NROP = 4;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'ajustesNoCap';
               G@NROP = 5;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'reservaLegal';
               G@NROP = 6;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'otrasReservas';
               G@NROP = 7;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'resAcum';
               G@NROP = 8;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'resRevaluoInm';
               G@NROP = 9;
               G@TIPD = 'N';
               G@MAR1 = '1';
               write g@tpec;
            endif;
            k1ticc.G@EMPR = 'A';
            k1ticc.G@SUCU = 'CA';
            k1ticc.G@NOMO = 'disponibilidades';
            chain %kds(k1ticc:4) gntpec;
            if not %found;
               G@EMPR = 'A';
               G@SUCU = 'CA';
               G@NOMO = 'disponibilidades';
               //PROPIEDADES
               G@NOMP = 'codigoBanco';
               G@NROP = 1;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'tipoCuenta';
               G@NROP = 2;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'numeroDeCuenta';
               G@NROP = 3;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'moneda';
               G@NROP = 4;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'codigoAfectacion';
               G@NROP = 5;
               G@TIPD = 'S';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'saldoMonedaOrig';
               G@NROP = 6;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'saldoEnPesos';
               G@NROP = 7;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'saldoExtracto';
               G@NROP = 8;
               G@TIPD = 'N';
               G@MAR1 = '0';
               write g@tpec;
               G@NOMP = 'financiera';
               G@NROP = 9;
               G@TIPD = 'S';
               G@MAR1 = '1';
               write g@tpec;
            endif;
         endsr;
      /end-free

      /define PMSG_LOAD_PROCEDURE
      /copy *libl/qcpybooks,pmsg_h

      /define PSYS_LOAD_PROCEDURE
      /copy *libl/qcpybooks,psys_h

      /define LOAD_CURLIB_PROCEDURE
      /copy *libl/qcpybooks,curlib_h

      /define GETSYSV_LOAD_PROCEDURE
      /copy *libl/qcpybooks,getsysv_h

