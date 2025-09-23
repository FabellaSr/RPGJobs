      /if not defined(RECDATO_H)
      /define OS400_JVM_12
      /copy QSYSINC/QRPGLESRC,JNI

      * ------------------------------------------------------------ *
      * Clases
      * ------------------------------------------------------------ *
     D RECDANTO_CLASS...
     D                 C                   'ar.com.hdi.gaus.-
     D                                     GenerarReciboDaniosTotales'

     D new_String      PR                  like(jString)
     D                                     EXTPROC(*JAVA
     D                                     :'java.lang.String'
     D                                     :*CONSTRUCTOR)
     D create_from                 1024A   VARYING const

      * ------------------------------------------------------------ *
      *  generateReciboDeRobo(): Genera Recibo                       *
      *                                                              *
      *          peNres (input) Numero de Recibo                     *
      *          peNeml (input) Nombre de Empresa                    *
      *          peNomb (input) Nombre del Beneficiario              *
      *          peImpo (input) Importe a pagar                      *
      *          peMesc (input) Monto Escrito a pagar                *
      *          pePoli (input) Numero de Poliza                     *
      *          peDani (input) Tipo de Daño                         *
      *          peVehi (input) Vehiculo                             *
      *          peVhan (input) Año del Vehiculo                     *
      *          peNmat (input) Patente                              *
      *          peFsid (input) Día de ocurrencia                    *
      *          peFsim (input) Mes de ocurrencia                    *
      *          peFsia (input) Año de ocurrencia                    *
      *          peLoca (input) Localidad                            *
      *          peProd (input) Provincia                            *
      *                                                              *
      * ------------------------------------------------------------ *
     D generateReciboDeRobo...
     D                 pr              n
     D                                     ExtProc( *java
     D                                     : RECDANTO_CLASS
     D                                     : 'generateReciboDeRobo')
     D                                     Static
     D  peNres                             like(jString)
     D  peNeml                             like(jString)
     D  peNomb                             like(jString)
     D  peImpo                             like(jString)
     D  peMesc                             like(jString)
     D  pePoli                             like(jString)
     D  peDani                             like(jString)
     D  peVehi                             like(jString)
     D  peVhan                             like(jString)
     D  peNmat                             like(jString)
     D  peFsid                             like(jString)
     D  peFsim                             like(jString)
     D  peFsia                             like(jString)
     D  peLoca                             like(jString)
     D  peProd                             like(jString)

      /define RECDATO_H
      /endif
