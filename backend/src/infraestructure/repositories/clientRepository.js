import { openDb } from "../../config/db.js";
import { Client } from "../../domain/models/client.js";
import { ClientPort } from "../../ports/clientPort.js";

export class ClientRepository extends ClientPort {

  findAll() {
    const db = openDb();
    const rows = db.prepare("SELECT * FROM clients").all();
    return rows.map(row => new Client(row));
  }

  findById(id) {
    const db = openDb();
    const row = db.prepare("SELECT * FROM clients WHERE id = ?").get(id);
    if (!row) throw new Error("Client not found");
    return new Client(row);
  }

  create(client) {
    try {
      const db = openDb();
      const stmt = db.prepare(`
        INSERT INTO clients (name, dni, address, postal_code, phone, email)
        VALUES (?, ?, ?, ?, ?, ?)
      `);

      const result = stmt.run(
        client.name,
        client.dni,
        client.address,
        client.postal_code,
        client.phone,
        client.email
      );

      return new Client({ id: result.lastInsertRowid, ...client });

    } catch (err) {
      if (err.code === "SQLITE_CONSTRAINT_UNIQUE") {
        throw new Error("DNI, teléfono o email ya existe");
      }
      throw err;
    }
  }

  update(id, client) {
    const db = openDb();

    const exists = db.prepare("SELECT id FROM clients WHERE id = ?").get(id);
    if (!exists) throw new Error("Client not found");

    try {
      db.prepare(`
        UPDATE clients
        SET name = ?, dni = ?, address = ?, postal_code = ?, phone = ?, email = ?
        WHERE id = ?
      `).run(
        client.name,
        client.dni,
        client.address,
        client.postal_code,
        client.phone,
        client.email,
        id
      );

      return new Client({ id, ...client });

    } catch (err) {
      if (err.code === "SQLITE_CONSTRAINT_UNIQUE") {
        throw new Error("DNI, teléfono o email ya existe");
      }
      throw err;
    }
  }
}
