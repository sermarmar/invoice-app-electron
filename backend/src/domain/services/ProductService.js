import { ProductRepository } from "../../infraestructure/repositories/ProductRepository.js";
import { InvoiceService } from "./InvoiceService.js";

export class ProductService {

    constructor() {
        this.productRepository = new ProductRepository();
    }

    async getProductsByInvoiceId(invoiceId) {
        return await this.productRepository.findByInvoiceId(invoiceId);
    }

    async addProductToInvoice(product) {
        return await this.productRepository.create(product);
    }

    async updateProducts(invoiceId, products) {
        // eliminar productos que ya no están en la lista entrante
        const productsExisting = await this.productRepository.findByInvoiceId(invoiceId);

        for (const product of products) {
            if (product.id) {
                await this.productRepository.update(product.id, product);
            } else {
                product.invoiceId = invoiceId;
                await this.productRepository.create(product);
            }
        }

        const incomingIds = products.filter(p => p.id).map(p => p.id);
        const removed = productsExisting.filter(pe => !incomingIds.includes(pe.id));

        for (const r of removed) {
            await this.productRepository.delete(r.id);
        }
    }

}