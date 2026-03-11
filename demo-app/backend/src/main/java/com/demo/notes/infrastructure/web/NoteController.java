package com.demo.notes.infrastructure.web;

import com.demo.notes.application.NotesApplicationService;
import com.demo.notes.application.dto.CreateNoteRequest;
import com.demo.notes.application.dto.NoteDto;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/notes")
public class NoteController {

    private final NotesApplicationService service;

    public NoteController(NotesApplicationService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public NoteDto create(@Valid @RequestBody CreateNoteRequest request) {
        return service.create(request);
    }

    @GetMapping
    public List<NoteDto> list() {
        return service.listAll();
    }
}
