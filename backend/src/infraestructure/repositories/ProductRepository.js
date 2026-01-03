import { openDb } from '../../config/db.js';
import { ProductPort } from '../../ports/ProductPort.js';
import { Product } from '../../domain/models/product.js';

export class ProductRepository extends ProductPort {
    constructor() {
        super();
    }

    findByInvoiceId(invoiceId) {
        const db = openDb();
        const sql = "SELECT * FROM products WHERE invoice_id = ?";
        const rows = db.prepare(sql).all(invoiceId);
        const products = rows.map(product => new Product({
            id: product.id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoice_id
        }));
        return products;
    }

    create(product) {
        const db = openDb();
        const sql = `INSERT INTO products (invoice_id, name, units, price) VALUES (?, ?, ?, ?)`;
        const stmt = db.prepare(sql);
        const result = stmt.run(product.invoiceId, product.name, product.units, product.price);
        const newProduct = new Product({
            id: result.lastInsertRowid,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
        return newProduct;
    }

    update(id, product) {
        const db = openDb();
        const sql = `UPDATE products SET invoice_id = ?, name = ?, units = ?, price = ? WHERE id = ?`;
        const stmt = db.prepare(sql);
        stmt.run(product.invoiceId, product.name, product.units, product.price, id);
        const updatedProduct = new Product({
            id,
            name: product.name,
            price: product.price,
            units: product.units,
            invoiceId: product.invoiceId
        });
        return updatedProduct;
    }

    delete(id) {
        const db = openDb();
        const sql = `DELETE FROM products WHERE id = ?`;
        const stmt = db.prepare(sql);
        stmt.run(id);
    }

}