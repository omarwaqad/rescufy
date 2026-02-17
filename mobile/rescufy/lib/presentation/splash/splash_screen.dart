// import 'package:flutter/material.dart';
// import 'package:rescufy/core/di/injection_container.dart' as di;
// import 'package:rescufy/core/navigation/app_routes.dart';
// import 'package:rescufy/data/datasources/local/auth_local_datasource.dart';
// import 'package:rescufy/domain/entities/user_role.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _decideNavigation();
//   }
//
//   void _decideNavigation() async {
//     final authLocal = di.sl<AuthLocalDatasource>();
//     final user = await authLocal.getCachedUser();
//
//     if (user == null) {
//       Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
//       return;
//     }
//
//     if (user.role == UserRole.paramedic) {
//       Navigator.pushReplacementNamed(context, AppRoutes.paramedicShell);
//     } else {
//       Navigator.pushReplacementNamed(context, AppRoutes.userHome);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(body: Center(child: CircularProgressIndicator()));
//   }
// }
