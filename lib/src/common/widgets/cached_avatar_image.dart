import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CachedAvatarImage extends StatelessWidget {
  const CachedAvatarImage({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.placeholderColor,
    this.errorColor,
  });

  final String imageUrl;
  final double radius;
  final Color? placeholderColor;
  final Color? errorColor;

  @override
  Widget build(BuildContext context) {
    // Debug log
    print('CachedAvatarImage: imageUrl = "$imageUrl"');

    // Boş URL kontrolü
    if (imageUrl.isEmpty) {
      print('CachedAvatarImage: Empty URL, showing error widget');
      return _buildErrorWidget();
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => _buildShimmerPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: radius,
            backgroundImage: imageProvider,
            backgroundColor: Colors.transparent,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: placeholderColor ?? Colors.grey[500]!,
      highlightColor: placeholderColor?.withOpacity(0.4) ?? Colors.grey[300]!,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: placeholderColor ?? Colors.grey[500],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: errorColor ?? Colors.grey[400],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: radius,
        color: Colors.white,
      ),
    );
  }
}
