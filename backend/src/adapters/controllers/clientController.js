import { ClientService } from "../../domain/services/clientService.js";

export class ClientController {

    constructor() {
        this.clientService = new ClientService();
        this.getAllClients = this.getAllClients.bind(this);
        this.getClientById = this.getClientById.bind(this);
        this.createClient = this.createClient.bind(this);
        this.updateClient = this.updateClient.bind(this);
    }

    async getAllClients(req, res) {
        try {
            const clients = await this.clientService.getAllClients();
            if(clients.length === 0) {
                res.status(404).json({ message: "No clients found" });
            } else {
                res.status(200).json(clients);
            }
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    async getClientById(req, res) {
        try {
            const id = req.params.id;
            const client = await this.clientService.getClientById(id);
            if (client) {
                res.status(200).json(client);
            } else {
                res.status(404).json({ message: "Client not found" });
            }
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    async createClient(req, res) {
        try {
            const clientData = req.body;
            const newClient = await this.clientService.createClient(clientData);
            res.status(201).json(newClient);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

    async updateClient(req, res) {
        try {
            const id = req.params.id;
            const clientData = req.body;
            const updatedClient = await this.clientService.updateClient(id, clientData);
            res.status(200).json(updatedClient);
        } catch (error) {
            res.status(500).json({ error: error.message });
        }
    }

}