package com.demo.notes.infrastructure.persistence;

import com.demo.notes.domain.model.Note;
import com.demo.notes.domain.model.NoteId;
import com.demo.notes.domain.port.out.NoteRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public class JpaNoteRepository implements NoteRepository {

    private final SpringDataNoteRepository springRepo;

    public JpaNoteRepository(SpringDataNoteRepository springRepo) {
        this.springRepo = springRepo;
    }

    @Override
    public Note save(Note note) {
        NoteJpaEntity entity = new NoteJpaEntity(
                note.getId().value(),
                note.getTitle(),
                note.getBody(),
                note.getCreatedAt()
        );
        springRepo.save(entity);
        return note;
    }

    @Override
    public List<Note> findAllOrderByCreatedAtDesc() {
        return springRepo.findAllByOrderByCreatedAtDesc().stream()
                .map(this::toDomain)
                .toList();
    }

    @Override
    public Optional<Note> findById(NoteId noteId) {
        return springRepo.findById(noteId.value()).map(this::toDomain);
    }

    private Note toDomain(NoteJpaEntity e) {
        return Note.fromPersistence(
                NoteId.of(e.getId()),
                e.getTitle(),
                e.getBody(),
                e.getCreatedAt()
        );
    }
}
