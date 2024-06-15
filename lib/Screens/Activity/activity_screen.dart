
import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Screens/Activity/group_posts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'popular_posts.dart';

class ActivityScreen extends StatefulWidget{
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<String> tabs = [
    "Popular",
    "Groups"
  ];
  int currentTab =0;
  double changePositionedOfLine(){
    switch (currentTab) {
      case 0:
        return 0;
      case 1:
        return 70;
      default:
        return 0;
    }
  }
  double changeContainerWidth(){
    switch (currentTab) {
      case 0:
        return 63;
      case 1:
        return 58 ;
      default:
        return 0;
    }
  }
  Widget changeSection(tab){
    switch (tab) {
      case "Popular":
        return const PopularPosts();
      case "Groups":
        return const GroupPosts();
      
      default:
        return const PopularPosts();
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
          children: [
            AppBar(
              title: const Text('Beehub'),
                actions: [
                  IconButton(onPressed: (){
                    showSearch(context:context, delegate: BeehubSearchDelegate());
                  }, icon:const Icon(Icons.search)),
                  IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () {
                        ///logout
                        DatabaseProvider().logOut(context);
                      }),
                ],
            ),
            SizedBox(
              width: size.width,
              height: size.height*0.05,
              child: Stack(children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: tabs.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              currentTab = index;
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:index==0?10:22,
                              top: 7),
                            child: Text(tabs[index],style: GoogleFonts.ubuntu(
                              fontSize: currentTab==index? 16:14,
                              fontWeight: currentTab==index?FontWeight.w400: FontWeight.w300),),
                          ),
                        );
                      }),
                  ),
                ),
                AnimatedPositioned(
                  bottom: 0,
                  left: changePositionedOfLine(),
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    margin: const EdgeInsets.only(left: 10),
                    duration:const Duration(milliseconds: 500),
                    width: changeContainerWidth(),
                    height: size.height*0.008,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: TColors.primary),
                    ),
                )
              ],)
            ),
            
            Expanded(
              child: changeSection(tabs[currentTab]))
            
          ],
        );
  }
}

class BeehubSearchDelegate extends SearchDelegate {
  List<String> list=[];
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: (){
        query="";
      }, icon: const Icon(Icons.clear)),
    ];
  }
  
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
        close(context,null);
      }, 
      icon: const Icon(Icons.arrow_back));
  }
  
  @override
  Widget buildResults(BuildContext context) =>Container();
  @override
  void showResults(BuildContext context) {
    Navigator.of(context).popAndPushNamed(
      '/search',
      arguments: query,
    );
    super.showResults(context);
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery=[];
    for(var item in list){
      if(item.toLowerCase().contains(query.toLowerCase())){
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context,index){
        return ListTile(
          title: Text(list[index]),
        );
      });
  }
}

