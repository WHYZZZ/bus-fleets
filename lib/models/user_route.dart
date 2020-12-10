import 'package:meta/meta.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/database_utils.dart';
import 'bus_stop.dart';

class UserRoute {
  UserRoute({
    @required this.name,
    @required this.color,
    @required this.busStops,
  }) : id = null;
  UserRoute.withId({
    @required this.id,
    @required this.name,
    @required this.color,
    @required this.busStops,
  });
  UserRoute._({
    @required this.id,
    @required this.name,
    @required this.color,
  }) : busStops = <BusStop>[];
  static UserRoute home = UserRoute._(id: defaultRouteId, name: defaultRouteName, color: null);

  final int id;
  String name;
  Color color;
  List<BusStop> busStops;

  static UserRoute fromMap(Map<String, dynamic> map) {
    return UserRoute._(
      id: map['id'],
      name: map['name'],
      color: Color(map['color']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'color': color.value,
    };
  }

  void update(UserRoute from) {
    name = from.name;
    color = from.color;
    busStops = List<BusStop>.from(from.busStops);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType)
      return false;
    final UserRoute otherRoute = other;
    return id == otherRoute.id && color == otherRoute.color && listEquals(busStops, otherRoute.busStops);
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return '$name (id: $id, color: $color) (bus stops: $busStops)';
  }
}

extension ContextColor on Color {
  Color of(BuildContext context) {
    return HSLColor.fromColor(this).withLightness(Theme.of(context).brightness == Brightness.light ? 0.45 : 0.75).toColor();
  }
}