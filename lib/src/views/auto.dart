import 'package:flutter/material.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AutoScreen extends StatefulWidget {
  const AutoScreen({Key? key}) : super(key: key);


  @override
  State<AutoScreen> createState() => _AutoScreenState();
}

class _AutoScreenState extends State<AutoScreen> with TickerProviderStateMixin {
  TabController? tabController;
  int selectedTabIndex = 0;

  @override
  initState() {
    tabController = TabController(vsync: this, length: 3);
    tabController!.addListener(() {
      setState(() {
        selectedTabIndex = tabController!.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  void onTabSelected(int index) {
    tabController!.animateTo(index);
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  autoIntro();
  }



  Widget autoIntro() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabBar(
            isScrollable: false,
            controller: tabController,
            indicator: const BoxDecoration(color: LIGHT_GREY),
            tabs: <Widget>[
              InkWell(
                  onTap: () => onTabSelected(0),
                  child: tabDeco(context, "How it works", selectedTabIndex, 0)),
              InkWell(
                  onTap: () => onTabSelected(1),
                  child: tabDeco(context, "Benefits", selectedTabIndex, 1)),
              InkWell(
                  onTap: () => onTabSelected(2),
                  child: tabDeco(context, "How to Claim", selectedTabIndex, 2)),
            ],
          ),
          verticalSpace(),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: [autoHowItWorks(), autoBenefits(), autoHowToClaim()]),
          ),
        ],
      ),
    );
  }

  autoHowItWorks() => Container(
    color: LIGHT_GREY,
    child: Column(
      children: [
        verticalSpace(),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 0.1),
                shape: BoxShape.circle,
                color: FILL_GREEN),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(book, height: 25,                      package: 'mca_flutter_sdk'
                ))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        textTile('Get this Auto Insurance Plan'),
        verticalSpace(),
        textTile('Provide Vehicle Details'),
        verticalSpace(),
        textTile('Get your Insurance Certificate'),
        verticalSpace(),
        textTile('Inspect your vehicle, from anywhere'),
      ],
    ),
  );

  autoBenefits() => Container(
    color: LIGHT_GREY,
    child: Column(
      children: [
        verticalSpace(),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 0.1),
                shape: BoxShape.circle,
                color: FILL_GREEN),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(insight, height: 25,                      package: 'mca_flutter_sdk'
                ))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        textTile('3rd Party Bodily Injury'),
        verticalSpace(),
        textTile('3rd party Property Damage Up to 1 Million'),
        verticalSpace(),
        textTile('Own Accident Damage'),
        verticalSpace(),
        textTile('Excess Buy Back'),
      ],
    ),
  );

  autoHowToClaim() => Container(
    color: LIGHT_GREY,
    child: Column(
      children: [
        verticalSpace(),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: GREEN, width: 0.1),
                shape: BoxShape.circle,
                color: FILL_GREEN),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(layer, height: 25,                      package: 'mca_flutter_sdk'
                ))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        textTile('Take pictures of damage'),
        verticalSpace(),
        textTile('Track the progress of your Claim'),
        verticalSpace(),
        textTile('Get paid'),
      ],
    ),
  );


}




