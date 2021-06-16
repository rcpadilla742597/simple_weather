import 'package:flutter/material.dart';
import 'package:gitpodflutter/constants/global_colors.dart';
import 'package:gitpodflutter/constants/global_widgets.dart';
import 'package:gitpodflutter/constants/text_styles.dart';
import 'package:gitpodflutter/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatelessWidget {
  final ArticleModel article;

  /*
   * this is a constructor for the ArticleSceen widget
   * The {} is for named parameters when you pass in a variable from outside this widget make sure it is final
   * 
  */
  ArticleScreen({this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgMain,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return SafeArea(
            minimum: EdgeInsets.symmetric(
                horizontal: orientation == Orientation.landscape ? 50 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(height: 40),
                imageTitle(),
                spacer(height: 20),
                content()
              ],
            ),
          );
        }));
  }

  Row imageTitle() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Same id as from the previous screen
          Hero(
              tag: article.id,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(
                      height: 170,
                      width: 130,
                      fit: BoxFit.cover,
                      image: article.image))),
          spacer(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  style: titleStyle.copyWith(
                      fontSize: titleStyle.fontSize - 6,
                      fontWeight: FontWeight.bold),
                  maxLines: 5,
                ),
                spacer(height: 8),
                //Gesture detectors allow to add on click functions to widgets that dont have it built in. This opens the field up for many custom widgets
                GestureDetector(
                  onTap: () {
                    //using url launcher pacakge to open up different links
                    launch(article.url);
                  },
                  child: Text(
                    // NOTE: This is Dart's String interoplation you can embed variables right within strings. The syntax is $variable or ${variable} the later is used when using methods or modifiers
                    'Source: ${article.newsSite}',
                    style: whiteRegular(fontSize: 13, color: Colors.cyan[500])
                        .copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                spacer(height: 4),
                Text(
                  'Published: ${article.publishedAt.substring(0, 10)}',
                  style:
                      whiteRegular(fontSize: 13, color: Colors.deepOrange[300]),
                ),
              ],
            ),
          )
        ],
      );

  Flexible content() => Flexible(
          child: Text(
        article.summary,
        style: titleStyle.copyWith(fontSize: titleStyle.fontSize - 12),
      ));
}
