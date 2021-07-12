
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('Kullanıcı oturumu kapattı');
      } else {
        print('Kullanıcı oturumu açtı');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(onPressed:_emailSifreKulaniciOlustur, child:Text("E-mail / Şifre")),
            TextButton(onPressed:_emailSifreKulaniciGirisyap, child:Text("E-mail / Şifre giriş")),
            TextButton(onPressed:CikisYap, child:Text("Çıkış yap")),
            TextButton(onPressed:Resedpasword, child:Text("şifreyi unuttum")),
          ],
        ),
      ),
    );
  }

  void _emailSifreKulaniciOlustur() async{
    String email="tufanmemisali4@gmail.com";
    String password="password";
   try{
     UserCredential _credential=await auth.createUserWithEmailAndPassword(email: email, password: password);
     User yeniUser =_credential.user;
     await yeniUser.sendEmailVerification();
     if(auth.currentUser!=null){
       print("Size bir mail attık lütfen onaylayın");
       await auth.signOut();
       print("Kullanıcıyı sistemden attık");

     }
     print(yeniUser);
   }catch(e){
     debugPrint("*******************************Hata*******************************");
     debugPrint(e.toString());
   }
  }

  void _emailSifreKulaniciGirisyap() async{
    String email="tufanmemisali4@gmail.com";
    String password="password";
    try{
      if(auth.currentUser==null){
        User oturum_acanuser=(await auth.signInWithEmailAndPassword(email: email, password: password)).user;

        if(oturum_acanuser.emailVerified){
          print("Mail onaylı devam edebilir");
        }else{
          print("mail onaylı değil");
          auth.signOut();
        }
      }else{
        print("Zaten giriş yapmış bir kullanıcı var");
      }
    }catch(e){
      debugPrint("*******************************Hata*******************************");
      debugPrint(e.toString());
    }
  }

  void CikisYap() {
    if(auth.currentUser!=null){
      auth.signOut();
    }else{
      print("zaten oturum açık değil");
    }
  }

  void Resedpasword() async{
    String email="tufanmemisali4@gmail.com";
    try{
      await auth.sendPasswordResetEmail(email: email);
      print("Resetleme Maili gönderildi");

    }catch(e){
      debugPrint("*******************************Hata*******************************");
      print(e.toString());
    }
  }
}
