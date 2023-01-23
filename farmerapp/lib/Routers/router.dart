import 'package:farmerapp/home/screens/ListMilkSocietiesScreen.dart';
import 'package:flutter/material.dart';
import 'package:farmerapp/home/screens/Homescreen.dart';
import 'package:farmerapp/register.dart';


class  RouterGenerator{
  final String? cityVal;
  RouterGenerator(this.cityVal);
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => const Homepage(cityVal: '',));
      case '/milkSocieties':
        return MaterialPageRoute(builder: (_) => const ListMSScreen(cityVal:''));
      // case '/updateProfile':
      //   return MaterialPageRoute(builder: (_) => const UpdateProfile());
      case '/register':
        return MaterialPageRoute(builder: (_) => const Register());
      default:
        return MaterialPageRoute(builder: (_) => const Scaffold(
          body: Center(
            child: Text('No route defined'),
          ),
        ));
    }
  }
}