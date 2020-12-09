import 'package:flutter/material.dart';
import 'package:simple_bloc/simple_bloc.dart';

abstract class StateWithBloc<TWidget extends StatefulWidget, TBloc extends SimpleBloc> extends State<TWidget> {
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
