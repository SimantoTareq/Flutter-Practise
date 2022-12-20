import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blurrycontainer/blurrycontainer.dart';

import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? position;

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position!.latitude;
      longitude = position!.longitude;
    });

    fetchWeatherData();
  }

  var latitude;
  var longitude;
  Map<String, dynamic>? weatherMap;
  Map<String, dynamic>? forecastMap;

  fetchWeatherData() async {
    String weatherUrl =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761";
    String foreCastUrl =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761";

    var weatherResponce = await http.get(Uri.parse(weatherUrl));
    var forecastRespose = await http.get(Uri.parse(foreCastUrl));

    weatherMap = Map<String, dynamic>.from(jsonDecode(weatherResponce.body));
    forecastMap = Map<String, dynamic>.from(jsonDecode(forecastRespose.body));

    setState(() {});

    print("pppp ${latitude}, $longitude");

    print("Weather response is ${weatherMap!["base"]}");
  }

  @override
  void initState() {
    // TODO: implement initState
    determinePosition();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: forecastMap != null
          ? Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/2.png',
                          ),
                          fit: BoxFit.cover)),
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            Text(
                              "${Jiffy(DateTime.now()).format("MMM do yy, h:mm a")}",
                              style: Style(20, Colors.white70),
                            ),
                            Text(
                              "${weatherMap!["name"]}",
                              style: Style(20, Colors.white70),
                            )
                          ],
                        ),
                      ),
                      Image.network(
                        "http://openweathermap.org/img/wn/${weatherMap!["weather"][0]["icon"]}@2x.png",
                        color: Colors.white,
                      ),
                      Text(
                        "${weatherMap!["main"]["temp"]} °",
                        style: Style(70, Colors.white),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            " Feels Like ${weatherMap!["main"]["feels_like"]} °",
                            style: Style(
                              30,
                              Colors.white30,
                            ),
                          ),
                          Text(
                            "${weatherMap!["weather"][0]["description"]}",
                            style: Style(35, Colors.white70),
                          )
                        ],
                      ),
                      Text(
                        "Humidity ${weatherMap!["main"]["humidity"]}, Pressure ${weatherMap!["main"]["pressure"]}",
                        style: Style(20, Colors.white70),
                      ),
                      Text(
                        "Sunrise ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm a")} , Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm a")}",
                        style: Style(20, Colors.white70),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .08,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: forecastMap!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(8),
                              child: BlurryContainer(
                                blur: 9,
                                //color: Colors.grey,

                                width: 200,
                                child: Column(
                                  children: [
                                    Text(
                                      "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE h:mm")}",
                                      style: Style(18, Colors.white70),
                                    ),
                                    Image.network(
                                        "https://openweathermap.org/img/wn/${forecastMap!['list'][index]['weather'][0]['icon']}@2x.png"),
                                    Text(
                                      "${forecastMap!["list"][index]["main"]["temp_min"]}/${forecastMap!["list"][index]["main"]["temp_max"]}",
                                      style: Style(18, Colors.white70),
                                    ),
                                    Text(
                                      "${forecastMap!["list"][index]["weather"][0]["description"]}",
                                      style: Style(18, Colors.white70),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Container(
              child: Center(child: Image.asset("images/home2.gif")),
            ),
    );
  }
}

Style(double? size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.lobster(color: clr, fontSize: size, fontWeight: fw);
}
