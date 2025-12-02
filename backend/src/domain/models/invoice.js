export class Invoice {
    constructor(data = {}) {
        this.id = data.id || data.ID || null;
        this.invoiceId = data.invoice_id ?? data.invoiceId ?? null;
        this.userId = data.user_id ?? data.userId ?? null;
        this.clientId = data.client_id ?? data.clientId ?? null;
        this.total = data.amount ?? data.total ?? null;
        this.date = data.date ?? null;
        this.products = data.products || data.productsList || [];
    }

}