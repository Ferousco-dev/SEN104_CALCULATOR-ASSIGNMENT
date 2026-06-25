import 'package:flutter/material.dart';

import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import 'statistics_controller.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key, required this.controller});
  final StatisticsController controller;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final _inputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _inputCtrl.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final ctrl = widget.controller;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppMetrics.sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter numbers',
            style: AppTypography.hint.copyWith(color: AppPalette.textSecondary),
          ),
          const SizedBox(height: AppMetrics.sp8),
          TextField(
            controller: _inputCtrl,
            minLines: 3,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            style: AppTypography.keyLabelSmall.copyWith(
              color: AppPalette.textPrimary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            decoration: InputDecoration(
              hintText: 'Comma or space separated — e.g. 1, 2, 3, 4, 5',
              hintStyle: AppTypography.hint.copyWith(color: AppPalette.textSecondary),
              filled: true,
              fillColor: AppPalette.surfaceRaised,
              contentPadding: const EdgeInsets.all(AppMetrics.sp16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: ctrl.setInput,
          ),
          const SizedBox(height: AppMetrics.sp12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Calculate',
                  accent: true,
                  onTap: ctrl.compute,
                ),
              ),
              const SizedBox(width: AppMetrics.sp12),
              _ActionButton(
                label: 'Clear',
                accent: false,
                onTap: () {
                  _inputCtrl.clear();
                  ctrl.clear();
                },
              ),
            ],
          ),
          const SizedBox(height: AppMetrics.sp16),
          if (state.errorMessage != null) _ErrorBox(message: state.errorMessage!),
          if (state.result != null) ..._buildResults(state, ctrl),
        ],
      ),
    );
  }

  List<Widget> _buildResults(StatisticsState state, StatisticsController ctrl) {
    final r = state.result!;
    return [
      _StatRow(label: 'Count', value: r.count.toString()),
      _StatRow(label: 'Sum', value: ctrl.fmtValue(r.sum)),
      _StatRow(label: 'Mean', value: ctrl.fmtValue(r.mean)),
      _StatRow(label: 'Median', value: ctrl.fmtValue(r.median)),
      _StatRow(label: 'Mode', value: ctrl.formatModes(r.modes)),
      _StatRow(label: 'Min', value: ctrl.fmtValue(r.min)),
      _StatRow(label: 'Max', value: ctrl.fmtValue(r.max)),
      _StatRow(label: 'Range', value: ctrl.fmtValue(r.range)),
      const Divider(color: AppPalette.hairline, height: AppMetrics.sp24),
      _StatRow(label: 'Variance (pop)', value: ctrl.fmtValue(r.variancePop)),
      _StatRow(label: 'Std Dev (pop)', value: ctrl.fmtValue(r.stddevPop)),
      _StatRow(label: 'Variance (sample)', value: ctrl.fmtValue(r.varianceSample)),
      _StatRow(label: 'Std Dev (sample)', value: ctrl.fmtValue(r.stddevSample)),
    ];
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.accent, required this.onTap});
  final String label;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppMetrics.sp12),
        decoration: BoxDecoration(
          color: accent ? AppPalette.accent : AppPalette.surfaceRaised,
          borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.modeLabel.copyWith(
              color: accent ? AppPalette.bg : AppPalette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.sp8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.keyLabel.copyWith(
              color: AppPalette.textPrimary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  const _ErrorBox({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMetrics.sp8),
      padding: const EdgeInsets.all(AppMetrics.sp12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1018),
        borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
        border: Border.all(color: const Color(0xFFCF6679)),
      ),
      child: Text(
        message,
        style: AppTypography.keyLabelSmall.copyWith(color: const Color(0xFFCF6679)),
      ),
    );
  }
}
