import 'package:flutter/material.dart';
import 'dart:ui';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          _buildBlurredCircle(
              context, 20, -1.2, 1, Color(0xFFE8CA2C).withOpacity(1)),
          _buildBlurredCircle(
              context, -2.7, -1.2, 1.3, Color(0xFF7B3113).withOpacity(1)),
          _buildBlurredCircle(
              context, 2.7, -1.2, 1.3, Color(0xFF7B3113).withOpacity(1)),
          child,
        ],
      ),
    );
  }

  Widget _buildBlurredCircle(BuildContext context, double alignX, double alignY,
      double sizeDivisor, Color color) {
    return Positioned.fill(
      child: Align(
        alignment: AlignmentDirectional(alignX, alignY),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth / sizeDivisor;
            return Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
