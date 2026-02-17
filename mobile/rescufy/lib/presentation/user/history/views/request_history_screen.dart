// lib/presentation/features/auth/views/request_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rescufy/core/theme/colors.dart';
import 'package:rescufy/core/theme/app_text_styles.dart';

class RequestHistoryScreen extends StatelessWidget {
  const RequestHistoryScreen({super.key});

  // Mock data
  final List<Map<String, dynamic>> _requests = const [
    {
      'id': 'REQ-001',
      'date': 'Today, 10:30 AM',
      'type': 'Personal Emergency',
      'status': 'Completed',
      'statusColor': AppColors.success,
      'description': 'Chest pain and difficulty breathing',
      'ambulance': 'AMB-012',
      'ambulanceDriver': 'Ahmed Hassan',
      'hospital': 'City General Hospital',
      'responseTime': '4 mins',
      'location': '123 Main Street, Cairo',
    },
    {
      'id': 'REQ-002',
      'date': 'Yesterday, 3:45 PM',
      'type': 'Reporting for Others',
      'status': 'In Progress',
      'statusColor': AppColors.warning,
      'description': 'Car accident with multiple injuries',
      'ambulance': 'AMB-008',
      'ambulanceDriver': 'Mohamed Ali',
      'hospital': 'Emergency Medical Center',
      'responseTime': '2 mins',
      'location': '456 Ring Road, Cairo',
    },
    {
      'id': 'REQ-003',
      'date': 'Jan 15, 2026 - 8:20 PM',
      'type': 'Personal Emergency',
      'status': 'Cancelled',
      'statusColor': AppColors.error,
      'description': 'Severe allergic reaction',
      'ambulance': 'N/A',
      'ambulanceDriver': 'N/A',
      'hospital': 'N/A',
      'responseTime': 'N/A',
      'location': '789 Downtown, Cairo',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColorsDark.textPrimary
        : AppColors.textPrimary;
    final secondaryTextColor = isDark
        ? AppColorsDark.textSecondary
        : AppColors.textSecondary;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Request History',
                style: AppTextStyles.headlineMedium(
                  Colors.white,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                ),
              ),
            ),
          ),

          // Statistics Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.check_circle,
                    label: 'Completed',
                    value: '1',
                    color: AppColors.success,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                  _buildStatItem(
                    icon: Icons.access_time,
                    label: 'In Progress',
                    value: '1',
                    color: AppColors.warning,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                  _buildStatItem(
                    icon: Icons.cancel,
                    label: 'Cancelled',
                    value: '1',
                    color: AppColors.error,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),

          // Request List
          _requests.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(
                    context,
                    textColor,
                    secondaryTextColor,
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final request = _requests[index];
                      return _buildRequestCard(
                        request,
                        context,
                        isDark,
                        textColor,
                        secondaryTextColor,
                      );
                    }, childCount: _requests.length),
                  ),
                ),

          // Bottom Padding
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: AppTextStyles.headlineMedium(
            textColor,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4.h),
        Text(label, style: AppTextStyles.bodySmall(secondaryTextColor)),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.history, size: 60.sp, color: AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Request History',
            style: AppTextStyles.headlineMedium(textColor),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'Your emergency requests will appear here once you make your first request',
              style: AppTextStyles.bodyMedium(secondaryTextColor),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: 200.w,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              child: Text(
                'Make Your First Request',
                style: AppTextStyles.buttonLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(
    Map<String, dynamic> request,
    BuildContext context,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.card : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _showRequestDetails(
            context,
            request,
            isDark,
            textColor,
            secondaryTextColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ID Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        request['id'],
                        style: AppTextStyles.labelLarge(
                          AppColors.primary,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: request['statusColor'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: request['statusColor'].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: request['statusColor'],
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            request['status'],
                            style: AppTextStyles.labelMedium(
                              request['statusColor'],
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Description
                Text(
                  request['description'],
                  style: AppTextStyles.bodyLarge(
                    textColor,
                  ).copyWith(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 16.h),

                // Info Row
                Wrap(
                  spacing: 16.w,
                  runSpacing: 12.h,
                  children: [
                    _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: request['date'],
                      isDark: isDark,
                      secondaryTextColor: secondaryTextColor,
                    ),
                    _buildInfoChip(
                      icon: request['type'] == 'Personal Emergency'
                          ? Icons.person
                          : Icons.people,
                      label: request['type'],
                      isDark: isDark,
                      secondaryTextColor: secondaryTextColor,
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Ambulance & Hospital
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColorsDark.background
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.local_hospital,
                          label: request['ambulance'],
                          textColor: textColor,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 30.h,
                        color: isDark
                            ? AppColorsDark.divider
                            : AppColors.divider,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildDetailRow(
                          icon: Icons.timer_outlined,
                          label: request['responseTime'],
                          textColor: textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12.h),

                // View Details Button
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showRequestDetails(
                          context,
                          request,
                          isDark,
                          textColor,
                          secondaryTextColor,
                        ),
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        label: Text(
                          'View Details',
                          style: AppTextStyles.labelLarge(
                            AppColors.primary,
                          ).copyWith(fontWeight: FontWeight.w600),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required bool isDark,
    required Color secondaryTextColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: secondaryTextColor),
          SizedBox(width: 6.w),
          Text(label, style: AppTextStyles.bodySmall(secondaryTextColor)),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required Color textColor,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.sp, color: AppColors.primary),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodySmall(
              textColor,
            ).copyWith(fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showRequestDetails(
    BuildContext context,
    Map<String, dynamic> request,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: isDark ? AppColorsDark.surface : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Handle Bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColorsDark.divider : AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              // Header
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.description,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Request Details',
                            style: AppTextStyles.headlineMedium(
                              Colors.white,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            request['id'],
                            style: AppTextStyles.bodyMedium(
                              Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Section
                      _buildSectionHeader(
                        'Status',
                        Icons.info_outline,
                        textColor,
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: request['statusColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: request['statusColor'].withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(request['status']),
                              color: request['statusColor'],
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              request['status'],
                              style: AppTextStyles.bodyLarge(
                                request['statusColor'],
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Emergency Details
                      _buildSectionHeader(
                        'Emergency Details',
                        Icons.medical_services,
                        textColor,
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailCard(
                        [
                          {'label': 'Type', 'value': request['type']},
                          {
                            'label': 'Description',
                            'value': request['description'],
                          },
                          {'label': 'Date & Time', 'value': request['date']},
                          {'label': 'Location', 'value': request['location']},
                        ],
                        isDark,
                        textColor,
                        secondaryTextColor,
                      ),

                      SizedBox(height: 24.h),

                      // Response Details
                      _buildSectionHeader(
                        'Response Details',
                        Icons.local_hospital,
                        textColor,
                      ),
                      SizedBox(height: 12.h),
                      _buildDetailCard(
                        [
                          {'label': 'Ambulance', 'value': request['ambulance']},
                          {
                            'label': 'Driver',
                            'value': request['ambulanceDriver'],
                          },
                          {'label': 'Hospital', 'value': request['hospital']},
                          {
                            'label': 'Response Time',
                            'value': request['responseTime'],
                          },
                        ],
                        isDark,
                        textColor,
                        secondaryTextColor,
                      ),

                      SizedBox(height: 32.h),

                      // Action Buttons
                      if (request['status'] == 'Completed')
                        SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Download receipt
                            },
                            icon: const Icon(Icons.download),
                            label: Text(
                              'Download Receipt',
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.headlineSmall(
            textColor,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    List<Map<String, String>> items,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: items.map((item) {
          final isLast = item == items.last;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Text(
                      item['label']!,
                      style: AppTextStyles.bodyMedium(secondaryTextColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item['value']!,
                      style: AppTextStyles.bodyMedium(
                        textColor,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (!isLast) ...[
                SizedBox(height: 12.h),
                Divider(
                  color: isDark ? AppColorsDark.divider : AppColors.divider,
                  height: 1,
                ),
                SizedBox(height: 12.h),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Completed':
        return Icons.check_circle;
      case 'In Progress':
        return Icons.access_time;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
