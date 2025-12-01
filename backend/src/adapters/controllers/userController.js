import { UserService } from "../../domain/services/userService.js";

export class UserController {

    constructor() {
        this.userService = new UserService();
        this.getAllUsers = this.getAllUsers.bind(this);
        this.getUserById = this.getUserById.bind(this);
    }

    async getAllUsers(req, res) {
        try {
            const users = await this.userService.getAllUsers();
            res.status(200).json(users);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    async getUserById(req, res) {
        try {
            const id = req.params.id;
            const user = await this.userService.getUserById(id);
            if (user) {
                res.status(200).json(user);
            } else {
                res.status(404).json({ message: "User not found" });
            }
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

}