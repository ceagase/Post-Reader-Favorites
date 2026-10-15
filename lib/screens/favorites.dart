import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/notes.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  Future<void> _editNote(
    BuildContext context,
    Box box,
    dynamic key,
    Map<String, dynamic> fav,
  ) async {
    final newNote = await showDialog<String>(
      context: context,
      builder: (_) => Notes(initialNote: fav['note'] ?? ''),
    );
    if (newNote == null) return;

    await box.put(key, {...fav, 'note': newNote});
  }

  void _delete(BuildContext context, Box box, dynamic key, String title) {
    box.delete(key);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('"$title" removed from favorites')));
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('favoritesBox');

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder<Box>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No favorites yet. Open a post and save it!'),
            );
          }

          final keys = box.keys.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              final key = keys[index];
              // READ
              final fav = Map<String, dynamic>.from(box.get(key) as Map);
              final note = (fav['note'] ?? '') as String;

              return Dismissible(
                key: ValueKey(key),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _delete(context, box, key, fav['title']),
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(
                      fav['title'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fav['body'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (note.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Note: $note',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_note),
                          tooltip: 'Edit note',
                          onPressed: () => _editNote(context, box, key, fav),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Remove',
                          onPressed: () =>
                              _delete(context, box, key, fav['title']),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
