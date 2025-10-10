      /if defined(SVPCFG_H)
      /eof
      /endif
      /define SVPCFG_H
            dcl-s Initialized    ind;
            // ----------------------------------------------------
            //  Estructura para llamar al CLRLIB
            // ----------------------------------------------------
            dcl-pr CLRLIB extpgm('CLRLIB');
                  lib char(10);
                  s   char(10);
            end-pr;

            // ----------------------------------------------------
            //  Estructura para llamar al RSTTTCMD
            // ----------------------------------------------------
            dcl-pr RSTTTCMD extpgm('RSTTTCMD');
                  libr char(10);
                  savf char(10);
                  lsav char(10);
                  savl char(10);
            end-pr;

            // Sus variables...
            dcl-ds conf_obj;
                  libr1 char(10) pos(1);
                  lsav1 char(10) pos(11);
                  savl1 char(10) pos(21);
            end-ds;

            // ----------------------------------------------------
            //  Estructura para llamar al GETSAVF
            // ----------------------------------------------------
            dcl-pr GETSAVF extpgm('GETSAVF');
                  SAVF   char(10);
                  peRst  ind;
                  peDlt  ind;
            end-pr;

            // ------------------------------------------------------------
            //  svpcfg_inz(): Inicializa módulo.
            // ------------------------------------------------------------
            dcl-pr svpcfg_inz end-pr;

            // ------------------------------------------------------------
            //  svpcfg_end(): Finaliza módulo.
            // ------------------------------------------------------------
            dcl-pr svpcfg_end end-pr;

            // ------------------------------------------------------------
            //  svpcfg_ambiente():
            //  Retorna: on / off.
            // ------------------------------------------------------------
            dcl-pr svpcfg_ambiente ind;
            pxAmbi char(10);
            end-pr;

