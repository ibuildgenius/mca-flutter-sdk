import 'package:flutter/material.dart';
import 'package:mca_flutter_sdk/src/theme.dart';

import '../validator.dart';
import '../widgets/input.dart';

class ContentForm extends StatefulWidget {
  const ContentForm({Key? key}) : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  var contentFormField = <Widget>[];
  final contentTitleController = <TextEditingController>[];
  final contentDescController = <TextEditingController>[];

  Widget contentFormCard() {
    var _contentTitleController = TextEditingController();
    contentTitleController.add(_contentTitleController);
    var _contentDescController = TextEditingController();
    contentDescController.add(_contentDescController);
    // Positioned(
    //     bottom: 0,
    //     right: 8,
    //     child: InkWell(
    //       onTap: () {
    //         if (_formKey.currentState!.validate()) {
    //           setState(
    //                   () => cards.add(packageCard(isExpanded: true)));
    //         }
    //       },
    //       child: Container(
    //           decoration: BoxDecoration(
    //               color: PRIMARY,
    //               borderRadius: BorderRadius.circular(3)),
    //           child: Padding(
    //             padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
    //             child: Row(
    //               children: [
    //                 const Icon(Icons.add_circle,
    //                     size: 18, color: WHITE),
    //                 Padding(
    //                   padding: const EdgeInsets.all(4.0),
    //                   child: DefaultText(
    //                       text: 'Another Package',
    //                       size: 10,
    //                       fontWeight: FontWeight.w400,
    //                       color: WHITE),
    //                 ),
    //               ],
    //             ),
    //           )),
    //     )),

    return Row(
      children: [
        InputFormField(
          label: "Object",
          controller: _contentTitleController,
          validator: (value) => FieldValidator.validate(value),
        ),
        const SizedBox(width: 10),
        InputFormField(
          label: "How many",
          controller: _contentDescController,
          maxLines: 3,
          validator: (value) => FieldValidator.validate(value),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    //   Container(
    //   decoration: BoxDecoration(
    //       border: Border.all(color: PRIMARY, width: 1.5),
    //       borderRadius: BorderRadius.circular(10),
    //       shape: BoxShape.rectangle),
    //   padding: const EdgeInsets.all(10),
    //   margin: const EdgeInsets.symmetric(vertical: 10),
    //   child: Scrollbar(
    //     child: ListView.builder(
    //       shrinkWrap: true,
    //       physics: const NeverScrollableScrollPhysics(),
    //       itemCount: contentFormField.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return Stack(
    //           children: [
    //             contentFormField[index],
    //           ],
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
