import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

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
    return SafeArea(
      child: Scaffold(
        body: forecastMap != null
            ? Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        children: [
                          Text(
                              "${Jiffy(DateTime.now()).format("MMM do yy, h:mm a")}"),
                          Text("${weatherMap!["name"]}")
                        ],
                      ),
                    ),
                    Text("${weatherMap!["main"]["temp"]} °"),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(
                              " Feels Like ${weatherMap!["main"]["feels_like"]} °"),
                          Text("${weatherMap!["weather"][0]["description"]}")
                        ],
                      ),
                    ),
                    Text(
                        "Humidity ${weatherMap!["main"]["humidity"]}, Pressure ${weatherMap!["main"]["pressure"]}"),
                    Text(
                        "Sunrise ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunrise"] * 1000)).format("h:mm a")} , Sunset ${Jiffy(DateTime.fromMillisecondsSinceEpoch(weatherMap!["sys"]["sunset"] * 1000)).format("h:mm a")}"),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: forecastMap!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey,
                            margin: EdgeInsets.only(right: 8),
                            width: 200,
                            child: Column(
                              children: [
                                Text(
                                    "${Jiffy(forecastMap!["list"][index]["dt_txt"]).format("EEE h:mm")}"),
                                Image.network(
                                    "https://openweathermap.org/img/wn/${forecastMap!['list'][index]['weather'][0]['icon']}@2x.png"),
                                Text(
                                    "${forecastMap!["list"][index]["main"]["temp_min"]}/${forecastMap!["list"][index]["main"]["temp_max"]}"),
                                Text(
                                    "${forecastMap!["list"][index]["weather"][0]["description"]}")
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
