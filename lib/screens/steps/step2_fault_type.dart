import 'package:flutter/material.dart';

class Step2FaultType extends StatefulWidget {
  final String selectedFaultType;
  final Function(String) onFaultTypeChanged;
  final GlobalKey<FormState> formKey;

  const Step2FaultType({
    super.key,
    required this.selectedFaultType,
    required this.onFaultTypeChanged,
    required this.formKey,
  });

  @override
  State<Step2FaultType> createState() => _Step2FaultTypeState();
}

class _Step2FaultTypeState extends State<Step2FaultType> {
  bool _showFaultTypeOptions = false;
  
  final List<String> _faultTypes = [
    'Su kesintisi',
    'Kanalizasyon tıkanıklığı',
    'Musluk patlaması',
    'Sayaç arızası',
    'Diğer',
  ];

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
              'Arıza Türü Seçin',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Arıza türü seçim butonu
            GestureDetector(
              onTap: () {
                setState(() {
                  _showFaultTypeOptions = !_showFaultTypeOptions;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.grey),
                    const SizedBox(width: 12),
                    Text(
                      widget.selectedFaultType.isEmpty 
                          ? 'Arıza türü seçin' 
                          : widget.selectedFaultType,
                      style: TextStyle(
                        color: widget.selectedFaultType.isEmpty 
                            ? Colors.grey 
                            : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _showFaultTypeOptions 
                          ? Icons.keyboard_arrow_up 
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            
            // Seçenekler listesi
            if (_showFaultTypeOptions) ...[
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  children: _faultTypes.map((faultType) {
                    return GestureDetector(
                      onTap: () {
                        widget.onFaultTypeChanged(faultType);
                        setState(() {
                          _showFaultTypeOptions = false;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: widget.selectedFaultType == faultType 
                              ? const Color(0xFF2196F3).withOpacity(0.1)
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.selectedFaultType == faultType 
                                    ? const Color(0xFF2196F3)
                                    : Colors.grey.shade300,
                              ),
                              child: widget.selectedFaultType == faultType
                                  ? const Icon(
                                      Icons.check,
                                      size: 14,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                faultType,
                                style: TextStyle(
                                  color: widget.selectedFaultType == faultType 
                                      ? const Color(0xFF2196F3)
                                      : Colors.black87,
                                  fontWeight: widget.selectedFaultType == faultType 
                                      ? FontWeight.w600 
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
            
            // Validasyon mesajı
            if (widget.selectedFaultType.isEmpty && _showFaultTypeOptions == false)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Lütfen bir arıza türü seçin',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 