library simple_bloc;

import 'package:flutter/material.dart';

abstract class SimpleBloc {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  BuildContext _context;

  void dispose();

  void updateContext(final BuildContext context) {
    _context = context;
  }

  NavigatorState get navigatorState => Navigator.of(_context);

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
    final _BlocProviderInherited<T> provider =
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

extension SimpleBlocBuildContext on BuildContext {
  TBloc getBloc<TBloc extends SimpleBloc>() => SimpleBlocProvider.of<TBloc>(this);
}

abstract class SimpleBlocState<TWidget extends StatefulWidget, TBloc extends SimpleBloc> extends State<TWidget> {
  TBloc bloc;

  @protected
  Widget buildWidget(final BuildContext context);

  @protected
  TBloc buildBloc();

  /// use [buildWidget] method instead
  @deprecated
  @override
  Widget build(final BuildContext context) {
    return SimpleBlocProvider<TBloc>(
      bloc: bloc,
      child: buildWidget(context),
    );
  }

  @mustCallSuper
  @override
  void initState() {
    bloc = buildBloc();
    super.initState();
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.updateContext(context);
  }
}
