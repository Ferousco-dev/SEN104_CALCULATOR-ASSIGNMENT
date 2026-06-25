import 'package:flutter/material.dart';

import '../theme/metrics.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';
import 'calc_mode.dart';

class ModeDrawer extends StatelessWidget {
  const ModeDrawer({
    super.key,
    required this.currentMode,
    required this.onModeSelected,
  });

  final CalcMode currentMode;
  final void Function(CalcMode) onModeSelected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppMetrics.sp24,
                AppMetrics.sp24,
                AppMetrics.sp24,
                AppMetrics.sp12,
              ),
              child: Text(
                'Calculator',
                style: AppTypography.modeLabel.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: AppMetrics.sp8),
            ...CalcMode.values.map((mode) => _ModeItem(
              mode: mode,
              isActive: mode == currentMode,
              onTap: () {
                Navigator.of(context).pop();
                onModeSelected(mode);
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _ModeItem extends StatelessWidget {
  const _ModeItem({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  final CalcMode mode;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.sp20,
          vertical: AppMetrics.sp12,
        ),
        decoration: BoxDecoration(
          border: isActive
              ? Border(
                  left: BorderSide(
                    color: AppPalette.accent,
                    width: 3,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              mode.icon,
              size: 20,
              color: isActive ? AppPalette.accent : AppPalette.textSecondary,
            ),
            const SizedBox(width: AppMetrics.sp16),
            Expanded(
              child: Text(
                mode.label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.modeLabel.copyWith(
                  color: isActive ? AppPalette.accent : AppPalette.textPrimary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
