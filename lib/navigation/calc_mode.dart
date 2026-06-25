import 'package:flutter/material.dart';

enum CalcMode {
  basic,
  scientific,
  matrix,
  combinatorics,
  statistics,
}

extension CalcModeInfo on CalcMode {
  String get label => switch (this) {
    CalcMode.basic => 'Basic',
    CalcMode.scientific => 'Scientific',
    CalcMode.matrix => 'Matrix',
    CalcMode.combinatorics => 'Permutations & Combinations',
    CalcMode.statistics => 'Statistics',
  };

  IconData get icon => switch (this) {
    CalcMode.basic => Icons.calculate_outlined,
    CalcMode.scientific => Icons.functions_outlined,
    CalcMode.matrix => Icons.grid_on_outlined,
    CalcMode.combinatorics => Icons.shuffle_outlined,
    CalcMode.statistics => Icons.bar_chart_outlined,
  };
}
