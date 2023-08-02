import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/models/hospital.dart';
import 'package:mca_official_flutter_sdk/src/services/api_scheme.dart';

import '../const.dart';
import '../services/services.dart';
import '../theme.dart';
import '../widgets/common.dart';

class HospitalList extends StatefulWidget {
  const HospitalList({Key? key,this.routeName, this.publicKey})
      : super(key: key);

  final String? publicKey;
  final String? routeName;

  @override
  State<HospitalList> createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  @override
  void initState() {
    getHospitalList();
    super.initState();
  }

  bool isLoading = false;
  List<Hospital> hospitalList = [];
  List<Hospital> filteredList = [];

  void getHospitalList() async {
    if (hospitalList.isNotEmpty) return;

    setState(() {
      isLoading = true;
    });

    var result =
        await WebServices.getHospitalList(widget.publicKey, widget.routeName!!);

    setState(() {
      isLoading = false;
    });

    print(result);

    if (result is Map) {
      if ((result["responseText"] as String)
          .toLowerCase()
          .contains("hospitals retrieved")) {
        List<Hospital> list = [];

        for (var x in result["data"]["hospitals"]) {
          list.add(Hospital.fromJson(x));
        }

        setState(() {
          hospitalList = list;
          filteredList = list;
        });
      } else {
        log(result.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 0.1),
                shape: BoxShape.circle,
                color: FILL_GREEN),
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(hospital,
                    height: 25, package: 'mca_official_flutter_sdk'))),
        (isLoading)
            ? const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: PRIMARY,
                  ),
                ),
              )
            : Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${hospitalList.length} Hospitals",
                        style: const TextStyle(
                            fontSize: 14,
                            color: PRIMARY,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Space"),
                      ),
                    ),
                    Card(
                      elevation: 0.4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              filteredList = hospitalList
                                  .where((element) => element.name!
                                      .toLowerCase()
                                      .startsWith(text.toLowerCase()))
                                  .toList();
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search hospital list",
                              hintStyle: TextStyle(
                                  color: ASH,
                                  fontSize: 14,
                                  fontFamily: "Space")),
                        ),
                      ),
                    ),
                    verticalSpace(),
                    Expanded(
                        child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var hospital = filteredList[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 7),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: Text(
                                      hospital.name!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontFamily: "Space",
                                          fontSize: 15,
                                          color: DARK_GREY),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.67,
                                    child: Text(hospital.address!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: "Space",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: ASH)),
                                  )
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(hospital.location!,
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontFamily: "Space",
                                      fontSize: 13,
                                      color: DARK_GREY))
                            ],
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
      ],
    );
  }
}
