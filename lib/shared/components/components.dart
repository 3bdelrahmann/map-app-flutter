import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_app/models/map_marker_model.dart';
import 'constants.dart';

class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(Animation<double> animation, {Key? key})
      : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(
      0.5,
      1.0,
      value,
    ); //It does not go to zero if it does not reach the middle
    const size = 50.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * newValue!,
          height: size * newValue,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MARKER_COLOR.withOpacity(0.5),
          ),
        ),
        Container(
          width: 20.0,
          height: 20.0,
          decoration: const BoxDecoration(
            color: MARKER_COLOR,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

final _styleTitle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);
final _styleAddress = TextStyle(
  color: Colors.grey[800],
  fontSize: 14.0,
);
Widget mapItemDetails({required MapMarkerModel mapMarker}) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        mapMarker.image,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mapMarker.title,
                          style: _styleTitle,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          mapMarker.address,
                          style: _styleAddress,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              color: MARKER_COLOR,
              elevation: 6.0,
              child: const Text(
                'CALL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );

Widget locationMarker({bool selected = false}) => Center(
      child: AnimatedContainer(
        height: selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED,
        width: selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED,
        duration: const Duration(milliseconds: 200),
        child: SvgPicture.asset(
          'assets/images/marker.svg',
          color: MARKER_COLOR,
        ),
      ),
    );
