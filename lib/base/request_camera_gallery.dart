import 'package:flutter/material.dart';
import 'package:multiservice_app/utils/colors.dart';
import 'package:multiservice_app/utils/dimension.dart';

class RequestCameraOrGallery extends StatefulWidget {
  const RequestCameraOrGallery({super.key});

  @override
  State<RequestCameraOrGallery> createState() => _RequestCameraOrGalleryState();
}

class _RequestCameraOrGalleryState extends State<RequestCameraOrGallery> {
  @override

  String photoSource = "Galeria";


  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)
      ),
      backgroundColor: AppColors.mainColor,
      child: Container(
        margin: const EdgeInsets.all(3),
        height: Dimensions.screenHeight/3,
        width: Dimensions.screenWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            Text(
              "Seleccionar Fuente de Imágenes",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
              ),
            ),
            const SizedBox(height: 20,),
            Divider(
              thickness: 3,
              color: AppColors.mainColor,
            ),
            const SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio(
                    value: "Camara",
                    groupValue: photoSource,
                    onChanged: (source){
                      setState(() {
                        photoSource = source!;
                      });
                    }),
                Text(
                  "Cámara",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                ),
                Radio(
                    value: "Galeria",
                    groupValue: photoSource,
                    onChanged: (source){
                      setState(() {
                        photoSource = source!;
                      });
                    }),
                Text(
                  "Galería",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18),
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context,photoSource);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selecionar",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20
                      ),
                    ),
                    Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 26,
                    )
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    primary: AppColors.mainColor
                ),
              ),
            ),

            SizedBox(height: 4,)
          ],
        ),
      ),
    );

  }
}