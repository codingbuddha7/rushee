package com.demo.notes.domain.event;

import com.demo.notes.domain.model.NoteId;

import java.time.Instant;

/**
 * Domain event: a note was created.
 */
public record NoteCreated(NoteId noteId, String title, String body, Instant createdAt) {}
