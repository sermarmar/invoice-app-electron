export class Client {
    constructor(data = {}) {
        this.id = data.id;
        this.name = data.name;
        this.dni = data.dni;
        this.address = data.address;
        this.postal_code = data.postal_code;
        this.phone = data.phone;
    }
}