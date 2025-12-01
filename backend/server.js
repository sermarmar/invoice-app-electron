import express from "express";
import cors from "cors";
import { userRouter } from "./src/adapters/routes/userRouter.js";

const app = express();
app.use(cors());
app.use(express.json());

// Inyección de dependencias
//const productRepo = new SQLiteProductRepository();
//const productService = new ProductService(productRepo);
//const productController = createProductController(productService);
const userRouterInstance = userRouter();

// Montar rutas
app.use("/api/users", userRouterInstance);

// Error handler centralizado
app.use((err, req, res, next) => {
  console.error(err);
  if (err && err.status) {
    return res.status(err.status).json({ message: err.message });
  }
  res.status(500).json({ message: "Internal Server Error" });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`Backend escuchando en http://localhost:${PORT}`);
});