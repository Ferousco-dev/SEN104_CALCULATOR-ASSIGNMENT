import 'package:flutter/material.dart';

import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../widgets/calc_key.dart';
import '../../widgets/display.dart';
import '../../widgets/key_grid.dart';
import 'scientific_controller.dart';

class ScientificScreen extends StatefulWidget {
  const ScientificScreen({super.key, required this.controller});
  final ScientificController controller;

  @override
  State<ScientificScreen> createState() => _ScientificScreenState();
}

class _ScientificScreenState extends State<ScientificScreen> {
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
  void _key(String k) => widget.controller.onKey(k);

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;
    final hyp = state.hypMode;

    return Column(
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
              _toggleChip(
                label: 'DEG',
                active: state.angleMode.name == 'degrees',
                onTap: () => _key('DEG'),
              ),
              const SizedBox(width: AppMetrics.sp8),
              _toggleChip(
                label: 'RAD',
                active: state.angleMode.name == 'radians',
                onTap: () => _key('RAD'),
              ),
              const SizedBox(width: AppMetrics.sp8),
              _toggleChip(
                label: 'HYP',
                active: hyp,
                onTap: () => _key('HYP'),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppPalette.hairline),
        Expanded(
          child: KeyGrid(rows: [
            [
              KeySpec(
                label: hyp ? 'sinh' : 'sin',
                onTap: () => _key(hyp ? 'sinh(' : 'sin('),
                variant: KeyVariant.function,
              ),
              KeySpec(
                label: hyp ? 'cosh' : 'cos',
                onTap: () => _key(hyp ? 'cosh(' : 'cos('),
                variant: KeyVariant.function,
              ),
              KeySpec(
                label: hyp ? 'tanh' : 'tan',
                onTap: () => _key(hyp ? 'tanh(' : 'tan('),
                variant: KeyVariant.function,
              ),
              KeySpec(label: '(', onTap: () => _key('('), variant: KeyVariant.function),
              KeySpec(label: ')', onTap: () => _key(')'), variant: KeyVariant.function),
            ],
            [
              KeySpec(
                label: hyp ? 'asinh' : 'asin',
                onTap: () => _key(hyp ? 'asinh(' : 'asin('),
                variant: KeyVariant.function,
              ),
              KeySpec(
                label: hyp ? 'acosh' : 'acos',
                onTap: () => _key(hyp ? 'acosh(' : 'acos('),
                variant: KeyVariant.function,
              ),
              KeySpec(
                label: hyp ? 'atanh' : 'atan',
                onTap: () => _key(hyp ? 'atanh(' : 'atan('),
                variant: KeyVariant.function,
              ),
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
        ),
      ],
    );
  }

  Widget _toggleChip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMetrics.sp12,
          vertical: AppMetrics.sp4,
        ),
        decoration: BoxDecoration(
          color: active ? AppPalette.accent : AppPalette.surfaceRaised,
          borderRadius: BorderRadius.circular(AppMetrics.radiusKey),
          border: Border.all(
            color: active ? AppPalette.accent : AppPalette.hairline,
            width: 1,
          ),
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
