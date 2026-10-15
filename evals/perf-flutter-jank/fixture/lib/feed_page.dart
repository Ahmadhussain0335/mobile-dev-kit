import 'dart:convert';

import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key, required this.rawJson});

  final String rawJson;

  @override
  Widget build(BuildContext context) {
    final items = (jsonDecode(rawJson) as List).cast<Map<String, dynamic>>();
    return ListView(
      children: items
          .map((item) => ListTile(
                leading: Image.network(item['image'] as String),
                title: Text(item['title'] as String),
              ))
          .toList(),
    );
  }
}
