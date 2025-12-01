import express from "express";
import { ClientController } from "../controllers/clientController.js";

export function clientRouter() {
    const router = express.Router();
    const controller = new ClientController();

    router.get("/", controller.getAllClients);
    router.get("/:id", controller.getClientById);
    router.post("/", controller.createClient);
    router.put("/:id", controller.updateClient);

    return router;
}