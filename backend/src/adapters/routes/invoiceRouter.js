import express from "express";
import { InvoiceController } from "../controllers/InvoiceController.js";

export function invoiceRouter() {
    const router = express.Router();
    const controller = new InvoiceController();

    router.get("/user/:userId", controller.getInvoicesByUserId);
    router.get("/:id", controller.getInvoiceById);
    router.post("/", controller.createInvoice);
    router.put("/:id", controller.updateInvoice);

    return router;
}