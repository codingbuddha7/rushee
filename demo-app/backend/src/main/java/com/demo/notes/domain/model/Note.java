package com.demo.notes.domain.model;

import com.demo.notes.domain.event.NoteCreated;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Aggregate root: Note. No public setters; state changes through behaviour.
 */
public class Note {

    private final NoteId id;
    private String title;
    private String body;
    private final Instant createdAt;

    private Note(NoteId id, String title, String body, Instant createdAt) {
        this.id = id;
        this.title = title;
        this.body = body;
        this.createdAt = createdAt;
    }

    public static Note create(String title, String body) {
        NoteId id = NoteId.create();
        Instant now = Instant.now();
        Note note = new Note(id, title, body, now);
        note.registerEvent(new NoteCreated(id, title, body, now));
        return note;
    }

    /** Reconstitute from persistence (no domain event). */
    public static Note fromPersistence(NoteId id, String title, String body, Instant createdAt) {
        return new Note(id, title, body, createdAt);
    }

    private final List<Object> domainEvents = new ArrayList<>();

    private void registerEvent(Object event) {
        domainEvents.add(event);
    }

    public List<Object> getDomainEvents() {
        return new ArrayList<>(domainEvents);
    }

    public void clearDomainEvents() {
        domainEvents.clear();
    }

    public NoteId getId() { return id; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public Instant getCreatedAt() { return createdAt; }
}
