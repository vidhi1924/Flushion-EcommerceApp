import 'package:ecommerce/main.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/ui/login.dart';
import 'package:ecommerce/utils/firebase_auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('images/register.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
          Container(
            color: Colors.black.withOpacity(0.8),
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Image.asset(
                  'images/lg.png',
                  width: 240.0,
                  height: 180.0,
                ),
              )),
          Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 210.0),
                child: Center(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.5),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: "Enter Full Name",
                                icon: Icon(Icons.person_add),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.5),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Enter Email",
                                icon: Icon(Icons.alternate_email),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white.withOpacity(0.5),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  icon: Icon(Icons.lock),
                                ),
                              ),
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.5),
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                icon: Icon(Icons.verified_user),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.lightBlueAccent,
                          elevation: 0.0,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              "Register",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            onPressed: () async {
                              bool res = await AuthProvider().signUp(_emailController.text, _passwordController.text);
                              print(res);
                              if (res){
                                // print("true");
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                              }
                              if (!res) print("Registration unsuccessful");
                              /*if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                print("Email and Password cannot be empty");
                                return;
                              }
                              bool res = await AuthProvider().signInWithEmail(
                                  _emailController.text, _passwordController.text);
                              print(res);
                              if (!res) {
                                print("Login failed");
                              }*/
                            },
                          ),
                        ),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Forgot Password",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: (){},
                          child: Text("Don't have an Account? Sign Up!", style: TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                        ),
                        /*RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0),
                              children: [
                                TextSpan(
                                    text:
                                        "Don't have an Account? Click here to"),
                                TextSpan(
                                    text: " Sign Up!",
                                    style: TextStyle(color: Colors.red))
                              ]
                          )
                      )*/
                      ),*/
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: new Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.redAccent,
                          elevation: 0.0,
                          child: FlatButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => new LoginPage()));
                              Navigator.pop(context);
                            },
                            /*async {
                              bool res = await AuthProvider().loginWithGoogle();
                              if (!res) print("Error logging in with google");
                            },*/
                            child: Text(
                              "Already Have an Account? Login",
                              style: TextStyle(color: Colors.white, fontSize: 17.0),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
