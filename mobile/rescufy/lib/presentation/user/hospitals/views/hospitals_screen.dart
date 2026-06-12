import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:rescufy/core/theme/app_spacing.dart';
import 'package:rescufy/core/theme/app_theme_tokens.dart';
import 'package:rescufy/domain/entities/hospital.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/user/hospitals/cubit/hospitals_cubit.dart';
import 'package:rescufy/presentation/user/hospitals/cubit/hospitals_state.dart';
import 'package:rescufy/presentation/user/hospitals/widgets/hospital_card.dart';
import 'package:rescufy/shared/widgets/common/app_screen_header.dart';
import 'package:rescufy/shared/widgets/common/app_tonal_icon.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  static const _fallbackCenter = LatLng(30.0444, 31.2357);
  static const _tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const _tileAttribution = '© OpenStreetMap contributors';

  static const MapOptions _fallbackMapOptions = MapOptions(
    initialCenter: _fallbackCenter,
    initialZoom: 11,
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.hospitals),
        actions: [
          IconButton(
            onPressed: () => context.read<HospitalsCubit>().loadNearbyHospitals(
              radiusKm: context.read<HospitalsCubit>().state.radiusKm,
            ),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.refresh,
          ),
          SizedBox(width: AppSpacing.xs.w),
        ],
      ),
      body: BlocBuilder<HospitalsCubit, HospitalsState>(
        builder: (context, state) {
          final hospitals = state.hospitals;

          return DecoratedBox(
            decoration: BoxDecoration(gradient: tokens.heroGradient),
            child: SafeArea(
              top: false,
              child: RefreshIndicator(
                onRefresh: () => context
                    .read<HospitalsCubit>()
                    .loadNearbyHospitals(radiusKm: state.radiusKm),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg.w,
                    AppSpacing.lg.h,
                    AppSpacing.lg.w,
                    AppSpacing.xl.h,
                  ),
                  children: [
                    _HospitalsHero(
                      title: l10n.nearbyHospitals,
                      subtitle: l10n.hospitalsSubtitle,
                      address: state.address ?? l10n.locationUnavailable,
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _MapPanel(
                      state: state,
                      options: _resolveMapOptions(state),
                      markers: _buildMarkers(state, hospitals, context),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    _SectionHeader(
                      title: l10n.liveCapacity,
                      count: hospitals.length,
                    ),
                    SizedBox(height: AppSpacing.md.h),
                    if (state.status == HospitalsStatus.loading &&
                        hospitals.isEmpty)
                      const _LoadingState()
                    else if (state.status == HospitalsStatus.error &&
                        hospitals.isEmpty)
                      _MessageState(
                        icon: Icons.location_off_outlined,
                        title: state.errorMessage == 'location_unavailable'
                            ? l10n.locationUnavailable
                            : l10n.hospitalsLoadFailed,
                        subtitle: state.errorMessage == 'location_unavailable'
                            ? l10n.enableLocationToFindHospitals
                            : state.errorMessage ?? l10n.hospitalsLoadFailed,
                        buttonLabel: l10n.retry,
                        onPressed: () => context
                            .read<HospitalsCubit>()
                            .loadNearbyHospitals(radiusKm: state.radiusKm),
                      )
                    else if (state.status == HospitalsStatus.empty)
                      _MessageState(
                        icon: Icons.local_hospital_outlined,
                        title: l10n.noHospitalsNearby,
                        subtitle: l10n.noHospitalsNearbyMessage,
                        buttonLabel: l10n.refresh,
                        onPressed: () => context
                            .read<HospitalsCubit>()
                            .loadNearbyHospitals(radiusKm: state.radiusKm),
                      )
                    else
                      ...hospitals.map(
                        (hospital) => Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                          child: HospitalCard(
                            hospital: hospital,
                            onCallPressed: () =>
                                _launchExternal(context, hospital.phoneUrl),
                            onDirectionsPressed: () => _launchExternal(
                              context,
                              hospital.directionsUrl,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  MapOptions _resolveMapOptions(HospitalsState state) {
    if (!state.hasLocation) {
      return _fallbackMapOptions;
    }

    return MapOptions(
      initialCenter: LatLng(state.latitude!, state.longitude!),
      initialZoom: 12.8,
    );
  }

  List<Marker> _buildMarkers(
    HospitalsState state,
    List<Hospital> hospitals,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final markers = <Marker>[];

    if (state.hasLocation) {
      markers.add(
        Marker(
          point: LatLng(state.latitude!, state.longitude!),
          width: 52.w,
          height: 52.w,
          child: _MapMarker(
            icon: Icons.my_location_rounded,
            color: Colors.blueAccent,
            label: l10n.yourLocation,
          ),
        ),
      );
    }

    for (final hospital in hospitals) {
      markers.add(
        Marker(
          point: LatLng(hospital.latitude, hospital.longitude),
          width: 52.w,
          height: 58.w,
          child: _MapMarker(
            icon: Icons.local_hospital_rounded,
            color: hospital.isAvailable ? Colors.redAccent : Colors.grey,
            label: hospital.name,
          ),
        ),
      );
    }

    return markers;
  }

  Future<void> _launchExternal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _HospitalsHero extends StatelessWidget {
  const _HospitalsHero({
    required this.title,
    required this.subtitle,
    required this.address,
  });

  final String title;
  final String subtitle;
  final String address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg.w),
      decoration: BoxDecoration(
        color: tokens.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
        border: Border.all(color: tokens.outlineSoft),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      child: AppScreenHeader(
        title: title,
        subtitle: subtitle,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm.w,
                vertical: AppSpacing.xs.h,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadii.pill.r),
              ),
              child: Text(
                l10n.openNow,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            SizedBox(
              width: 132.w,
              child: Text(
                address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPanel extends StatelessWidget {
  const _MapPanel({
    required this.state,
    required this.options,
    required this.markers,
  });

  final HospitalsState state;
  final MapOptions options;
  final List<Marker> markers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 260.h,
      decoration: BoxDecoration(
        color: tokens.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
        border: Border.all(color: tokens.outlineSoft),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 24.r,
            offset: Offset(0, 12.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              options: options,
              children: [
                TileLayer(
                  urlTemplate: HospitalsScreen._tileUrl,
                  userAgentPackageName: 'com.rescfy.rescufy',
                ),
                MarkerLayer(markers: markers),
                RichAttributionWidget(
                  popupBackgroundColor: tokens.surfaceRaised,
                  attributions: const [
                    TextSourceAttribution(HospitalsScreen._tileAttribution),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: AppSpacing.md.w,
            right: AppSpacing.md.w,
            top: AppSpacing.md.h,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.md.w,
                vertical: AppSpacing.sm.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppRadii.md.r),
              ),
              child: Row(
                children: [
                  AppTonalIcon(
                    icon: Icons.my_location_rounded,
                    color: theme.colorScheme.primary,
                    size: 40,
                    iconSize: 18,
                  ),
                  SizedBox(width: AppSpacing.sm.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.yourLocation,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          state.address ?? l10n.locationUnavailable,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 14.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 18.sp),
          ),
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.r),
                bottomRight: Radius.circular(8.r),
              ),
            ),
            transform: Matrix4.rotationZ(0.8),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm.w,
            vertical: AppSpacing.xs.h,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadii.pill.r),
          ),
          child: Text(
            '$count',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxl.h),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appThemeTokens;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        color: tokens.surfaceRaised,
        borderRadius: BorderRadius.circular(AppRadii.lg.r),
        border: Border.all(color: tokens.outlineSoft),
      ),
      child: Column(
        children: [
          AppTonalIcon(
            icon: icon,
            color: theme.colorScheme.primary,
            size: 56,
            iconSize: 24,
            shape: BoxShape.circle,
          ),
          SizedBox(height: AppSpacing.md.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          SizedBox(height: AppSpacing.lg.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}
