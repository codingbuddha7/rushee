package com.demo.notes.application;

import com.demo.notes.application.dto.CreateNoteRequest;
import com.demo.notes.application.dto.NoteDto;
import com.demo.notes.domain.model.Note;
import com.demo.notes.domain.port.out.NoteRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class NotesApplicationService {

    private final NoteRepository noteRepository;

    public NotesApplicationService(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    @Transactional
    public NoteDto create(CreateNoteRequest request) {
        Note note = Note.create(request.title(), request.body());
        note = noteRepository.save(note);
        return toDto(note);
    }

    @Transactional(readOnly = true)
    public List<NoteDto> listAll() {
        return noteRepository.findAllOrderByCreatedAtDesc().stream()
                .map(this::toDto)
                .toList();
    }

    private NoteDto toDto(Note note) {
        return new NoteDto(
                note.getId().value(),
                note.getTitle(),
                note.getBody(),
                note.getCreatedAt()
        );
    }
}
