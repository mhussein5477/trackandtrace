import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mappage extends StatefulWidget {
  final String patientname;
  final List lat , long ;
  const Mappage({Key key, this.patientname , this.long , this.lat}) : super(key: key);
  @override
  _MappageState createState() => _MappageState();
}

class _MappageState extends State<Mappage> {

  Completer<GoogleMapController> _controller = Completer();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Gprs Location"),
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
          markers:{
            for (int i=0; i<widget.lat.length; i++)
            Marker(
                markerId: MarkerId('place$i'),
                position: LatLng(widget.lat[i],widget.long[i]),
                infoWindow: InfoWindow(title: 'Patient was here'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue
                )
            ),

          },

          initialCameraPosition: CameraPosition(target: LatLng(0.3031,36.0800), zoom: 10,),
        ));


  }


}
