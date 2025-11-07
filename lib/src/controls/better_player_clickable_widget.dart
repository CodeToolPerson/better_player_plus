// Flutter imports:
import 'package:flutter/material.dart';

class BetterPlayerMaterialClickableWidget extends StatelessWidget {
  final Widget child;
  final void Function() onTap;
  final bool autofocus;
  final FocusNode? focusNode;

  const BetterPlayerMaterialClickableWidget({
    Key? key,
    required this.onTap,
    required this.child,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(60),
      ),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        autofocus: autofocus,
        focusNode: focusNode,
        focusColor: Colors.white.withValues(alpha: 0.3),
        child: child,
      ),
    );
  }
}
