     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * svpcfg: instalador                                         *
      * ------------------------------------------------------------ *
      * Fabella Ivan                                                 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *
      *--- Copy H -------------------------------------------------- *
      /copy HDIILE/qcpybooks,ceetrec_h
      /copy HDIILE/qcpybooks,getsysv_h
      /copy instalador/qcpybooks,svpcfg_H
      * ------------------------------------------------------------ *
      * svpcfg_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
        dcl-proc svpcfg_inz export;
            dcl-pi svpcfg_inz end-pi;
            initialized = *ON;
            return;
        end-proc;
      * ------------------------------------------------------------ *
      * svpcfg_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
        dcl-proc svpcfg_End export;
          dcl-pi svpcfg_end end-pi;
          //close *all;
          initialized = *OFF;
          return;
        end-proc;

      * ------------------------------------------------------------ *
      * svpcfg_ambiente():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpcfg_ambiente export;
          dcl-pi svpcfg_ambiente ind;
            pxAmbi char(10);
          end-pi;
            pxAmbi = rtvSysName();
            if ( pxAmbi = *blanks );
                  pxAmbi = 'ERROR';
                  return *off;
                  CEETREC( *omit: 1 );
            endif;
            return *on;
        end-proc;

      /define PSYS_LOAD_PROCEDURE
      /copy hdiile/qcpybooks,psys_h
      /define GETSYSV_LOAD_PROCEDURE
      /copy hdiile/qcpybooks,getsysv_h
