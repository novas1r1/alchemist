import 'package:alchemist/alchemist.dart';
import 'package:alchemist/src/golden_test_scenario_constraints.dart';
import 'package:flutter/material.dart';

/// An internal [WidgetBuilder] that builds the widget it's given.
WidgetBuilder _build(Widget build) => (context) => build;

/// {@template golden_test_scenario}
/// A widget that displays its child with a label for use in golden tests.
///
/// This widget is used in tandem with [GoldenTestGroup] to display a set of
/// golden test scenarios, which can be converted to snapshot files when used
/// in [goldenTest]s.
///
/// See also:
/// * [goldenTest], which renders and compares [GoldenTestGroup]s.
/// * [GoldenTestGroup], which groups multiple [GoldenTestScenario]s together.
/// * [GoldenTestScenario.builder], which creates a test scenario from a
///   [WidgetBuilder] that allows access to the [BuildContext] of the widget.
/// * [GoldenTestScenario.withTextScaleFactor], which allows a default text
///   scale factor to be applied to the child.
/// {@endtemplate}
class GoldenTestScenario extends StatelessWidget {
  /// {@macro golden_test_scenario}
  GoldenTestScenario({
    Key? key,
    required this.name,
    required Widget child,
    this.constraints,
    this.padding = const EdgeInsets.all(8),
    this.shouldShowName = true,
  })  : builder = _build(child),
        super(key: key);

  /// Creates a [GoldenTestScenario] with a [builder] function that allows
  /// access to the [BuildContext] of the widget.
  const GoldenTestScenario.builder({
    Key? key,
    required this.name,
    required this.builder,
    this.constraints,
    this.padding = const EdgeInsets.all(8),
    this.shouldShowName = true,
  }) : super(key: key);

  /// Creates a [GoldenTestScenario] with a custom [textScaleFactor] that
  /// applies a default scale of text to its child.
  GoldenTestScenario.withTextScaleFactor({
    Key? key,
    required this.name,
    required double textScaleFactor,
    required Widget child,
    this.constraints,
    this.padding = const EdgeInsets.all(8),
    this.shouldShowName = true,
  })  : builder = _build(
          _CustomTextScaleFactor(
            textScaleFactor: textScaleFactor,
            child: child,
          ),
        ),
        super(key: key);

  /// The name of the scenario.
  ///
  /// This text will be rendered as a [Text] label above the child, and is used
  /// to differentiate between different [GoldenTestScenario]s in the same
  /// [GoldenTestGroup].
  ///
  /// This is required.
  final String name;

  /// The builder function that builds the widget to be displayed.
  final WidgetBuilder builder;

  /// Constraints to apply to the widget built by [builder]
  final BoxConstraints? constraints;

  /// Padding to apply to the widget built by [builder]
  final EdgeInsetsGeometry padding;

  /// Whether or not to show the name of the scenario
  final bool shouldShowName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (shouldShowName) ...[
            Text(
              name,
              style: const TextStyle(fontSize: 18),
              textHeightBehavior: const TextHeightBehavior(
                applyHeightToFirstAscent: false,
              ),
            ),
            const SizedBox(height: 8),
          ],
          ConstrainedBox(
            constraints: constraints ??
                GoldenTestScenarioConstraints.maybeOf(context) ??
                const BoxConstraints(),
            child: Builder(
              builder: builder,
            ),
          ),
        ],
      ),
    );
  }
}

/// {@template _custom_text_scale_factor}
/// An internal widget used to apply a default [textScaleFactor] to its [child].
/// {@endtemplate}
@protected
class _CustomTextScaleFactor extends StatelessWidget {
  /// {@macro _custom_text_scale_factor}
  const _CustomTextScaleFactor({
    required this.textScaleFactor,
    required this.child,
  });

  /// The default text scale factor to apply to the [child].
  final double textScaleFactor;

  /// The child widget to apply the [textScaleFactor] to.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: child,
    );
  }
}
