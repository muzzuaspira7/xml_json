import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:xml2json/xml2json.dart';
import '../colors/colors.dart';
import '../model/newsmodel.dart';
import 'detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // I have definded here the NewsModel as model
  NewsModel? model;
  @override
  void initState() {
    super.initState();
    // fetch the data in the initial point
    fetchData();
  }

// Fetch data starts here
  Future<void> fetchData() async {
    // XML format API is here
    const String apiUrl =
        'https://timesofindia.indiatimes.com/rssfeedstopstories.cms';

    try {
      // mentioned response as the apiUrl
      final Response response = await get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // fetched the data now parse xml to json format
        final Xml2Json xml2json = Xml2Json();
        xml2json.parse(response.body);
        // Getting the json
        final String jsonData = xml2json.toGData();
        // printing the json
        log(jsonData);
        setState(() {
          model = NewsModel.fromJson(jsonDecode(jsonData));
        });
        debugPrint("Done");
      } else {
        // Handle error
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      debugPrint('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluePrimary,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: const Text('India News'),
      ),
      body: SafeArea(
        // its just like if the model == null then return circular progress else listview builder (tried first time)
        child: model == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                // I want the item so mentioned like this
                itemCount: model!.rss.channel.item.length,
                itemBuilder: (context, index) {
                  // to make it easy i have used it
                  final newsItem = model!.rss.channel.item[index];
                  // Parse pubDate string into a DateTime object
                  final pubDate = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z')
                      .parse(newsItem.pubDate.t);
                  // Formatting the data how we want
                  final formattedDate =
                      DateFormat.yMMMMd().add_jm().format(pubDate);

                  return Card(
                    color: AppColors.softGreen,
                    child: Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            color: AppColors.bluePrimary,
                            blurStyle: BlurStyle.inner)
                      ]),
                      child: ListTile(
                        title: Text(newsItem.title.t),
                        subtitle: Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 12),
                        ),
                        // Image starts here
                        leading: SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: newsItem.enclosure.url,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsPage(
                                  // Here I have passed newsItem and also the formattedDate
                                  newsItem: newsItem,
                                  formattedDate: formattedDate),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
