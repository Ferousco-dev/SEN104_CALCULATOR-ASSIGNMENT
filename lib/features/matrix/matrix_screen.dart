import 'package:flutter/material.dart';

import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import 'matrix_controller.dart';

class MatrixScreen extends StatefulWidget {
  const MatrixScreen({super.key, required this.controller});
  final MatrixController controller;

  @override
  State<MatrixScreen> createState() => _MatrixScreenState();
}

class _MatrixScreenState extends State<MatrixScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppMetrics.sp16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SizeSelector(
            current: state.size,
            onChanged: widget.controller.setSize,
          ),
          const SizedBox(height: AppMetrics.sp16),
          _MatrixInput(
            label: 'Matrix A',
            size: state.size,
            cells: state.matrixA,
            onCellChanged: widget.controller.setCellA,
          ),
          const SizedBox(height: AppMetrics.sp12),
          _MatrixInput(
            label: 'Matrix B  (or scalar in B[0][0])',
            size: state.size,
            cells: state.matrixB,
            onCellChanged: widget.controller.setCellB,
          ),
          const SizedBox(height: AppMetrics.sp16),
          _OpButtons(onOp: widget.controller.compute),
          const SizedBox(height: AppMetrics.sp16),
          if (state.errorMessage != null) _ErrorBox(message: state.errorMessage!),
          if (state.resultRows != null)
            _ResultBox(
              label: state.resultLabel,
              rows: state.resultRows!,
            ),
          const SizedBox(height: AppMetrics.sp24),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({required this.current, required this.onChanged});
  final int current;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Size: ', style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary)),
        for (final s in [2, 3, 4])
          Padding(
            padding: const EdgeInsets.only(right: AppMetrics.sp8),
            child: GestureDetector(
              onTap: () => onChanged(s),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: current == s ? AppPalette.accent : AppPalette.surfaceRaised,
                  borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                ),
                child: Text(
                  '${s}x$s',
                  style: AppTypography.keyLabelSmall.copyWith(
                    color: current == s ? AppPalette.bg : AppPalette.textPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MatrixInput extends StatelessWidget {
  const _MatrixInput({
    required this.label,
    required this.size,
    required this.cells,
    required this.onCellChanged,
  });

  final String label;
  final int size;
  final List<List<String>> cells;
  final void Function(int r, int c, String v) onCellChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.hint.copyWith(color: AppPalette.textSecondary)),
        const SizedBox(height: AppMetrics.sp8),
        Container(
          padding: const EdgeInsets.all(AppMetrics.sp12),
          decoration: BoxDecoration(
            color: AppPalette.surfaceRaised,
            borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
          ),
          child: Column(
            children: List.generate(size, (r) => Row(
              children: List.generate(size, (c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: _CellField(
                    value: cells[r][c],
                    onChanged: (v) => onCellChanged(r, c, v),
                  ),
                ),
              )),
            )),
          ),
        ),
      ],
    );
  }
}

class _CellField extends StatefulWidget {
  const _CellField({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_CellField> createState() => _CellFieldState();
}

class _CellFieldState extends State<_CellField> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_CellField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value && _ctrl.text != widget.value) {
      _ctrl.text = widget.value;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _ctrl,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      textAlign: TextAlign.center,
      style: AppTypography.keyLabelSmall.copyWith(
        color: AppPalette.textPrimary,
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        filled: true,
        fillColor: AppPalette.keyNumber,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}

class _OpButtons extends StatelessWidget {
  const _OpButtons({required this.onOp});
  final void Function(MatrixOp) onOp;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppMetrics.sp8,
      runSpacing: AppMetrics.sp8,
      children: [
        _OpChip(label: 'A + B', op: MatrixOp.add, onTap: onOp),
        _OpChip(label: 'A - B', op: MatrixOp.subtract, onTap: onOp),
        _OpChip(label: 'A x B', op: MatrixOp.multiply, onTap: onOp),
        _OpChip(label: 'scalar x A', op: MatrixOp.scalarMultiply, onTap: onOp),
        _OpChip(label: 'det(A)', op: MatrixOp.determinant, onTap: onOp),
        _OpChip(label: 'A^-1', op: MatrixOp.inverse, onTap: onOp),
        _OpChip(label: 'A^T', op: MatrixOp.transpose, onTap: onOp),
      ],
    );
  }
}

class _OpChip extends StatelessWidget {
  const _OpChip({required this.label, required this.op, required this.onTap});
  final String label;
  final MatrixOp op;
  final void Function(MatrixOp) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(op),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.sp16,
          vertical: AppMetrics.sp8,
        ),
        decoration: BoxDecoration(
          color: AppPalette.accent,
          borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
        ),
        child: Text(
          label,
          style: AppTypography.keyLabelSmall.copyWith(color: AppPalette.bg),
        ),
      ),
    );
  }
}

class _ResultBox extends StatelessWidget {
  const _ResultBox({required this.label, required this.rows});
  final String label;
  final List<List<String>> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.sp16),
      decoration: BoxDecoration(
        color: AppPalette.surfaceRaised,
        borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
        border: Border.all(color: AppPalette.accent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.hint.copyWith(color: AppPalette.accent)),
          const SizedBox(height: AppMetrics.sp8),
          ...rows.map((row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((v) => Expanded(
              child: Center(
                child: Text(
                  v,
                  style: AppTypography.keyLabel.copyWith(
                    color: AppPalette.textPrimary,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ),
            )).toList(),
          )),
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
      width: double.infinity,
      padding: const EdgeInsets.all(AppMetrics.sp12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1018),
        borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
        border: Border.all(color: const Color(0xFFCF6679), width: 1),
      ),
      child: Text(
        message,
        style: AppTypography.keyLabelSmall.copyWith(color: const Color(0xFFCF6679)),
      ),
    );
  }
}
