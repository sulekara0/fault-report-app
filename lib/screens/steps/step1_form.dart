import 'package:flutter/material.dart';

class Step1Form extends StatefulWidget {
  final String fullName;
  final String phoneNumber;
  final String email;
  final Function(String) onFullNameChanged;
  final Function(String) onPhoneNumberChanged;
  final Function(String) onEmailChanged;
  final GlobalKey<FormState> formKey;

  const Step1Form({
    super.key,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.onFullNameChanged,
    required this.onPhoneNumberChanged,
    required this.onEmailChanged,
    required this.formKey,
  });

  @override
  State<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends State<Step1Form> {
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
              'İletişim Bilgileri',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Ad Soyad
            TextFormField(
              initialValue: widget.fullName,
              decoration: const InputDecoration(
                labelText: 'Ad Soyad',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: widget.onFullNameChanged,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen ad soyad giriniz';
                }
                if (value.trim().length < 3) {
                  return 'Ad soyad en az 3 karakter olmalıdır';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Telefon
            TextFormField(
              initialValue: widget.phoneNumber,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              onChanged: widget.onPhoneNumberChanged,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen telefon numarası giriniz';
                }
                if (value.trim().length < 10) {
                  return 'Geçerli bir telefon numarası giriniz';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // E-posta
            TextFormField(
              initialValue: widget.email,
              decoration: const InputDecoration(
                labelText: 'E-posta Adresi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: widget.onEmailChanged,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lütfen e-posta adresi giriniz';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Geçerli bir e-posta adresi giriniz';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
} 