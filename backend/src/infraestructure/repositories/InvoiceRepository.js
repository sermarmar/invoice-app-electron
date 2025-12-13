import { openDb } from '../../config/db.js';
import { Invoice } from '../../domain/models/invoice.js';
import { InvoicePort } from '../../ports/InvoicePort.js';

export class InvoiceRepository extends InvoicePort {
    constructor() {
        super();
    }

    async findByUserId(userId) {
        const db = openDb();
        const stmt = db.prepare("SELECT * FROM invoices WHERE user_id = ?");
        const invoices = stmt.all(userId);
        return invoices.map(invoice => new Invoice({
            id: invoice.id,
            invoiceId: invoice.invoice_id,
            userId: invoice.user_id,
            clientId: invoice.client_id,
            total: invoice.total,
            date: invoice.date
        }));
    }

    async findById(id) {
        const db = openDb();
        const stmt = db.prepare("SELECT * FROM invoices WHERE id = ?");
        const invoice = stmt.get(id);
        if (!invoice) return null;
        return new Invoice({
            id: invoice.id,
            invoiceId: invoice.invoice_id,
            clientId: invoice.client_id,
            userId: invoice.user_id,
            amount: invoice.total,
            date: invoice.date
        });
    }

    async create(invoice) {
        const db = openDb();
        const stmt = db.prepare(
            `INSERT INTO invoices (invoice_id, user_id, client_id, date, total) VALUES (?, ?, ?, ?, ?)`
        );
        const result = stmt.run(invoice.invoiceId, invoice.userId, invoice.clientId, invoice.date, invoice.total);
        return new Invoice({
            id: result.lastInsertRowid,
            invoice_id: invoice.invoiceId,
            user_id: invoice.userId,
            client_id: invoice.clientId,
            amount: invoice.total,
            date: invoice.date,
            products: invoice.products || []
        });
    }

    async update(id, invoice) {
        const db = openDb();
        const stmt = db.prepare(
            `UPDATE invoices SET client_id = ?, date = ?, total = ? WHERE id = ?`
        );
        stmt.run(invoice.clientId, invoice.date, invoice.total, id);
        return new Invoice({
            id,
            invoice_id: invoice.invoiceId,
            user_id: invoice.userId,
            client_id: invoice.clientId,
            amount: invoice.total || invoice.amount,
            date: invoice.date,
            products: invoice.products || []
        });
    }

}