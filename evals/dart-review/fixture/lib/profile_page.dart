import 'package:flutter/material.dart';

import 'profile_api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.api});

  final ProfileApi api;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();

  Future<void> _save() async {
    await widget.api.saveName(_nameController.text);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TextField(controller: _nameController),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        child: const Icon(Icons.save),
      ),
    );
  }
}
