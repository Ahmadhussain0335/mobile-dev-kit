import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key, required this.onCancel, required this.onHelp});

  final VoidCallback onCancel;
  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your order'),
          actions: [IconButton(onPressed: onHelp, icon: const Icon(Icons.help_outline))],
        ),
        body: Column(
          children: [
            Image.asset('assets/courier.png', semanticLabel: 'Courier on the way'),
            GestureDetector(onTap: onCancel, child: const Text('Cancel order')),
          ],
        ),
      ),
    );
  }
}
