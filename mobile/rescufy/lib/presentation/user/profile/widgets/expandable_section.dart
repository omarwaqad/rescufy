// lib/presentation/features/profile/widgets/expandable_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final List<Widget> children;
  final Color? color;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.icon,
    required this.count,
    required this.children,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: color ?? theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text('$count ${count == 1 ? 'item' : 'items'}'),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
