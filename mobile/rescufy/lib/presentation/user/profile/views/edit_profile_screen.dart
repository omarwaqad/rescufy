import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/presentation/user/profile/cubit/profile_cubit.dart';
import 'package:rescufy/presentation/user/profile/cubit/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bloodTypeController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _medicalNotesController;

  bool _pregnancyStatus = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _bloodTypeController = TextEditingController(text: state.bloodType);
    _weightController = TextEditingController(
      text: state.weightKg > 0 ? state.weightKg.toString() : '',
    );
    _heightController = TextEditingController(
      text: state.heightCm > 0 ? state.heightCm.toString() : '',
    );
    _medicalNotesController = TextEditingController(text: state.medicalNotes);
    _pregnancyStatus = state.pregnancyStatus;
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _medicalNotesController.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      bloodType: _bloodTypeController.text,
      weightKg: int.parse(_weightController.text.trim()),
      heightCm: int.parse(_heightController.text.trim()),
      pregnancyStatus: _pregnancyStatus,
      medicalNotes: _medicalNotesController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            previous.isUpdating != current.isUpdating ||
            previous.updateError != current.updateError ||
            previous.updateSuccess != current.updateSuccess,
        listener: (context, state) {
          if (!state.isUpdating && state.updateSuccess != null) {
            Navigator.of(context).pop();
          } else if (!state.isUpdating && state.updateError != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.updateError!),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.fullName,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(state.email, style: theme.textTheme.bodyMedium),
                          if (state.phone.trim().isNotEmpty) ...[
                            SizedBox(height: 4.h),
                            Text(state.phone, style: theme.textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _LabeledField(
                    label: 'Blood Type',
                    child: TextFormField(
                      controller: _bloodTypeController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter blood type',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Blood type is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _LabeledField(
                    label: 'Weight (kg)',
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter weight in kg',
                      ),
                      validator: _validatePositiveInt,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _LabeledField(
                    label: 'Height (cm)',
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Enter height in cm',
                      ),
                      validator: _validatePositiveInt,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Pregnancy Status'),
                    subtitle: Text(
                      _pregnancyStatus ? 'Pregnant' : 'Not Pregnant',
                    ),
                    value: _pregnancyStatus,
                    onChanged: state.isUpdating
                        ? null
                        : (value) {
                            setState(() {
                              _pregnancyStatus = value;
                            });
                          },
                  ),
                  SizedBox(height: 8.h),
                  _LabeledField(
                    label: 'Medical Notes',
                    child: TextFormField(
                      controller: _medicalNotesController,
                      maxLines: 5,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'Add medical notes',
                      ),
                    ),
                  ),
                  SizedBox(height: 28.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.isUpdating ? null : _save,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: state.isUpdating
                            ? SizedBox(
                                height: 20.h,
                                width: 20.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Save Changes'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String? _validatePositiveInt(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'This field is required';
    }

    final parsed = int.tryParse(normalized);
    if (parsed == null) {
      return 'Enter a valid integer';
    }

    if (parsed <= 0) {
      return 'Value must be greater than 0';
    }

    return null;
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }
}
