package com.demo.notes.infrastructure.persistence;

import jakarta.persistence.*;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "notes")
public class NoteJpaEntity {

    @Id
    private UUID id;
    private String title;
    private String body;
    private Instant createdAt;

    protected NoteJpaEntity() {}

    public NoteJpaEntity(UUID id, String title, String body, Instant createdAt) {
        this.id = id;
        this.title = title;
        this.body = body;
        this.createdAt = createdAt;
    }

    public UUID getId() { return id; }
    public String getTitle() { return title; }
    public String getBody() { return body; }
    public Instant getCreatedAt() { return createdAt; }
}
