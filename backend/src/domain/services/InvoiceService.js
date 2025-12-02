
import { InvoiceResponse } from '../../adapters/resource/InvoiceResponse.js';
import { InvoiceRepository } from '../../infraestructure/repositories/InvoiceRepository.js';
import { ClientRepository } from '../../infraestructure/repositories/clientRepository.js';
import { ProductService } from './ProductService.js';

export class InvoiceService {

    constructor() {
        this.invoiceRepository = new InvoiceRepository();
        this.clientRepository = new ClientRepository();
        this.productService = new ProductService();
    }

    async getInvoicesByUserId(userId) {
        const invoices = await this.invoiceRepository.findByUserId(userId);
        const invoicesData = [];

        for (const invoice of invoices) {
            const products = await this.productService.getProductsByInvoiceId(invoice.id);
            const client = await this.clientRepository.findById(invoice.clientId);
            invoicesData.push({
                ...invoice,
                client,
                products
            });
        }

        return invoicesData.map(invoice => new InvoiceResponse(invoice));
    }

    async getInvoiceById(id) {
        const invoice = await this.invoiceRepository.findById(id);
        const products = await this.productService.getProductsByInvoiceId(invoice.id);
        const client = await this.clientRepository.findById(invoice.clientId);
        const invoiceData = {
            ...invoice,
            client,
            products
        };
        return new InvoiceResponse(invoiceData);
    } 

    async createInvoice(invoiceCommand) {
        if (!invoiceCommand.invoiceId) {
            const userId = invoiceCommand.userId;
            const invoices = await this.invoiceRepository.findByUserId(userId);

            const lastNumber = (invoices && invoices.length)
                ? invoices.reduce((max, inv) => {
                    const n = Number(inv.invoiceId);
                    return Number.isFinite(n) ? Math.max(max, n) : max;
                  }, 0)
                : 0;

            invoiceCommand.invoiceId = String(lastNumber + 1);
        }

        const createdInvoice = await this.invoiceRepository.create(invoiceCommand);

        for (const product of invoiceCommand.products || []) {
            product.invoiceId = createdInvoice.id;
            await this.productService.addProductToInvoice(product);
        }

        return createdInvoice;
    }

    async updateInvoice(id, invoiceCommand) {
        const updatedInvoice = await this.invoiceRepository.update(id, invoiceCommand);

        await this.productService.updateProducts(id, invoiceCommand.products || []);

        updatedInvoice.products = await this.productService.getProductsByInvoiceId(id);

        return updatedInvoice;
    }
}