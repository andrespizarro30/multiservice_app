import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {

  String imagePath;

  ImageViewer({
    super.key,
    required this.imagePath
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      child: PhotoView(
        imageProvider: FileImage(File(imagePath)),
      ),
    );

  }
}
