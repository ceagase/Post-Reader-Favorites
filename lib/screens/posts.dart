import 'dart:convert';
import 'package:finals_lab_exam/widgets/new_post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  static const _url = 'https://jsonplaceholder.typicode.com/posts';

  List<dynamic> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse(_url));
      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _posts = jsonDecode(response.body) as List<dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load posts (status ${response.statusCode}).';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load posts. Check your internet connection.\n$e';
        _isLoading = false;
      });
    }
  }

  Future<void> _openNewPost() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const NewPost(),
    );
    if (result == null || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result['message'] as String)));
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _fetchPosts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(child: Text('${post['id']}')),
              title: Text(
                post['title'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                post['body'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/post_details',
                  arguments: {
                    'id': post['id'],
                    'title': post['title'],
                    'body': post['body'],
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openNewPost,
        child: const Icon(Icons.add),
      ),
    );
  }
}
