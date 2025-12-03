PRAGMA foreign_keys = ON;

-- ============================
-- 1. TABLA DE USUARIOS
-- ============================
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  name VARCHAR(25) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
  dni VARCHAR(9) NOT NULL UNIQUE,
  account VARCHAR(24) NOT NULL UNIQUE,
  address VARCHAR(100),
  postal_code VARCHAR(5),
  phone VARCHAR(15)
);


-- ============================
-- 2. TABLA DE CLIENTES
-- ============================
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(50) NOT NULL,
  dni VARCHAR(9) UNIQUE,
  address VARCHAR(100),
  postal_code VARCHAR(5),
  phone VARCHAR(15)
);



-- ============================
-- 3. TABLA DE FACTURAS
-- ============================
CREATE TABLE IF NOT EXISTS invoices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  client_id INTEGER NOT NULL,
  date DATE NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  CONSTRAINT uniq_invoices_invoice_id_user_id_client_id UNIQUE (invoice_id, user_id, client_id)
);

-- Índice para buscar facturas por usuario
CREATE INDEX IF NOT EXISTS idx_invoices_user_id ON invoices (user_id);
-- Índice para buscar facturas por cliente
CREATE INDEX IF NOT EXISTS idx_invoices_client_id ON invoices (client_id);

-- ============================
-- 4. TABLA DE PRODUCTOS
-- ============================
CREATE TABLE IF NOT EXISTS products (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(100) NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  units INTEGER NOT NULL,
  invoice_id INTEGER NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);


-- Índice para buscar productos por factura
CREATE INDEX IF NOT EXISTS idx_products_invoice_id ON products (invoice_id);