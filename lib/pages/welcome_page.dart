import 'package:flutter/material.dart';

import 'news_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('lib/assets/943489.png',fit: BoxFit.cover,width: double.maxFinite,height: double.maxFinite,),
          Container(
            decoration: BoxDecoration(
              /*gradient: LinearGradient(
                colors: [Colors.black87,Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
              )*/
            ),
          ),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Anime News Network",
                  style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                ),
                Text("The scraped version anyway",style: TextStyle(color: Colors.white54),)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> NewsPage())),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(.4),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
                      child: Text("🏴‍☠️Arrrr!!!🏴‍☠️ to the news ship >>>",textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
