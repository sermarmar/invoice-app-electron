export class User {

    constructor(data = {}) {
        this.id = data.id;
        this.username = data.username;
        this.name = data.name;
        this.apellidos = data.apellidos;
        this.dni = data.dni;
        this.account = data.account;
        this.address = data.address;
        this.postal_code = data.postal_code;
        this.phone = data.phone;
    }

}