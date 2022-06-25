import 'package:flutter/material.dart';

import '../../../providers/theme/primary_box_decoration.dart';
import 'main.dart';

ceremonieShimmer(BuildContext context) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 30),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          decoration: BoxDecorationPrimary(context,
              topRigth: 20, topLeft: 20, bottomRigth: 0, bottomLeft: 0),
          height: 253,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CustomWidget.rectangular(
                  height: 20,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: CustomWidget.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person),
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.airplane_ticket),
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: CustomWidget.rectangular(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Expanded(
                    child: Center(),
                  ),
                  CustomWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
          height: 80,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: CustomWidget.rectangular(
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            height: 16,
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          width: double.infinity,
          decoration: BoxDecorationPrimary(context,
              topRigth: 0, topLeft: 0, bottomRigth: 20, bottomLeft: 20),
        ),
      ],
    ),
  );
}
