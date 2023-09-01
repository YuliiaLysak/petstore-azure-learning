package io.swagger.service;

import com.chtrembl.petstore.pet.model.Pet;
import io.swagger.repository.PetRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PetService {
    private final PetRepository petRepository;

    public PetService(PetRepository petRepository) {
        this.petRepository = petRepository;
    }

    public List<Pet> getPets() {
        return petRepository.findAll();
    }
}
