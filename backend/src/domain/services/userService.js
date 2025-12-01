import { UserRepository } from '../../infraestructure/repositories/userRepository.js';

export class UserService {
    
    constructor() {
        this.userRepository = new UserRepository();
    }

    async getAllUsers() {
        return await this.userRepository.findAll();
    }

    async getUserById(id) {
        return await this.userRepository.findById(id);
    }

}