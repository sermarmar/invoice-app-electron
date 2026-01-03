import fs from "fs";
import path from "path";
import { openDb } from "./config/db.js";

const sqlPath = path.join(__dirname, "../database/init.sql");
const logFile = path.join(process.env.USER_DATA_PATH || __dirname, 'init.log');

function log(message) {
    try {
        const dir = path.dirname(logFile);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }
        fs.appendFileSync(logFile, new Date().toISOString() + ': ' + message + '\n');
    } catch (e) {
        console.error('Error writing log:', e);
    }
}

function run() {
    log("Starting init script");
    console.log("Checking for init.sql...");
    if (!fs.existsSync(sqlPath)) {
        const error = "No existe database/init.sql — crea el archivo con tus DDL";
        log(error);
        console.error(error);
        process.exit(1);
    }

    log("Reading SQL file...");
    console.log("Reading SQL file...");
    const sql = fs.readFileSync(sqlPath, "utf8");
    log("SQL length: " + sql.length);
    console.log("Opening database...");
    const db = openDb();
    log("DB opened");
    console.log("Executing PRAGMA...");
    db.exec("PRAGMA foreign_keys = ON;");
    log("PRAGMA executed");
    console.log("Executing init SQL...");
    db.exec(sql);
    log("Init SQL executed successfully");
    console.log("Base de datos inicializada");
    process.exit(0);
}

run();