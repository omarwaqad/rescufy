// lib/presentation/features/auth/views/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/register/register_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RegisterCubit>().initialize(
        context: context,
        formKey: _formKey,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: cubit.navigateBack,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Sign Up',
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Card
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create your account',
                          style: textTheme.headlineMedium,
                        ),

                        SizedBox(height: 28.h),

                        // Full Name
                        _buildTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          textTheme: textTheme,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Email
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'example@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textTheme: textTheme,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Password
                        StreamBuilder<bool>(
                          stream: cubit.obscurePasswordStream,
                          initialData: true,
                          builder: (context, snapshot) {
                            return _buildTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hint: 'Create a password',
                              icon: Icons.lock_outline_rounded,
                              obscureText: snapshot.data ?? true,
                              textTheme: textTheme,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  snapshot.data ?? true
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22.sp,
                                ),
                                onPressed: cubit.togglePasswordVisibility,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Confirm Password
                        StreamBuilder<bool>(
                          stream: cubit.obscureConfirmPasswordStream,
                          initialData: true,
                          builder: (context, snapshot) {
                            return _buildTextField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              hint: 'Re-enter password',
                              icon: Icons.lock_outline_rounded,
                              obscureText: snapshot.data ?? true,
                              textTheme: textTheme,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  snapshot.data ?? true
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22.sp,
                                ),
                                onPressed:
                                    cubit.toggleConfirmPasswordVisibility,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                        SizedBox(height: 20.h),

                        // National ID
                        _buildTextField(
                          controller: _nationalIdController,
                          label: 'National ID',
                          hint: 'Enter your national ID',
                          icon: Icons.badge_outlined,
                          textTheme: textTheme,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your national ID';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Phone Number
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+20 123 456 7890',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          textTheme: textTheme,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Age
                        _buildTextField(
                          controller: _ageController,
                          label: 'Age',
                          hint: 'Enter your age',
                          icon: Icons.calendar_today_outlined,
                          keyboardType: TextInputType.number,
                          textTheme: textTheme,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your age';
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 1 || age > 120) {
                              return 'Please enter a valid age';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 20.h),

                        // Gender Dropdown
                        StreamBuilder<String>(
                          stream: cubit.selectedGenderStream,
                          initialData: '',
                          builder: (context, snapshot) {
                            final selectedGender = snapshot.data ?? '';
                            return DropdownButtonFormField<String>(
                              value: selectedGender.isEmpty
                                  ? null
                                  : selectedGender,
                              style: textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                hintText: 'Select your gender',
                                prefixIcon: Icon(
                                  Icons.wc_outlined,
                                  size: 22.sp,
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Text('Male'),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text('Female'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  cubit.setGender(value);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select your gender';
                                }
                                return null;
                              },
                            );
                          },
                        ),

                        SizedBox(height: 32.h),

                        // Sign Up Button
                        StreamBuilder<bool>(
                          stream: cubit.isLoadingStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            final isLoading = snapshot.data ?? false;
                            return SizedBox(
                              width: double.infinity,
                              height: 56.h,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        cubit.register(
                                          fullName: _fullNameController.text
                                              .trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text
                                              .trim(),
                                          confirmPassword:
                                              _confirmPasswordController.text
                                                  .trim(),
                                          nationalId: _nationalIdController.text
                                              .trim(),
                                          phoneNumber: _phoneController.text
                                              .trim(),
                                          age: _ageController.text.trim(),
                                          gender:
                                              '', // Will use cubit's selected gender
                                        );
                                      },
                                child: isLoading
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        'Sign Up',
                                        style: textTheme.labelLarge?.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextTheme textTheme,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 22.sp),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
