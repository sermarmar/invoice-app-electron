import { Invoice } from '../../domain/models/invoice.js';
import { InvoiceService } from '../../domain/services/InvoiceService.js';
import { InvoiceResource } from '../resource/InvoiceResource.js';
import { InvoiceResponse } from '../resource/InvoiceResponse.js';
import { GeneratePDFService } from '../../domain/services/GeneratePDFService.js';

export class InvoiceController {

    constructor() {
        this.invoiceService = new InvoiceService();
        this.generateInvoicePDFService = new GeneratePDFService();
        this.getInvoicesByUserId = this.getInvoicesByUserId.bind(this);
        this.getInvoiceById = this.getInvoiceById.bind(this);
        this.createInvoice = this.createInvoice.bind(this);
        this.updateInvoice = this.updateInvoice.bind(this);
        this.generateInvoicePDF = this.generateInvoicePDF.bind(this);
    }

    async getInvoicesByUserId(req, res) {
        try {
            const userId = parseInt(req.params.userId, 10);
            const invoices = await this.invoiceService.getInvoicesByUserId(userId);
            if(!invoices) {
                res.status(404).json({ message: 'Invoices not found' });
            } else {
                res.json(invoices.map(invoice => new InvoiceResponse(invoice)));
            }
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }

    async getInvoiceById(req, res) {
        try {
            const id = parseInt(req.params.id, 10);
            const invoice = await this.invoiceService.getInvoiceById(id);
            if (!invoice) {
                return res.status(404).json({ message: 'Invoice not found' });
            }
            res.json(new Invoice(invoice));
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }

    async createInvoice(req, res) {
        try {
            const invoiceData = req.body;
            const invoiceCommand = new InvoiceResource(invoiceData)
            const newInvoice = await this.invoiceService.createInvoice(invoiceCommand);
            res.status(201).json(new Invoice(newInvoice));
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }

    async updateInvoice(req, res) {
        try {
            const id = parseInt(req.params.id, 10);
            const invoiceData = req.body;
            const invoiceCommand = new InvoiceResource(invoiceData)
            const updatedInvoice = await this.invoiceService.updateInvoice(id, invoiceCommand);
            if (!updatedInvoice) {
                return res.status(404).json({ message: 'Invoice not found' });
            }
            res.json(new Invoice(updatedInvoice));
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }

    async generateInvoicePDF(req, res) {
        try {
            const id = parseInt(req.params.id, 10);
            const pdfBytes = await this.generateInvoicePDFService.generateInvoicePDF(id);
            res.setHeader('Content-Type', 'application/pdf');
            res.setHeader('Content-Disposition', `attachment; filename=invoice_${id}.pdf`);
            res.setHeader('Content-Length', pdfBytes.length);
            res.send(Buffer.from(pdfBytes));
        } catch (error) {
            console.error('Error al generar factura PDF:', error);
            res.status(500).json({ success: false, error: error.message });
        }

    }

}