import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';

class CreateOrGetExistingNote extends StatefulWidget {
  const CreateOrGetExistingNote({Key? key}) : super(key: key);

  @override
  State<CreateOrGetExistingNote> createState() =>
      _CreateOrGetExistingNoteState();
}

class _CreateOrGetExistingNoteState extends State<CreateOrGetExistingNote> {
  late final NotesService _notesService;
  late final TextEditingController _textController;
  DatabaseNotes? _note;

  Future<DatabaseNotes> createOrGetExistingNotes(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNotes>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNotes(owner: owner);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.updateNotes(
        note: note,
        text: text,
      );
    }
  }

  void _textControllerListner() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNotes(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListner);
    _textController.addListener(_textControllerListner);
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 48, 62, 70),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 48, 62, 70),
        title: const Text('New note'),
      ),
      body: FutureBuilder(
          future: createOrGetExistingNotes(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note...',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
