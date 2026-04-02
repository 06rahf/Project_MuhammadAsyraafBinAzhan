import 'package:flutter/material.dart';

class AcademicIntegrityPage extends StatelessWidget {
  const AcademicIntegrityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academic Integrity'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Academic Integrity Compliance Declaration',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            _buildInstructionItem(
              '1.',
              'This assessment is the sole effort of the student submitting the work.',
            ),
            _buildInstructionItem(
              '2.',
              'Wholesale copying the code of an entire project or any major feature from ANY resource is NOT ALLOWED at all.',
            ),
            _buildInstructionItem(
              '3.',
              'Any sharing of ideas or code will be considered a violation of academic integrity and will result in zero (0) mark for the assessment.',
            ),
            _buildInstructionItem(
              '4.',
              'Proper citation of reference(s), borrowed intellectual property and plagiarism declaration are made in this dedicated mobile app page.',
            ),
            _buildInstructionItem(
              '5.',
              'Students shall avoid from practicing any copyright infringement at all.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student Declaration:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'I, Muhammad Asyraaf bin Azhan, hereby declare that this project is my own work and that I have not plagiarized any part of it.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
