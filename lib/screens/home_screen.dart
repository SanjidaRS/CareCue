import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../add_medication.dart';
import '../widgets/medication_card.dart';
import '../theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Stream<QuerySnapshot> _medsStream() {
    return FirebaseFirestore.instance
        .collection('medications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
          );
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _medsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text(
                        "Loading...",
                        style: TextStyle(color: Colors.grey),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    int remaining = 0;
                    for (final d in docs) {
                      final data = d.data() as Map<String, dynamic>;
                      final int dose = (data['dose'] ?? 1) as int;
                      final int taken = (data['takenDoses'] ?? 0) as int;
                      remaining += (dose - taken).clamp(0, dose);
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hello there!!",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        if (docs.isEmpty)
                          const Text(
                            "No medications added yet.",
                            style: TextStyle(color: Colors.grey),
                          )
                        else if (remaining > 0)
                          Text(
                            "You have $remaining pills left today",
                            style: const TextStyle(color: Colors.redAccent),
                          )
                        else
                          Row(
                            children: const [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "All medications taken for today!",
                                style: TextStyle(color: Colors.green),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// MEDICATION LIST
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _medsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.medication_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "No medications yet",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Tap + to add your first medication",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;

                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final data =
                            doc.data() as Map<String, dynamic>;

                        final String name =
                            (data['name'] ?? 'Unnamed').toString();
                        final String time =
                            (data['time'] ?? 'No time').toString();
                        final int dose = (data['dose'] ?? 1) as int;
                        final int taken =
                            (data['takenDoses'] ?? 0) as int;

                        return MedicationCard(
                          name: name,
                          subtitle:
                              "$taken / $dose pills • $time",
                          completed: taken >= dose,

                          
                          onTap: () {
                            if (taken < dose) {
                              doc.reference.update({
                                'takenDoses': taken + 1,
                              });
                            } else {
                              doc.reference.update({
                                'takenDoses': 0,
                              });
                            }
                          },

                          
                          onLongPress: () {
                            if (taken > 0) {
                              doc.reference.update({
                                'takenDoses': taken - 1,
                              });
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
