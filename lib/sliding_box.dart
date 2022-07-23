library sliding_box;

import 'package:flutter/material.dart';

class SlidingBox extends StatefulWidget {
  /// Create a widget that will display only one widget based on the current focused index,
  /// and each change will be accompanied by an animation.
  ///
  /// The duration of switching from one widget to the next depends on [duration]
  /// if the length of children is 1, there will be no change
  const SlidingBox({
    Key? key,
    required this.height,
    required this.width,
    required this.children,
    this.scrollDirection,
    this.onChanged,
    this.duration,
    this.slidingDuration,
    this.curve,
  }) : super(key: key);

  /// This will be the height of the box
  /// can't be null
  final double height;

  // This will be the width of the box
  /// can't be null
  final double width;

  /// [SlidingBox] items
  /// the widget you create will have the same height and width
  /// according to the [height] and [width] in the properties.
  final List<Widget> children;

  /// Direction of sliding animation
  /// if this is empty it will be filled with the default [Axis.horizontal]
  final Axis? scrollDirection;

  /// Will be called when the focused widget changes
  final ValueChanged<int>? onChanged;

  /// This will be the duration of each change
  /// if this is empty it will be filled with the default duration is 3 seconds
  final Duration? duration;

  /// This will be the duration of the sliding animation to the next or previous widget
  /// if this is empty it will be filled with the default duration is 300 miliseconds
  final Duration? slidingDuration;

  /// This will be the curve for the sliding animation
  /// if this is empty it will be filled with the default [Curves.linear]
  final Curve? curve;

  @override
  createState() => _SlidingBoxState();
}

class _SlidingBoxState extends State<SlidingBox> {
  late final PageController _controller;
  late int _currentIndex;
  bool _reversed = false;

  @override
  void initState() {
    _currentIndex = 0;
    _controller = PageController(initialPage: _currentIndex);
    changedIndex();
    super.initState();
  }

  // this is the function that will determine the next index
  // if the current index is the last limit
  // then the next index is currentIndex - 1
  // and change revered to true
  void changedIndex() async {
    if (widget.children.length == 1) {
      _currentIndex = 0;
      _reversed = false;
      return;
    }
    await Future.delayed(widget.duration ?? const Duration(seconds: 3));
    if (_reversed) {
      if (_currentIndex == 0) {
        _reversed = !_reversed;
        _currentIndex++;
        nextPage();
      } else {
        _currentIndex--;
        previousPage();
      }
    } else {
      if (_currentIndex == widget.children.length - 1) {
        _reversed = !_reversed;
        _currentIndex--;
        previousPage();
      } else {
        _currentIndex++;
        nextPage();
      }
    }
    if (mounted) {
      changedIndex();
    }
  }

  void nextPage() {
    if (!mounted) return;
    _controller.nextPage(
      duration: widget.slidingDuration ?? const Duration(milliseconds: 300),
      curve: widget.curve ?? Curves.linear,
    );
  }

  void previousPage() {
    if (!mounted) return;
    _controller.previousPage(
      duration: widget.slidingDuration ?? const Duration(milliseconds: 300),
      curve: widget.curve ?? Curves.linear,
    );
  }

  @override
  void didUpdateWidget(covariant SlidingBox oldWidget) {
    if (widget.children.length != oldWidget.children.length) {
      changedIndex();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollDirection = widget.scrollDirection ?? Axis.vertical;
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.children.length,
        scrollDirection: scrollDirection,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          if (widget.onChanged != null) {
            widget.onChanged!(index);
          }
        },
        itemBuilder: (context, index) => widget.children[index],
      ),
    );
  }
}
