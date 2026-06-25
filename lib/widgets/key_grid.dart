import 'package:flutter/material.dart';

import '../theme/metrics.dart';
import 'calc_key.dart';

class KeySpec {
  const KeySpec({
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
}

class KeyGrid extends StatelessWidget {
  const KeyGrid({super.key, required this.rows});

  final List<List<KeySpec>> rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppMetrics.sp8,
        AppMetrics.sp8,
        AppMetrics.sp8,
        AppMetrics.sp20,
      ),
      child: Column(
        children: rows.map(_buildRow).toList(),
      ),
    );
  }

  Widget _buildRow(List<KeySpec> specs) {
    return Row(
      children: specs.map((s) => CalcKey(
        label: s.label,
        subLabel: s.subLabel,
        onTap: s.onTap,
        variant: s.variant,
        flex: s.flex,
        enabled: s.enabled,
      )).toList(),
    );
  }
}
