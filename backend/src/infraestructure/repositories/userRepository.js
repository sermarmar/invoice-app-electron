import { User } from "../../domain/models/user.js";
import { UserPort } from "../../ports/userPort.js";
import { openDb } from "../../config/db.js";

export class UserRepository extends UserPort {
    constructor() {
        super();
    }

    async findAll() {
        const db = await openDb();
        const users = await db.all("SELECT * FROM users");
        return users.map(user => new User(user));
    }

    async findById(id) {
        const db = await openDb();
        const user = await db.get(`SELECT * FROM users WHERE id = ?`, [id]);
        if (!user) return null;
        return new User(user);
    }
}