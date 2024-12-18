import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -3.75,
            top: -3.75,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
