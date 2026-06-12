import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/domain/entities/hospital.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/shared/widgets/common/app_tonal_icon.dart';

class HospitalCard extends StatelessWidget {
  const HospitalCard({
    super.key,
    required this.hospital,
    required this.onCallPressed,
    required this.onDirectionsPressed,
  });

  final Hospital hospital;
  final VoidCallback onCallPressed;
  final VoidCallback onDirectionsPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;
    final statusColor = hospital.isAvailable
        ? tokens.success
        : theme.colorScheme.error;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md.w),
      decoration: BoxDecoration(
        color: tokens.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
        border: Border.all(color: tokens.outlineSoft),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.04),
            blurRadius: 20.r,
            offset: Offset(0, 10.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92.w,
                height: 92.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.12),
                      theme.colorScheme.primary.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadii.md.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppTonalIcon(
                      icon: Icons.local_hospital_rounded,
                      color: theme.colorScheme.primary,
                      size: 44,
                      iconSize: 22,
                      shape: BoxShape.circle,
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      l10n.liveCapacity,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            hospital.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm.w),
                        _StatusChip(
                          label: _statusLabel(l10n),
                          color: statusColor,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs.h),
                    Text(
                      hospital.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    Wrap(
                      spacing: AppSpacing.sm.w,
                      runSpacing: AppSpacing.sm.h,
                      children: [
                        _InfoChip(
                          icon: Icons.bed_outlined,
                          label: l10n.availableBeds(hospital.availableBeds),
                        ),
                        _InfoChip(
                          icon: Icons.route_outlined,
                          label: l10n.distanceKm(
                            (hospital.distanceKm ?? 0).toStringAsFixed(1),
                          ),
                        ),
                        _InfoChip(
                          icon: Icons.monitor_heart_outlined,
                          label: l10n.icuAvailability(hospital.availableIcu),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Container(
            padding: EdgeInsets.all(AppSpacing.md.w),
            decoration: BoxDecoration(
              color: tokens.surfaceMuted,
              borderRadius: BorderRadius.circular(AppRadii.md.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricBlock(
                    label: l10n.openNow,
                    value: hospital.status.trim().isNotEmpty
                        ? hospital.status
                        : _statusLabel(l10n),
                  ),
                ),
                Expanded(
                  child: _MetricBlock(
                    label: l10n.liveCapacity,
                    value: '${hospital.availableBeds}/${hospital.bedCapacity}',
                  ),
                ),
                Expanded(
                  child: _MetricBlock(
                    label: 'ICU',
                    value: '${hospital.availableIcu}/${hospital.icuCapacity}',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: hospital.contactPhone.trim().isEmpty
                      ? null
                      : onCallPressed,
                  icon: const Icon(Icons.call_outlined),
                  label: Text(l10n.call),
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onDirectionsPressed,
                  icon: const Icon(Icons.navigation_outlined),
                  label: Text(l10n.directions),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n) {
    if (hospital.isAvailable) {
      return l10n.hospitalStatusAvailable;
    }

    if (hospital.status.trim().isNotEmpty) {
      return hospital.status;
    }

    return l10n.hospitalStatusUnavailable;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadii.pill.r),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm.w,
        vertical: AppSpacing.xs.h,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadii.pill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: theme.colorScheme.primary),
          SizedBox(width: 6.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        SizedBox(height: 4.h),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
