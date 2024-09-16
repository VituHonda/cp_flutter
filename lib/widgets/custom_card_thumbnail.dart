import 'package:cp_flutter/common/utils.dart';
import 'package:flutter/material.dart';

class CustomCardThumbnail extends StatelessWidget {
  final String imageAsset;
  final VoidCallback? onTap;

  const CustomCardThumbnail({
    super.key,
    required this.imageAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage('$imageUrl$imageAsset'),
          ),
        ),
      ),
    );
  }
}
