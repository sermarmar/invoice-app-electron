import express from "express";
import cors from "cors";
import { userRouter } from "./src/adapters/routes/userRouter.js";
import { clientRouter } from "./src/adapters/routes/clientRouter.js";

const app = express();
app.use(cors());
app.use(express.json());

const userRouterInstance = userRouter();
const clientRouterInstance = clientRouter();

// Montar rutas
app.use("/api/users", userRouterInstance);
app.use("/api/clients", clientRouterInstance);

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