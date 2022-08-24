import 'package:flutter/material.dart';

void showDialogg(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context)  {
      return Dialog(
        // The background color
        backgroundColor: Colors.white,

        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              // The loading indicator
              CircularProgressIndicator(),
              SizedBox(
                height: 15,
                width: 50,
              ),
              // Some text
              Text('Carregando...')
            ],
          ),
        ),
      );
    },
  );

}


void showDialogError(BuildContext context, String message) {

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        // The background color
        backgroundColor: Colors.white,

        child: SizedBox(
          width: 500,
          height: 250,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    // The loading indicator
                      Icon(Icons.warning),
                     SizedBox(
                      height: 15,
                      width: 50,
                    ),
                    // Some text
                    Text(message, style: TextStyle(fontSize: 16),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                    child: Container(
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(9, 245, 226, 1.0), borderRadius: BorderRadius.circular(20)
                        ),
                        child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: const Text("Ok",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            )
                        )


                    )
                ),

              ),
            ],
          ),
        ),
      );
    },
  );

}


void showDialogWithCancelButton(BuildContext context, bool buttonCancelClicked) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        // The background color
        backgroundColor: Colors.white,

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                    width: 50,
                  ),
                  // Some text
                  Text('Carregando...')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Container(
                    margin: EdgeInsets.only(top: 30),
                    width: 250,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(171, 9, 9, 1.0), borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          buttonCancelClicked = true;
                        },
                        child: const Text("Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )
                    )


                )
              ),

            ),
          ],
        ),
      );
    },
  );
}