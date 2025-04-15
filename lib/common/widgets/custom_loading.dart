import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/generated/assets.dart';
import 'package:shipping_address/main.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<LoadingProvider>().isLoading;

    if (!isLoading) return const SizedBox.shrink();

    return AbsorbPointer(
      absorbing: true,
      child: Stack(
        children: [
          // blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          // center loading GIF
          Center(
            child: Image.asset(
              Assets.assetsIconsIcLoading,
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
