import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/beehub_button.dart';
import 'package:beehub_flutter_app/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>  with SingleTickerProviderStateMixin{
  final _searchController = TextEditingController();
  late final TabController _tabController;
  
  // final Map<String,dynamic> result = {"posts": <List<Post>>[], "groups": [],"people": []};
  final List<Tab> _tabs = const [
    Tab(text: "Posts"),
    Tab(text: "People"),
    Tab(text: "Groups"),
  ];
  final List<Widget> _tabsBody = [
    PostSearched(onUpdatePost: (){}),
    const PeopleSearched(),
    const GroupSearched()
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       bool refetch = Provider.of<UserProvider>(context, listen: false).refetch;
       
      if(refetch){
        Provider.of<UserProvider>(context, listen: false).refetchSearch(_searchController.text);
      }else{
        Provider.of<UserProvider>(context, listen: false).fetchSearch(_searchController.text);
      }
      final UserProvider myProvider = Provider.of<UserProvider>(context, listen: false);
      _searchController.addListener(() {
        myProvider.fetchSearch(_searchController.text);
      });
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String arguments = Get.arguments ?? {};
    _searchController.text = arguments;
    
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(icon: const Icon(Icons.chevron_left),onPressed: (){
          Get.toNamed("/");
        },),
        title: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Searching on Beehub',
                  ),
                )
      ),
      resizeToAvoidBottomInset : false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TabBar(
                    controller:  _tabController,
                    tabs: _tabs
                    )
                ],
              ),
            ),
            Expanded(
              flex: 13,
              child: TabBarView(
                  controller: _tabController,
                  children: _tabsBody,),
              
              )
          ],
        )
    );
  }
}
class PostSearched extends StatelessWidget {
  const PostSearched({super.key, required this.onUpdatePost});
  final void Function() onUpdatePost;
  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    Map<String,dynamic> search = Provider.of<UserProvider>(context).resultSearch;    
    if(isLoading||search.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<dynamic> list =  search["posts"] ?? [];
    if(list.isEmpty){
      return const Text("Found 0 post");
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index){
        return PostWidget(post: list[index],onUpdatePostList: onUpdatePost,);
      });
  }
}
class PeopleSearched extends StatelessWidget {
  const PeopleSearched({super.key});
  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).refetch = true;
    Widget getButton(User usernow){
      switch (usernow.typeRelationship) {
        case "BLOCKED":
          return BeehubButton.UnBlock(usernow.id, '/search',Get.arguments);
        case "FRIEND":
          return BeehubButton.UnFriend(usernow.id, '/search',Get.arguments);
        case "SENT_REQUEST":
          return BeehubButton.CancelRequest(usernow.id, '/search',Get.arguments);
        case "NOT_ACCEPT":
          return BeehubButton.AcceptFriend(usernow.id, usernow.isBanned, '/search',Get.arguments);
        default:
          return BeehubButton.AddFriend(usernow.id, '/search',Get.arguments);

      }
    }
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    Map<String,dynamic> search = Provider.of<UserProvider>(context).resultSearch;
    if(isLoading||search.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<dynamic> list = search["people"] ?? [];
    if(list.isEmpty){
      return const Text("Found 0 people");
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: list.length,
      itemBuilder: (context, index){
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: GestureDetector(
            onTap: (){
             
              Get.toNamed("/userpage/${list[index].username}");
            },
            child: list[index].image!=null
            ? CircleAvatar(
              child: Image.network(list[index].image!))
            :(list[index].gender=='female'
                          ?CircleAvatar(
                            child: Image.asset("assets/avatar/user_female.png"),)
                          :CircleAvatar(
                            child: Image.asset("assets/avatar/user_male.png"))
            ),
          ),
          title: GestureDetector(
            onTap: (){
              Get.toNamed("/userpage/${list[index].username}");
            },
            child: Text(list[index].fullname)),
          subtitle: Row(
            children: [
              Text("${list[index].friendCounter} friends"),
              const SizedBox(width: 20),
              Text("${list[index].groupCounter} groups")
            ],
          ),
          trailing: getButton(list[index]),
        );
      });
  }
}
class GroupSearched extends StatelessWidget {
  const GroupSearched({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    Map<String,dynamic> search = Provider.of<UserProvider>(context).resultSearch;
    if(isLoading||search.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<dynamic> list = search["groups"]??[];
    if(list.isEmpty){
      return const Text("Found 0 group");
    }
    Widget getButton(Group group){
      if(group.joined==null){
        return BeehubButton.JoinGroup(group.id!, "/search", Get.arguments);
      }else if(group.joined=='send request'){
        return BeehubButton.CancelJoinGroup(group.id!, "/search", Get.arguments);
      }else{
        switch (group.memberRole) {
          case "MEMBER":
            return BeehubButton.VisitGroup(group.id!);
          case "GROUP_CREATOR":
            return BeehubButton.ManagerGroup(group.id!);
          case "GROUP_MANAGER":
            return BeehubButton.ManagerGroup(group.id!);
          default:
            return BeehubButton.VisitGroup(group.id!);
        }
      }
    }
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemCount: list.length,
      itemBuilder: (context, index){
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: GestureDetector(
            onTap: (){
              Get.toNamed("/group/${list[index].id}");
            },
            child: list[index].imageGroup!=null
            ? CircleAvatar(
              child: Image.network(list[index].imageGroup!))
            :CircleAvatar(child: Image.asset("assets/avatar/group_image.png")),
          ),
          title: Text(list[index].groupname),
          subtitle: Row(
            children: [
              Text("${list[index].publicGroup? "Public": "Private"} group"),
              const SizedBox(width: 20),
              Text("${list[index].memberCount} members")
            ],
          ),
          trailing: getButton(list[index]),
        );
      });
  }
}