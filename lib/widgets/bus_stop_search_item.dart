import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meta/meta.dart';

import '../models/bus_stop.dart';
import '../models/user_route.dart';
import '../utils/database_utils.dart';
import '../widgets/highlighted_icon.dart';

class BusStopSearchItem extends StatefulWidget {
  const BusStopSearchItem({
    @required Key key,
    @required this.codeStart,
    @required this.codeBold,
    @required this.codeEnd,
    @required this.nameStart,
    @required this.nameBold,
    @required this.nameEnd,
    @required this.distance,
    @required this.busStop,
    this.onTap
  }) : super (key: key);

  final String codeStart;
  final String codeBold;
  final String codeEnd;
  final String nameStart;
  final String nameBold;
  final String nameEnd;
  final String distance;
  final BusStop busStop;
  final Function onTap;

  @override
  State<StatefulWidget> createState() {
    return BusStopSearchItemState();
  }
}

class BusStopSearchItemState extends State<BusStopSearchItem> with SingleTickerProviderStateMixin {
  bool _isStarEnabled = false;

  BusStopChangeListener _busStopListener;

  @override
  void initState() {
    super.initState();
    isBusStopInRoute(widget.busStop, UserRoute.home).then((bool contains) {
      if (mounted)
        setState(() {
          _isStarEnabled = contains;
        });
    });
    _busStopListener = (BusStop busStop) {
      isBusStopInRoute(widget.busStop, UserRoute.home).then((bool contains) {
        if (mounted)
          setState(() {
            _isStarEnabled = contains;
          });
      });
    };
    registerBusStopListener(widget.busStop, _busStopListener);
  }

  @override
  void dispose() {
    unregisterBusStopListener(widget.busStop, _busStopListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0, right: 16.0),
      onTap: widget.onTap,
      leading: Container(
        width: 48.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HighlightedIcon(
              iconColor: Theme.of(context).colorScheme.primary,
              child: SvgPicture.asset(
                'assets/images/bus-stop.svg',
                width: 24.0,
                height: 24.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (widget.distance.isNotEmpty)
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.distance,
                    softWrap: false,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      title: RichText(
        text: TextSpan(
          text: widget.nameStart,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.normal),
          children: <TextSpan>[
            TextSpan(
                text: widget.nameBold,
                style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  decorationColor: Theme.of(context).textTheme.bodyText2.color,
                )),
            TextSpan(
                text: widget.nameEnd),
          ],
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: widget.codeStart,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: Theme.of(context).hintColor),
          children: <TextSpan>[
            TextSpan(
                text: widget.codeBold,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  decorationColor: Theme.of(context).textTheme.bodyText2.color,
                )),
            TextSpan(
                text: widget.codeEnd),
            TextSpan(
                text: ' ⋅ ${widget.busStop.road}'),
          ],
        ),
      ),
      trailing: IconButton(
        icon: SvgPicture.asset(
          _isStarEnabled ? 'assets/images/pin.svg': 'assets/images/pin-outline.svg',
          color: _isStarEnabled ? Theme.of(context).colorScheme.secondary : Theme.of(context).hintColor,
        ),
        tooltip: _isStarEnabled ? 'Unpin from home' : 'Pin to home',
        onPressed: () {
          setState(() {
            _isStarEnabled = !_isStarEnabled;
          });
          if (_isStarEnabled) {
            addBusStopToRoute(widget.busStop, UserRoute.home, context);
          } else {
            removeBusStopFromRoute(widget.busStop, UserRoute.home, context);
          }
        },
      ),
    );
  }
}