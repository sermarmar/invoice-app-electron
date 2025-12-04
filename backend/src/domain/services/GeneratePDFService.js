import { UserRepository } from "../../infraestructure/repositories/userRepository.js";
import { InvoiceService } from "./InvoiceService.js";
import { PDFDocument, rgb, StandardFonts } from "pdf-lib";

export class GeneratePDFService {

    constructor() {
        this.invoiceService = new InvoiceService();
        this.userRepository = new UserRepository();
    }

    async generateInvoicePDF(id) {
        const invoice = await this.invoiceService.getInvoiceById(id);
        const user = await this.userRepository.findById(invoice.userId);

        // === Datos principales ===
        const fullName = `${user.name} ${user.apellidos}`;
        const dni = `NIF: ${user.dni}`;
        const address = `Dirección: ${user.address}, ${user.postal_code}`;
        const phone = `Teléfono: ${user.phone}`;
        const invoiceNumber = `Nº Factura: ${invoice.invoiceId}`;
        const date = `Fecha: ${invoice.date}`;
        const client = invoice.client;

        const account = `Cuenta Bancaria: ${user.account}`;

        // Crear documento PDF
        const pdfDoc = await PDFDocument.create();
        const page = pdfDoc.addPage([595, 842]); // A4 vertical
        const { width, height } = page.getSize();

        // Fuentes
        const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
        const fontBold = await pdfDoc.embedFont(StandardFonts.HelveticaBold);

        let y = height - 60;

        // === Título del usuario (emisor) ===
        page.drawText(fullName, { x: 40, y, size: 20, font: fontBold });
        y -= 22;
        page.drawText(dni, { x: 40, y, size: 11, font });
        y -= 16;
        page.drawText(address, { x: 40, y, size: 11, font });
        y -= 16;
        page.drawText(phone, { x: 40, y, size: 11, font });

        // === FACTURA (lado derecho) ===
        page.drawText("FACTURA", { x: width - 150, y: height - 60, size: 28, font: fontBold });

        page.drawText(invoiceNumber, {
            x: width - 180,
            y: height - 95,
            size: 12,
            font: fontBold
        });

        page.drawText(date, {
            x: width - 180,
            y: height - 115,
            size: 12,
            font: fontBold
        });

        // === Línea azul separadora ===
        page.drawLine({
            start: { x: 40, y: height - 140 },
            end: { x: width - 40, y: height - 140 },
            thickness: 2,
            color: rgb(0.2, 0.4, 0.9)
        });

        // === Info Cliente ===
        const clientY = height - 170;

        page.drawText("Cliente:", { x: 40, y: clientY, size: 12, font: fontBold });
        page.drawText(client.name, { x: 40, y: clientY - 18, size: 11, font });

        page.drawText("CIF:", { x: 200, y: clientY, size: 12, font: fontBold });
        page.drawText(client.dni, { x: 200, y: clientY - 18, size: 11, font });

        page.drawText("Dirección:", { x: 360, y: clientY, size: 12, font: fontBold });
        page.drawText(`${client.address}, ${client.postal_code}`, {
            x: 360,
            y: clientY - 18,
            size: 11,
            font
        });

        // === Tabla de productos ===
        let tableY = clientY - 60;

        // Encabezado tabla
        page.drawText("Cantidad", { x: 40, y: tableY, font: fontBold, size: 12 });
        page.drawText("Concepto", { x: 140, y: tableY, font: fontBold, size: 12 });
        page.drawText("Precio Unit.", { x: 330, y: tableY, font: fontBold, size: 12 });
        page.drawText("Total", { x: 460, y: tableY, font: fontBold, size: 12 });

        tableY -= 25;

        let subtotal = 0;

        invoice.products.forEach(p => {
            page.drawText(`${p.units}`, { x: 40, y: tableY, size: 11, font });
            page.drawText(p.name, { x: 140, y: tableY, size: 11, font });
            page.drawText(`${p.price} €`, { x: 330, y: tableY, size: 11, font });
            page.drawText(`${p.units * p.price} €`, { x: 460, y: tableY, size: 11, font });

            subtotal += p.units * p.price;
            tableY -= 18;
        });

        // === Caja resumen ===
        const boxY = tableY - 40;

        // Subtotal
        page.drawText("Subtotal:", { x: 360, y: boxY, font: font, size: 12 });
        page.drawText(`${subtotal.toFixed(2)} €`, { x: 480, y: boxY, font: fontBold, size: 12 });

        // IVA
        const iva = subtotal * 0.21;
        page.drawText("IVA (21%):", { x: 360, y: boxY - 20, font: font, size: 12 });
        page.drawText(`${iva.toFixed(2)} €`, { x: 480, y: boxY - 20, font: fontBold, size: 12 });

        // Retención
        const ret = subtotal * 0.19;
        page.drawText("Retención (19%):", { x: 360, y: boxY - 40, font: font, size: 12 });
        page.drawText(`${ret.toFixed(2)} €`, { x: 480, y: boxY - 40, font: fontBold, size: 12 });

        // Total final
        const totalFinal = subtotal + iva - ret;

        page.drawText("TOTAL:", { x: 360, y: boxY - 80, font: fontBold, size: 16 });
        page.drawText(`${totalFinal.toFixed(2)} €`, {
            x: 480,
            y: boxY - 80,
            font: fontBold,
            size: 16,
            color: rgb(0.1, 0.3, 1)
        });

        // === Pie de página ===
        page.drawText(account, { x: 40, y: 40, size: 11, font });

        // Exportar PDF
        return await pdfDoc.save();
    }

}