
export class InvoiceResource {
    
    constructor(invoice) {
        this.id = invoice.id;
        this.invoiceId = invoice.invoiceId;
        this.userId = invoice.userId;
        this.clientId = invoice.clientId;
        this.date = invoice.date;
        this.products = invoice.products.map(product => ({
            id: product.id,
            invoiceId: product.invoiceId,
            name: product.name,
            units: product.units,
            price: product.price
        }));
        this.total = invoice.total;
    }

}