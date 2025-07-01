import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notepad/core/providers/auth_provider.dart';
import 'package:notepad/features/auth/domain/auth_service_provider.dart';

class AddNoteScreen extends ConsumerWidget {
  String? title;
  String? message;
   AddNoteScreen({super.key,this.title,this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteRepo = ref.read(noteRepositoryProvider);
    final user = ref.read(authServiceProvider).currentUser;

    // Text controllers
    final titleController = TextEditingController(text: title);
    final noteController = TextEditingController(text: message);

  

    Future<void> saveNote() async {
      final title = titleController.text.trim();
      final message = noteController.text.trim();

      if (title.isEmpty && message.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please write something to save")),
        );
        return;
      }

      try {
        await noteRepo.addNote(
          uid: user!.uid,
          title: title,
          message: message,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note added successfully")),
        );

        Navigator.pop(context); // Go back to notes list or home
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
         
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveNote,
            tooltip: 'Save',
          ),
          SizedBox(width: 15,)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Title',
                ),
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: noteController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write your note here...',
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
