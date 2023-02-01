import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_mob3/helpers/weather_assets.dart';
import 'package:tic_mob3/models/weather_model.dart';

class CustomListView extends StatefulWidget {
  const CustomListView({
    super.key,
    required this.cod,
    required this.message,
    required this.cnt,
    required this.list,
    required this.city,
  });

  final String cod;
  final int message;
  final int cnt;
  final List<ListWeather> list;
  final City city;

  @override
  State<CustomListView> createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  String unitSymbol = "°C";

  Future<void> getUnitSymbol() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String unit = preferences.getString('unit') ?? 'metric';
    setState(() {
      if (unit == 'metric') {
        unitSymbol = "°C";
      } else {
        unitSymbol = '°F';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUnitSymbol();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 5,
            color: Color(0xFF000000),
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage(weatherAssets[widget.list[0].weather[0].main]),
          fit: BoxFit.cover,
        ),
      ),
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(0), bottom: Radius.circular(20)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.transparent,
                Colors.black54,
                Colors.black54,
                Colors.black54,
              ],
            ),
          ),
          // Colors.white.withOpacity(0.5),
          child: Text(
            '${widget.city.name} - ${widget.list[0].main.temp.toString() + unitSymbol}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
