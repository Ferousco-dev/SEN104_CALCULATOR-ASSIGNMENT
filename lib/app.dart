import 'package:flutter/material.dart';

import 'core/lifecycle/lifecycle_observer.dart';
import 'features/basic/basic_controller.dart';
import 'features/basic/basic_screen.dart';
import 'features/combinatorics/combinatorics_controller.dart';
import 'features/matrix/matrix_controller.dart';
import 'features/matrix/matrix_screen.dart';
import 'features/scientific/scientific_controller.dart';
import 'features/scientific/scientific_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/statistics/statistics_controller.dart';
import 'features/statistics/statistics_screen.dart';
import 'navigation/app_shell.dart';
import 'navigation/calc_mode.dart';
import 'theme/app_theme.dart';

class MyCalcApp extends StatefulWidget {
  const MyCalcApp({super.key});

  @override
  State<MyCalcApp> createState() => _MyCalcAppState();
}

class _MyCalcAppState extends State<MyCalcApp> {
  bool _showSplash = true;

  final _basicCtrl = BasicController();
  final _sciCtrl = ScientificController();
  final _matrixCtrl = MatrixController();
  final _comboCtrl = CombinatoricsController();
  final _statsCtrl = StatisticsController();

  CalcMode _mode = CalcMode.basic;

  void _onRestored(SessionSnapshot snap) {
    final mode = CalcMode.values[snap.modeIndex.clamp(0, CalcMode.values.length - 1)];
    setState(() => _mode = mode);
    _basicCtrl.restoreExpression(snap.expression);
    _sciCtrl.restoreExpression(snap.expression);
  }

  SessionSnapshot _snapshot() => (
    modeIndex: _mode.index,
    expression: switch (_mode) {
      CalcMode.basic => _basicCtrl.expressionSnapshot,
      CalcMode.scientific => _sciCtrl.expressionSnapshot,
      _ => '',
    },
  );

  @override
  void dispose() {
    _basicCtrl.dispose();
    _sciCtrl.dispose();
    _matrixCtrl.dispose();
    _comboCtrl.dispose();
    _statsCtrl.dispose();
    super.dispose();
  }

  Widget _bodyForMode(CalcMode mode) {
    return switch (mode) {
      CalcMode.basic => BasicScreen(controller: _basicCtrl),
      CalcMode.scientific => ScientificScreen(
          controller: _sciCtrl,
          comboController: _comboCtrl,
        ),
      CalcMode.matrix => MatrixScreen(controller: _matrixCtrl),
      CalcMode.statistics => StatisticsScreen(controller: _statsCtrl),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCalc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: _showSplash
          ? SplashScreen(onComplete: () => setState(() => _showSplash = false))
          : AppShell(
              initialMode: _mode,
              bodyBuilder: (mode) {
                _mode = mode;
                return _bodyForMode(mode);
              },
              snapshotProvider: _snapshot,
              onRestored: _onRestored,
            ),
    );
  }
}
