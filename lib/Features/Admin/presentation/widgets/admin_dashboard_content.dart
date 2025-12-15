import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/shared/constants/app_colors.dart';
import '../../../../core/shared/utils/responsive_helper.dart';

class AdminDashboardContent extends StatelessWidget {
  const AdminDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإحصائيات',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
          ResponsiveHelper.isMobile(context)
              ? Column(
                  children: [
                    _buildStatCard(
                      'المشرفين',
                      '12',
                      Icons.supervisor_account,
                      Colors.blue,
                      context,
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                    _buildStatCard(
                      'العمال',
                      '45',
                      Icons.work,
                      Colors.orange,
                      context,
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                    _buildStatCard(
                      'المستخدمين',
                      '234',
                      Icons.people,
                      Colors.green,
                      context,
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                    _buildStatCard(
                      'المناطق',
                      '8',
                      Icons.location_on,
                      Colors.purple,
                      context,
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'المشرفين',
                            '12',
                            Icons.supervisor_account,
                            Colors.blue,
                            context,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                        Expanded(
                          child: _buildStatCard(
                            'العمال',
                            '45',
                            Icons.work,
                            Colors.orange,
                            context,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'المستخدمين',
                            '234',
                            Icons.people,
                            Colors.green,
                            context,
                          ),
                        ),
                        SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
                        Expanded(
                          child: _buildStatCard(
                            'المناطق',
                            '8',
                            Icons.location_on,
                            Colors.purple,
                            context,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 24)),
          Text(
            'الإجراءات السريعة',
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 20),
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 16)),
          _buildActionCard(
            'إدارة المشرفين',
            Icons.supervisor_account,
            () {},
            context,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
          _buildActionCard(
            'إدارة العمال',
            Icons.work,
            () {},
            context,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
          _buildActionCard(
            'إدارة المناطق',
            Icons.location_on,
            () {},
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: ResponsiveHelper.getResponsiveFontSize(context, 32),
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 12)),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 24),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, 14),
              color: Colors.grey.shade600,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    VoidCallback onTap,
    BuildContext context,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.getResponsiveSpacing(context, 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: ResponsiveHelper.getResponsiveFontSize(context, 24),
            ),
            SizedBox(width: ResponsiveHelper.getResponsiveSpacing(context, 16)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, 16),
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: ResponsiveHelper.getResponsiveFontSize(context, 16),
            ),
          ],
        ),
      ),
    );
  }
}

