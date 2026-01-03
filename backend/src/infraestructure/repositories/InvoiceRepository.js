import { openDb } from '../../config/db.js';
import { Invoice } from '../../domain/models/invoice.js';
import { InvoicePort } from '../../ports/InvoicePort.js';

export class InvoiceRepository extends InvoicePort {
    constructor() {
        super();
    }

    findByUserId(userId) {
        const db = openDb();
        const sql = "SELECT * FROM invoices WHERE user_id = ?";
        const rows = db.prepare(sql).all(userId);
        const invoices = rows.map(invoice => new Invoice({
            id: invoice.id,
            invoiceId: invoice.invoice_id,
            userId: invoice.user_id,
            clientId: invoice.client_id,
            total: invoice.total,
            date: invoice.date
        }));
        return invoices;
    }

    findById(id) {
        const db = openDb();
        const sql = "SELECT * FROM invoices WHERE id = ?";
        const row = db.prepare(sql).get(id);
        if (!row) {
            return null;
        } else {
            const invoice = new Invoice({
                id: row.id,
                invoiceId: row.invoice_id,
                clientId: row.client_id,
                userId: row.user_id,
                amount: row.total,
                date: row.date
            });
            return invoice;
        }
    }

    create(invoice) {
        const db = openDb();
        const sql = `INSERT INTO invoices (invoice_id, user_id, client_id, date, total) VALUES (?, ?, ?, ?, ?)`;
        const stmt = db.prepare(sql);
        const result = stmt.run(invoice.invoiceId, invoice.userId, invoice.clientId, invoice.date, invoice.total);
        const newInvoice = new Invoice({
            id: result.lastInsertRowid,
            invoice_id: invoice.invoiceId,
            user_id: invoice.userId,
            client_id: invoice.clientId,
            amount: invoice.total,
            date: invoice.date,
            products: invoice.products || []
        });
        return newInvoice;
    }

    update(id, invoice) {
        const db = openDb();
        const sql = `UPDATE invoices SET client_id = ?, date = ?, total = ? WHERE id = ?`;
        const stmt = db.prepare(sql);
        stmt.run(invoice.clientId, invoice.date, invoice.total, id);
        const updatedInvoice = new Invoice({
            id,
            invoice_id: invoice.invoiceId,
            user_id: invoice.userId,
            client_id: invoice.clientId,
            amount: invoice.total || invoice.amount,
            date: invoice.date,
            products: invoice.products || []
        });
        return updatedInvoice;
    }

}