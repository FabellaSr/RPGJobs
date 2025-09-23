# Generador de Recibos de Daños Totales desde GAUS

Este proyecto genera un documento PDF que contiene un recibo de daños totales (puede ser Robo o Daño) con información proporcionada por un proceso batch. Utiliza la biblioteca iText 5.5.3 para la manipulación de documentos PDF.

El recibo se llamará Recibo_%s.pdf, reemplazando %s por el numero de recibo que llega por parámetros.

## Requisitos

- JDK 8 o superior
- Biblioteca iText 5.5.13.2

## Instalación

1. Clona el repositorio o descarga los archivos del proyecto.
2. Asegúrate de tener JDK 8 o superior instalado en tu sistema.
3. Añade la biblioteca iText al proyecto. Puedes descargarlas desde los siguientes enlaces:
   - [iText 5.5.13.2](https://mvnrepository.com/artifact/com.itextpdf/itextpdf/5.5.13.2)

## Uso

Para usar desde RPG se debe tener el miembro RECDATO_H de HDIILE/QCPYBOOKS copiado en el fuente del programa cliente. 

Los parámetros que el método recibe son:

```
peNres (input) Numero de Recibo        
peNeml (input) Nombre de Empresa       
peNomb (input) Nombre del Beneficiario 
peImpo (input) Importe a pagar         
peMesc (input) Monto Escrito a pagar   
pePoli (input) Numero de Poliza        
peDani (input) Tipo de Daño            
peVehi (input) Vehiculo                
peVhan (input) Año del Vehiculo        
peNmat (input) Patente                 
peFsid (input) Día de ocurrencia       
peFsim (input) Mes de ocurrencia       
peFsia (input) Año de ocurrencia       
peLoca (input) Localidad               
peProd (input) Provincia               
```

Todos estos parámetros son OBJETOS de tipo jString.

El método generateReciboDeRobo() retornará: 

* True: Si pudo generar el archivo PDF
* False: Si no pudo generarlo

