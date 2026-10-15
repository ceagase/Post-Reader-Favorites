import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  final String initialNote;
  const Notes({super.key, required this.initialNote});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personal Note'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 100,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Write a short note...',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          child: const Text('Save'),
        ),
      ],
    );
  }
}