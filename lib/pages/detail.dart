import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xml_json/colors/colors.dart';
import '../model/newsmodel.dart';

class NewsPage extends StatelessWidget {
  // here I defined this because i am passing data to this page
  // because of this newsItem I can access those data from the API
  final NewsItem newsItem;
  final String formattedDate;

  const NewsPage({
    super.key,
    required this.newsItem,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bluePrimary,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: Text(
          newsItem.dcCreator.t,
          style: const TextStyle(fontSize: 17),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: newsItem.enclosure.url,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newsItem.title.t,
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: const Color.fromARGB(255, 196, 224, 253),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Text('Published at $formattedDate'),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              newsItem.description.cdata,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Published by: ${newsItem.dcCreator.t}',
              style: const TextStyle(color: Color.fromARGB(255, 53, 151, 255)),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 199, 226, 255),
              onPressed: () {
                launchUrlString(newsItem.link.t);
              },
              label: const Text('Read More Article Here!')),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
