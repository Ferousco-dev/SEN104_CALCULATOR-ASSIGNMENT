import 'package:flutter/material.dart';

import '../theme/metrics.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';

class CalcDisplay extends StatelessWidget {
  const CalcDisplay({
    super.key,
    required this.expression,
    required this.result,
    this.errorMessage,
  });

  final String expression;
  final String result;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppMetrics.sp24,
        AppMetrics.sp20,
        AppMetrics.sp24,
        AppMetrics.sp16,
      ),
      decoration: BoxDecoration(
        color: AppPalette.surfaceRaised,
        borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (expression.isNotEmpty)
            Text(
              expression,
              style: AppTypography.expressionLine.copyWith(
                color: AppPalette.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          const SizedBox(height: AppMetrics.sp8),
          if (errorMessage != null)
            Text(
              errorMessage!,
              style: AppTypography.keyLabelSmall.copyWith(
                color: const Color(0xFFCF6679),
              ),
              textAlign: TextAlign.end,
            )
          else
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                result.isEmpty ? '0' : result,
                style: AppTypography.displayValue.copyWith(
                  color: AppPalette.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
