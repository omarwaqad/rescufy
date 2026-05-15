import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/navigation/app_routes.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_state.dart';
import 'package:rescufy/shared/widgets/common/app_screen_header.dart';

import '../widgets/dashboard_inline_message.dart';
import '../widgets/dashboard_overview_card.dart';
import '../widgets/dashboard_status_hero.dart';
import '../widgets/dashboard_waiting_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    _initialized = true;
    context.read<DashboardCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return BlocConsumer<DashboardCubit, DashboardState>(
      listenWhen: (prev, curr) =>
          curr.incomingRequest != null &&
          curr.incomingRequest != prev.incomingRequest,
      listener: (context, state) async {
        final request = state.incomingRequest;
        if (request == null) {
          return;
        }

        await Navigator.of(
          context,
        ).pushNamed(AppRoutes.paramedicIncomingRequest, arguments: request);

        if (context.mounted) {
          context.read<DashboardCubit>().clearIncomingRequest();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: tokens.heroGradient),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg.w,
                  AppSpacing.lg.h,
                  AppSpacing.lg.w,
                  AppSpacing.xl.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.lg.h),
                    DashboardStatusHero(
                      isOnline: state.isOnline,
                      signalRStatus: state.signalRStatus,
                      onToggleAvailability: context
                          .read<DashboardCubit>()
                          .toggleAvailability,
                    ),
                    if (state.error != null) ...[
                      SizedBox(height: AppSpacing.md.h),
                      DashboardInlineMessage(
                        icon: Icons.error_outline,
                        color: theme.colorScheme.error,
                        message: state.error!,
                      ),
                    ],
                    SizedBox(height: AppSpacing.md.h),
                    DashboardOverviewCard(
                      title: 'Dispatch Monitoring',
                      subtitle: state.isOnline
                          ? 'Listening for incoming emergency requests through the mock real-time hub.'
                          : 'Go online to start receiving emergency requests.',
                      icon: Icons.wifi_tethering,
                      accentColor: tokens.info,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DashboardOverviewCard(
                      title: 'Current Workflow',
                      subtitle:
                          'Dashboard receives the request, incoming view handles accept or reject, and active case manages live treatment progress.',
                      icon: Icons.alt_route,
                      accentColor: theme.colorScheme.primary,
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    DashboardWaitingCard(
                      signalRStatus: state.signalRStatus,
                      isOnline: state.isOnline,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
