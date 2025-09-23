      // -------------------------------------------------------- //
      // STR013: Estados de Inspecciones.                         //
      //                                                          //
      // -------------------------------------------------------- //
      //  Fabella Ivan                           *03-09-2025      //
      // -------------------------------------------------------- //
      //                                                          //
      // -------------------------------------------------------- //
        ctl-opt
          actgrp(*caller)
          bnddir('HDIILE/HDIBDIR')
          option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
          datfmt(*iso) timfmt(*iso);
        // --------------------------- Archivos --------------------------- //
        dcl-f set334   disk usage(*input) keyed;
        dcl-f set335   disk usage(*input) prefix(t5:2) keyed;
        dcl-f set915   usage(*input:*output:*update:*delete) keyed;
        dcl-f ctlsti   usage(*input:*output:*update:*delete) keyed;
        // ----------------------- Claves / KDS --------------------------- //
        dcl-ds k1yst2 likerec(c1lsti:*key);
        dcl-ds k1y915 likerec(s1t915:*key);
        // -------------------- Interfaz de programa ---------------------- //
        dcl-pr STR013 extpgm('STR013');
          peIdpr ind  ;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pr;
        dcl-pi STR013;
          peIdpr ind  ;
          peEmpr char(1);
          peSucu char(2);
          peSini packed(7:0);
          peRama packed(2:0);
        end-pi;
        // -------------------- Includes JDBC / Protos -------------------- //
        /copy *libl/qcpybooks,jdbc_h
        /copy *libl/qcpybooks,dclproto_h
        // --------------------------- Conexion --------------------------- //
        dcl-s peConn   like(Connection);
        dcl-s peStmt   like(PreparedStatement);
        dcl-s peStm1   like(PreparedStatement);
        dcl-s peStm2   like(PreparedStatement);
        dcl-s peRset   like(ResultSet);
        dcl-s peTabl   char(10);
        dcl-s auxInsRc char(10);
        dcl-s auxInspe char(10);
        dcl-s @@id     int(10);
        dcl-s @@obsv   char(256);
        dcl-s @@cantR  packed(18:0);
        dcl-s @@cantI  packed(18:0);
        // --------------------------  estados ---------------------------- //
        dcl-s pasoNro int(10) inz(1);
        dcl-s finPgm  ind     inz(*off);
        dcl-s error   ind     inz(*off);
        // ----------------------------------------------------------------
        // MAIN: Bucle por Pasos
        // ----------------------------------------------------------------
        *inlr = *on;
        clear @@id;
        clear @@cantR;
        clear @@cantI;
        peIdpr = *off;
        dow not finPgm;
          select;
            when pasoNro = 1;
              // Paso 1: Numeración y estado inicial de control
              proc01_Init();
            when pasoNro = 2;
              // Paso 2: Validar parámetros en SET334/SET335
              proc02_CargarCfg();
            when pasoNro = 3;
              // Paso 3: Conectar JDBC
              proc03_Conectar();
            when pasoNro = 4;
              // Paso 4: Preparar Stmts principales
              proc04_PrepararStmts();
            when pasoNro = 5;
              // Paso 5: Ejecutar Query principal
              proc05_EjecutarQueryPrincipal();
            when pasoNro = 6;
              // Paso 6: Procesar filas
              proc06_ProcesarFilas();
            when pasoNro = 7;
              // Paso 7: Cierre, actualización de control y retorno
              proc07_CerrarActualizar();
            other;
              finPgm = *on;
          endsl;
        enddo;
        return;
        // ============================================================================
        // PROC 01: Inicializaciones de control
        //
        //   - setNumeroDeCorrida
        //   - setIniciaCtl
        // ============================================================================
        dcl-proc proc01_Init;
          dcl-pi *n end-pi;
          error = *off;
          setNumeroDeCorrida();
          if error;
            finPgm = *on;
            return;
          endif;
          setIniciaCtl();
          if error;
            finPgm = *on;
            return;
          endif;
          pasoNro = 2;
        end-proc;
        // ============================================================================
        // PROC 02: Lee SET334 (conexión) y SET335 (SQL base, 'INSPECCION')
        // ============================================================================
        dcl-proc proc02_CargarCfg;
          dcl-pi *n end-pi;
          error = *off;
          setgt *hival set334;
          readp set334;
          if %eof;
            @@obsv = 'Falta datos de conexion - SET334';
            setErrorCtl();
            peIdpr = *off;
            error   = *on;
            finPgm  = *on;
            return;
          endif;
          peTabl = 'INSPECCION';
          chain peTabl set335;
          if not %found;
            @@obsv = 'Falta datos SQL - SET335';
            setErrorCtl();
            peIdpr = *off;
            error   = *on;
            finPgm  = *on;
            return;
          endif;
          pasoNro = 3;
        end-proc;
        // ============================================================================
        // PROC 03: Conecta por JDBC
        // ============================================================================
        dcl-proc proc03_Conectar;
          dcl-pi *n end-pi;
          error = *off;
          //Me conecto a zamba
          monitor;
            peConn = JDBC_Connect( %trim(t@driv)
                                 : %trim(t@durl)
                                 : %trim(t@bddu)
                                 : %trim(t@pass));
            if peConn = *null;
              @@obsv = 'Fall al intentar conectar con el servidor - SET334';
              setErrorCtl();
              peIdpr = *off;
              error  = *on;
              finPgm = *on;
              return;
            endif;
          on-error;
            @@obsv = 'Fall al intentar conectar con el servidor - SET334';
            setErrorCtl();
            peIdpr = *off;
            error  = *on;
            finPgm = *on;
            return;
          endmon;
          pasoNro = 4;
        end-proc;
        // ============================================================================
        // PROC 04: Prepara peStmt con %DB%, %SINIESTRO% y %RAMA%
        // ============================================================================
        dcl-proc proc04_PrepararStmts;
          dcl-pi *n end-pi;
          error = *off;
          peTabl = 'INSPECCION';
          chain peTabl set335;
          if not %found;
            @@obsv = 'Falta datos SQL - SET335';
            setErrorCtl();
            monitor;
              JDBC_freePrepStmt(peStmt);
              JDBC_close(peConn);
            on-error;
            endmon;
            peIdpr = *off;
            error  = *on;
            finPgm = *on;
            return;
          endif;
          t5stmt = %scanrpl('%DB%'
                           : %trim(t@bddn)
                           : t5stmt);
          t5stmt = %scanrpl('%SINIESTRO%'
                           : %trim(%char(peSini))
                           : t5stmt);
          t5stmt = %scanrpl('%RAMA%'
                           : %trim(%char(peRama))
                           : t5stmt);
          peStmt = JDBC_PrepStmt( peConn
                                : %trim(t5stmt));
          if peStmt = *null;
            @@obsv = 'Falla  peStmt = *null';
            setErrorCtl();
            monitor;
              JDBC_freePrepStmt(peStmt);
              JDBC_close(peConn);
            on-error;
            endmon;
            peIdpr = *off;
            error  = *on;
            finPgm = *on;
            return;
          endif;
          peTabl = 'INSPECCION';
          chain peTabl set335;
          if not %found;
            @@obsv = 'Falta datos SQL - SET335';
            setErrorCtl();
            monitor;
              JDBC_freePrepStmt(peStmt);
              JDBC_close(peConn);
            on-error;
            endmon;
            peIdpr = *off;
            error  = *on;
            finPgm = *on;
            return;
          endif;
          pasoNro = 5;
        end-proc;
        // ============================================================================
        // PROC 05: Ejecuta query principal -> peRset
        // ============================================================================
        dcl-proc proc05_EjecutarQueryPrincipal;
          dcl-pi *n end-pi;
          error = *off;
          peRset = JDBC_execPrepQry(peStmt);
          if peRset = *null;
            @@obsv = 'No se encontró información para procesar';
            setErrorCtl();
            monitor;
              JDBC_freePrepStmt(peStmt);
              JDBC_close(peConn);
            on-error;
            endmon;
            peIdpr = *off;
            error  = *on;
            finPgm = *on;
            return;
          endif;
          pasoNro = 6;
        end-proc;
        // ============================================================================
        // PROC 06: Itera filas del peRset y procesa
        // ============================================================================
        dcl-proc proc06_ProcesarFilas;
          dcl-pi *n end-pi;
          error = *off;
          @@obsv = 'No se encontró información para procesar';
          peIdpr = *off;
          dow JDBC_nextRow(peRset);
            clear @@obsv;
            //Si tiene inspeccion en un estado distinto al
            //'Autorizada' no va.
            auxInspe = %trim(JDBC_getCol(peRset:3));
            select;
              when  auxInspe <> *blanks;
                  if auxInspe = '1'  or //Autorizada
                     auxInspe = '2'  or //Convenida Sin Autorizar
                     auxInspe = '12' or //Trabajo Finalizado
                     auxInspe = '17';   //No Supera Franquicia
                    peIdpr = *on;
                  endif;
              other;
                    peIdpr = *off;
                    leave;
            endsl;
            @@obsv = 'Siniestro: '
                   + %char(peSini)
                   + ' Estado Inspeccion -> '
                   + %trim(auxInspe);
            @@cantR += 1;
          enddo;
          if @@cantR = 0;
            peIdpr = *off;
          endif;
          pasoNro = 7;
        end-proc;
        // ============================================================================
        // PROC 07: Libera recursos JDBC, actualiza control y retorna
        // ============================================================================
        dcl-proc proc07_CerrarActualizar;
          dcl-pi *n end-pi;
          error = *off;
          monitor;
            JDBC_freePrepStmt(peStmt);
            JDBC_close(peConn);
          on-error;
          endmon;
          updCantidadCtl();
          procesoFinalizado();
          finPgm = *on;
        end-proc;
        // ============================================================================
        // --------------------------- PROCS CONTROLES --------------------------------
        // ============================================================================
        dcl-proc setNumeroDeCorrida;
          dcl-pi *n end-pi;
          k1y915.t@empr = peEmpr;
          k1y915.t@sucu = peSucu;
          k1y915.t@tnum = 'PI';
          chain %kds(k1y915:3) set915;
          if %found(set915);
            if t@nres = 9999999;
              t@nres = 0;
            endif;
            t@nres += 1;
            t@user  = @PsDs.CurUsr;
            t@mp01  = '1';
            t@dnum  = 'Proceso de Inspecciones Zamba';
            t@date  = %dec(%date);
            t@time  = %dec(%time);
            update s1t915;
          else;
            t@empr  = peEmpr;
            t@sucu  = peSucu;
            t@dnum  = 'Proceso de Inspecciones Zamba';
            t@tnum  = 'PI';
            t@mp01  = '1';
            t@nres  = 1;
            t@user  = @PsDs.CurUsr;
            t@date  = %dec(%date);
            t@time  = %dec(%time);
            write  s1t915;
          endif;
          // Guardar nro de Corrida.-
          @@id = t@nres;
        end-proc;

        dcl-proc setIniciaCtl;
          dcl-pi *n end-pi;
          k1yst2.c1empr = peEmpr;
          k1yst2.c1sucu = peSucu;
          k1yst2.c1sini = peSini;
          chain %kds(k1yst2:3) ctlsti;
          clear c1lsti;
          c1empr = peEmpr;
          c1sucu = peSucu;
          c1idpr = @@id;
          c1esta = '0';
          c1sini = peSini;
          c1RAMA = peRama;
          c1user = 'PROC_INSPE';
          c1date = %dec(%date():*iso);
          c1time = %dec(%time():*iso);
          if %found();
            update c1lsti;
          else;
            write c1lsti;
          endif;
        end-proc;

        dcl-proc setErrorCtl;
          dcl-pi *n end-pi;
          k1yst2.c1empr = peEmpr;
          k1yst2.c1sucu = peSucu;
          k1yst2.c1sini = peSini;
          chain %kds(k1yst2:3) ctlsti;
          if %found();
            c1obsv = @@obsv;
            c1esta = 'E';
            monitor;
              update c1lsti;
            on-error;
            endmon;
          endif;
        end-proc;

        dcl-proc procesoFinalizado;
          k1y915.t@empr = peEmpr;
          k1y915.t@sucu = peSucu;
          k1y915.t@tnum = 'PI';
          chain %kds(k1y915:3) set915;
          if %found(set915);
            t@mp01 = '0';
            update s1t915;
          endif;
        end-proc;

        dcl-proc updCantidadCtl;
          dcl-pi *n end-pi;
          k1yst2.c1empr = peEmpr;
          k1yst2.c1sucu = peSucu;
          k1yst2.c1sini = peSini;
          chain %kds(k1yst2:3) ctlsti;
          if %found();
            c1canp = @@cantR;
            c1cani = @@cantI;
            c1obsv = @@obsv;
            c1esta = peIdpr;
            c1camp = peIdpr;
            monitor;
              update c1lsti;
            on-error;
            endmon;
          endif;
        end-proc;
