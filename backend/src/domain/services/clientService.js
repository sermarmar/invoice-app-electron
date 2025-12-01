import { ClientRepository } from "../../infraestructure/repositories/clientRepository.js";
import { ConflictError } from '../errors/ConflictError.js';
import { ValidationError } from '../errors/ValidationError.js';
import { NotFoundError } from '../errors/NotFoundError.js';

export class ClientService {

    constructor() {
        this.clientRepository = new ClientRepository();
    }

    async getAllClients() {
        return await this.clientRepository.findAll();
    }

    async getClientById(id) {
        return await this.clientRepository.findById(id);
    }

    async createClient(client) {
        try {
            // Verificar si existe un cliente con ese ID
            const existingClient = await this.clientRepository.findById(client.id);
            if (existingClient) {
                throw new ConflictError("Client with this ID already exists");
            }

            // Validación completa
            await this.validatedClient(client);

            return await this.clientRepository.create(client);

        } catch (error) {

            if (error instanceof ValidationError || error instanceof ConflictError) {
                throw error;
            }

            throw new Error(`Error creating client: ${error.message}`);
        }
    }

    async updateClient(id, client) {
        try {
            // Verificar si existe
            const existingClient = await this.clientRepository.findById(id);
            if (!existingClient) {
                throw new NotFoundError("Client not found");
            }

            // Validación completa
            await this.validatedClient({ ...client, id });

            // Actualizar solo campos enviados
            existingClient.name = client.name ?? existingClient.name;
            existingClient.dni = client.dni ?? existingClient.dni;
            existingClient.address = client.address ?? existingClient.address;
            existingClient.postal_code = client.postal_code ?? existingClient.postal_code;
            existingClient.phone = client.phone ?? existingClient.phone;

            return await this.clientRepository.update(id, existingClient);

        } catch (error) {
            if (
                error instanceof NotFoundError ||
                error instanceof ValidationError ||
                error instanceof ConflictError
            ) {
                throw error;
            }

            throw new Error(`Error updating client: ${error.message}`);
        }
    }

    async validatedClient(client) {

        // DNI obligatorio
        if (!client.dni || client.dni.trim() === "") {
            throw new ValidationError("DNI cannot be empty");
        }

        // Formato DNI
        if (!/^[0-9]{8}[A-Za-z]$/.test(client.dni)) {
            throw new ValidationError("DNI format is invalid");
        }

        // Código postal (opcional)
        if (client.postal_code && !/^[0-9]{5}$/.test(client.postal_code)) {
            throw new ValidationError("Postal code format is invalid");
        }

        // Teléfono (opcional)
        if (client.phone && !/^[0-9]{9}$/.test(client.phone)) {
            throw new ValidationError("Phone format is invalid");
        }

        // Validar que no exista otro cliente con el mismo DNI
        const clients = await this.clientRepository.findAll();

        const duplicateDniClient = clients.find(c =>
            c.dni === client.dni && c.id !== client.id
        );

        if (duplicateDniClient) {
            throw new ConflictError("DNI must be unique");
        }
    }
}