import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget buildNutXoaSanPham({required VoidCallback onPressed}) {
  return Container(
    margin: EdgeInsets.only(top: 8),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(Icons.delete),
      label:Text(""),
    ),
  );
}

Widget buildItemXoaGioHang({
  required String id,
  required String tenSanPham,
  required String anhSanPham,
  required int gia,
  required VoidCallback onXoa,
}) {
  return Slidable(
    key: ValueKey(id),
    endActionPane: ActionPane(
      motion: ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => onXoa(),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Xóa',
        ),
      ],
    ),
    child: Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(
          anhSanPham,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
        title: Text(tenSanPham),
        subtitle: Text('$gia đ', style: TextStyle(color: Colors.red)),
      ),
    ),
  );
}
