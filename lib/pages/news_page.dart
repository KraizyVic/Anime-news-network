import 'package:flutter/material.dart';

import '../models/anime_news_model.dart';
import '../services/scraper.dart';
import '../utilities/news_tiles.dart';
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<AnimeNewsPreview>> newsPreviews;
  @override
  void initState() {
    // TODO: implement initState
    newsPreviews = Scraper().newsPreviews();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text("News"),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: newsPreviews,
          builder: (context,snapshot){
            if(snapshot.hasData){
              return SizedBox(
                height: double.maxFinite,
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context,index){
                    return NewsTiles(preview: snapshot.data![index],);
                  },
                ),
              );
            }else if (snapshot.hasError){
              return Center(child: Text("${snapshot.error}"),);
            }else{
              return Center(child: CircularProgressIndicator(color: Colors.blue,),);
            }
          }
      ),
    );
  }
}
