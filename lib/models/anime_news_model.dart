class AnimeNews {
  final String title;
  final String intro;
  final String image;
  final String news;
  AnimeNews({
    required this.title,
    required this.intro,
    required this.image,
    required this.news,
  });
}

class AnimeNewsPreview{
  final String imageUrl;
  final String link;
  final String title;
  final String time;
  final String preview;

  AnimeNewsPreview({
    required this.imageUrl,
    required this.link,
    required this.title,
    required this.time,
    required this.preview,
  });
}