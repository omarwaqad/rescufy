// lib/presentation/features/profile/widgets/profile_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final VoidCallback onEditPressed;
  final VoidCallback onUploadImagePressed;
  final VoidCallback onDeleteImagePressed;
  final bool isUploadingImage;
  final bool isDeletingImage;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.onEditPressed,
    required this.onUploadImagePressed,
    required this.onDeleteImagePressed,
    this.isUploadingImage = false,
    this.isDeletingImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Profile Picture
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child:
                      profileImageUrl != null &&
                          profileImageUrl!.trim().isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            profileImageUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50.sp,
                          color: theme.colorScheme.primary,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isUploadingImage || isDeletingImage
                          ? null
                          : onUploadImagePressed,
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: isUploadingImage
                            ? SizedBox(
                                width: 16.w,
                                height: 16.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.add_a_photo,
                                size: 16.sp,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
                if (profileImageUrl != null &&
                    profileImageUrl!.trim().isNotEmpty)
                  Positioned(
                    top: -4.h,
                    right: -4.w,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isUploadingImage || isDeletingImage
                            ? null
                            : onDeleteImagePressed,
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: isDeletingImage
                              ? SizedBox(
                                  width: 14.w,
                                  height: 14.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Icon(
                                  Icons.delete_outline,
                                  size: 14.sp,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 16.h),

            // User Info
            Text(
              fullName,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 4.h),

            Text(email, style: theme.textTheme.bodyMedium),

            if (phone.trim().isNotEmpty) ...[
              SizedBox(height: 2.h),
              Text(phone, style: theme.textTheme.bodySmall),
            ],

            SizedBox(height: 16.h),

            // Edit Profile Button
            OutlinedButton.icon(
              onPressed: onEditPressed,
              icon: Icon(Icons.edit, size: 18.sp),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
