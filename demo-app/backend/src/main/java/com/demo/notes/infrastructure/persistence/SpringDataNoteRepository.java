package com.demo.notes.infrastructure.persistence;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SpringDataNoteRepository extends JpaRepository<NoteJpaEntity, UUID> {

    List<NoteJpaEntity> findAllByOrderByCreatedAtDesc();
}
