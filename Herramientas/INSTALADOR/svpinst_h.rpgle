      /if defined(SVPINST_H)
      /eof
      /endif
      /define SVPINST_H
     Fsetsrc    uf a e           k disk
     Fsetins    uf a e           k disk
     Fsetsrcpf  if   e           k disk    rename( S1TSRC : SPTSRC )
     * ---------------------------------------------------- *
     *  Generales
     * ---------------------------------------------------- *
     * ---------------------------------------------------- *
     * keyS
     * ---------------------------------------------------- *
     D k1tsrc          ds                  likerec( s1tsrc : *Key )
     D k1tins          ds                  likerec( sitins : *Key )
     D @@Dssrc         ds                  likerec( s1tsrc : *input  )
     D @@Dsins         ds                  likerec( sitins : *input  )
     * ---------------------------------------------------- *
     * area de datos
     * ---------------------------------------------------- *
     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     * ---------------------------------------------------- *
     * Estrucutura para fechas
     * ---------------------------------------------------- *
     D                 ds                  inz
     D    fech                 1      8  0
     D    feca                 1      4  0
     D    fecm                 5      6  0
     D    fecd                 7      8  0
     * ---------------------------------------------------- *
     *  Estructura para llamar al MOVSRC
     * ---------------------------------------------------- *
     DMOVSRCMBRC       pr                  extpgm('MOVSRCMBRC')
     D FFIL                          20a
     D TFIL                          20a
     D MBR                           10a
     * - -------------------------------------------------- *
     *  Generales
     * - -------------------------------------------------- *
      *
      * A partir de aca, variables especificas de cada pgm
      *
     * ---------------------------------------------------- *
     *  Estructura para llamar al FUENTESB
     * ---------------------------------------------------- *
     D*INSTALFUEN       pr                  extpgm('FUENTESB')
     DPGGFUENTES       pr                  extpgm('PGGFUE')
     D desa                          10a
     D secu                           2  0
     * ---------------------------------------------------- *
     *  Estructura para llamar al FUENTESA
     * ---------------------------------------------------- *
     D*LECTURAINST      pr                  extpgm('PGGINST1')
     DPGGLECTURA       pr                  extpgm('PGGLEC')
     D desa                          10a
     D secu                           2  0
     D deta                          50a
     * ---------------------------------------------------- *
     *  Estructura para llamar al OBJETOS
     * ---------------------------------------------------- *
     D*INSTALOBJ        pr                  extpgm('OBJETOS')
     DPGGOBJETOS       pr                  extpgm('PGGOBJ')
     D desa                          10a
     D secu                           2  0
     * ---------------------------------------------------- *
     *  Estructura para llamar al procinst
     * ---------------------------------------------------- *
     DINSTCOMP         pr                  extpgm('INSTCOM')
     D desa                          10a
     D desc                          50a
     D flaotipoinst                    n
     D estado                          n
     D*
     D estoyEn         s             10a
     D retornoSecu     s              2  0
     D paso            s             10i 0 inz(1)
     D parasf          s               n   inz(*on)
     D asteri          s             10A   inz('*         ')
     * - -------------------------------------------------- *
     *  FUENTESA
     * - -------------------------------------------------- *
     * ---------------------------------------------------- *
     * Variables varias
     * ---------------------------------------------------- *
     D                 DS            10
     d  qfile                  1     10a
     D  q                      1      1a   inz('Q')
     D  file                   2     10a
     D
     D conf_ins        DS            30
     D  tlib                   1     10
     D  LIBO                  11     20
     D  tfil                  21     30
     d
     D @@vsys          s            512a
     D* FLIB            s             10a
     D tipoInst        s               n   inz(*off)
     D estadoInst      s               n
     D x               s             10i 0
     D                 ds                  inz
     Dcadena                   1    100
     Dnomfue                   2     11
     Desws                     2      3
     Dtipo                    12     21
     * ---------------------------------------------------- *
     *  FUENTESA
     * ---------------------------------------------------- *
      *
      *
      *
     * ---------------------------------------------------- *
     *  FUENTESB
     * ---------------------------------------------------- *
     * ---------------------------------------------------- *
     * Variables varias
     * ---------------------------------------------------- *
     D                 ds            20
     D fromfile                1     20
     D S1FFIL                  1     10
     D S1FLIB                 11     20
     D                 ds            20
     D tofile                  1     20
     D S1tfil                  1     10
     D S1tLIB                 11     20
     * ---------------------------------------------------- *
     *  FUENTESB
     * ---------------------------------------------------- *
      *
      *
      *
     * ---------------------------------------------------- *
     *  OBJETOS
     * ---------------------------------------------------- *
     * ---------------------------------------------------- *
     * Variables varias
     * ---------------------------------------------------- *
     D bloqueado       s               n   inz(*off)
     D formato         S              8a   inz('OBJL0100')
     D objType         S             10a   inz('*FILE')
     D rcvVar          S          32767a
     D rcvVarLen       S             10i 0
     D tipoObj         S             10a
     D srvpgm          s               n   inz(*off)
     D                 ds
     D objlck                  1     20
     D obj                     1     10
     D libobj                 11     20
     * ---------------------------------------------------- *
     *  OBJETOS
     * ---------------------------------------------------- *

