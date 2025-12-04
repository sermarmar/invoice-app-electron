import { openDb } from '../../config/db.js';
import { Invoice } from '../../domain/models/invoice.js';
import { InvoicePort } from '../../ports/InvoicePort.js';

export class InvoiceRepository extends InvoicePort {
    constructor() {
        super();
    }

    async findByUserId(userId) {
        const db = await openDb();
        const invoices = await db.all("SELECT * FROM invoices WHERE user_id = ?", [userId]);
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
        const db = await openDb();
        const invoice = await db.get("SELECT * FROM invoices WHERE id = ?", [id]);
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
        const db = await openDb();
        const result = await db.run(
            `INSERT INTO invoices (invoice_id, user_id, client_id, date, total) VALUES (?, ?, ?, ?, ?)`,
            [invoice.invoiceId, invoice.userId, invoice.clientId, invoice.date, invoice.total]
        );
        return new Invoice({
            id: result.lastID,
            invoice_id: invoice.invoiceId,
            user_id: invoice.userId,
            client_id: invoice.clientId,
            amount: invoice.total,
            date: invoice.date,
            products: invoice.products || []
        });
    }

    async update(id, invoice) {
        const db = await openDb();
        await db.run(
            `UPDATE invoices SET client_id = ?, date = ?, total = ? WHERE id = ?`,
            [invoice.clientId, invoice.date, invoice.total, id]
        );
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