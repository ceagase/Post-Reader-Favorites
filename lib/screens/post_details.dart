import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PostDetails extends StatelessWidget {
  const PostDetails({super.key});

  void _saveToFavorites(BuildContext context, Map<String, dynamic> post) {
    final box = Hive.box('favoritesBox');
    final id = post['id'];

    if (box.containsKey(id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This post is already in your favorites.'),
        ),
      );
      return;
    }

    box.put(id, {
      'id': id,
      'title': post['title'],
      'body': post['body'],
      'note': '',
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved to favorites!')));
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final box = Hive.box('favoritesBox');

    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post #${args['id']}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            Text(
              args['title'],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(args['body'], style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            ValueListenableBuilder<Box>(
              valueListenable: box.listenable(keys: [args['id']]),
              builder: (context, box, _) {
                final isSaved = box.containsKey(args['id']);
                return SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: isSaved
                        ? null
                        : () => _saveToFavorites(context, args),
                    icon: Icon(isSaved ? Icons.check : Icons.favorite_border),
                    label: Text(isSaved ? 'Saved' : 'Save to Favorites'),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Posts'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
