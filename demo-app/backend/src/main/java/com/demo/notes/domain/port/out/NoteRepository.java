package com.demo.notes.domain.port.out;

import com.demo.notes.domain.model.Note;
import com.demo.notes.domain.model.NoteId;

import java.util.List;
import java.util.Optional;

/**
 * Output port: persistence of notes. Pure interface; no Spring/JPA.
 */
public interface NoteRepository {

    Note save(Note note);

    List<Note> findAllOrderByCreatedAtDesc();

    Optional<Note> findById(NoteId noteId);
}
