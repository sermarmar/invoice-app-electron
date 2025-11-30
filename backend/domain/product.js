export class Product {
    constructor(id, name, price = 0.0, units = 0, invoinceId) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.units = units;
        this.invoinceId = invoinceId;
    }
}