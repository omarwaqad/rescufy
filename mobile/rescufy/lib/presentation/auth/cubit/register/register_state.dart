import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.name = '',
    this.email = '',
    this.userName = '',
    this.password = '',
    this.nationalId = '',
    this.age = '',
    this.gender = '',
    this.profileImagePath,
    this.nameError,
    this.emailError,
    this.userNameError,
    this.passwordError,
    this.nationalIdError,
    this.ageError,
    this.genderError,
    this.obscurePassword = true,
    this.showValidation = false,
  });

  final String name;
  final String email;
  final String userName;
  final String password;
  final String nationalId;
  final String age;
  final String gender;
  final String? profileImagePath;
  final String? nameError;
  final String? emailError;
  final String? userNameError;
  final String? passwordError;
  final String? nationalIdError;
  final String? ageError;
  final String? genderError;
  final bool obscurePassword;
  final bool showValidation;

  int? get parsedAge => int.tryParse(age.trim());
  bool get hasProfileImage =>
      profileImagePath != null && profileImagePath!.trim().isNotEmpty;
  bool get isValid =>
      nameError == null &&
      emailError == null &&
      userNameError == null &&
      passwordError == null &&
      nationalIdError == null &&
      ageError == null &&
      genderError == null;

  RegisterState copyWith({
    String? name,
    String? email,
    String? userName,
    String? password,
    String? nationalId,
    String? age,
    String? gender,
    String? profileImagePath,
    String? nameError,
    String? emailError,
    String? userNameError,
    String? passwordError,
    String? nationalIdError,
    String? ageError,
    String? genderError,
    bool? obscurePassword,
    bool? showValidation,
    bool clearNameError = false,
    bool clearEmailError = false,
    bool clearUserNameError = false,
    bool clearPasswordError = false,
    bool clearNationalIdError = false,
    bool clearAgeError = false,
    bool clearGenderError = false,
    bool clearProfileImagePath = false,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      nationalId: nationalId ?? this.nationalId,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      profileImagePath: clearProfileImagePath
          ? null
          : (profileImagePath ?? this.profileImagePath),
      nameError: clearNameError ? null : (nameError ?? this.nameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      userNameError: clearUserNameError
          ? null
          : (userNameError ?? this.userNameError),
      passwordError: clearPasswordError
          ? null
          : (passwordError ?? this.passwordError),
      nationalIdError: clearNationalIdError
          ? null
          : (nationalIdError ?? this.nationalIdError),
      ageError: clearAgeError ? null : (ageError ?? this.ageError),
      genderError: clearGenderError ? null : (genderError ?? this.genderError),
      obscurePassword: obscurePassword ?? this.obscurePassword,
      showValidation: showValidation ?? this.showValidation,
    );
  }

  @override
  List<Object?> get props => [
    name,
    email,
    userName,
    password,
    nationalId,
    age,
    gender,
    profileImagePath,
    nameError,
    emailError,
    userNameError,
    passwordError,
    nationalIdError,
    ageError,
    genderError,
    obscurePassword,
    showValidation,
  ];
}
