import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

String baseUrl = "https://newsapi.org/docs/endpoints/everything?";
String token = "6f216ebce676448a8e7a27baa4b1f235";

myStyle(double size, Color clr, [FontWeight? fw]) {
  return GoogleFonts.nunito(
    fontSize: size,
    color: clr,
    fontWeight: fw,
  );
}
