import { openDb } from '../../config/db.js';
import { ProductPort } from '../../ports/ProductPort.js';
import { Product } from '../../domain/models/product.js';

export class ProductRepository extends ProductPort {
    constructor() {
        super();
    }

    async findByInvoiceId(invoiceId) {
        const db = await openDb();
        const products = await db.all("SELECT * FROM products WHERE invoice_id = ?", [invoiceId]);
        return products.map(product => new Product({
            id: product.id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoice_id
        }));
    }

    async create(product) {
        const db = await openDb();
        const result = await db.run(
            `INSERT INTO products (invoice_id, name, units, price) VALUES (?, ?, ?, ?)`,
            [product.invoiceId, product.name, product.units, product.price]
        );
        return new Product({
            id: result.lastID,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
    }

    async update(id, product) {
        const db = await openDb();
        await db.run(
            `UPDATE products SET invoice_id = ?, name = ?, units = ?, price = ? WHERE id = ?`,
            [product.invoiceId, product.name, product.units, product.price, id]
        );
        return new Product({
            id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
    }

}