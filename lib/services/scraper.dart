import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:http/http.dart';
import 'package:js_unpack/js_unpack.dart';

import '../models/anime_news_model.dart';
class Scraper{
  Future<AnimeNews> scrape( String url) async{
    String targetUrl = "https://www.animenewsnetwork.com$url";
    var response = await http.get(Uri.parse(targetUrl));
    if(response.statusCode == 200){
      Document document = parse(response.body);

      Element? title = document.querySelector('h1.same-width-as-main');
      Element? intro = document.querySelector('div.intro');
      Element? image = document.querySelector('figure.fright img');
      Element? news = document.querySelector('div.meat');
      Element? sources = document.querySelector('em');

      title?.querySelector('div.sub-title')?.remove();
      news?.querySelector('figure.fright')?.remove();
      news?.querySelector('em')?.remove();
      String imgurl = image?.attributes['data-src'] ?? image?.attributes['src'] ?? "Null";//'https://images4.alphacoders.com/134/thumb-1920-1344995.png';

      String titletxt = title?.text.trim() ?? "NULL";
      String introtxt = intro?.text.trim() ?? "NULL";
      String imagetxt = getFullImageUrl(imgurl, targetUrl);
      String newstxt = news?.text.trim() ?? "NULL";
      String sourcestxt = sources?.text.trim() ?? "Unattributed";

      print(sourcestxt);
      return AnimeNews(
        title: titletxt,
        intro: introtxt,
        image: imagetxt,
        news: newstxt,
      );
    }else{
      throw Exception("Did not find");
    }

  }
  String getFullImageUrl(String? imgSrc, String baseUrl) {
    // If the image URL starts with '/', it's relative, so prepend the base URL
    if (imgSrc != null && imgSrc.startsWith('/')) {
      return Uri.parse(baseUrl).resolve(imgSrc).toString();
    }
    return imgSrc ?? "NULL";
  }

  Future<List<AnimeNewsPreview>> newsPreviews () async{
    final baseUrl = "https://www.animenewsnetwork.com/news";
    final response = await http.get(Uri.parse(baseUrl));
    if(response.statusCode == 200){
      Document document = parse(response.body);

      List<Element> elements = document.querySelectorAll('div.herald.box.news.t-news');
      List<AnimeNewsPreview> news = [];
      for(var element in elements){
        String? link = element.querySelector('div.wrap a')?.attributes['href'];
        String? title = element.querySelector('div.wrap h3')?.text.trim();
        // Extract the image URL from the background-image or data-src attribute in the <div class="thumbnail">
        String? backgroundImageStyle = element.querySelector('div.thumbnail')?.attributes['style'];
        String? imageUrl = extractImageUrlFromStyle(backgroundImageStyle);

        // Fallback if image is in data-src
        imageUrl ??= element.querySelector('div.thumbnail')?.attributes['data-src'];
        String? time = element.querySelector('time')?.text;
        String? preview = element.querySelector('span.hook')?.text;

        news.add(AnimeNewsPreview(imageUrl: imageUrl!, link: link!, title: title!, time: time!, preview: preview!));
      }
      print(news[0].link);
      return news;
    }else{
      throw Exception("Error");
    }
  }
  String? extractImageUrlFromStyle(String? style) {
    if (style != null) { // Check if the style string is not null
      // Regular expression to extract the URL from the background-image style
      RegExp regExp = RegExp('url\\(["\']?(.+?)["\']?\\)'); // Pattern to match the URL inside url()

      Match? match = regExp.firstMatch(style); // Apply the regex to the style string

      if (match != null) {
        return match.group(1); // Return the first capturing group, which is the image URL
      }
    }
    return null; // Return null if the style is null or no match is found
  }

}

class VidStream{
  final keys = {
    'key': Key.fromUtf8('37911490979715163134003223491201'),
    'secondKey': Key.fromUtf8('54674138327930866480207815084989'),
    'iv': IV.fromUtf8('3134003223491201'),
  };
  Future<String> getIframeLink(String epLink) async {
    // Fetch the HTML of the episode page
    final res = await fetch(epLink);

    // Parse the HTML to find the iframe element
    final doc = parse(res);

    // Get the 'src' attribute of the iframe element (contains the video link)
    final String iframeLink = doc.querySelector("iframe")?.attributes['src'] ?? '';

    // If the iframe link is empty, throw an error
    if (iframeLink.isEmpty) {
      throw Exception("No iframe link found on the page");
    }
    return iframeLink;
  }

  Future<String> getEncryptedKey(String id) async {
    // Prepare the AES encryption key and initialization vector (IV)
    final encrypter = Encrypter(AES(keys['key'] as Key, mode: AESMode.cbc));

    // Encrypt the ID of the video stream
    final encryptedKey = encrypter.encrypt(id, iv: keys['iv'] as IV);

    // Return the base64-encoded version of the encrypted key
    return encryptedKey.base64;
  }

  Future<String?> decrypt(Uri streamLink) async {
    // Fetch the stream page HTML content
    final res = await fetch(streamLink.toString());

    // Parse the HTML to find the encrypted JavaScript data
    final doc = html.parse(res);

    // Get the encrypted value from the script tag with a specific data attribute
    final String val = doc.querySelector('script[data-name="episode"]')
        ?.attributes['data-value'] ?? '';

    // If no value is found, return null
    if (val.isEmpty) return null;

    // Decrypt the base64-encoded value using AES
    final Encrypter encrypter =
    Encrypter(AES(keys['key'] as Key, mode: AESMode.cbc, padding: null));

    // Decrypt the value
    final decrypted =
    encrypter.decrypt(Encrypted.fromBase64(val), iv: keys['iv'] as IV);

    return decrypted;
  }
  Future<List<String>> extract(String streamLink) async {
    if (streamLink.isEmpty) {
      throw new Exception("ERR_EMPTY_STREAM_LINK");
    }

    // Parse the stream link URI and get the ID from query parameters
    final epLink = Uri.parse(streamLink);
    final id = epLink.queryParameters['id'] ?? '';

    // Get the encrypted key for the video
    final encryptedKey = await getEncryptedKey(id);

    // Decrypt the JavaScript data to get the required parameters
    final decrypted = await decrypt(epLink);

    // Build the parameters for the AJAX request
    final params = "id=$encryptedKey&alias=$id&$decrypted";

    // Send the AJAX request to fetch the video source data
    final res = await get(
        Uri.parse("${epLink.scheme}://${epLink.host}/encrypt-ajax.php?$params"),
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
        });

    // Parse the response and get the encrypted video source data
    final encryptedData = json.decode(res.body)['data'];

    // Decrypt the source data to get the actual video stream links
    final Encrypter encrypter =
    Encrypter(AES(keys['secondKey'] as Key, mode: AESMode.cbc));
    final decryptedSourceData = encrypter.decrypt(
        Encrypted.fromBase64(encryptedData),
        iv: keys['iv'] as IV);

    // Parse the decrypted data as JSON
    final parsed = json.decode(decryptedSourceData);

    // Create a list of streams to hold the video qualities
    List<String> qualityList = [];

    if (parsed['source'] == null && parsed['source_bk'] == null) {
      throw new Exception("No stream found");
    }

    // Iterate through the video sources and add them to the quality list
    for (final src in parsed['source']) {
      qualityList.add(src['file']);
    }
    print(qualityList.length);
    print(qualityList[0]);
    return qualityList;
  }

  Future<String> fetch(String url) async {
    final response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("Failed to load page: ${response.statusCode}");
    }
  }



}
