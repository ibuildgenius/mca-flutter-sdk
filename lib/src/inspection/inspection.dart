import 'package:flutter/material.dart';

import 'demo.dart';

enum TypeOfProduct { auto, health, gadget, travel }
enum InspectionType { vehicle, gadget, home  }


class MyCoverInspection {
  const MyCoverInspection({
    Key? key,
    required this.context,
    required this.email,
    required this.token,
    required this.policyId,
    required this.reference,
    required this.typeOfInspection,
  });

  final BuildContext context;
  final String token,
      email,
      policyId,reference;
  final InspectionType typeOfInspection;

  initialise() async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DemoScreen(
                  token: token,
                  email: email,
                  policyId: policyId,
              reference: reference,
                  typeOfInspection: typeOfInspection,
                )));
  }
}
