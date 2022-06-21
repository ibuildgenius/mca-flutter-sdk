import 'package:flutter/material.dart';

import '../theme.dart';

Widget button({onTap, color, text}) => Padding(
  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
  child: InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: PRIMARY,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Center(
            child: Text(
              text ?? '',
              style: const TextStyle(
                  color: WHITE, fontSize: 14, fontWeight: FontWeight.w600),
            )),
      ),
    ),
  ),
);

Widget successButton({onTap, color, text}) => Padding(
  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
  child: InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: PRIMARY,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Center(
                child: Text(
                  text ?? '',
                  style: const TextStyle(
                      color: WHITE, fontSize: 14, fontWeight: FontWeight.w600),
                )),
            const Icon(Icons.arrow_forward, color: WHITE, size: 16),
          ],
        ),
      ),
    ),
  ),
);

Widget dialogButton({onTap, color, text}) => Padding(
  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
  child: InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: PRIMARY,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        child: Center(
            child: Text(
              text ?? '',
              style: const TextStyle(
                  color: WHITE, fontSize: 14, fontWeight: FontWeight.w600),
            )),
      ),
    ),
  ),
);

