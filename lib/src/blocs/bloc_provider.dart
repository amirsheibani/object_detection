import 'package:flutter/material.dart';

abstract class BlocBase{
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget{
  final T bloc;
  final Widget child;

  BlocProvider({Key key,this.bloc, this.child}): super(key: key);

  @override
  State<StatefulWidget> createState() => _BlocProviderState<T>();

  static T of<T extends BlocBase>(BuildContext context){
    BlocProvider<T> provider = context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }
}
class _BlocProviderState<T> extends State<BlocProvider<BlocBase>>{
  @override
  Widget build(BuildContext context) => widget.child;
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}