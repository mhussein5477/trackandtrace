import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'demographicdata.dart';

class Addpatient extends StatefulWidget {
  final String patientname  , patientid;
  final List long , lat ;
  const Addpatient({Key key, this.patientname , this.long, this.lat, this.patientid}) : super(key: key);

  @override
  _AddpatientState createState() => _AddpatientState();
}

class _AddpatientState extends State<Addpatient> {

  String idno , registryno  , clinicname , currentlocation;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String date= DateFormat('dd/MM/yyyy').format(selectedDate).toString();
    String time = selectedTime.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientname),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey ,
            child: Column(
              children: [


                Padding(
                  padding: const EdgeInsets.only(top: 28.0,),
                  child: Text("Patient Registering" , style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Text("Step One", style: TextStyle(fontSize: 18),),
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   idno = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Identification Number",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   registryno = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Registry Number",
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 38, right: 38 , bottom: 8),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() =>   clinicname = value.trim());
                    } ,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Clinic Name",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:18.0),
                  child: Text(DateFormat('dd/MM/yyyy').format(selectedDate).toString() +" , "+ time),
                ),
                RaisedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Interview Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.green,
                ),

                RaisedButton(
                  onPressed: () => _selecttime(context),
                  child: Text("Interview Time" , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  color: Colors.green,
                ),


                Padding(
                  padding: const EdgeInsets.only(top:28.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.blue, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(width: 56, height: 56, child: Icon(Icons.arrow_forward_ios , color: Colors.white,)),
                        onTap:() async{
                          var  uid =  (await FirebaseAuth.instance.currentUser()).uid;
                          final DocumentReference documentReference = await Firestore.instance.collection('patient').add({
                            'patientid': "" ,
                          });

                          final String itemId= documentReference.documentID;
                          Firestore.instance.collection('patient').document(itemId).setData({
                           "name" : widget.patientname,
                            "long" : widget.long,
                            "lat" : widget.lat,
                            "idno" : idno,
                            "regno": registryno,
                            "date": date ,
                            "time" : time,
                            "clinicname" : clinicname,
                            'patientid': widget.patientid ,
                            "adminid" : uid
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Demograph(
                                patientid : widget.patientid,
                                patientname : widget.patientname,
                                clinicname : clinicname
                            )),
                          );
                        },
                      ),
                    ),
                  ),
                )



              ],
            ),
          ) ,
        ) ,
      ),
    );
  }
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  _selecttime(BuildContext context) async{
    TimeOfDay timepicked = await showTimePicker(
      context: context,
      initialTime: selectedTime,

    );
    if (timepicked != null && timepicked != selectedTime){
      setState(() {
        selectedTime = timepicked;
      });
    }
  }


}
