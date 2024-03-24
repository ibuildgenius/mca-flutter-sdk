import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
// import 'package:flutter_html/flutter_html.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/common.dart';

class AutoScreen extends StatefulWidget {
  const AutoScreen({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

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
    return autoIntro();
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
                    child: Image.asset(book,
                        height: 25, package: 'mca_official_flutter_sdk'))),
            verticalSpacer(10),
            const Divider(
              color: CustomColors.gray200Color,
            ),
            verticalSpacer(10),
            Expanded(
              // child: Container(),
              child: SingleChildScrollView(
                child: HtmlWidget(
                  widget.data["how_it_works"] ?? "<p>no data</p>",
                  // style: htmlStyle,
                ),
              ),
            )
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
                    child: Image.asset(insight,
                        height: 25, package: 'mca_official_flutter_sdk'))),
            verticalSpacer(10),
            const Divider(
              color: CustomColors.gray200Color,
            ),
            verticalSpacer(10),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (widget.data["full_benefits"] != null &&
                        widget.data["full_benefits"] is List)
                    ? List<Widget>.generate(
                        (widget.data["full_benefits"] as List).length, (index) {
                        return textTile(widget.data["full_benefits"][index]
                                ["name"] +
                            " - " +
                            widget.data["full_benefits"][index]["description"]);
                      })
                    : [
                        // Container()
                        HtmlWidget(
                          widget.data["key_benefits"] ?? "<p>no data</p>",
                        )
                      ],
              ),
            ))
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
                    child: Image.asset(layer,
                        height: 25, package: 'mca_official_flutter_sdk'))),
            verticalSpacer(10),
            const Divider(
              color: CustomColors.gray200Color,
            ),
            verticalSpacer(10),
            Expanded(
              child: SingleChildScrollView(
                child: HtmlWidget(
                  widget.data["how_to_claim"] ?? "<p>no data</p>",
                  // style: htmlStyle,
                ),
              ),
            )
          ],
        ),
      );
}
