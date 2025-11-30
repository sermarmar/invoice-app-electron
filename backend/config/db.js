import sqlite3 from "sqlite3";
import { open } from "sqlite";

export async function openDb() {
    const dbPath = path.join(__dirname, "../../database/app.db");
    return open({
        filename: dbPath,
        driver: sqlite3.Database
    });
}