import 'package:flutter/material.dart';

import '../const.dart';
import '../theme.dart';
import '../widgets/common.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({Key? key}) : super(key: key);

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen>
    with TickerProviderStateMixin {
  TabController? tabController;
  int selectedTabIndex = 0;

  @override
  initState() {
    tabController = TabController(vsync: this, length: 2);
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
    return travelIntro();
  }

  // Travel
  Widget travelIntro() {
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
                  child:
                  tabDeco(context, "What we cover", selectedTabIndex, 1)),
            ],
          ),
          verticalSpace(),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: [travelHowItWorks(), travelBenefits()]),
          ),
        ],
      ),
    );
  }

  travelHowItWorks() => Container(
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
                child: Image.asset(book, height: 25,package: 'mca_official_flutter_sdk'))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        textTile('Buy a Travel Insurance Plan'),
        verticalSpace(),
        textTile('Provide details'),
        verticalSpace(),
        textTile('Get your Insurance Certificate'),
      ],
    ),
  );

  travelBenefits() => Container(
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
                child: Image.asset(insight, height: 25,package: 'mca_official_flutter_sdk'))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        textTile('Medical expenses Injury and Illness'),
        verticalSpace(),
        textTile('Excess'),
        verticalSpace(),
        textTile(
            'Medical evacuation, repatriation or transport to medical offline'),
        verticalSpace(),
        textTile('Optical & expenses - Injury'),
        verticalSpace(),
        textTile('Follow up treatment in Nigeria'),
        verticalSpace(),
        textTile('Other cover are listed in the document'),
      ],
    ),
  );
}

