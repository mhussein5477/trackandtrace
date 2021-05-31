import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trackandtrace/views/household.dart';
class Demograph extends StatefulWidget {
  final String patientid ,  clinicname , patientname;
  const Demograph({Key key, this.patientid,this.clinicname,this.patientname}) : super(key: key);
  @override
  _DemographState createState() => _DemographState();
}

class _DemographState extends State<Demograph> {
  String gender , county ,  constituency , ward , occupation , phoneno ;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Form(
            key: _formKey ,
            child: Column(
              children: [


                Padding(
                  padding: const EdgeInsets.only(top: 85.0,),
                  child: Text("Demographic Data" , style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Text("Step Two", style: TextStyle(fontSize: 18),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:38.0, top: 10, right: 38, bottom: 20),
                  child: DropdownButtonFormField(
                    value: gender,
                    items: ["Female","Male" ].map((label) => DropdownMenuItem(
                      child: Text(label),
                      value: label,
                    )).toList(),
                    onChanged: (value) {
                      setState(() => gender = value);
                    },
                    hint: Text('Gender', style: TextStyle(color: Colors.black),),
                  ),),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   county = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "County",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   constituency = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Constituency",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   ward = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Ward",
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   occupation = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Occupation",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   phoneno = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Phone Number",
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:28.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(width: 56, height: 56, child: Icon(Icons.arrow_forward_ios, color: Colors.white,)),
                        onTap:() async{
                          var  uid =  (await FirebaseAuth.instance.currentUser()).uid;
                          final DocumentReference documentReference = await Firestore.instance.collection('demographic').add({
                            'patientid': "" ,
                          });

                          final String itemId= documentReference.documentID;
                          Firestore.instance.collection('demographic').document(itemId).setData({
                            "gender" :  gender ,
                            "county" : county ,
                            "constituency" : constituency,
                            "ward": ward,
                            "occupation": occupation ,
                            "phoneno" : phoneno,
                            'patientid': widget.patientid ,
                            "adminid" : uid
                          });


                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Household(
                                patientid : widget.patientid,
                                clinicname : widget.clinicname,
                              patientname : widget.patientname,
                            )),
                          );

                        },
                      ),
                    ),
                  ),
                ),



              ],
            ),
          ) ,
          ),
        ),
      ),
    );
  }
}
