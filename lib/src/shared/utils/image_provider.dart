import 'package:bookihub/src/shared/constant/dimensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget showImage({required String imageUrl}) {
  return CachedNetworkImage(
    imageUrl: imageUrl, // The URL of the image to load
    imageBuilder: (context, imageProvider) => Container(
      width: MediaQuery.sizeOf(context).width / 6,
      decoration: BoxDecoration(
        borderRadius:
            borderRadius, // Optional: Apply a border radius to the image
        image: DecorationImage(
          image: imageProvider, // The loaded image provider
          fit: BoxFit
              .cover, // Optional: Specify how the image should fit in the container
        ),
      ),
    ),
    placeholder: (context, url) => const Center(
        child: CircularProgressIndicator()), // Placeholder while loading
    errorWidget: (context, url, error) =>
        const Icon(Icons.error), // Widget to display on error
  );
}
