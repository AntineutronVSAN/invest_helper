

import 'package:flutter/cupertino.dart';

class UnfocusWidget extends StatelessWidget {

  final Widget child;
  final Function()? onTap;

  const UnfocusWidget({Key? key, required this.child, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTap?.call();
      },
      child: child,
    );
  }


}