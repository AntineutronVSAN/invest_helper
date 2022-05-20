import 'package:flutter/material.dart';
import 'package:invests_helper/theme/texts.dart';

class PaginableList<T> extends StatefulWidget {
  final List<T> data;
  final int items;
  final Widget Function(BuildContext context, int index) builder;

  const PaginableList({
    Key? key,
    required this.data,
    this.items = 15,
    required this.builder,
  }) : super(key: key);

  @override
  _PaginableListState<T> createState() => _PaginableListState<T>();
}

class _PaginableListState<T> extends State<PaginableList<T>> {
  List<T>? currentData;
  int caretPos = 0;
  bool canPaginate = true;

  @override
  void didUpdateWidget(covariant PaginableList<T> oldWidget) {
    final currentConsultationsCount = widget.data.length;
    final oldConsultationsCount = oldWidget.data.length;
    if (currentConsultationsCount != oldConsultationsCount) {
      _resetPagination();
      _paginate();
    } else {
      _updateData();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _resetPagination();
    _paginate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _updateData();
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: currentData!.length,
            itemBuilder: (context, index) {
              return widget.builder(context, index);
        }),
        if (canPaginate)
          GestureDetector(
            onTap: () {
              _makePagination();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: AppTexts.subtitleText(text: 'Показать больше'),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _paginate() {
    caretPos += widget.items;
    if (!_canPaginate()) {
      canPaginate = false;
      currentData = widget.data;
      return;
    }
    _updateData();
  }

  void _resetPagination() {
    caretPos = 0;
    canPaginate = widget.data.length >= widget.items;
  }

  bool _canPaginate() {
    final consultationsCount = widget.data.length;
    if (caretPos > consultationsCount) {
      return false;
    }
    /*if (caretPos > consultationsCount ||
        caretPos + widget.items - 1 > consultationsCount) {
      return false;
    }*/
    if (consultationsCount == currentData?.length) {
      return false;
    }
    return true;
  }

  void _makePagination() {
    _paginate();
    setState(() {});
  }

  void _updateData() {
    if (widget.data.length <= caretPos) {
      currentData = widget.data;
      return;
    }
    currentData = widget.data.sublist(0, caretPos);
  }
}
