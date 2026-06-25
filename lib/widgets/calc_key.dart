import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/metrics.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';

enum KeyVariant { number, function, accent }

class CalcKey extends StatefulWidget {
  const CalcKey({
    super.key,
    required this.label,
    required this.onTap,
    this.variant = KeyVariant.number,
    this.subLabel,
    this.flex = 1,
    this.enabled = true,
  });

  final String label;
  final String? subLabel;
  final VoidCallback onTap;
  final KeyVariant variant;
  final int flex;
  final bool enabled;

  @override
  State<CalcKey> createState() => _CalcKeyState();
}

class _CalcKeyState extends State<CalcKey> {
  bool _pressed = false;

  Color get _idleColor => switch (widget.variant) {
    KeyVariant.number => AppPalette.keyNumber,
    KeyVariant.function => AppPalette.surfaceRaised,
    KeyVariant.accent => AppPalette.accent,
  };

  Color get _pressedColor => switch (widget.variant) {
    KeyVariant.number => AppPalette.keyPressed,
    KeyVariant.function => AppPalette.keyPressed,
    KeyVariant.accent => AppPalette.accentPressed,
  };

  Color get _labelColor => switch (widget.variant) {
    KeyVariant.accent => AppPalette.bg,
    _ => AppPalette.textPrimary,
  };

  void _handleTapDown(TapDownDetails _) {
    HapticFeedback.selectionClick();
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    setState(() => _pressed = false);
    widget.onTap();
  }

  void _handleTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.sp4),
        child: GestureDetector(
          onTapDown: widget.enabled ? _handleTapDown : null,
          onTapUp: widget.enabled ? _handleTapUp : null,
          onTapCancel: widget.enabled ? _handleTapCancel : null,
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              constraints: const BoxConstraints(minHeight: AppMetrics.keyMinHeight),
              decoration: BoxDecoration(
                color: _pressed ? _pressedColor : _idleColor,
                borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
              ),
              child: Center(
                child: widget.subLabel != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label,
                            style: AppTypography.keyLabelSmall.copyWith(color: _labelColor),
                          ),
                          Text(
                            widget.subLabel!,
                            style: AppTypography.hint.copyWith(
                              color: _labelColor.withAlpha(160),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        widget.label,
                        style: AppTypography.keyLabel.copyWith(color: _labelColor),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
