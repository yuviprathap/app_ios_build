import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'dart:convert';
import 'dart:async';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import 'setting.dart';
import 'app/dashboard.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(const MyApp());
}

final LocalStorage storage = LocalStorage('localstorage_app');

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        fontFamily: 'Nunito',
      ),
      home: const loginPage(title: 'Evolut Reporting App'),
    );
  }
}

class loginPage extends StatefulWidget {
  const loginPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  int _counter = 0;
  TextEditingController txtunersane = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  TextEditingController ddlcompany = TextEditingController();
  TextEditingController txtApiUrl = TextEditingController();

  var items = ['Dark', 'White'];
  // Initial Selected Value
  String ddlTheme = 'Dark';

  bool appBar = false;
  var isflag = 0;

  @override
  void initState() {
    super.initState();
    getLocalStorage();
  }

  void getLocalStorage() async {
    //wait until ready
    await storage.ready;
    if (storage.getItem('api_url') != "" &&
        storage.getItem('api_url') != null) {
      txtApiUrl.text =
          storage.getItem('api_url'); 
    } else {
      txtApiUrl.text = ""; 
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final _formKey = GlobalKey<FormState>();
    final _settingKey = GlobalKey<FormState>();
    var rememberValue = false;
    txtunersane.text = "sdadmin";
    txtpassword.text = "sdadmin";

    return Scaffold(
      appBar: appBar
          ? null
          : AppBar(
              // Here we take the value from the loginPage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(
                widget.title,
                style: TextStyle(fontFamily: 'Nunito', fontSize: 22),
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isflag = isflag == 1 ? 0 : 1;
                      print(isflag);
                    });
                  },
                )
              ],
            ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_login.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isflag == 0)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87, // HexColor("#161718"),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 60,
                            width: 250,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/login-logo.png"),
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          /* const Text(
                          'Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),*/
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: txtunersane,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your user name';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Enter your user name',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Nunito"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: txtpassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              maxLines: 1,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Nunito")),
                          /* CheckboxListTile(
                          title: const Text("Remember me"),
                          contentPadding: EdgeInsets.zero,
                          value: rememberValue,
                          activeColor: Theme.of(context).colorScheme.primary,
                          onChanged: (newValue) {
                            setState(() {
                              rememberValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),*/
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (storage.getItem('api_url') == "" ||
                                    storage.getItem('api_url') == null) {
                                  return showCommonAlert(
                                      context,
                                      "Api Url not yet configured. Please click the setting icon in top.",
                                      200);
                                }
                                getSessionID();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 15, 40, 15),
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (isflag == 1)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87, // HexColor("#161718"),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: _settingKey,
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 60,
                            width: 250,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/login-logo.png"),
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          /* const Text(
                          'Sign in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),*/
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: txtApiUrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your api url';
                              }
                              return null;
                            },
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Enter api url',
                              prefixIcon: const Icon(Icons.api),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Nunito"),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          /* Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Theme",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Nunito"),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            child: DropdownButton(
                              isExpanded: true,
                              underline: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                              // Initial Value
                              value: ddlTheme,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  ddlTheme = newValue!;
                                  storage.setItem('Theme', ddlTheme);
                                  print(storage.getItem('Theme'));
                                });
                              },
                            ),
                          ),*/
                          ElevatedButton(
                            onPressed: () {
                              if (_settingKey.currentState!.validate()) {
                                setState(() {
                                  storage.setItem('api_url', txtApiUrl.text);
                                  isflag = 0;
                                });
                                showCommonAlert(context,
                                    "Api url saved successfully.", 200);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 15, 40, 15),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getSessionID() async {
    try {
      final response = await http.get(Uri.parse(api_url + '/GetSessionID/01'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        var jsonData = json.decode(response.body);

        var sessionId = jsonData['data'][0]['output'][0]['session_id'];
        /*  SharedPreferences.setMockInitialValues({});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', sessionId);*/
        storage.setItem('sessionId', sessionId);
        getValidateLoginPos();
        if (kDebugMode) {
          print("sessionId : " + storage.getItem('sessionId'));
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }
    } catch (ex) {
      AlertDialog alert = AlertDialog(
        /*title: Text("Fail"),*/
        content: Text(ex.toString()),
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  getValidateLoginPos() async {
    final response = await http.get(Uri.parse(api_url +
        '/GetValidateLogin/01?sessionid=' +
        storage.getItem('sessionId') +
        '&username=' +
        txtunersane.text +
        '&pwd=' +
        txtpassword.text));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonData = json.decode(response.body);
      if (kDebugMode) {
        print((jsonData[0]['result']));
      }
      if (jsonData[0]['result'] == "FAIL") {
        // set up the AlertDialog
        AlertDialog alert = const AlertDialog(
          /*title: Text("Fail"),*/
          content: Text("Please Enter Valid User name & password"),
        );
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      } else {
        setState(() {
          storage.setItem('login_user_details', jsonData);
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                const dashboard(title: "DashBoard")));
      }

      //_getShift();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
