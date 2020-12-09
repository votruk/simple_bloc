library simple_bloc;

import 'package:flutter/material.dart';

abstract class SimpleBloc {
  BuildContext _context;

  void dispose();

  void updateContext(final BuildContext context) {
    _context = context;
  }
}

abstract class SimpleBlocNavAndScaffold extends SimpleBloc with NavigationAware, ScaffoldAware {}

abstract class SimpleBlocNav extends SimpleBloc with NavigationAware {}

abstract class SimpleBlocScaffold extends SimpleBloc with ScaffoldAware {}

mixin NavigationAware on SimpleBloc {
  NavigatorState get navigatorState => Navigator.of(_context);
}

mixin ScaffoldAware on SimpleBloc {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  ScaffoldState get scaffoldState => _scaffoldKey.currentState;
}

class SimpleBlocProvider<T extends SimpleBloc> extends StatefulWidget {
  SimpleBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  @override
  _SimpleBlocProviderState<T> createState() => _SimpleBlocProviderState<T>();

  static T of<T extends SimpleBloc>(BuildContext context) {
    _BlocProviderInherited<T> provider =
        context.getElementForInheritedWidgetOfExactType<_BlocProviderInherited<T>>()?.widget as _BlocProviderInherited<T>;
    return provider?.bloc;
  }
}

class _SimpleBlocProviderState<T extends SimpleBloc> extends State<SimpleBlocProvider<T>> {
  @override
  void dispose() {
    widget.bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      bloc: widget.bloc,
      child: widget.child,
    );
  }
}

class _BlocProviderInherited<T> extends InheritedWidget {
  _BlocProviderInherited({
    Key key,
    @required Widget child,
    @required this.bloc,
  }) : super(key: key, child: child);

  final T bloc;

  @override
  bool updateShouldNotify(_BlocProviderInherited<T> oldWidget) => false;
}

extension BlocContext on BuildContext {
  TBloc getBloc<TBloc extends SimpleBloc>() => SimpleBlocProvider.of<TBloc>(this);
}
