// lib/presentation/user/profile/widgets/edit_bottom_sheet.dart
// Pure UI — zero Bloc imports. All logic via callbacks.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/colors.dart';

// ──────────────────────────────────────────────────────────
// MEDICAL INFO SHEET
// ──────────────────────────────────────────────────────────
class EditMedicalInfoSheet extends StatefulWidget {
  final String pregnancyStatus;
  final String medicalNotes;
  final void Function(String pregnancyStatus, String medicalNotes) onSave;

  const EditMedicalInfoSheet({
    super.key,
    required this.pregnancyStatus,
    required this.medicalNotes,
    required this.onSave,
  });

  @override
  State<EditMedicalInfoSheet> createState() => _EditMedicalInfoSheetState();
}

class _EditMedicalInfoSheetState extends State<EditMedicalInfoSheet> {
  late final TextEditingController _notesCtrl;
  late String _selectedStatus;
  final _formKey = GlobalKey<FormState>();

  static const _statuses = ['Not Pregnant', 'Pregnant', 'Unknown', 'N/A'];

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController(text: widget.medicalNotes);
    _selectedStatus = _statuses.contains(widget.pregnancyStatus)
        ? widget.pregnancyStatus
        : _statuses.first;
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: 'Edit Medical Information',
      icon: Icons.medical_information,
      iconColor: AppColors.primary,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave(_selectedStatus, _notesCtrl.text.trim());
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FieldLabel('Pregnancy Status'),
            SizedBox(height: 8.h),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: _inputDecoration('Select status'),
              items: _statuses
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStatus = v!),
            ),
            SizedBox(height: 20.h),
            _FieldLabel('Medical Notes'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: _inputDecoration('e.g. Regular checkups needed'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// MEDICATION SHEET
// ──────────────────────────────────────────────────────────
class EditMedicationSheet extends StatefulWidget {
  final Map<String, String>? existing; // null = add mode
  final void Function(Map<String, String> data) onSave;

  const EditMedicationSheet({super.key, this.existing, required this.onSave});

  @override
  State<EditMedicationSheet> createState() => _EditMedicationSheetState();
}

class _EditMedicationSheetState extends State<EditMedicationSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _dosageCtrl;
  late final TextEditingController _freqCtrl;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _dosageCtrl = TextEditingController(text: widget.existing?['dosage'] ?? '');
    _freqCtrl = TextEditingController(
      text: widget.existing?['frequency'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dosageCtrl.dispose();
    _freqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: _isEdit ? 'Edit Medication' : 'Add Medication',
      icon: Icons.medication,
      iconColor: AppColors.primary,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave({
            'name': _nameCtrl.text.trim(),
            'dosage': _dosageCtrl.text.trim(),
            'frequency': _freqCtrl.text.trim(),
          });
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _RequiredField(
              ctrl: _nameCtrl,
              label: 'Medication Name',
              hint: 'e.g. Albuterol Inhaler',
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _dosageCtrl,
              label: 'Dosage',
              hint: 'e.g. 2 puffs / 500mg',
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _freqCtrl,
              label: 'Frequency',
              hint: 'e.g. Daily / As needed',
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// ALLERGY SHEET
// ──────────────────────────────────────────────────────────
class EditAllergySheet extends StatefulWidget {
  final Map<String, String>? existing;
  final void Function(Map<String, String> data) onSave;

  const EditAllergySheet({super.key, this.existing, required this.onSave});

  @override
  State<EditAllergySheet> createState() => _EditAllergySheetState();
}

class _EditAllergySheetState extends State<EditAllergySheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _notesCtrl;
  late String _selectedSeverity;
  final _formKey = GlobalKey<FormState>();

  static const _severities = ['Mild', 'Moderate', 'Severe'];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _notesCtrl = TextEditingController(text: widget.existing?['notes'] ?? '');
    final existingSeverity = widget.existing?['severity'] ?? '';
    _selectedSeverity = _severities.contains(existingSeverity)
        ? existingSeverity
        : _severities.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Color get _severityColor => _selectedSeverity == 'Severe'
      ? Colors.red
      : _selectedSeverity == 'Moderate'
      ? Colors.orange
      : Colors.yellow.shade700;

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: _isEdit ? 'Edit Allergy' : 'Add Allergy',
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave({
            'name': _nameCtrl.text.trim(),
            'severity': _selectedSeverity,
            'notes': _notesCtrl.text.trim(),
          });
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RequiredField(
              ctrl: _nameCtrl,
              label: 'Allergy Name',
              hint: 'e.g. Penicillin',
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Severity'),
            SizedBox(height: 8.h),
            Row(
              children: _severities.map((s) {
                final isSelected = _selectedSeverity == s;
                final color = s == 'Severe'
                    ? Colors.red
                    : s == 'Moderate'
                    ? Colors.orange
                    : Colors.yellow.shade700;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: s != _severities.last ? 8.w : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSeverity = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? color.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected ? color : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          s,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected ? color : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Notes (optional)'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: _inputDecoration('e.g. Causes hives and swelling'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// DISEASE SHEET
// ──────────────────────────────────────────────────────────
class EditDiseaseSheet extends StatefulWidget {
  final Map<String, String>? existing;
  final void Function(Map<String, String> data) onSave;

  const EditDiseaseSheet({super.key, this.existing, required this.onSave});

  @override
  State<EditDiseaseSheet> createState() => _EditDiseaseSheetState();
}

class _EditDiseaseSheetState extends State<EditDiseaseSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _yearCtrl;
  late String _selectedSeverity;
  final _formKey = GlobalKey<FormState>();

  static const _severities = ['Mild', 'Moderate', 'Severe'];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _yearCtrl = TextEditingController(
      text: widget.existing?['diagnosed_year'] ?? '',
    );
    final existingSeverity = widget.existing?['severity'] ?? '';
    _selectedSeverity = _severities.contains(existingSeverity)
        ? existingSeverity
        : _severities.first;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: _isEdit ? 'Edit Disease' : 'Add Chronic Disease',
      icon: Icons.local_hospital,
      iconColor: Colors.purple,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave({
            'name': _nameCtrl.text.trim(),
            'severity': _selectedSeverity,
            'diagnosed_year': _yearCtrl.text.trim(),
          });
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RequiredField(
              ctrl: _nameCtrl,
              label: 'Disease Name',
              hint: 'e.g. Asthma',
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Severity'),
            SizedBox(height: 8.h),
            Row(
              children: _severities.map((s) {
                final isSelected = _selectedSeverity == s;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: s != _severities.last ? 8.w : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSeverity = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.purple.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected
                                ? Colors.purple
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Text(
                          s,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected ? Colors.purple : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _yearCtrl,
              label: 'Year Diagnosed',
              hint: 'e.g. 2015',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SURGERY SHEET
// ──────────────────────────────────────────────────────────
class EditSurgerySheet extends StatefulWidget {
  final Map<String, String>? existing;
  final void Function(Map<String, String> data) onSave;

  const EditSurgerySheet({super.key, this.existing, required this.onSave});

  @override
  State<EditSurgerySheet> createState() => _EditSurgerySheetState();
}

class _EditSurgerySheetState extends State<EditSurgerySheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _notesCtrl;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _yearCtrl = TextEditingController(text: widget.existing?['year'] ?? '');
    _notesCtrl = TextEditingController(text: widget.existing?['notes'] ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: _isEdit ? 'Edit Surgery' : 'Add Past Surgery',
      icon: Icons.healing,
      iconColor: Colors.teal,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave({
            'name': _nameCtrl.text.trim(),
            'year': _yearCtrl.text.trim(),
            'notes': _notesCtrl.text.trim(),
          });
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _RequiredField(
              ctrl: _nameCtrl,
              label: 'Surgery Name',
              hint: 'e.g. Appendectomy',
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _yearCtrl,
              label: 'Year',
              hint: 'e.g. 2018',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            _FieldLabel('Notes (optional)'),
            SizedBox(height: 8.h),
            TextFormField(
              controller: _notesCtrl,
              maxLines: 2,
              decoration: _inputDecoration('e.g. No complications'),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// CONTACT SHEET
// ──────────────────────────────────────────────────────────
class EditContactSheet extends StatefulWidget {
  final Map<String, String>? existing;
  final void Function(Map<String, String> data) onSave;

  const EditContactSheet({super.key, this.existing, required this.onSave});

  @override
  State<EditContactSheet> createState() => _EditContactSheetState();
}

class _EditContactSheetState extends State<EditContactSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _relationCtrl;
  final _formKey = GlobalKey<FormState>();

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?['name'] ?? '');
    _phoneCtrl = TextEditingController(text: widget.existing?['phone'] ?? '');
    _relationCtrl = TextEditingController(
      text: widget.existing?['relation'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _relationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SheetScaffold(
      title: _isEdit ? 'Edit Contact' : 'Add Emergency Contact',
      icon: Icons.contact_phone,
      iconColor: Colors.red,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          widget.onSave({
            'name': _nameCtrl.text.trim(),
            'phone': _phoneCtrl.text.trim(),
            'relation': _relationCtrl.text.trim(),
          });
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _RequiredField(
              ctrl: _nameCtrl,
              label: 'Full Name',
              hint: 'e.g. John Doe',
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _phoneCtrl,
              label: 'Phone Number',
              hint: 'e.g. +1 (555) 987-6543',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.h),
            _RequiredField(
              ctrl: _relationCtrl,
              label: 'Relation',
              hint: 'e.g. Spouse / Parent / Sibling',
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────
// SHARED PRIVATE HELPERS
// ──────────────────────────────────────────────────────────

class _SheetScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Widget child;
  final VoidCallback onSave;

  const _SheetScaffold({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 12.h, bottom: 20.h),
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ),
          // Title row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          child,
          SizedBox(height: 24.h),
          // Save button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _RequiredField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  const _RequiredField({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        SizedBox(height: 8.h),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? '$label is required' : null,
        ),
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
  );
}
