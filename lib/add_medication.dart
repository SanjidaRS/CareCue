import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController(
    text: '1',
  );

  String _selectedTime = 'Morning';

  Future<void> _saveMedication() async {
    final name = _nameController.text.trim();
    final dose = int.tryParse(_doseController.text) ?? 1;

    if (name.isEmpty || dose <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid name and dose')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('medications').add({
      'name': name,
      'time': _selectedTime,
      'dose': dose,
      'takenDoses': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: backgroundColor, // light grey
      appBar: AppBar(title: const Text('Add Medication')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Medication Name'),
            TextField(controller: _nameController),

            const SizedBox(height: 16),

            const Text('Pills per time'),
            TextField(
              controller: _doseController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            const Text('Time of day'),
            Wrap(
              spacing: 10,
              children: ['Morning', 'Afternoon', 'Night'].map((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: _selectedTime == t,
                  onSelected: (_) => setState(() => _selectedTime = t),
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 2,
                ),
                onPressed: _saveMedication,
                child: const Text(
                  'Save Medication',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
