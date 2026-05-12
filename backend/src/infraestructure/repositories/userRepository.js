import { User } from "../../domain/models/user.js";
import { UserPort } from "../../ports/userPort.js";
import { openDb } from "../../config/db.js";

export class UserRepository extends UserPort {
    constructor() {
        super();
    }

    findAll() {
        const db = openDb();
        const rows = db.prepare("SELECT * FROM users").all();
        return rows.map(row => new User(row));
    }

    findById(id) {
        const db = openDb();
        const row = db.prepare("SELECT * FROM users WHERE id = ?").get(id);
        return row ? new User(row) : null;
    }
}