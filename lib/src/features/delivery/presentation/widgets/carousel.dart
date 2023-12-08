import 'package:bookihub/src/shared/utils/image_provider.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({
    Key? key,
    required this.images,
  }) : super(key: key);
  final List<dynamic> images;
  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final imageList = <String>[];
  getImages() {
    for (var image in widget.images) {
      imageList.add(image.image);
    }
  }

  final PageController _pageController = PageController();
  // final int _currentPageIndex = 0;
  @override
  void initState() {
    getImages();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height / 6,
      child: GridView.builder(
        // controller: _pageController,
        itemCount: widget.images.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return showImage(imageUrl: imageList[index]);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisExtent: 170, mainAxisSpacing: 10),
      ),
    );
  }
}
