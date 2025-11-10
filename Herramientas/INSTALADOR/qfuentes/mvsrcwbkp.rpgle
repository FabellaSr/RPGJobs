            // - --- ---------------------------------------------------- --- - //
            //  Programa  : MOVMBR_RPG
            //  Objetivo  : Reemplaza la lógica CL de rotación y movimiento de
            //              miembros (MBR, MBR_, MBR__, MBR___) en RPGLE Free.
            //  Autor     : Fabella Ivan
            //  Fecha     : 2025-
            // - --- ---------------------------------------------------- --- - //
            ctl-opt
            actgrp(*caller)
            bnddir('INSTALADOR/HDIBDIR')
            option(*srcstmt: *nodebugio: *nounref: *noshowcpy)
            datfmt(*iso) timfmt(*iso);

            /copy *libl/qcpybooks,svpapi_h
            /copy *libl/qcpybooks,svpinst_h

            dcl-pi *n;
                fromFile20 char(20) const;
                toFile20   char(20) const;
                mbrIn      char(10) const;
            end-pi;
            //inicio
            *inlr = *on;
            parseos();
            //Fuente existe?

           // if not  chkMbr(fromFileM: fromLib : mbr);
            if not chkMbrEnSrcpf(fromFileM : fromLib : mbr);
                cmd = 'SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) '    +
                        'MSGDTA(''' +
                        'No existe el archivo ' + %trim(fromFileM) +
                        ' en ' + %trim(fromLib) + ''') '           +
                        'MSGTYPE(*ESCAPE)';
                svpapi_RunCl(cmd);
                return;
            endif;
            // - --- Renombro existentes --- - //
            renombraFuentes(toFileM: toLib: mbr);
            // - --- Ahora lo nuevo --- - //
            muevoFuenteNuevo();

            return;
            //Fin
            //Muevo el fuente nuevo al desetino
            dcl-proc muevoFuenteNuevo;
                // - --- Muevo el nuevo --- - //
                cmd = 'MOVM FROMFILE(' + %trim(fromLib) + '/'
                    + %trim(fromFileM) + ')' +
                    ' TOFILE(' + %trim(toLib) + '/' + %trim(toFileM) + ')' +
                    ' FROMMBR(' + %trim(mbr) + ')';
                ok = svpapi_RunCl(cmd);
                //Si algo salio mal...
                if not ok;
                    cmd = 'SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA(''' +
                        'Error al mover/copiar el miembro ' +
                        %trim(mbr) + ''') MSGTYPE(*ESCAPE)';
                    svpapi_RunCl(cmd);
                    return;
                endif;
            end-proc;
            // - --- Parseo y normalización --- - //
            dcl-proc parseos;
                fromFileM = %subst(fromFile20 :1  :10);
                fromLib   = %subst(fromFile20 :11 :10);
                toFileM   = %subst(toFile20   :1  :10);
                toLib     = %subst(toFile20   :11 :10);
                mbr       = mbrIn;
                // Trim a derecha (por si vienen con blanks)
                fromFileM = %trimr(fromFileM);
                fromLib   = %trimr(fromLib);
                toFileM   = %trimr(toFileM);
                toLib     = %trimr(toLib);
                mbr       = %trimr(mbr);
            end-proc;
            // Verifica existencia de miembro dentro de archivo
            dcl-proc   chkMbrEnSrcpf;
                dcl-pi   chkMbrEnSrcpf ind;
                    pFile char(10) const;
                    pLib  char(10) const;
                    pMbr  char(10) const;
                end-pi;
                return svpapi_memberExists(pFile+plib:pMbr);
            end-proc;
            // Rota: borra MBR___; MBR__->MBR___; MBR_->MBR__; MBR->MBR_
            dcl-proc  renombraFuentes;
                dcl-pi  renombraFuentes;
                    pFile char(10) const;
                    pLib  char(10) const;
                    pMbr  char(10) const;
                end-pi;

                dcl-s base   char(20);
                dcl-s m1     char(20);
                dcl-s m2     char(20);
                dcl-s m3     char(20);
                dcl-s cl     varchar(200);
                base = %trim(pMbr);
                //Con fuentes de largo nombre no anda... habra que ver que se
                //hace
                m1 = %trim(base)+ '_';
                m2 = %trim(base)+ '__';
                m3 = %trim(base)+ '___';
                // Si existe MBR___ -> RMVM
                if   chkMbrEnSrcpf(pFile: pLib: m3);
                    cl = 'RMVM FILE(' + %trim(pLib) + '/' +
                        %trim(pFile) + ') MBR(' + %trim(m3) + ')';
                    svpapi_RunCl(cl);
                endif;
                // Si existe MBR__ -> RNMM a MBR___
                if   chkMbrEnSrcpf(pFile: pLib: m2);
                    cl = 'RNMM FILE(' + %trim(pLib) + '/' +
                         %trim(pFile) + ') ' + 'MBR(' + %trim(m2) +
                         ') NEWMBR(' + %trim(m3) + ')';
                    svpapi_RunCl(cl);
                endif;
                // Si existe MBR_ -> RNMM a MBR__
                if   chkMbrEnSrcpf(pFile: pLib: m1);
                    cl = 'RNMM FILE(' + %trim(pLib) + '/' +
                          %trim(pFile) + ') ' +
                         'MBR(' + %trim(m1) + ') NEWMBR(' + %trim(m2) + ')';
                    svpapi_RunCl(cl);
                endif;
                // Si existe MBR -> RNMM a MBR_
                if   chkMbrEnSrcpf(pFile: pLib: pMbr);
                    cl = 'RNMM FILE(' + %trim(pLib) + '/' +
                         %trim(pFile) + ') ' +
                         'MBR(' + %trim(pMbr) + ') NEWMBR(' + %trim(m1) + ')';
                    svpapi_RunCl(cl);
                endif;
            end-proc;
