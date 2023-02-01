import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tic_mob3/helpers/weather_assets.dart';
import 'package:tic_mob3/models/weather_model.dart';
import 'package:tic_mob3/patterns/custom_app_bar.dart';
import 'package:tic_mob3/patterns/custom_bottom_bar.dart';
import 'package:tic_mob3/patterns/custom_list_view.dart';
import 'package:tic_mob3/patterns/custom_list_view_all.dart';
import 'package:tic_mob3/weather.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Widget> getWeathers() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? favorites = preferences.getStringList('favorites');
    return FutureBuilder<List<WeatherModel>>(
        future: fetchWeatherFavorites(favorites),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<WeatherModel> weather = snapshot.data!;
            if (snapshot.data!.isEmpty || snapshot.data == null) {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Color(0xFF000000),
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.blue,
                    image: DecorationImage(
                      image: AssetImage('assets/gif/empty.gif'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      width: double.infinity,
                      decoration: const BoxDecoration(

                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(0),
                            bottom: Radius.circular(20)),
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
                      child: const Text(
                        'No favorites yet...',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: weather.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeatherPage(
                            cod: weather[index].cod,
                            message: weather[index].message,
                            cnt: weather[index].cnt,
                            list: weather[index].list,
                            city: weather[index].city,
                          ),
                        ),
                      );
                    },
                    child: CustomListView(
                      cod: weather[index].cod,
                      message: weather[index].message,
                      cnt: weather[index].cnt,
                      list: weather[index].list,
                      city: weather[index].city,
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        });
  }

  Widget favorites = Container();
  @override
  void initState() {
    // ignore: unused_element
    getWeathers().then((value) {
      setState(() {
        favorites = value;
      });
    });
    super.initState();
  }

  // @override
  // void didUpdateWidget(Home oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   if (oldWidget.id != widget.id) update();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(
        title: '',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getWeathers().then((value) {
            setState(() {
              favorites = value;
            });
          });
        },
        child: ListView(children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Favorites',
                  style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w800),
                ),
              ),
              Container(
                height: 590,
                alignment: Alignment.center,
                child: favorites,
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: const CustomBottomBar(index: 0),
    );
  }
}
