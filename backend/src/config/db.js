import Database from "better-sqlite3";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let db;

export function openDb() {
    if (!db) {
        const dbPath = path.join(__dirname, "../../database/app.db");

        db = new Database(dbPath);

        // Activar foreign keys
        db.pragma("foreign_keys = ON");
    }

    return db;
}