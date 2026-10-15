package com.example.shared

import android.content.Context
import java.io.File

class NoteRepository(private val context: Context, private val api: NotesApi) {
    private val cache = File(context.cacheDir, "notes.json")

    suspend fun refresh(): List<Note> {
        val notes = api.fetchNotes()
        cache.writeText(notes.joinToString("\n") { it.title })
        return notes
    }
}
