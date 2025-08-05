import 'package:flutter/material.dart';

class Step4Description extends StatefulWidget {
  final String description;
  final Function(String) onDescriptionChanged;
  final GlobalKey<FormState> formKey;

  const Step4Description({
    super.key,
    required this.description,
    required this.onDescriptionChanged,
    required this.formKey,
  });

  @override
  State<Step4Description> createState() => _Step4DescriptionState();
}

class _Step4DescriptionState extends State<Step4Description> {
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
              'Adım 4',
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