
import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/anime_news_model.dart';
import '../pages/news_details_page.dart';

class NewsTiles extends StatelessWidget {
  final AnimeNewsPreview preview;
  const NewsTiles({
    super.key,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: GestureDetector(
        onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetailsPage(url: preview.link, preview: preview))),//()=>Navigator.push(context,MaterialPageRoute(builder: (context)=>NewsDetailsPage(url: preview.link , preview: preview,))),
        child: SizedBox(
          height: 150,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "https://cdn.animenewsnetwork.com${preview.imageUrl}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        preview.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(preview.time),
                      Text(
                        preview.preview,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
