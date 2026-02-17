import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        elevation: 0,
        title: Text(
          'Case History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _buildHistoryCard(
            severity: 'CRITICAL',
            severityColor: const Color(0xFFDC2626),
            title: 'Cardiac Arrest',
            caseId: 'EMR-2410',
            date: 'Feb 16, 2026 - 14:35',
            responseTime: '18m 32s',
          ),
          SizedBox(height: 16.h),
          _buildHistoryCard(
            severity: 'HIGH',
            severityColor: const Color(0xFFEA580C),
            title: 'Severe Bleeding',
            caseId: 'EMR-2409',
            date: 'Feb 16, 2026 - 09:12',
            responseTime: '12m 45s',
          ),
          SizedBox(height: 16.h),
          _buildHistoryCard(
            severity: 'MEDIUM',
            severityColor: const Color(0xFFFACC15),
            title: 'Fractured Limb',
            caseId: 'EMR-2408',
            date: 'Feb 15, 2026 - 18:47',
            responseTime: '15m 20s',
          ),
          SizedBox(height: 16.h),
          _buildHistoryCard(
            severity: 'CRITICAL',
            severityColor: const Color(0xFFDC2626),
            title: 'Stroke Symptoms',
            caseId: 'EMR-2407',
            date: 'Feb 15, 2026 - 11:23',
            responseTime: '9m 18s',
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String severity,
    required Color severityColor,
    required String title,
    required String caseId,
    required String date,
    required String responseTime,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF2A3142), width: 1),
      ),
      child: Column(
        children: [
          // Severity Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              severity,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          // Case Details
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2E),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  caseId,
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14.sp,
                      color: Colors.white54,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      date,
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.timer, size: 14.sp, color: Colors.white54),
                    SizedBox(width: 8.w),
                    Text(
                      responseTime,
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
