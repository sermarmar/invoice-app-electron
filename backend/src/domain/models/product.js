export class Product {
    constructor(data = {}) {
        this.id = data.id;
        this.name = data.name;
        this.price = data.price;
        this.units = data.units;
        this.invoiceId = data.invoiceId;
    }
}