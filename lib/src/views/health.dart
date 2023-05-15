import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/common.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;
  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen>
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
    return  healthIntro();
  }



  Widget healthIntro() {
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
            ],
          ),
          verticalSpace(),
          Expanded(
            child: TabBarView(
                controller: tabController,
                children: [healthHowItWorks(), healthBenefits()]),
          ),
        ],
      ),
    );
  }

  healthHowItWorks() => Container(
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
                child: Image.asset(book, height: 25, package: 'mca_official_flutter_sdk'
                ))),
        verticalSpace(),
        const Divider(),
        verticalSpace(),
        Expanded(
          child: SingleChildScrollView(
            child: Html(data: widget.data["how_it_works"]  ?? "<p>no data</p>", style: htmlStyle,),
          ),
        )
      ],
    ),
  );

  healthBenefits() => Container(
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
                child: Image.asset(insight, height: 25,                      package: 'mca_official_flutter_sdk'
                ))),
        verticalSpace(),
        const Divider(),

        Expanded(child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  (widget.data["full_benefits"] != null && widget.data["full_benefits"] is List) ?
            List<Widget>.generate((widget.data["full_benefits"] as List).length, (index) {
              return textTile(widget.data["full_benefits"][index]["name"] + " - " + widget.data["full_benefits"][index]["description"]);
            }) : [Html(data: widget.data["key_benefits"] ?? "<p>no data</p>", style: htmlStyle,)],
          ),
        ))

      ],
    ),
  );
}

