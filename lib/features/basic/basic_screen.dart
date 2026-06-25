import 'package:flutter/material.dart';

import '../../theme/metrics.dart';
import '../../theme/palette.dart';
import '../../widgets/calc_key.dart';
import '../../widgets/display.dart';
import '../../widgets/key_grid.dart';
import 'basic_controller.dart';

class BasicScreen extends StatefulWidget {
  const BasicScreen({super.key, required this.controller});
  final BasicController controller;

  @override
  State<BasicScreen> createState() => _BasicScreenState();
}

class _BasicScreenState extends State<BasicScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() => setState(() {});

  void _key(String k) => widget.controller.onKey(k);

  @override
  Widget build(BuildContext context) {
    final state = widget.controller.state;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.sp16,
            AppMetrics.sp12,
            AppMetrics.sp16,
            AppMetrics.sp8,
          ),
          child: CalcDisplay(
            expression: state.expression,
            result: state.result,
            errorMessage: state.errorMessage,
          ),
        ),
        const Divider(height: 1, color: AppPalette.hairline),
        Expanded(
          child: KeyGrid(rows: [
            [
              KeySpec(label: 'AC', onTap: () => _key('AC'), variant: KeyVariant.function),
              KeySpec(label: '+/-', onTap: () => _key('+/-'), variant: KeyVariant.function),
              KeySpec(label: '%', onTap: () => _key('%'), variant: KeyVariant.function),
              KeySpec(label: '÷', onTap: () => _key('÷'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '7', onTap: () => _key('7')),
              KeySpec(label: '8', onTap: () => _key('8')),
              KeySpec(label: '9', onTap: () => _key('9')),
              KeySpec(label: '×', onTap: () => _key('×'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '4', onTap: () => _key('4')),
              KeySpec(label: '5', onTap: () => _key('5')),
              KeySpec(label: '6', onTap: () => _key('6')),
              KeySpec(label: '-', onTap: () => _key('-'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: '1', onTap: () => _key('1')),
              KeySpec(label: '2', onTap: () => _key('2')),
              KeySpec(label: '3', onTap: () => _key('3')),
              KeySpec(label: '+', onTap: () => _key('+'), variant: KeyVariant.accent),
            ],
            [
              KeySpec(label: 'C', onTap: () => _key('C'), variant: KeyVariant.function),
              KeySpec(label: '0', onTap: () => _key('0')),
              KeySpec(label: '.', onTap: () => _key('.')),
              KeySpec(label: '=', onTap: () => _key('='), variant: KeyVariant.accent),
            ],
          ]),
        ),
      ],
    );
  }
}
