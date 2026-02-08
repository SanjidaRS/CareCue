import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void exitApp(BuildContext context) {
  if (kIsWeb) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Close the browser tab to exit the app"),
      ),
    );
    return;
  }

  SystemNavigator.pop();
}


  Future<void> resetToday(BuildContext context) async {
    final meds = await FirebaseFirestore.instance
        .collection('medications')
        .get();

    for (final doc in meds.docs) {
      await doc.reference.update({'takenDoses': 0});
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Today's medications reset")));
  }

  Future<void> clearAll(BuildContext context) async {
    final meds = await FirebaseFirestore.instance
        .collection('medications')
        .get();

    for (final doc in meds.docs) {
      await doc.reference.delete();
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("All medications cleared")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text("Reset today"),
              onTap: () => resetToday(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text("Clear all medications"),
              onTap: () => clearAll(context),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
              title: const Text(
                "Exit app",
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () => exitApp(context),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About CareCue"),
              subtitle: Text(
                "CareCue helps users track daily medications and stay on schedule.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
