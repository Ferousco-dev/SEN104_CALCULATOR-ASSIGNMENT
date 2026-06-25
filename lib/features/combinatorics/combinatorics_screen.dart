import 'package:flutter/material.dart';

import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import 'combinatorics_controller.dart';

class CombinatoricsScreen extends StatefulWidget {
  const CombinatoricsScreen({super.key, required this.controller});
  final CombinatoricsController controller;

  @override
  State<CombinatoricsScreen> createState() => _CombinatoricsScreenState();
}

class _CombinatoricsScreenState extends State<CombinatoricsScreen> {
  final _nCtrl = TextEditingController();
  final _rCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    _nCtrl.dispose();
    _rCtrl.dispose();
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppMetrics.sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InputRow(
            label: 'n',
            hint: 'Non-negative integer',
            controller: _nCtrl,
            onChanged: widget.controller.setN,
          ),
          const SizedBox(height: AppMetrics.sp12),
          _InputRow(
            label: 'r',
            hint: 'Optional (for nPr and nCr)',
            controller: _rCtrl,
            onChanged: widget.controller.setR,
          ),
          const SizedBox(height: AppMetrics.sp16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: widget.controller.compute,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppMetrics.sp12),
                    decoration: BoxDecoration(
                      color: AppPalette.accent,
                      borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                    ),
                    child: Center(
                      child: Text(
                        'Calculate',
                        style: AppTypography.modeLabel.copyWith(color: AppPalette.bg),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppMetrics.sp12),
              GestureDetector(
                onTap: () {
                  _nCtrl.clear();
                  _rCtrl.clear();
                  widget.controller.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppMetrics.sp12,
                    horizontal: AppMetrics.sp20,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.surfaceRaised,
                    borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                  ),
                  child: Text(
                    'Clear',
                    style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppMetrics.sp16),
          if (state.errorMessage != null)
            _ErrorBox(message: state.errorMessage!),
          if (state.result != null) ...[
            _ResultTile(label: 'n!', value: state.result!.nFactorial),
            const SizedBox(height: AppMetrics.sp8),
            _ResultTile(label: 'nPr', value: state.result!.nPr),
            const SizedBox(height: AppMetrics.sp8),
            _ResultTile(label: 'nCr', value: state.result!.nCr),
          ],
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            style: AppTypography.keyLabel.copyWith(color: AppPalette.accent),
          ),
        ),
        const SizedBox(width: AppMetrics.sp12),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: AppTypography.keyLabelSmall.copyWith(
              color: AppPalette.textPrimary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.hint.copyWith(color: AppPalette.textSecondary),
              filled: true,
              fillColor: AppPalette.surfaceRaised,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.sp16,
                vertical: AppMetrics.sp12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMetrics.sp20,
        vertical: AppMetrics.sp16,
      ),
      decoration: BoxDecoration(
        color: AppPalette.surfaceRaised,
        borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.displayValueSmall.copyWith(
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
