PRAGMA foreign_keys = ON;

-- ============================
-- 1. TABLA DE USUARIOS
-- ============================
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  name VARCHAR(25) NOT NULL,
  apellidos VARCHAR(50) NOT NULL,
);

INSERT INTO users (username, name, apellidos, email, password) VALUES
('maite', 'Maite', 'Martín Gastelut'),
('elo', 'Eloisa', 'Martín Gastelut');

-- ============================
-- 2. TABLA DE CLIENTES
-- ============================
CREATE TABLE IF NOT EXISTS clients (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name VARCHAR(50) NOT NULL
);


INSERT INTO clients (name) VALUES
('Tienda');

-- ============================
-- 3. TABLA DE FACTURAS
-- ============================
CREATE TABLE IF NOT EXISTS invoices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  client_id INTEGER NOT NULL,
  date DATE NOT NULL,
  total_iva DECIMAL(10, 2) NOT NULL,
  recession DECIMAL(10, 2) NOT NULL,
  total DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
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
CREATE INDEX IF NOT EXISTS idx_products_factura_id ON products (invoice_id);