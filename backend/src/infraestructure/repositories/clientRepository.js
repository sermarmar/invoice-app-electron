import { openDb } from "../../config/db.js";
import { Client } from "../../domain/models/client.js";
import { ClientPort } from "../../ports/clientPort.js";

export class ClientRepository extends ClientPort {
    
    constructor() {
        super();
    }

    async findAll() {
        const db = await openDb();
        const clients = await db.all("SELECT * FROM clients");
        return clients.map(client => new Client(client));
    }

    async findById(id) {
        const db = await openDb();
        const client = await db.get(`SELECT * FROM clients WHERE id = ?`, [id]);
        if (!client) return null;
        return new Client(client);
    }

    async create(client) {
        const db = await openDb();
        const result = await db.run(
            `INSERT INTO clients (name, dni, address, postal_code, phone) VALUES (?, ?, ?, ?, ?)`,
            [client.name, client.dni, client.address, client.postal_code, client.phone]
        );
        return new Client({ id: result.lastID, ...client });
    }

    async update(id, client) {
        const db = await openDb();
        await db.run(
            `UPDATE clients SET name = ?, dni = ?, address = ?, postal_code = ?, phone = ? WHERE id = ?`,
            [client.name, client.dni, client.address, client.postal_code, client.phone, id]
        );
        return new Client({ id, ...client });
    }
}