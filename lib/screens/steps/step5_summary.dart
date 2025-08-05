import 'package:flutter/material.dart';

class Step5Summary extends StatefulWidget {
  final String summary;
  final Function(String) onSummaryChanged;
  final GlobalKey<FormState> formKey;

  const Step5Summary({
    super.key,
    required this.summary,
    required this.onSummaryChanged,
    required this.formKey,
  });

  @override
  State<Step5Summary> createState() => _Step5SummaryState();
}

class _Step5SummaryState extends State<Step5Summary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Adım 5',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bu adım için içerik henüz eklenmedi.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 