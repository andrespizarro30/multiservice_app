
import 'package:flutter/material.dart';
import 'package:multiservice_app/utils/app_constants.dart';

import '../models/chat_message_model.dart';


class NotificationDialogBox extends StatefulWidget {

  ChatMessageModel? chatMessageModel;
  
  NotificationDialogBox({this.chatMessageModel});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)
      ),
      backgroundColor: Colors.transparent,
        elevation: 2,
      child: Container(
        margin: EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[800]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 22,),

            Image.asset("assets/image/logo.jpg",
              width: 160,
            ),

            const SizedBox(height: 2,),

            Text(
              AppConstants.APP_NAME,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 2,),

            const Divider(
              height: 3,
              thickness: 3,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset("assets/image/logo.jpg",
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 22,),

                      Expanded(
                        child: Text(
                          widget.chatMessageModel!.senderEmail!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    children: [
                      Image.asset("assets/image/logo.jpg",
                        width: 30,
                        height: 30,
                      ),

                      const SizedBox(width: 22,),

                      Expanded(
                        child: Text(
                          widget.chatMessageModel!.message!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            const Divider(
              height: 3,
              thickness: 3,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancelar".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white
                        ),
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      maximumSize: Size(200, 40)
                    ),
                  ),

                  const SizedBox(width: 10,),

                  ElevatedButton(
                      onPressed: (){
                        goToChat(context);
                      },
                      child: Text(
                        "Aceptar".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white
                        ),
                      ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      maximumSize: Size(200, 40)
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
    
  }

  void goToChat(BuildContext context) {


  }
}
