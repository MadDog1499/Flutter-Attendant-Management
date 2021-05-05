import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:real_app/API/section_A.dart';
import 'package:real_app/Object/employee.dart';
import 'package:real_app/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../screens1/home.dart';

class SignApp extends StatefulWidget {
  @override
  _SignAppState createState() => _SignAppState();
}

class _SignAppState extends State<SignApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  bool visible = true;
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  Future<User> _signIn(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content:
          new Text(AppLocalizations.of(context).translate('sign_in_button')),
    ));

    final GoogleSignInAccount googleUser = await _googlSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final User userinfo =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    UserDetails details = new UserDetails(
      userinfo.displayName,
      userinfo.photoURL,
      userinfo.email,
    );
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new HomeScreen(userDetails: details),
      ),
    );
    return userinfo;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        supportedLocales: [
          Locale('vi', 'VN'),
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        home: Scaffold(
          body: Builder(
              builder: (context) => Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/images/banner1.jpg"),
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 260),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: ListView(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                child: Container(
                                  color: Color(0xfff5f5f5),
                                  child: TextFormField(
                                    controller: usernamecontroller,
                                    keyboardType: TextInputType.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'SFUIDisplay'),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: AppLocalizations.of(context)
                                            .translate('Username'),
                                        prefixIcon: Icon(Icons.person_outline),
                                        labelStyle: TextStyle(fontSize: 15)),
                                  ),
                                ),
                              ),
                              Container(
                                color: Color(0xfff5f5f5),
                                child: TextFormField(
                                  controller: passwordcontroller,
                                  obscureText: visible,
                                  keyboardType: TextInputType.visiblePassword,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'SFUIDisplay'),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: AppLocalizations.of(context)
                                          .translate('Password'),
                                      prefixIcon: Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.visibility),
                                        onPressed: () {
                                          setState(() {
                                            print(visible);
                                            if (visible == true) {
                                              visible = false;
                                            } else {
                                              visible = true;
                                            }
                                          });
                                        },
                                      ),
                                      labelStyle: TextStyle(fontSize: 15)),
                                ),
                              ),
                              //
                              //  SIGN IN BUTTON
                              //
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: MaterialButton(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('Sign_In'),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'SFUIDisplay',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Color(0xffff2d55),
                                  elevation: 0,
                                  minWidth: 400,
                                  height: 50,
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {
                                    setState(() {
                                      User_SignIn user = new User_SignIn(
                                          usernamecontroller.text,
                                          passwordcontroller.text);
                                      sign_in(user, context);
                                    });
                                  },
                                ),
                              ),
                              //
                              //  GOOGLE SIGN IN
                              //
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: OutlineButton(
                                    splashColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(color: Colors.grey),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 7, 0, 5),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                              image: AssetImage(
                                                  "assets/images/google_logo.png"),
                                              height: 35.0),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate('sign_in_button'),
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                                fontFamily: 'SFUIDisplay',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () => _signIn(context)
                                        .then((User user) => print('Logged In'))
                                        .catchError((e) => print(e))),
                              ),

                              //
                              // FORGOT PASSWORD
                              //
                              Padding(
                                padding: EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('Forget_pass'),
                                    style: TextStyle(
                                        fontFamily: 'SFUIDisplay',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          left: size.width / 4,
                          bottom: 30,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30),
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)
                                          .translate('Donot_have_acc'),
                                      style: TextStyle(
                                        fontFamily: 'SFUIDisplay',
                                        color: Colors.black,
                                        fontSize: 15,
                                      )),
                                  TextSpan(
                                      text: " " +
                                          AppLocalizations.of(context)
                                              .translate('Sign_Up'),
                                      style: TextStyle(
                                        fontFamily: 'SFUIDisplay',
                                        color: Color(0xffff2d55),
                                        fontSize: 15,
                                      ))
                                ]),
                              ),
                            ),
                          )),
                      Positioned(
                        left: size.width * .35,
                        top: 300,
                        child: Text(
                          AppLocalizations.of(context).translate('Sign_In'),
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
        ));
  }
}

class UserDetails {
  final String userName;
  final String photoUrl;
  final String userEmail;

  UserDetails(this.userName, this.photoUrl, this.userEmail);
}

class ProviderDetails {
  ProviderDetails(this.providerDetails);
  final String providerDetails;
}
