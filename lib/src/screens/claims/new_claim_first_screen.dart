// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class ClaimIncidentTypeScreen extends StatefulWidget {
//   const ClaimIncidentTypeScreen({super.key});
//
//   @override
//   State<ClaimIncidentTypeScreen> createState() =>
//       _ClaimIncidentTypeScreenState();
// }
//
// class _ClaimIncidentTypeScreenState extends State<ClaimIncidentTypeScreen> {
//   String? selectedOption;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const TopBar(),
//
//             // Progress bar
//             const ProgressBar(progress: 0.2),
//
//             const SizedBox(height: 20),
//
//             // Question text
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 "What incident type is this claim for?",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Options
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OptionCard(
//                       assetName: "Accidental",
//                       icon: Icons.car_crash, // Replace with asset icon
//                       isSelected: selectedOption == "Accidental",
//                       onTap: () {
//                         setState(() => selectedOption = "Accidental");
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: OptionCard(
//                       label: "Theft or Fire",
//                       icon: Icons.masks, // Replace with asset icon
//                       isSelected: selectedOption == "Theft or Fire",
//                       onTap: () {
//                         setState(() => selectedOption = "Theft or Fire");
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const Spacer(),
//
//             // Continue button
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: ContinueButton(
//                 enabled: selectedOption != null,
//                 onPressed: () {
//                   if (selectedOption != null) {
//                     // navigate next
//                   }
//                 },
//               ),
//             ),
//
//             const SizedBox(height: 24),
//
//             // Footer
//             const Footer(),
//
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class TopBar extends StatelessWidget {
//   const TopBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(Icons.arrow_back_ios, size: 20),
//           Row(
//             children: [
//               Icon(Icons.help_outline, size: 20),
//               SizedBox(width: 4),
//               Text(
//                 "Help",
//                 style: TextStyle(fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           Icon(Icons.close, size: 20),
//         ],
//       ),
//     );
//   }
// }
//
// class ProgressBar extends StatelessWidget {
//   final double progress;
//
//   const ProgressBar({super.key, required this.progress});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8),
//         child: LinearProgressIndicator(
//           value: progress,
//           minHeight: 6,
//           backgroundColor: Colors.grey.shade300,
//           valueColor: const AlwaysStoppedAnimation<Color>(
//             Colors.green,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class OptionCard extends StatelessWidget {
//   final String label;
//   final String assetName;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const OptionCard({
//     super.key,
//     required this.label,
//     required this.assetName,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 94.h,
//         width: 162.w,
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: isSelected ? Colors.teal : Colors.grey.shade300,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               height: 62.h,
//               width: 62.w,
//               child: Column(
//                 children: [
//                   SvgPicture.asset(assetName),
//                   const SizedBox(height: 12),
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Icon(
//                 isSelected
//                     ? Icons.radio_button_checked
//                     : Icons.radio_button_off,
//                 color: isSelected ? Colors.teal : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ContinueButton extends StatelessWidget {
//   final bool enabled;
//   final VoidCallback onPressed;
//
//   const ContinueButton({
//     super.key,
//     required this.enabled,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: ElevatedButton(
//         onPressed: enabled ? onPressed : null,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.teal.shade200,
//           foregroundColor: Colors.white,
//           disabledBackgroundColor: Colors.teal.shade100,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: const Text(
//           "Continue",
//           style: TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
//
// class Footer extends StatelessWidget {
//   const Footer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.shield_outlined, size: 16, color: Colors.grey),
//           const SizedBox(width: 4),
//           const Text(
//             "Powered by ",
//             style: TextStyle(color: Colors.grey),
//           ),
//           Text(
//             "mycover.ai",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.teal.shade400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }