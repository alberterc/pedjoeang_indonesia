import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef AppLifecycleStateNotifier = ValueNotifier<AppLifecycleState>;

class AppLifecycleObserver extends StatefulWidget {
  final Widget child;
  const AppLifecycleObserver({super.key, required this.child});

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver> {
  late final AppLifecycleListener _appLifecycleListener;

  final ValueNotifier<AppLifecycleState> _lifecycleListenable = ValueNotifier(AppLifecycleState.inactive);

  @override
  Widget build(BuildContext context) {
    return InheritedProvider<AppLifecycleStateNotifier>.value(
      value: _lifecycleListenable,
      child: widget.child
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _appLifecycleListener = AppLifecycleListener(
      onStateChange: (s) => _lifecycleListenable.value = s,
    );
  }
}