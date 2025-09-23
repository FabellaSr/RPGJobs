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
      /copy instalador/qcpybooks,svpapi_H
     * - ----------------------------------------------------------- *
      *   Archivos
     * - ----------------------------------------------------------- *

     D Initialized     s              1N
     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
      * ------------------------------------------------------------ *
      * svpapi_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P svpapi_inz      B                   export
     D svpapi_inz      pi
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

     P svpapi_inz      E
      * ------------------------------------------------------------ *
      * svpapi_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P svpapi_End      B                   export
     D svpapi_End      pi
      /free
       //close *all;
       initialized = *OFF;
       return;
      /end-free

     P svpapi_End      E

      * ------------------------------------------------------------ *
      * svpapi_spaceUsr():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_spaceUsr...
     P                 B                   export
     D svpapi_spaceUsr...
     D                 pi              n
      /free
      *
      * Delete the user space if it exists
      *
       svpapi_dltSpaceUsr();
       monitor;
      *
      * Create the user space
      *
          callp QUSCRTUS(SPACENAME
                        : ATTRIBUTE
                        : INIT_SIZE
                        : blanco
                        : AUTHORITY
                        : TEXT);
          return *on;
       on-error;
          return *off;
       endmon;
      /end-free
     P svpapi_spaceUsr...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_dltSpaceUsr():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_dltSpaceUsr...
     P                 B                   export
     D svpapi_dltSpaceUsr...
     D                 pi              n
      /free
      *
      * Delete the user space if it exists
      *
       monitor;
          callp QUSDLTUS(SPACENAME : IGNERR);
          return *on;
       on-error;
          return *off;
       endmon;
      /end-free
     P svpapi_dltSpaceUsr...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_listTheMembers():                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_listTheMembers...
     P                 B                   export
     D svpapi_listTheMembers...
     D                 pi              n
     D peLib                                likeds(file_lib)
      /free
      *
      * Call the API to list the members in the requested file
      *
       monitor;
          callp QUSLMBR(SPACENAME
                      : MBR_LIST
                      : peLib
                      : WHICHMBR
                      : OVERRIDE);
          return *on;
        on-error;
          return *off;
       endmon;

      /end-free
     P svpapi_listTheMembers...
     P                 E

      * ------------------------------------------------------------ *
      * svpapi_getPointerToTheUsrSpace()                             *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_getPointerToTheUsrSpace...
     P                 B                   export
     D svpapi_getPointerToTheUsrSpace...
     D                 pi              n
     D pePtUs                              like(PTR)
      /free
      *
      * Get a pointer to the user-space
      *
       monitor;
        callp QUSPTRUS(SPACENAME : pePtUs);
        return *on;
       on-error;
        return *off;
       endmon;

      /end-free
     P svpapi_getPointerToTheUsrSpace...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_loadMemToLib()                             *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_loadMemToLib...
     P                 B                   export
     D svpapi_loadMemToLib...
     D                 pi              n
     D peLib                               likeds(file_lib)
     D pxDsMbr                             likeds(MBR0200_T)
     D                                     Options( *Nopass: *Omit ) Dim(99)
     D pxeDsCMbr                     10i 0 Options( *Nopass: *Omit )

     D x               s             10i 0
      /free
        clear pxDsMbr;
        clear pxeDsCMbr;
        x = 1;
        endpgm = *on;
        dow endpgm;
          select;
            when x = 1;
              endpgm = svpapi_spaceUsr();
              x = 2;
            when x = 2;
              endpgm = svpapi_listTheMembers(peLib);
              x = 3;
            when x = 3;
              endpgm = svpapi_getPointerToTheUsrSpace(PTR);
              leave;
          endsl;
        enddo;
        MBRPTR = %addr(ARR(OFFSET));
        pxeDsCMbr = size;
        eval-corr pxDsMbr = MBR0200_T;
        return endpgm;

      /end-free
     P svpapi_loadMemToLib...
     P                 E

      * ------------------------------------------------------------ *
      * svpapi_chkStatusObj()                             *
      *         recibe obj y libobj                                *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_chkStatusObj...
     P                 B                   export
     D svpapi_chkStatusObj...
     D                 pi              n
     D pxObjlck                            like(objlock)

     D x               s             10i 0
      /free
        x = 1;
        endpgm = *on;
        dow endpgm;
          select;
            when x = 1;
              endpgm = svpapi_spaceUsr();
              x = 2;
            when x = 2;
            //le mando obj y liboj
              endpgm = svpapi_chkobjlck(pxObjlck);
              x = 3;
            when x = 3;
              endpgm = svpapi_getPointerToTheUsrSpace(PTR);
              leave;
          endsl;
        enddo;
        if userspaceHeade.nmbrEntries > 0;
          stateObj = *on;
        else;
            stateObj = *off;
        endif;
        return stateObj;

      /end-free
     P svpapi_chkStatusObj...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_chkobjexist(                                          *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_chkobjexist...
     P                 B                   export
     D svpapi_chkobjexist...
     D                 pi              n
     D peNfue                        10a
     D peFlib                        10a
     D peTobj                        10a

     D retorno         s               n   inz(*off)
     D estr            ds            20
     D todo                    1     20a
     D objeto                  1     10a
     D lib                    11     20a
     D existe          ds            41
     D trampa                  2     41
     D x               s             10i 0
      /free
        x = 1;
        objeto= peNfue;
        lib = peFlib;
        endpgm = *on;
        dow endpgm;
          select;
            when x = 1;
              endpgm = svpapi_spaceUsr();
              x = 2;
            when x = 2;
            //le mando obj y liboj
              QUSLOBJ( SPACENAME
                      : CHK_OBJ
                      : todo
                      : peTobj
                      : errCode );
              x = 3;
            when x = 3;
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
      /end-free
     P svpapi_chkobjexist...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_getTypeAndAttributeObj()                                          *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_getTypeAndAttributeObj...
     P                 B                   export
     D svpapi_getTypeAndAttributeObj...
     D                 pi              n
     D peNfue                        10a
     D peFlib                        10a
     D pxTobj                        10a
     D pxAttr                        10a

     D retorno         s               n   inz(*off)
     D estr            ds            20
     D todo                    1     20a
     D objeto                  1     10a
     D lib                    11     20a
     D objType         ds            40
     D type                   22     30
     D attr                   33     40
     D x               s             10i 0
      /free
        x = 1;
        objeto= peNfue;
        lib = peFlib;
        endpgm = *on;
        dow endpgm;
          select;
            when x = 1;
              endpgm = svpapi_spaceUsr();
              x = 2;
            when x = 2;
            //le mando obj y liboj
              QUSLOBJ( SPACENAME
                      : CHK_OBJ2
                      : todo
                      : ATTRIBUTEALL
                      : errCode );
              x = 3;
            when x = 3;
              endpgm = svpapi_getPointerToTheUsrSpace(PTR);
              leave;
          endsl;
        enddo;

        MBRPTR = %addr(ARR(OFFSET));
        if MBR0200_T(1).MBRNAME <> *blanks;
          objType = MBR0200_T(1).MBRNAME;
          pxTobj = type;
          pxAttr = attr;
          retorno = *on;
        endif;
       return retorno;

      /end-free
     P svpapi_getTypeAndAttributeObj...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_chkobjlck()                                           *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_chkobjlck...
     P                 B                   export
     D svpapi_chkobjlck...
     D                 pi              n
     D pxObjlck                            like(objlock)
      /free
       monitor;
        callp QWCLOBJL(SPACENAME
                      : CHK_OBJ
                      : pxObjlck
                      : ATTRIBUTEFILE
                      : NONE
                      : errCode);
        return *on;
       on-error;
        return *off;
       endmon;

      /end-free
     P svpapi_chkobjlck...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_movobj()                                              *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_movobj...
     P                 B                   export
     D svpapi_movobj...
     D                 pi              n
     D peObjl                        10a
     D peNfue                        10a
     D peFlib                        10a
     D peTlib                        10a
     D peTobj                        10a
       /free
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
            CMDLEN = %len(%trim(CMD));
            callp QCMDEXC(CMD: CMDLEN);
        endif;
            CMD = 'MOVOBJ OBJ('
                    + %trim(peFlib)
                    + '/'
                    + %trim(peNfue)
                    + ') OBJTYPE('
                    + %trim(peTobj)
                    + ') TOlib('
                    + %trim(peTlib) + ')';
            CMDLEN = %len(%trim(CMD));
            callp QCMDEXC(CMD: CMDLEN);
            return *on;
       /end-free
     P svpapi_movobj...
     P                 E
      * ------------------------------------------------------------ *
      * svpapi_movfil()                                              *
      *                                                              *
      * Retorna: on off.                                             *
      * ------------------------------------------------------------ *
     P svpapi_movfil...
     P                 B                   export
     D svpapi_movfil...
     D                 pi              n
     D peObjl                        10a
     D peNfue                        10a
     D peFlib                        10a
     D peTobj                        10a
      /free
          monitor;
            cmd = 'RPLPF FILE('
                  + %trim(peObjl)
                  + '/'
                  + %trim(peNfue)
                  + ') FROMlib('
                  + %trim(peFlib)
                  + ')';
            CMDLEN = %len(%trim(CMD));
            callp QCMDEXC(CMD: CMDLEN);
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
              CMDLEN = %len(%trim(CMD));
              callp QCMDEXC(CMD: CMDLEN);
            on-error;
              return *off;
            endmon;
            //si hay error?
          endmon;
          return *on;
      /end-free
     P svpapi_movfil...
     P                 E
