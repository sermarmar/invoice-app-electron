import fs from "fs";
import path from "path";
import { openDb } from "./config/db.js";

const sqlPath = path.join(process.cwd(), "database", "init.sql");

async function run() {
    if (!fs.existsSync(sqlPath)) {
        console.error("No existe database/init.sql — crea el archivo con tus DDL");
        process.exit(1);
    }

    const sql = fs.readFileSync(sqlPath, "utf8");
    const db = await openDb();
    await db.exec("PRAGMA foreign_keys = ON;");
    await db.exec(sql);
    console.log("Base de datos inicializada");
    process.exit(0);
}

run().catch(err => {
    console.error(err);
    process.exit(1);
});