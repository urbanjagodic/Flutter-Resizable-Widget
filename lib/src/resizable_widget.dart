import 'package:flutter/material.dart';
import 'package:resizable_widget/src/model/common_sizes.dart';
import 'package:resizable_widget/src/model/trigger.dart';
import 'resizable_widget_controller.dart';
import 'trigger_widget.dart';

class ResizableWidget extends StatefulWidget {
  ResizableWidget({
    super.key,
    double? height,
    double? width,
    Offset? initialPosition,
    double minWidth = 0.0,
    double minHeight = 0.0,
    this.showDragWidgets,
    required double areaHeight,
    required double areaWidth,
    required this.child,
    required this.dragWidgetsArea,
    required this.triggersList,
    required this.controller
  }) {
    height ??= areaHeight;
    width ??= areaWidth;
    initialPosition ??= Offset(areaWidth / 2, areaHeight / 2);
    size = CommonSizes(
      areaHeight: areaHeight,
      areaWidth: areaWidth,
      height: height,
      width: width,
      minHeight: minHeight,
      minWidth: minWidth,
      initialPosition: initialPosition,
    );
  }

  late final CommonSizes size;
  final bool? showDragWidgets;
  final Widget child;
  final Size dragWidgetsArea;
  final List<Trigger> triggersList;
  final ResizableWidgetController? controller;

  @override
  State<ResizableWidget> createState() => _ResizableWidgetState();
}

class _ResizableWidgetState extends State<ResizableWidget> {

  @override
  void initState() {
    widget.controller!.init(finalSize: widget.size, showDragWidgets: widget.showDragWidgets);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller!,
      child: Stack(
        children: widget.triggersList.map((trigger) {
          return TriggerWidget(
            onDrag: trigger.dragTriggerType.getOnDragFunction(widget.controller!),
            trigger: trigger,
          );
        }).toList(),
      ),
      builder: (_, triggersStack) {
        return Stack(
          children: <Widget>[
            Positioned(
              top: widget.controller!.top,
              left: widget.controller!.left,
              bottom: widget.controller!.bottom,
              right: widget.controller!.right,
              child: widget.child,
            ),
            Positioned(
              top: widget.controller!.top - widget.dragWidgetsArea.height,
              left: widget.controller!.left - widget.dragWidgetsArea.width,
              bottom: widget.controller!.bottom - widget.dragWidgetsArea.height,
              right: widget.controller!.right - widget.dragWidgetsArea.width,
              child: Visibility(
                visible: widget.controller!.showDragWidgets,
                child: triggersStack!,
              ),
            ),
          ],
        );
      },
    );
  }
}
