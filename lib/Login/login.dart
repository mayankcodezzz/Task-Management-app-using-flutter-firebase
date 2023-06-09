import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internday7/home%20screen/homepage.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade100,
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
                top: 100, bottom: 50, left: 50, right: 50),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NOTRIKA",
                    style: GoogleFonts.gochiHand(
                        textStyle: const TextStyle(fontSize: 60)),
                  ),
                  const SizedBox(
                    height: 300,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()));
                      },
                      child: Text("Continue",
                          style: GoogleFonts.gochiHand(
                              textStyle: const TextStyle(
                            fontSize: 29,
                          )))),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
