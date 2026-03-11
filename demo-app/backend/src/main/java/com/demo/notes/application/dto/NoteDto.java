package com.demo.notes.application.dto;

import java.time.Instant;
import java.util.UUID;

public record NoteDto(UUID id, String title, String body, Instant createdAt) {}
