import 'package:flutter/material.dart';
import 'steps/step1_form.dart';
import 'steps/step2_fault_type.dart';
import 'steps/step3_location.dart';
import 'steps/step4_description.dart';
import 'steps/step5_summary.dart';

class FaultFormSteps extends StatefulWidget {
  const FaultFormSteps({super.key});

  @override
  State<FaultFormSteps> createState() => _FaultFormStepsState();
}

class _FaultFormStepsState extends State<FaultFormSteps> {
  int _currentStep = 0;
  
  // Form verileri
  String _fullName = '';
  String _phoneNumber = '';
  String _email = '';
  String _selectedFaultType = '';
  String _location = '';
  String _description = '';
  String _summary = '';
  
  // Form key'leri
  final GlobalKey<FormState> _step1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step3FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step4FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _step5FormKey = GlobalKey<FormState>();

  void _nextStep() {
    if (_currentStep < 4) {
      // Mevcut adımın validasyonunu kontrol et
      bool canProceed = false;
      
      switch (_currentStep) {
        case 0:
          canProceed = _step1FormKey.currentState!.validate();
          break;
        case 1:
          canProceed = _selectedFaultType.isNotEmpty;
          break;
        case 2:
          canProceed = _location.isNotEmpty;
          break;
        case 3:
          canProceed = _step4FormKey.currentState!.validate();
          break;
        case 4:
          canProceed = _step5FormKey.currentState!.validate();
          break;
      }
      
      if (canProceed) {
        setState(() {
          _currentStep++;
        });
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitForm() {
    // Form verilerini işleme
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Arıza talebiniz başarıyla gönderildi!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  Widget _getCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Step1Form(
          fullName: _fullName,
          phoneNumber: _phoneNumber,
          email: _email,
          onFullNameChanged: (value) => setState(() => _fullName = value),
          onPhoneNumberChanged: (value) => setState(() => _phoneNumber = value),
          onEmailChanged: (value) => setState(() => _email = value),
          formKey: _step1FormKey,
        );
      case 1:
        return Step2FaultType(
          selectedFaultType: _selectedFaultType,
          onFaultTypeChanged: (value) => setState(() => _selectedFaultType = value),
          formKey: _step2FormKey,
        );
      case 2:
        return Step3Location(
          location: _location,
          onLocationChanged: (value) => setState(() => _location = value),
          formKey: _step3FormKey,
        );
      case 3:
        return Step4Description(
          description: _description,
          onDescriptionChanged: (value) => setState(() => _description = value),
          formKey: _step4FormKey,
        );
      case 4:
        return Step5Summary(
          summary: _summary,
          onSummaryChanged: (value) => setState(() => _summary = value),
          formKey: _step5FormKey,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arıza Formu'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentStep 
                          ? const Color(0xFF2196F3) 
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          
          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Adım ${_currentStep + 1}/5',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getStepTitle(_currentStep),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Current Step Content
          Expanded(
            child: _getCurrentStep(),
          ),
          
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF2196F3)),
                      ),
                      child: const Text('Geri'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep == 4 ? _submitForm : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(_currentStep == 4 ? 'Gönder' : 'İleri'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'İletişim Bilgileri';
      case 1:
        return 'Arıza Türü';
      case 2:
        return 'Konum';
      case 3:
        return 'Açıklama';
      case 4:
        return 'Özet';
      default:
        return '';
    }
  }
} 
