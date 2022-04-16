import 'dart:convert';
import 'dart:io';

import 'package:faceken/api.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../main.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login> {
  String email = "";
  String password = "";
  dynamic data2 = {};
  File? jsonFile;
  Directory? tempDir;
  @override
  void initState() {
    super.initState();
    initial();
  }

  initial() async {
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir!.path + '/emb.json';
    jsonFile = File(_embPath);
    if (jsonFile!.existsSync()) {
      data2 = json.decode(jsonFile!.readAsStringSync());
    }
  }

  loginAPI() async {
    final response = await http
        .post(Uri.parse("http://$ipadress/presensi/login.php"), headers: {
      'Accept': 'application/json',
    }, body: {
      "email": email,
      "password": password
    });
    var data = jsonDecode(response.body);

    if (data['value'] == 1) {
      print(data['message']);
      data2[data['username']] = List.from(json.decode(data['data']));
      print(data2);
      jsonFile!.writeAsStringSync(json.encode(data2));
      initial();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MyHomePage()));
    } else {
      print(data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: const Color(0xffDDDDDD),
          title: NeumorphicText(
            'Face recognition',
            style: const NeumorphicStyle(
              depth: 4, //customize depth here
              color: Colors.white, //customize color here
            ),
            textStyle: NeumorphicTextStyle(
              fontSize: 18, //customize size here
              // AND others usual text style properties (fontFamily, fontWeight, ...)
            ),
          ),
        ),
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Center(
                child: Neumorphic(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                      depth: 8,
                      lightSource: LightSource.topLeft,
                      color: const Color.fromARGB(255, 245, 244, 244)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 8,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: NeumorphicButton(
                          onPressed: () {
                            loginAPI();
                          },
                          pressed: _isButtonEnabled(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      _AvatarField(),
                      const SizedBox(
                        height: 8,
                      ),
                      _TextField(
                        label: "Email",
                        hint: "",
                        onChanged: (email1) {
                          setState(() {
                            email = email1;
                          });
                        },
                      ),
                      _TextField(
                        label: "Password",
                        hint: "",
                        onChanged: (password1) {
                          setState(() {
                            password = password1;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      /*
                  _RideField(
                    rides: this.rides,
                    onChanged: (rides) {
                      setState(() {
                        this.rides = rides;
                      });
                    },
                  ),
                  SizedBox(
                    height: 28,
                  ),
                   */
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  bool _isButtonEnabled() {
    return email.isNotEmpty && password.isNotEmpty;
  }
}

class _AvatarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        padding: const EdgeInsets.all(10),
        style: NeumorphicStyle(
          boxShape: const NeumorphicBoxShape.circle(),
          depth: NeumorphicTheme.embossDepth(context),
        ),
        child: Icon(
          Icons.insert_emoticon,
          size: 120,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    );
  }
}

class _AgeField extends StatelessWidget {
  double? age;
  ValueChanged<double>? onChanged;

  _AgeField({this.age, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            "Age",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: NeumorphicSlider(
                  min: 8,
                  max: 75,
                  value: age!,
                  onChanged: (value) {
                    onChanged!(value);
                  },
                ),
              ),
            ),
            Text("${age!.floor()}"),
            const SizedBox(
              width: 18,
            )
          ],
        ),
      ],
    );
  }
}

class _TextField extends StatefulWidget {
  String? label;
  String? hint;

  ValueChanged<String>? onChanged;

  _TextField({this.label, this.hint, this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: Text(
            widget.label!,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: NeumorphicTheme.defaultTextColor(context),
            ),
          ),
        ),
        Neumorphic(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
          style: NeumorphicStyle(
            depth: NeumorphicTheme.embossDepth(context),
            boxShape: const NeumorphicBoxShape.stadium(),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
          child: TextField(
            onChanged: widget.onChanged,
            controller: _controller,
            decoration: InputDecoration.collapsed(hintText: widget.hint),
          ),
        )
      ],
    );
  }
}
