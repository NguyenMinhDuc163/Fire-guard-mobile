// import 'package:flutter/material.dart';
//
// class ReorderableListViewWidget extends StatefulWidget {
//   const ReorderableListViewWidget({super.key});
//
//   @override
//   State<ReorderableListViewWidget> createState() =>
//       _ReorderableListViewWidgetState();
// }
//
// class _ReorderableListViewWidgetState extends State<ReorderableListViewWidget> {
//   final List<String> _products = [
//     'Delicious Apple',
//     'Tropical Mango',
//     'Juicy Orange',
//     'Sweet Banana',
//     'Fresh Strawberry',
//     'Ripe Cherry'
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return ReorderableListView.builder(
//       itemCount: _products.length,
//       itemBuilder: (context, index) {
//         return Card(
//           key: ValueKey(_products[index]),
//           color: Colors.black,
//           elevation: 4,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(16),
//             title: Text(
//               _products[index],
//               style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//             ),
//             tileColor: Colors.green.shade50,
//             iconColor: Colors.black,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         );
//       },
//       onReorder: (oldIndex, newIndex) {
//         setState(() {
//           if (newIndex > oldIndex) {
//             newIndex -= 1;
//           }
//           final item = _products.removeAt(oldIndex);
//           _products.insert(newIndex, item);
//         });
//       },
//     );
//   }
// }
