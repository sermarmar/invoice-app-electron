import express from "express";
import { UserController } from "../controllers/userController.js";

export function userRouter() {
    const router = express.Router();
    const controller = new UserController();

    router.get("/", controller.getAllUsers);
    router.get("/:id", controller.getUserById);

    return router;
}