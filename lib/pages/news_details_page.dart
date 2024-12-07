import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../models/anime_news_model.dart';
import '../services/scraper.dart';

class NewsDetailsPage extends StatefulWidget {
  final String url;
  final AnimeNewsPreview preview;
  const NewsDetailsPage({super.key, required this.url,required this.preview});

  @override
  State<NewsDetailsPage> createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  late Future<AnimeNews> news;

  @override
  void initState() {
    // TODO: implement initState
    news = Scraper().scrape(widget.preview.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: news,
        builder:(context,snapshot){
          if(snapshot.hasData){
            return Column(
                children: [
                  Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            height:MediaQuery.of(context).size.height*0.75,
                            child: Stack(
                              children: [
                                Image.network(
                                  snapshot.data!.image != "Null"?snapshot.data!.image:"https://cdn.animenewsnetwork.com${widget.preview.imageUrl}",
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [Colors.black,Colors.transparent],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter
                                      )
                                  ),
                                ),
                              ],
                            )
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.45,
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                        child: Row(
                                          children: [
                                            Expanded(child: SizedBox()),
                                            Text(widget.preview.time,style: TextStyle(color: Colors.white60),)
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(snapshot.data!.title.toUpperCase(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,),),
                                            SizedBox(height: 20,),
                                            Text(snapshot.data!.intro,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                        child: Text(snapshot.data!.news),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          "Credit: Anime news network",
                                          style: TextStyle(fontSize: 12,color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height*0.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Theme.of(context).canvasColor,Colors.transparent],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter
                                )
                            ),
                          ),
                          Column(
                            children: [
                              AppBar(
                                backgroundColor: Colors.transparent,
                                scrolledUnderElevation: 0,
                                leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(CupertinoIcons.back)),
                              ),
                            ],
                          )
                        ],
                      )
                  )
                ]
              );
          }else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }else{
            return Center(child: CircularProgressIndicator(color: Colors.blue,),);
          }
        }
      ),
    );
  }
}
