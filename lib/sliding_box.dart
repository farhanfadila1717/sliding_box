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
    this.physics,
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

  /// How the page view should respond to user input.
  ///
  /// For example, determines how the page view continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// If an explicit [ScrollBehavior] is provided to [scrollBehavior], the
  /// [ScrollPhysics] provided by that behavior will take precedence after
  /// [physics].
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

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
    onChanged();
    if (mounted) {
      changedIndex();
    }
  }

  void onChanged([bool fromPageView = false, int? index]) {
    if (_reversed) {
      if (_currentIndex == 0) {
        _reversed = !_reversed;
        _currentIndex = index ?? _currentIndex++;
        if (!fromPageView) nextPage();
      } else {
        _currentIndex = index ?? _currentIndex--;
        if (!fromPageView) previousPage();
      }
    } else {
      if (_currentIndex == widget.children.length - 1) {
        _reversed = !_reversed;
        _currentIndex = index ?? _currentIndex--;
        if (!fromPageView) previousPage();
      } else {
        _currentIndex = index ?? _currentIndex++;
        if (!fromPageView) nextPage();
      }
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
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
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
        physics: widget.physics,
        onPageChanged: (index) {
          if (widget.onChanged != null) {
            widget.onChanged!(index);
          }
          setState(() {
            onChanged(true, index);
          });
        },
        itemBuilder: (context, index) => widget.children[index],
      ),
    );
  }
}
