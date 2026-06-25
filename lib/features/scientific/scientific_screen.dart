import 'package:flutter/material.dart';

import '../../core/format/number_format.dart';
import '../../core/math/combinatorics.dart';
import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../theme/typography.dart';
import '../../widgets/calc_key.dart';
import '../../widgets/display.dart';
import '../../widgets/key_grid.dart';
import '../combinatorics/combinatorics_controller.dart';
import 'scientific_controller.dart';

class ScientificScreen extends StatefulWidget {
  const ScientificScreen({
    super.key,
    required this.controller,
    required this.comboController,
  });

  final ScientificController controller;
  final CombinatoricsController comboController;

  @override
  State<ScientificScreen> createState() => _ScientificScreenState();
}

class _ScientificScreenState extends State<ScientificScreen> {
  final _nCtrl = TextEditingController();
  final _rCtrl = TextEditingController();

  // Inline P&C result state (not using full controller to keep it lightweight)
  String? _nPr;
  String? _nCr;
  String? _nFact;
  String? _comboError;

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
  void _key(String k) => widget.controller.onKey(k);

  void _computeCombo() {
    final n = int.tryParse(_nCtrl.text.trim());
    final r = int.tryParse(_rCtrl.text.trim());
    if (n == null) {
      setState(() { _comboError = 'n must be a non-negative integer'; _nPr = _nCr = _nFact = null; });
      return;
    }
    try {
      final fact = Combinatorics.factorial(n);
      final pnr = r != null ? Combinatorics.nPr(n, r) : null;
      final cnr = r != null ? Combinatorics.nCr(n, r) : null;
      setState(() {
        _comboError = null;
        _nFact = NumberFormatter.formatBigInt(fact);
        _nPr = pnr != null ? NumberFormatter.formatBigInt(pnr) : null;
        _nCr = cnr != null ? NumberFormatter.formatBigInt(cnr) : null;
      });
    } on CombinatoricsException catch (e) {
      setState(() { _comboError = e.message; _nPr = _nCr = _nFact = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final hyp = state.hypMode;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppMetrics.sp16, AppMetrics.sp12,
              AppMetrics.sp16, AppMetrics.sp8,
            ),
            child: CalcDisplay(
              expression: state.expression,
              result: state.result,
              errorMessage: state.errorMessage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppMetrics.sp16,
              vertical: AppMetrics.sp4,
            ),
            child: Row(
              children: [
                _toggleChip(label: 'DEG', active: state.angleMode.name == 'degrees', onTap: () => _key('DEG')),
                const SizedBox(width: AppMetrics.sp8),
                _toggleChip(label: 'RAD', active: state.angleMode.name == 'radians', onTap: () => _key('RAD')),
                const SizedBox(width: AppMetrics.sp8),
                _toggleChip(label: 'HYP', active: hyp, onTap: () => _key('HYP')),
              ],
            ),
          ),
          const Divider(height: 1, color: AppPalette.hairline),
          KeyGrid(rows: [
            [
              KeySpec(label: hyp ? 'sinh' : 'sin', onTap: () => _key(hyp ? 'sinh(' : 'sin('), variant: KeyVariant.function),
              KeySpec(label: hyp ? 'cosh' : 'cos', onTap: () => _key(hyp ? 'cosh(' : 'cos('), variant: KeyVariant.function),
              KeySpec(label: hyp ? 'tanh' : 'tan', onTap: () => _key(hyp ? 'tanh(' : 'tan('), variant: KeyVariant.function),
              KeySpec(label: '(', onTap: () => _key('('), variant: KeyVariant.function),
              KeySpec(label: ')', onTap: () => _key(')'), variant: KeyVariant.function),
            ],
            [
              KeySpec(label: hyp ? 'asinh' : 'asin', onTap: () => _key(hyp ? 'asinh(' : 'asin('), variant: KeyVariant.function),
              KeySpec(label: hyp ? 'acosh' : 'acos', onTap: () => _key(hyp ? 'acosh(' : 'acos('), variant: KeyVariant.function),
              KeySpec(label: hyp ? 'atanh' : 'atan', onTap: () => _key(hyp ? 'atanh(' : 'atan('), variant: KeyVariant.function),
              KeySpec(label: 'ln', onTap: () => _key('ln('), variant: KeyVariant.function),
              KeySpec(label: 'log', onTap: () => _key('log('), variant: KeyVariant.function),
            ],
            [
              KeySpec(label: 'x^y', onTap: () => _key('^'), variant: KeyVariant.function),
              KeySpec(label: 'sqrt', onTap: () => _key('sqrt('), variant: KeyVariant.function),
              KeySpec(label: 'cbrt', onTap: () => _key('cbrt('), variant: KeyVariant.function),
              KeySpec(label: 'pi', onTap: () => _key('pi'), variant: KeyVariant.function),
              KeySpec(label: 'e', onTap: () => _key('e'), variant: KeyVariant.function),
            ],
            [
              KeySpec(label: 'AC', onTap: () => _key('AC'), variant: KeyVariant.function),
              KeySpec(label: '+/-', onTap: () => _key('+/-'), variant: KeyVariant.function),
              KeySpec(label: 'x!', onTap: () => _key('!'), variant: KeyVariant.function),
              KeySpec(label: '÷', onTap: () => _key('÷'), variant: KeyVariant.accent),
              KeySpec(label: '×', onTap: () => _key('×'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '7', onTap: () => _key('7')),
              KeySpec(label: '8', onTap: () => _key('8')),
              KeySpec(label: '9', onTap: () => _key('9')),
              KeySpec(label: '-', onTap: () => _key('-'), variant: KeyVariant.accent),
              KeySpec(label: '+', onTap: () => _key('+'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '4', onTap: () => _key('4')),
              KeySpec(label: '5', onTap: () => _key('5')),
              KeySpec(label: '6', onTap: () => _key('6')),
              KeySpec(label: 'C', onTap: () => _key('C'), variant: KeyVariant.function),
              KeySpec(label: ',', onTap: () => _key(','), variant: KeyVariant.function),
            ],
            [
              KeySpec(label: '1', onTap: () => _key('1')),
              KeySpec(label: '2', onTap: () => _key('2')),
              KeySpec(label: '3', onTap: () => _key('3')),
              KeySpec(label: '.', onTap: () => _key('.')),
              KeySpec(label: '=', onTap: () => _key('='), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '0', onTap: () => _key('0'), flex: 2),
              KeySpec(label: 'exp', onTap: () => _key('exp('), variant: KeyVariant.function, flex: 2),
              KeySpec(label: 'abs', onTap: () => _key('abs('), variant: KeyVariant.function),
            ],
          ]),
          // Permutations & Combinations panel
          _ComboPanel(
            nCtrl: _nCtrl,
            rCtrl: _rCtrl,
            onCompute: _computeCombo,
            onClear: () {
              _nCtrl.clear();
              _rCtrl.clear();
              setState(() { _nPr = _nCr = _nFact = _comboError = null; });
            },
            nPr: _nPr,
            nCr: _nCr,
            nFact: _nFact,
            errorMessage: _comboError,
          ),
          const SizedBox(height: AppMetrics.sp24),
        ],
      ),
    );
  }

  Widget _toggleChip({required String label, required bool active, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppMetrics.sp12, vertical: AppMetrics.sp4),
        decoration: BoxDecoration(
          color: active ? AppPalette.accent : AppPalette.surfaceRaised,
          borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
          border: Border.all(color: active ? AppPalette.accent : AppPalette.hairline, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: active ? AppPalette.bg : AppPalette.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ComboPanel extends StatelessWidget {
  const _ComboPanel({
    required this.nCtrl,
    required this.rCtrl,
    required this.onCompute,
    required this.onClear,
    this.nPr,
    this.nCr,
    this.nFact,
    this.errorMessage,
  });

  final TextEditingController nCtrl;
  final TextEditingController rCtrl;
  final VoidCallback onCompute;
  final VoidCallback onClear;
  final String? nPr;
  final String? nCr;
  final String? nFact;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppMetrics.sp16, 0, AppMetrics.sp16, 0),
      child: Container(
        padding: const EdgeInsets.all(AppMetrics.sp16),
        decoration: BoxDecoration(
          color: AppPalette.surfaceRaised,
          borderRadius: BorderRadius.circular(AppMetrics.radiusPanel),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Permutations & Combinations',
              style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary),
            ),
            const SizedBox(height: AppMetrics.sp12),
            Row(
              children: [
                _Label('n'),
                const SizedBox(width: AppMetrics.sp8),
                Expanded(child: _Field(controller: nCtrl, hint: 'integer')),
                const SizedBox(width: AppMetrics.sp12),
                _Label('r'),
                const SizedBox(width: AppMetrics.sp8),
                Expanded(child: _Field(controller: rCtrl, hint: 'optional')),
              ],
            ),
            const SizedBox(height: AppMetrics.sp12),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCompute,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: AppMetrics.sp8),
                      decoration: BoxDecoration(
                        color: AppPalette.accent,
                        borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                      ),
                      child: Center(
                        child: Text('Calculate', style: AppTypography.keyLabelSmall.copyWith(color: AppPalette.bg)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppMetrics.sp8),
                GestureDetector(
                  onTap: onClear,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: AppMetrics.sp8, horizontal: AppMetrics.sp16),
                    decoration: BoxDecoration(
                      color: AppPalette.keyNumber,
                      borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
                    ),
                    child: Text('Clear', style: AppTypography.keyLabelSmall.copyWith(color: AppPalette.textSecondary)),
                  ),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: AppMetrics.sp8),
              Text(errorMessage!, style: AppTypography.hint.copyWith(color: const Color(0xFFCF6679))),
            ],
            if (nFact != null) ...[
              const SizedBox(height: AppMetrics.sp12),
              _ResultRow(label: 'n!', value: nFact!),
              if (nPr != null) _ResultRow(label: 'nPr', value: nPr!),
              if (nCr != null) _ResultRow(label: 'nCr', value: nCr!),
            ],
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTypography.keyLabel.copyWith(color: AppPalette.accent));
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint});
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: AppTypography.keyLabelSmall.copyWith(color: AppPalette.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.hint.copyWith(color: AppPalette.textSecondary),
        filled: true,
        fillColor: AppPalette.keyNumber,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppMetrics.sp12, vertical: AppMetrics.sp8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppMetrics.sp4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.modeLabel.copyWith(color: AppPalette.textSecondary)),
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
