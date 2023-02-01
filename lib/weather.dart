import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_mob3/helpers/weather_assets.dart';
import 'package:tic_mob3/home.dart';
import 'package:tic_mob3/main.dart';
import 'package:tic_mob3/models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
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
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  Widget iconRed = const Icon(Icons.push_pin, color: Colors.lightBlueAccent);
  Widget iconOutlined =
      const Icon(Icons.push_pin_outlined, color: Colors.white);
  Widget favoriteIcon =
      const Icon(Icons.push_pin_outlined, color: Colors.white);
  String unitSymbol = "°C";
  Future<void> getSharedPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String>? favorites = preferences.getStringList('favorites');
    final String unit = preferences.getString('unit') ?? 'metric';

    setState(() {
      if (favorites != null && favorites.contains(widget.city.name)) {
        favoriteIcon = iconRed;
      } else {
        favoriteIcon = iconOutlined;
      }
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
    getSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.city.name),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            alignment: Alignment.center,
            onPressed: (() {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => const Home())));
            }),
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  final List<String>? favorites =
                      preferences.getStringList('favorites');
                  if (favorites != null &&
                      favorites.contains(widget.city.name)) {
                    logSuccess(favorites.toString());
                    favorites.remove(widget.city.name);
                    preferences.setStringList('favorites', favorites);
                    setState(() {
                      favoriteIcon = iconOutlined;
                    });
                  } else {
                    List<String> fav = favorites ?? [];
                    logError(fav.toString());
                    fav.add(widget.city.name);
                    logInfo(fav.toString());
                    preferences.setStringList('favorites', fav);
                    setState(() {
                      favoriteIcon = iconRed;
                    });
                  }
                },
                icon: favoriteIcon),
          ]),
      body: PageView.builder(
          controller: PageController(),
          scrollDirection: Axis.horizontal,
          itemCount: widget.list.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      weatherAssets[widget.list[index].weather[0].main]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Weather in ${widget.city.name}',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    DateFormat('dd MMMM')
                        .format(widget.list[index].dtTxt)
                        .toString(),
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '${DateFormat('H').format(widget.list[index].dtTxt).toString()}h',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    widget.list[index].weather[0].description,
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Temperature : ${widget.list[index].main.temp.toString() + unitSymbol}',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'min: ${widget.list[index].main.tempMin.toString() + unitSymbol} - max: ${widget.list[index].main.tempMax.toString() + unitSymbol}',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'pressure : ${widget.list[index].main.pressure.toString()}',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'humidity : ${widget.list[index].main.humidity.toString()}',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'wind speed : ${widget.list[index].wind.speed.toString()}m/s',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'wind direction : ${widget.list[index].wind.deg.toString()}°',
                    // textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
