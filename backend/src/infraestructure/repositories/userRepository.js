import { User } from "../../domain/models/user.js";
import { UserPort } from "../../ports/userPort.js";
import { openDb } from "../../config/db.js";

export class UserRepository extends UserPort {
    constructor() {
        super();
    }

    async findAll() {
        const db = openDb();
        const stmt = db.prepare("SELECT * FROM users");
        const users = stmt.all();
        return users.map(user => new User(user));
    }

    async findById(id) {
        const db = openDb();
        const stmt = db.prepare(`SELECT * FROM users WHERE id = ?`);
        const user = stmt.get(id);
        if (!user) return null;
        return new User(user);
    }
}