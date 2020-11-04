import 'package:latlong/latlong.dart';

getDist(lat1, long1, lat2, long2, radius){
  final Distance distance = new Distance();
  final double mile = distance.as(LengthUnit.Mile,
      new LatLng(lat1,long1),new LatLng(lat2,long2));
  if (mile < radius){
    return true;
  } else return false;
}

getMiles(i) {
  return i*0.000621371192;
}
getMeters(i) {
  return i*1609.344;
}