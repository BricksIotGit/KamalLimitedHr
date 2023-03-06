import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../MainScreens/Home.dart';

class UpdateProfile extends StatefulWidget {
  final String empID;

  UpdateProfile(this.empID, {Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final myController = TextEditingController();
  final myControllerPassword = TextEditingController();

  @override
  void initState() {
    //getLogins();
    //upLoadLoginsOnce();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    myControllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Stack(
                  children: [
                    Image(
                      width: 100 * SizeConfig.widthMultiplier,
                      image: AssetImage(Images.header_other_screens),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Image(
                          width: 10 * SizeConfig.widthMultiplier,
                          image: AssetImage(Images.back_arrow_ic),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 40,
                        width: 100 * SizeConfig.widthMultiplier,
                        child: Center(
                            child: Text(
                          "Settings",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 80),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Skip",
                        style: TextStyle(color: Clrs.dark_Grey),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: TextFormField(
                  controller: myControllerPassword,
                  cursorColor: Clrs.dark_Grey,
                  style: const TextStyle(color: Colors.black54),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                child: TextFormField(
                  controller: myController,
                  // controller: controller.password,
                  cursorColor: Clrs.black,
                  style: const TextStyle(color: Colors.black54),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.black54)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (myController.text == myControllerPassword.text) {
                      if (myControllerPassword.text.length < 6) {
                        toast("Length to short. Try again!");
                      } else
                        updateLogins();
                    } else
                      toast("Passowrd not matched!");
                    // if (_formKey.currentState!.validate()) {
                    //   LoginUpController.instance.loginUser(
                    //       controller.email.text.trim(),
                    //       controller.password.text.trim());
                    // }
                  },
                  child: Text('Save',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Clrs.white,
                    shape: StadiumBorder(),
                    minimumSize: Size(250, 40),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLogins() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final ref = database.ref();

    final snapshot = await ref.child('usersLogin/188700001').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  Future<void> updateLogins() async {
    // A post entry.
    final postData = {'password': myController.text, 'userId': widget.empID};

    final Map<String, Map> updates = {};
    updates['usersLogin/${widget.empID}'] = postData;

    return FirebaseDatabase.instance.ref().update(updates).then((_) {
      print("update successfuly");
      storeLogin(widget.empID, myController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error) {
      print("update $error");
    });
  }

  Future<void> upLoadLoginsOnce() async {
    var listuser = [
      '191700004',
      '188700012',
      '70500041',
      '70500034',
      '187700001',
      '188700001',
      '188700019',
      '50500002',
      '81500010',
      '188700026',
      '70500139',
      '70500010',
      '188700031',
      '188700021',
      '70500002',
      '50500003',
      '70500030',
      '70500271',
      '70500272',
      '70500133',
      '70500251',
      '188700027',
      '192700006',
      '192700005',
      '70500263',
      '70500244',
      '70500235',
      '81500030',
      '188700011',
      '70500104',
      '70500011',
      '191700005',
      '192700002',
      '70500195',
      '188700017',
      '188700030',
      '70500243',
      '98700001',
      '70500259',
      '70500242',
      '70500148',
      '70500132',
      '81500029',
      '188700002',
      '191700002',
      '70500245',
      '70500191',
      '191700001',
      '70500134',
      '188700028',
      '188700013',
      '70500284',
      '70500208',
      '70500053',
      '70500119',
      '70500241',
      '70500170',
      '192700001',
      '70500045',
      '70500280',
      '70500256',
      '192700003',
      '70500147',
      '188700022',
      '70500281',
      '188700033',
      '188700032',
      '70500083',
      '188700016',
      '187700003',
      '187700002',
      '188700015',
      '192700004',
      '188700006',
      '70500240',
      '70500100',
      '70500268',
      '186700001',
      '70500265',
      '98700002',
      '70500232',
      '98700004',
      '70500226',
      '70500249',
      '70500207',
      '191700003',
      '188700004',
      '188700003',
      '70500164',
      '187700004',
      '188700029',
      '70500142',
      '70500048',
      '188700024',
      '70500255',
      '70500254',
      '95500002',
      '188700020',
      '70500274',
      '188700023',
      '191700008',
      '70500269',
      '70500257',
      '70500145',
      '81500021',
      '70500138',
      '70500258',
      '188700010',
      '95500001',
      '188700025',
      '70500277',
      '26700004',
      '50500005',
      '188700007',
      '98700003',
      '50500006',
      '188700014',
      '70500276',
      '70500275',
      '191700006',
      '188700008',
      '188700005',
      '191700007',
      '188700018',
      '185700001',
      '188700009',
      '70500264'
    ];
    // A post entry.

    for (int i = 0; i < listuser.length; i++) {
    //  print("upload this user: " + listuser[i]);

      final postData = {'password': '123456', 'userId': listuser[i]};

      final Map<String, Map> updates = {};
      updates['usersLogin/${listuser[i]}'] = postData;

       FirebaseDatabase.instance.ref().update(updates).then((_) {
      //  print("update successfuly");
        print("upload this user: " + listuser[i]);

      }).catchError((error) {
        print("update $error");
      });


    }

  }

  Future<void> storeLogin(String empId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('empID', empId);
    await prefs.setString('password', password);

    final String? empIDSp = prefs.getString('empID');
    final String? passwordSP = prefs.getString('password');

    print("sharedPreff empID: $empIDSp and password $passwordSP");
  }
}
