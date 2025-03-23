import 'dart:io';

import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetImageWidget extends StatefulWidget {
  const GetImageWidget({super.key});

  @override
  State<GetImageWidget> createState() => _GetImageWidgetState();
}

class _GetImageWidgetState extends State<GetImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Consumer<GetImageViewModel>(
        builder: (context, getImageProvider, child) {
          return InkWell(
            onTap: getImageProvider.tempImage != null
              ? () => getImageProvider.showImage()
              : () => getImageProvider.showSelectImageSourceDialog(),
            child: getImageProvider.tempImage != null
              ? Image.file(
                File(getImageProvider.tempImage!),
                fit: BoxFit.cover,
              )
              : Icon(Icons.image),
          );
        }
      ) 
    );
  }
}