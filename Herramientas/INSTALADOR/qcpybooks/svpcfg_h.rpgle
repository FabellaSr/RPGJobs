      /if defined(SVPCFG_H)
      /eof
      /endif
      /define SVPCFG_H
     * ---------------------------------------------------- *
     *  Estructura para llamar al CLRLIB
     * ---------------------------------------------------- *
     DCLRLIB           pr                  extpgm('CLRLIB')
     D lib                           10a
     D s                             10A
     * ---------------------------------------------------- *
     *  Estructura para llamar al RSTTTCMD
     * ---------------------------------------------------- *
     DRSTTTCMD         pr                  extpgm('RSTTTCMD')
     D libr                          10a
     D savf                          10a
     D lsav                          10a
     D savl                          10a
     * Sus variables...
     D conf_obj        DS            30
     D  libr1                  1     10
     D  lsav1                 11     20
     D  savl1                 21     30
     * ---------------------------------------------------- *
     *  Estructura para llamar al getsavf
     * ---------------------------------------------------- *
     DGETSAVF          pr                  extpgm('GETSAVF')
     D SAVF                          10a
     D  peRst                          n
     D  peDlt                          n
      * ------------------------------------------------------------ *
      * svpcfg_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D svpcfg_inz      pr
      * ------------------------------------------------------------ *
      * svpcfg_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D svpcfg_end      pr
      * ------------------------------------------------------------ *
      * svpcfg_ambiente():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     D svpcfg_ambiente...
     D                 pr              n
     D   pxAmbi                      10

