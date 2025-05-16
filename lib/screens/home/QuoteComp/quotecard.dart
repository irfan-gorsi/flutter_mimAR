import 'package:flutter/material.dart';

class QuoteCard extends StatelessWidget {
  final String text;
  final String author;

  const QuoteCard({
    super.key,
    required this.text,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"$text"',
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '- $author',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
