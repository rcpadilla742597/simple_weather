import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gitpodflutter/constants/global_colors.dart';
import 'package:gitpodflutter/constants/global_widgets.dart';
import 'package:gitpodflutter/constants/text_styles.dart';
import 'package:gitpodflutter/models/article_model.dart';
import 'package:gitpodflutter/screens/article_screen.dart';
import 'package:gitpodflutter/services/api_service.dart';

//This is the home page this is stateful widget because the data on the page is dynamically changing and not preset

class MyHomePage extends StatefulWidget {
  //boiler plate code don't need to worry
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future reponseFromApi;

//This is the initial state of the MyHomePage the lifecycle of a stateful widget is as such: initState -> build -> dispose
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Calls the api service fetch method which returns Future<List<ArticleModel>>
    reponseFromApi = SpaceFlightService.fetch();
  }

  //This is not needed since flutter will auto dispose
  @override
  void dispose() {
    super.dispose();
  }

  //build method renders your widgets on to the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //sets background color to hex #121212 use the OxFF{hex} format
      backgroundColor: bgMain,
      //the app bar is the bar that displays at the top right now it set to transparent
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
//OrientationBuilder is used to adapt to rotation and oriention of the device
      body: OrientationBuilder(
        builder: (context, orientation) {
          //Here is the safe area which accounts for notches, cameras etc.
          return SafeArea(
            minimum: EdgeInsets.symmetric(

                // condition ?  condition true: condition false This is the ternary operator in dart
                horizontal: orientation == Orientation.landscape ? 50 : 20),
            //Column represents a view laid out in a vertical format
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleSection('SpaceFlight'),
                spacer(height: 20),
                listSection(),
                spacer(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // seperating into methods like this makes different section more manageable and the above code more readable refactorable
  Widget titleSection(String title) {
    return Text(
      title,
      //Extract styles to constants file that you know you will use in later parts of the app to save time
      style: titleStyle,
    );
  }

//Notice since the listSection method is inside the scope of the MyHomePage class there is no need to pass in context
  Widget listSection() {
    //This is a future builder it takes in a future and does something based on the state of the future
    return FutureBuilder(
      future: reponseFromApi,
      //snapshot represents an asynchronus snapshot of the future. TLDR: snaphot holds the data from the future
      builder: (context, snapshot) {
        //Conditional rendering allows you to display loading screens while the data is being fetched
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          //as mentioned before snapshot holds the data to access it just use snapshot.data
          List<ArticleModel> articleList = snapshot.data;

          return Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RawScrollbar(
                thumbColor: Colors.white54,
                // isAlwaysShown: true,
                radius: Radius.circular(10),

                // NOTE: Listviews are unbounded so they need some sort of constraints. In this case above the parent of this is a Expanded widget which exapnds to the rest of the available space
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  //Tells the list view how many items it will need to render
                  itemCount: articleList.length,
                  //since this is a ListView.seperated there is a property called seperator builder this is convienient when you dont want to adding padding around the main content widget
                  // NOTE: the _ signifies an unused varaible normally context is the variable passed but it is not needed
                  separatorBuilder: (_, index) => spacer(height: 20),
                  //This is how the items get rendered from the article list
                  itemBuilder: (_, index) {
                    ArticleModel article = articleList[index];

                    //simple card
                    return Card(
                      color: Colors.grey[900],
                      margin: EdgeInsets.zero,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),

                        // NOTE: Hero widgets allow you to wrap one widget that animates transition from one screen to another
                        leading: Hero(
                          //Every Hero widget needs a tag this tag should be the same as the one on the recieving end
                          tag: article.id,
                          child: CircleAvatar(
                            backgroundImage: article.image,
                            backgroundColor: Colors.grey[600],
                          ),
                        ),
                        title: Text(
                          article.title,
                          style: whiteBold(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          article.newsSite,
                          style: whiteRegular(
                              fontSize: 12, color: Colors.cyan[400]),
                        ),
                        onTap: () {
                          //This is how to navigate through screens with the Navigator api
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ArticleScreen(
                              article: article,
                            ),
                          ));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
