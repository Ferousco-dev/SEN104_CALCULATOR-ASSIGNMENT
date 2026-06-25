import 'package:flutter/widgets.dart';

import '../persistence/session_store.dart';

// AppLifecycleState  <- Android Activity callback
// resumed            <- onResume
// inactive           <- onPause (transient)
// paused             <- onPause -> onStop (backgrounded)
// hidden             <- onStop
// detached           <- onDestroy

typedef SessionSnapshot = ({int modeIndex, String expression});
typedef SnapshotProvider = SessionSnapshot Function();

class LifecycleObserver with WidgetsBindingObserver {
  LifecycleObserver({required this.onRestored, required this.snapshotProvider});

  final void Function(SessionSnapshot) onRestored;
  final SnapshotProvider snapshotProvider;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _persist();
      case AppLifecycleState.resumed:
        _restore();
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        break;
    }
  }

  void _persist() {
    final snap = snapshotProvider();
    SessionStore.saveSession(
      modeIndex: snap.modeIndex,
      expression: snap.expression,
    );
  }

  void _restore() {
    SessionStore.loadSession().then(onRestored);
  }
}
