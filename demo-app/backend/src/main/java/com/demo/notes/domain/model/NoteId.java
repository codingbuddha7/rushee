package com.demo.notes.domain.model;

import java.util.UUID;

/**
 * Value object: identity of a Note.
 */
public record NoteId(UUID value) {
    public static NoteId create() {
        return new NoteId(UUID.randomUUID());
    }

    public static NoteId of(UUID value) {
        return new NoteId(value);
    }
}
