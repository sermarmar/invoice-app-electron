import { openDb } from '../../config/db.js';
import { ProductPort } from '../../ports/ProductPort.js';
import { Product } from '../../domain/models/product.js';

export class ProductRepository extends ProductPort {
    constructor() {
        super();
    }

    async findByInvoiceId(invoiceId) {
        const db = openDb();
        const stmt = db.prepare("SELECT * FROM products WHERE invoice_id = ?");
        const products = stmt.all(invoiceId);
        return products.map(product => new Product({
            id: product.id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoice_id
        }));
    }

    async create(product) {
        const db = openDb();
        const stmt = db.prepare(
            `INSERT INTO products (invoice_id, name, units, price) VALUES (?, ?, ?, ?)`
        );
        const result = stmt.run(product.invoiceId, product.name, product.units, product.price);
        return new Product({
            id: result.lastInsertRowid,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
    }

    async update(id, product) {
        const db = openDb();
        const stmt = db.prepare(
            `UPDATE products SET invoice_id = ?, name = ?, units = ?, price = ? WHERE id = ?`
        );
        stmt.run(product.invoiceId, product.name, product.units, product.price, id);
        return new Product({
            id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
    }

    async delete(id) {
        const db = openDb();
        const stmt = db.prepare(
            `DELETE FROM products WHERE id = ?`
        );
        stmt.run(id);
    }

}