import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier{
 bool _firstTimeLogin=false;
 bool firstTimeLogin(){
   return _firstTimeLogin;
 }
 void setFirstTimeLogin(bool loginStatus){
   _firstTimeLogin=loginStatus;
   notifyListeners();
 }
}