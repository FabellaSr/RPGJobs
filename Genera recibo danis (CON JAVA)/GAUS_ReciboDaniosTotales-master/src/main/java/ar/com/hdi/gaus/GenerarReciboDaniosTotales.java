package ar.com.hdi.gaus;

import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.IOException;

public class GenerarReciboDaniosTotales {

	public static boolean generateReciboDeRobo(String NroRecibo, String empresa, String beneficiario, String importe,
            String montoEscrito, String poliza, String danio,
            String vehiculo, String anio, String patente,
            String dia, String mes, String anioOcurrencia,
            String localidad, String provincia) {


        String logoPath  = "/home/ReciboDanioTotal/config/images/logoHDI.png";;
        String firmaPath = "/home/ReciboDanioTotal/config/images/firmaReciboDanioTotal.png";
        String pdfPath = String.format("/home/ReciboDanioTotal/Recibo_%s.pdf", NroRecibo);
        String textoFilePath = "/home/ReciboDanioTotal/config/textoDanioTotal.txt";

        // Verificar que el archivo de la imagen de la firma existe
        File firmaFile = new File(firmaPath);
        if (!firmaFile.exists()) {
            return false;
        }

        // Verificar que el archivo de la imagen del logo existe
        File logoFile = new File(logoPath);
        if (!logoFile.exists()) {
            return false;
        }

        // Verificar que el archivo PDF no existe
        File pdfFile = new File(pdfPath);
        if (pdfFile.exists()) {
            return false;
        }

        Document document = new Document();
        try {
            PdfWriter.getInstance(document, new FileOutputStream(pdfPath));
            document.open();

            // Agregar imagen del logo en el encabezado
            Image logo = Image.getInstance(logoPath);
            logo.setAlignment(Image.ALIGN_CENTER);
            logo.scalePercent(40);
            document.add(logo);

            // Preparo parrafo
            Paragraph parrafo = new Paragraph();
            parrafo.add(Chunk.NEWLINE);
            parrafo.add(Chunk.NEWLINE);
            parrafo.add(Chunk.NEWLINE);

            // Leer el texto principal desde un txt
            String texto = readFile(textoFilePath);
            if (texto != null) {
                // Reemplazar los placeholders en el texto
                texto = texto.replace("{empresa}", empresa)
                             .replace("{beneficiario}", beneficiario)
                             .replace("{importe}", importe)
                             .replace("{montoEscrito}", montoEscrito)
                             .replace("{poliza}", poliza)
                             .replace("{danio}", danio)
                             .replace("{vehiculo}", vehiculo)
                             .replace("{anio}", anio)
                             .replace("{patente}", patente)
                             .replace("{dia}", dia)
                             .replace("{mes}", mes)
                             .replace("{anioOcurrencia}", anioOcurrencia)
                             .replace("{localidad}", localidad)
                             .replace("{provincia}", provincia);

                // Agregar el texto principal al documento
                parrafo.add(texto.trim());
                parrafo.setAlignment(Element.ALIGN_JUSTIFIED);
                document.add(parrafo);

                // Agregar imagen de la firma en el pie
                Image firma = Image.getInstance(firmaPath);
                firma.scalePercent(10);
                firma.setAbsolutePosition(400.0F, 20.0F);

                document.add(firma);
            }

            document.close();
            return true;

        } catch (DocumentException | IOException e) {
            return false;
        } finally {
            if (document.isOpen()) {
                document.close();
            }
        }

	}


    private static String readFile(String filePath) {
        StringBuilder content = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                content.append(line).append("\n");
            }
        } catch (IOException e) {
            return null;
        }
        return content.toString();
    }

	public static void main(String[] args) {
	}

}
