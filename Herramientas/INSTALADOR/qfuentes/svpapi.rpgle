     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * svpapi: instalador                                         *
      * ------------------------------------------------------------ *
      * Fabella Ivan                                                 *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * ************************************************************ *
      *--- Copy H -------------------------------------------------- *
      // /include qsysinc/qrpglesrc,qusrmbrd
      /copy instalador/qcpybooks,svpapi_H
      /copy instalador/qcpybooks,svpcfg_H

      * ------------------------------------------------------------ *
      * svpapi_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_inz export;
            initialized = *ON;
            return;

        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_End export;

            //close *all;
            initialized = *OFF;
            return;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_spaceUsr():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_spaceUsr export;
            dcl-pi svpapi_spaceUsr ind;
            end-pi;
            // *
            // * Delete the user space if it exists
            // *
            svpapi_dltSpaceUsr();
            monitor;
            // *
            // * Create the user space
            // *
                callp QUSCRTUS( SPACENAME
                              : ATTRIBUTE
                              : INIT_SIZE
                              : blanco
                              : AUTHORITY
                              : TEXT);
                return *on;
            on-error;
                return *off;
          endmon;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_dltSpaceUsr():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_dltSpaceUsr export;
            dcl-pi svpapi_dltSpaceUsr ind;
            end-pi;
          // *
          // * Delete the user space if it exists
          // *
            monitor;
                callp QUSDLTUS(SPACENAME : IGNERR);
                return *on;
            on-error;
                return *off;
            endmon;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_listTheMembers():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_listTheMembers export;
            dcl-pi svpapi_listTheMembers ind;
                  peLib likeds(FILE_LIB);
            end-pi;
            // *
            // * Call the API to list the members in the requested file
            // *
            monitor;
                callp QUSLMBR( SPACENAME
                             : MBR_LIST
                             : peLib
                             : WHICHMBR
                             : OVERRIDE);
                return *on;
              on-error;
                return *off;
            endmon;

        end-proc;

      * ------------------------------------------------------------ *
      * svpapi_getPointerToTheUsrSpace()                             *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_getPointerToTheUsrSpace export;
            dcl-pi svpapi_getPointerToTheUsrSpace ind;
                  pePtUs like(PTR);
            end-pi;
            // *
            // * Get a pointer to the user-space
            // *
            monitor;
              callp QUSPTRUS(SPACENAME : pePtUs);
              return *on;
            on-error;
              return *off;
            endmon;

        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_loadMemToLib()                             *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_loadMemToLib export;
            dcl-pi svpapi_loadMemToLib ind;
                  peLib     likeds(FILE_LIB);
                  pxDsMbr   likeds(MBR0200_T) dim(99) options(*nopass : *omit);
                  pxeDsCMbr int(10)           options(*nopass : *omit);
            end-pi;
            clear pxDsMbr;
            clear pxeDsCMbr;
            count  = 1;
            endpgm = *on;
            dow endpgm;
              select;
                when count = 1;
                  endpgm = svpapi_spaceUsr();
                  count = 2;
                when count = 2;
                  endpgm = svpapi_listTheMembers(peLib);
                  count = 3;
                when count = 3;
                  endpgm = svpapi_getPointerToTheUsrSpace(PTR);
                  leave;
              endsl;
            enddo;
            MBRPTR    = %addr(ARR(OFFSET));
            pxeDsCMbr = size;
            eval-corr pxDsMbr = MBR0200_T;
            return endpgm;
        end-proc;

      * ------------------------------------------------------------ *
      * svpapi_chkStatusObj()                                        *
      *         recibe obj y libobj                                  *
      * Retorna: on si el obj esta bloqueado off si no esta bloq     *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_chkStatusObj export;
            dcl-pi svpapi_chkStatusObj ind;
                  pxObjlck like(objlock);
            end-pi;
            count  = 1;
            endpgm = *on;
            dow endpgm;
              select;
                when count  = 1;
                  endpgm = svpapi_spaceUsr();
                  count  = 2;
                when count  = 2;
                //le mando obj y liboj
                  endpgm = svpapi_chkobjlck(pxObjlck);
                  count  = 3;
                when count  = 3;
                  endpgm = svpapi_getPointerToTheUsrSpace(usPtr);
                  leave;
              endsl;
            enddo;
            if userspaceHeader.nmbrEntries > 0;
              stateObj = *on;
            else;
              stateObj = *off;
            endif;
            return stateObj;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_chkobjexist(                                          *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_chkobjexist export;
          dcl-pi svpapi_chkobjexist ind;
                peNfue char(10);
                peFlib char(10);
                peTobj char(10);
          end-pi;
          dcl-s retorno ind inz(*off);

          dcl-ds estr;
            todo   char(20) pos(1);
            objeto char(10) pos(1);
            lib    char(10) pos(11);
          end-ds;
          dcl-ds existe;
            trampa char(40) pos(2);
          end-ds;
          count  = 1;
          objeto = peNfue;
          lib    = peFlib;
          endpgm = *on;
          dow endpgm;
            select;
              when count  = 1;
                endpgm = svpapi_spaceUsr();
                count  = 2;
              when count  = 2;
              //le mando obj y liboj
                QUSLOBJ( SPACENAME
                       : CHK_OBJ
                       : todo
                       : peTobj
                       : errCode );
                count  = 3;
              when count  = 3;
                endpgm = svpapi_getPointerToTheUsrSpace(PTR);
                leave;
            endsl;
          enddo;
          MBRPTR = %addr(ARR(OFFSET));
          existe = %TRIM(MBR0200_T(1).MBRNAME);
          if trampa <> *blanks;
            retorno = *on;
          endif;
          return retorno;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_getTypeAndAttributeObj()                              *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_getTypeAndAttributeObj export;
          dcl-pi svpapi_getTypeAndAttributeObj ind;
                peNfue char(10);
                peFlib char(10);
                pxTobj char(10);
                pxAttr char(10);
          end-pi;
          dcl-s retorno ind inz(*off);
          // --- DS de 20 bytes con overlays
          dcl-ds EstrDS inz;
            todo   char(20);                 // base (1\Z20)
            objeto char(10) overlay(todo:1); // 1\Z10
            lib    char(10) overlay(todo:11);// 11\Z20
          end-ds;
          // --- DS de 40 bytes con overlays
          dcl-ds ObjTypeDS inz;
            bloque char(40);                   // base (1\Z40)
            type   char(9)  overlay(bloque:22);// 22\Z30
            attr   char(8)  overlay(bloque:33);// 33\Z40
          end-ds;
          count  = 1;
          objeto = peNfue;
          lib    = peFlib;
          endpgm = *on;
          dow endpgm;
            select;
              when count = 1;
                endpgm = svpapi_spaceUsr();
                count  = 2;
              when count = 2;
              //le mando obj y liboj
                QUSLOBJ( SPACENAME
                      : CHK_OBJ2
                      : todo
                      : ATTRIBUTEALL
                      : errCode );
                count = 3;
              when count = 3;
                endpgm = svpapi_getPointerToTheUsrSpace(PTR);
                leave;
            endsl;
          enddo;

          MBRPTR = %addr(ARR(OFFSET));
          if MBR0200_T(1).MBRNAME <> *blanks;
            bloque  = MBR0200_T(1).MBRNAME;
            pxTobj  = type;
            pxAttr  = attr;
            retorno = *on;
          endif;
          return retorno;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_chkobjlck()                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_chkobjlck export;
          dcl-pi svpapi_chkobjlck ind;
                pxObjlck like(objlock);
          end-pi;
          monitor;
            callp QWCLOBJL( SPACENAME
                          : CHK_OBJ       //OBJL0100
                          : pxObjlck
                          : ATTRIBUTEFILE //*FILE
                          : NONE
                          : errCode);
            return *on;
          on-error;
            return *off;
          endmon;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_movobj()                                              *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_movobj export;
          dcl-pi svpapi_movobj ind;
                peObjl char(10);
                peNfue char(10);
                peFlib char(10);
                peTlib char(10);
                peTobj char(10);
          end-pi;
          if svpapi_chkobjexist( peNfue
                               : peTlib
                               : peTobj);
              CMD = 'DLTOBJ OBJ('
                  + %trim(peTlib)
                  + '/'
                  + %trim(peNfue)
                  + ') OBJTYPE('
                  + %trim(peTobj)
                  +  ')';
              svpapi_RunCl(CMD);
          endif;
          CMD = 'MOVOBJ OBJ('
              + %trim(peFlib)
              + '/'
              + %trim(peNfue)
              + ') OBJTYPE('
              + %trim(peTobj)
              + ') TOlib('
              + %trim(peTlib) + ')';
          svpapi_RunCl(CMD);
          return *on;
        end-proc;
      * ------------------------------------------------------------ *
      * svpapi_movfil()                                              *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
        dcl-proc svpapi_movfil export;
          dcl-pi svpapi_movfil ind;
                peObjl char(10);
                peNfue char(10);
                peFlib char(10);
                peTobj char(10);
          end-pi;
          monitor;
            cmd = 'RPLPF FILE('
                  + %trim(peObjl)
                  + '/'
                  + %trim(peNfue)
                  + ') FROMlib('
                  + %trim(peFlib)
                  + ')';
            svpapi_RunCl(CMD);
          on-error;
            monitor;
              CMD = 'MOVOBJ OBJ('
                  + %trim(peFlib)
                  + '/'
                  + %trim(peNfue)
                  + ') OBJTYPE('
                  + %trim(peTobj)
                  + ') TOlib('
                  + %trim(peObjl) + ')';
              svpapi_RunCl(CMD);
            on-error;
              return *off;
            endmon;
            //si hay error?
          endmon;
          return *on;
        end-proc;
        // =================================================================
        //  PROCEDIMIENTO EXPORT: existe miembro?
        //  peLib  : likeds(FILE_LIB)  --> debe ser CHAR(20) FILE+LIB (10/10)
        //  peMbr  : nombre del miembro
        // =================================================================
        dcl-proc svpapi_memberExists export;
          dcl-pi svpapi_memberExists ind;
                peLib  char(20) const;
                peMbr  char(10)  const;
          end-pi;
          qualFile = peLib;
          mbr      = peMbr;
          QUSRMBRD( MbrDs
                  : dsLen
                  : format
                  : qualFile
                  : mbr
                  : ovrprc
                  : qusec);
          if QUSEI<>' ';
            retorno = *off;
            msgq    ='*EXT';
            errmsg  ='API QUSRMBRD returned error ' + QUSEI;
          endif;
          return retorno;
        end-proc;
        // =================================================================
        //  PROCEDIMIENTO EXPORT: Ejecuta comando
        // =================================================================
        dcl-proc svpapi_RunCl export;
          dcl-pi svpapi_RunCl ind;
              pCmd  varchar(200) const;
          end-pi;
          monitor;
              CMDLEN = %len(%trim(pCmd));
              callp QCMDEXC(pCmd: CMDLEN);
              return *on;
          on-error;
              return *off;
          endmon;
        end-proc;
