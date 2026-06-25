import 'package:flutter/material.dart';

import '../core/lifecycle/lifecycle_observer.dart';
import '../theme/palette.dart';
import '../theme/typography.dart';
import 'calc_mode.dart';
import 'mode_drawer.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.bodyBuilder,
    required this.initialMode,
    required this.snapshotProvider,
    required this.onRestored,
  });

  final Widget Function(CalcMode mode) bodyBuilder;
  final CalcMode initialMode;
  final SnapshotProvider snapshotProvider;
  final void Function(SessionSnapshot) onRestored;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late CalcMode _mode;
  late LifecycleObserver _lifecycleObserver;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _lifecycleObserver = LifecycleObserver(
      onRestored: widget.onRestored,
      snapshotProvider: widget.snapshotProvider,
    );
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }

  void _onModeSelected(CalcMode mode) {
    setState(() => _mode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.bg,
      appBar: AppBar(
        title: Text(
          _mode.label,
          style: AppTypography.modeLabel.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppPalette.textPrimary,
          ),
        ),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: AppPalette.textPrimary),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: ModeDrawer(
        currentMode: _mode,
        onModeSelected: _onModeSelected,
      ),
      body: widget.bodyBuilder(_mode),
    );
  }
}
