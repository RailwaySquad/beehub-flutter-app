import 'package:flutter/material.dart';

class ScrollTable extends StatelessWidget {
  final ScrollController _horizontal = ScrollController(),
      _vertical = ScrollController();

  final List<DataColumn> columns;
  final List<DataRow> rows;

  ScrollTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      width: 400,
      child: Scrollbar(
          controller: _vertical,
          thumbVisibility: true,
          trackVisibility: true,
          child: Scrollbar(
            controller: _horizontal,
            thumbVisibility: true,
            trackVisibility: true,
            notificationPredicate: (notif) => notif.depth == 1,
            child: SingleChildScrollView(
                controller: _vertical,
                child: SingleChildScrollView(
                  controller: _horizontal,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: columns,
                    rows: rows,
                  ),
                )),
          )),
    );
  }
}
