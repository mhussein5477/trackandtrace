import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackandtrace/views/addpatient.dart';
import 'package:trackandtrace/views/home_view.dart';
import 'package:trackandtrace/widgets/provider_widget.dart';
import 'package:trackandtrace/widgets/resultcard.dart';
import 'home_view.dart';



class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),


  ];
  bool typecheck = false ;
  String accounttype = " ";

  @override
  void initState() {
    checktype().then((value){
      print('Async done');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(accounttype , style: TextStyle(
            fontSize: 22, color: Colors.white, ),),centerTitle: true,
        actions: <Widget>[

          Visibility(
            visible: typecheck,
            child:  IconButton(
              color: Colors.white,
              onPressed: (){
                showSearch(context: context, delegate: VacancySearch() );
              },
              icon: Icon(Icons.search),
            )
            ,
          )


        ],
      ),

      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue[400], //This will change the drawer background to blue.
          //other styles
        ),
        child: Drawer(


          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child:  FutureBuilder(
                            future: Provider.of(context).auth.getCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return displayUserInformation(context, snapshot);
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                decoration: BoxDecoration(
                  color: Colors.blue[400],
                ),
              ),



              Padding(padding: EdgeInsets.only(top: 10),),
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14, top: 50),
                child: Container(
                  color: Colors.white,
                  child: ListTile(

                      title: Text('LOGOUT'),
                      leading: Icon(Icons.exit_to_app, size: 23, color: Colors.blue,),
                      onTap: ()   {
                        Navigator.of(context).pushReplacementNamed('/firstview');
                      },),
                ),
              ),


            ],
          ),

        ),
      ),


      body: _children[_currentIndex],

    );
  }

  void onTabTapped(int index) {

    setState(() {
      _currentIndex = index;
    });
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

          return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Icon(Icons.account_circle, color: Colors.white, size: 60,),
                ),
                Padding(padding: const EdgeInsets.only(top: 5.0),),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${authData.displayName}",
                    style: TextStyle(fontSize: 15 , color: Colors.white),
                  ),
                ),





    ]
    );
  }


 checktype() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseUser user = await auth.currentUser();
final userid = user.uid;
    Firestore.instance.collection('users').where('uid', isEqualTo: userid).getDocuments().then((docs){
      if(docs.documents[0].exists){
        if(docs.documents[0].data['type'] == 'admin'){
          setState(() {
            typecheck = true;
            accounttype = "Health officer";
          });
        }else{
          setState(() {
            typecheck = false;
            accounttype = "Users";
          });
        }
      }
    });
  }


}
class VacancySearch extends SearchDelegate<Home>{

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
      icon: Icon(Icons.clear),
      onPressed: (){
        query = "";
      },
    ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than one letters.",
            ),
          )
        ],
      );
    }
    else {
      return Container(
        color: Colors.grey[100],
        child : StreamBuilder(
          stream: query != "" && query != null ?
          Firestore.instance.collection('users').where(
              'name', isGreaterThanOrEqualTo : query).snapshots()
              : Firestore.instance.collection('userData').snapshots(),
          builder:   (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');


            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    resultcard(context, snapshot.data.documents[index]));
          },
        ),
      );

    }

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  Container(
      color: Colors.grey[100],
      child: StreamBuilder(
        stream: query != "" && query != null ?
        Firestore.instance.collection('users').where(
            'name', isGreaterThanOrEqualTo : query).snapshots()
            : Firestore.instance.collection('userData').snapshots(),
        builder:   (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          if(snapshot.data == null) return Center(child: Text('No result found'));

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) =>
                  resultcard(context, snapshot.data.documents[index]));
        },
      ),
    );
  }







}
