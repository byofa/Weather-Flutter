import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_mob3/patterns/custom_bottom_bar.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool unit = true;
  Future<void> getSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      unit = preferences.getString('unit') == 'metric';
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Row(children: [
            Text(
              'Fahrenheit',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            Switch(
                activeColor: Colors.white,
                activeTrackColor: Colors.blue[100],
                inactiveThumbColor: Colors.blue,
                inactiveTrackColor: Colors.blue[100],
                value: unit,
                onChanged: (value) async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  if (value) {
                    preferences.setString('unit', 'metric');
                  } else {
                    preferences.setString('unit', 'imperial');
                  }
                  setState(() {
                    unit = value;
                  });
                }),
            Text(
              'Celsius',
              style: GoogleFonts.nunito(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
          ])
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(index: 1),
    );
  }
}
