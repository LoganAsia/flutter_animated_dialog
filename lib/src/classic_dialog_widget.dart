import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

typedef OnSingleSelectionCallback = void Function(int selectedIndex);
typedef OnMultiSelectionCallback = void Function(List<int> selectedIndexes);

@immutable
class ClassicGeneralDialogWidget extends StatelessWidget {
  final String titleText; // Non-nullable and required
  final String? contentText;
  final List<Widget>? actions;
  final String? negativeText;
  final String? positiveText;
  final TextStyle? negativeTextStyle;
  final TextStyle? positiveTextStyle;
  final VoidCallback? onNegativeClick;
  final VoidCallback? onPositiveClick;

  ClassicGeneralDialogWidget({
    required this.titleText,
    this.contentText,
    this.actions,
    this.negativeText,
    this.positiveText,
    this.negativeTextStyle,
    this.positiveTextStyle,
    this.onNegativeClick,
    this.onPositiveClick,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDialogWidget(
      title: Text(
        titleText,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: contentText != null
          ? Text(
              contentText!,
              style: Theme.of(context).dialogTheme.contentTextStyle,
            )
          : null,
      actions: actions ??
          [
            if (onNegativeClick != null)
              TextButton(
                onPressed: onNegativeClick,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.overline?.color,
                  textStyle: negativeTextStyle ??
                      TextStyle(
                        fontSize: Theme.of(context).textTheme.button?.fontSize,
                      ),
                ),
                child: Text(negativeText ?? 'Cancel'),
              ),
            if (onPositiveClick != null)
              TextButton(
                onPressed: onPositiveClick,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  textStyle: positiveTextStyle ??
                      TextStyle(
                        fontSize: Theme.of(context).textTheme.button?.fontSize,
                      ),
                ),
                child: Text(positiveText ?? 'Confirm'),
              ),
          ],
      elevation: 0.0,
      shape: Theme.of(context).dialogTheme.shape,
    );
  }
}

enum ListType { single, singleSelect, multiSelect }

class ClassicListDialogWidget<T> extends StatefulWidget {
  final String titleText;
  final List<T>? dataList;
  final Widget? listItem;
  final VoidCallback? onListItemClick;
  final ListType listType;
  final ListTileControlAffinity controlAffinity;
  final Color? activeColor;
  final List<int>? selectedIndexes;
  final int? selectedIndex;
  final String? negativeText;
  final String? positiveText;
  final VoidCallback? onNegativeClick;
  final VoidCallback? onPositiveClick;
  final List<Widget>? actions;

  ClassicListDialogWidget({
    required this.titleText,
    this.dataList,
    this.listItem,
    this.onListItemClick,
    this.listType = ListType.single,
    this.controlAffinity = ListTileControlAffinity.leading,
    this.activeColor,
    this.selectedIndexes,
    this.selectedIndex,
    this.actions,
    this.negativeText,
    this.positiveText,
    this.onNegativeClick,
    this.onPositiveClick,
  });

  @override
  State<StatefulWidget> createState() => ClassicListDialogWidgetState<T>();
}

class ClassicListDialogWidgetState<T> extends State<ClassicListDialogWidget> {
  late int selectedIndex;
  late List<bool> valueList;
  late List<int> selectedIndexes;

  @override
  void initState() {
    super.initState();
    valueList = List.generate(widget.dataList?.length ?? 0, (index) {
      if (widget.selectedIndexes != null &&
          widget.selectedIndexes!.contains(index)) {
        return true;
      }
      return false;
    });
    selectedIndex = widget.selectedIndex ?? -1;
    selectedIndexes = widget.selectedIndexes ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;
    if (widget.dataList != null) {
      contentWidget = ListView.builder(
        shrinkWrap: true,
        itemCount: widget.dataList!.length,
        itemBuilder: (context, index) {
          switch (widget.listType) {
            case ListType.single:
              return ListTile(
                title: Text(
                  widget.dataList![index].toString(),
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                onTap: widget.onListItemClick ??
                    () {
                      Navigator.of(context).pop(index);
                    },
              );
            case ListType.singleSelect:
              return RadioListTile<int>(
                controlAffinity: widget.controlAffinity,
                title: Text(
                  widget.dataList![index].toString(),
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                activeColor:
                    widget.activeColor ?? Theme.of(context).primaryColor,
                value: index,
                groupValue: selectedIndex,
                onChanged: (value) {
                  setState(() {
                    selectedIndex = value!;
                  });
                },
              );
            case ListType.multiSelect:
              return CheckboxListTile(
                controlAffinity: widget.controlAffinity,
                selected: valueList[index],
                value: valueList[index],
                title: Text(
                  widget.dataList![index].toString(),
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    valueList[index] = value!;
                  });
                },
                activeColor:
                    widget.activeColor ?? Theme.of(context).primaryColor,
              );
            default:
              return ListTile(
                title: Text(
                  widget.dataList![index].toString(),
                  style: Theme.of(context).dialogTheme.contentTextStyle,
                ),
                onTap: widget.onListItemClick ??
                    () {
                      Navigator.of(context).pop(index);
                    },
              );
          }
        },
      );
      contentWidget = Container(
        width: double.maxFinite,
        child: contentWidget,
      );
    } else {
      contentWidget = Container();
    }

    return CustomDialogWidget(
      title: Text(
        widget.titleText,
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      contentPadding: EdgeInsets.all(0.0),
      content: contentWidget,
      actions: widget.actions ??
          [
            if (widget.onNegativeClick != null)
              TextButton(
                onPressed: widget.onNegativeClick,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.overline?.color,
                ),
                child: Text(widget.negativeText ?? 'Cancel'),
              ),
            TextButton(
              onPressed: widget.onPositiveClick ??
                  () {
                    switch (widget.listType) {
                      case ListType.single:
                        Navigator.of(context).pop();
                        break;
                      case ListType.singleSelect:
                        Navigator.of(context).pop(selectedIndex);
                        break;
                      case ListType.multiSelect:
                        selectedIndexes = [];
                        for (int i = 0; i < valueList.length; i++) {
                          if (valueList[i]) {
                            selectedIndexes.add(i);
                          }
                        }
                        Navigator.of(context).pop(selectedIndexes);
                        break;
                    }
                  },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(widget.positiveText ?? 'Confirm'),
            ),
          ],
      elevation: 0.0,
      shape: Theme.of(context).dialogTheme.shape,
    );
  }
}
