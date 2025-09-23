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
     * - ----------------------------------------------------------- *
      *   Archivos
     * - ----------------------------------------------------------- *

     D Initialized     s              1N
     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
      * ------------------------------------------------------------ *
      * svpcfg_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P svpcfg_inz      B                   export
     D svpcfg_inz      pi
      * ------------------------------------------------------------ *
      * SVPCALC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
      /free
       //if not %open(setdat);
         //open setdat;
       //endif;

       initialized = *ON;
       return;

      /end-free

     P svpcfg_inz      E

      * ------------------------------------------------------------ *
      * svpcfg_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P svpcfg_End      B                   export
     D svpcfg_End      pi
      /free
       //close *all;
       initialized = *OFF;
       return;
      /end-free

     P svpcfg_End      E

      * ------------------------------------------------------------ *
      * svpcfg_ambiente():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpcfg_ambiente...
     P                 B                   export
     D svpcfg_ambiente...
     D                 pi              n
     D   pxAmbi                      10
      /free
        pxAmbi = rtvSysName();
        if ( pxAmbi = *blanks );
              pxAmbi = 'ERROR';
              return *off;
              CEETREC( *omit: 1 );
        endif;
        return *on;
      /end-free
     P svpcfg_ambiente...
     P                 E

      /define PSYS_LOAD_PROCEDURE
      /copy hdiile/qcpybooks,psys_h
      /define GETSYSV_LOAD_PROCEDURE
      /copy hdiile/qcpybooks,getsysv_h
