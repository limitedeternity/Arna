import 'package:arna/arna.dart';
import 'package:flutter/material.dart' show MaterialLocalizations;

/// Implements the master detail layout structure.
///
/// See also:
///
///  * [ArnaHeaderBar], which is a horizontal bar shown at the top of the app.
class ArnaMasterDetailScaffold extends StatefulWidget {
  /// Creates a master detail structure in the Arna style.
  const ArnaMasterDetailScaffold({
    super.key,
    this.headerBarLeading,
    this.title,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    this.onItemSelected,
    this.currentIndex,
    this.resizeToAvoidBottomInset = true,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Called when one of the [items] is tapped.
  final ValueChanged<int>? onItemSelected;

  /// The index into [items] for the current active [MasterNavigationItem].
  final int? currentIndex;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<ArnaMasterDetailScaffold> createState() => _ArnaMasterDetailScaffoldState();
}

/// The [State] for a [ArnaMasterDetailScaffold].
class _ArnaMasterDetailScaffoldState extends State<ArnaMasterDetailScaffold> {
  int _index = -1;
  int _previousIndex = 0;

  void _setIndex(int index) {
    _previousIndex = _index;
    _index = index;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > Styles.expanded
            ? _LateralPage(
                headerBarLeading: widget.headerBarLeading,
                title: widget.title,
                actions: widget.actions,
                leading: widget.leading,
                items: widget.items,
                trailing: widget.trailing,
                emptyBody: widget.emptyBody,
                currentIndex: _index == -1 ? _previousIndex : _index,
                onSelected: _setIndex,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              )
            : _NestedPage(
                headerBarLeading: widget.headerBarLeading,
                title: widget.title,
                actions: widget.actions,
                leading: widget.leading,
                items: widget.items,
                trailing: widget.trailing,
                emptyBody: widget.emptyBody,
                currentIndex: _index,
                onSelected: _setIndex,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              );
      },
    );
  }
}

/// Lateral page widget.
class _LateralPage extends StatefulWidget {
  /// Creates a lateral page.
  const _LateralPage({
    this.headerBarLeading,
    this.title,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    required this.currentIndex,
    required this.onSelected,
    this.resizeToAvoidBottomInset = true,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Current index of the selected item.
  final int currentIndex;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<_LateralPage> createState() => _LateralPageState();
}

/// The [State] for a [_LateralPage].
class _LateralPageState extends State<_LateralPage> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void _onPressed(int index) {
    widget.onSelected(index);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: Styles.masterSideWidth,
          child: ArnaScaffold(
            headerBarLeading: widget.headerBarLeading,
            title: widget.title,
            actions: widget.actions,
            body: _MasterItemBuilder(
              leading: widget.leading,
              items: widget.items,
              trailing: widget.trailing,
              onPressed: _onPressed,
              currentIndex: _currentIndex,
            ),
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.only(start: Styles.masterSideWidth),
          child: ArnaDivider(direction: Axis.vertical),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: Styles.masterSideWidth + 1,
          ),
          child: widget.items.length > _currentIndex
              ? ArnaScaffold(
                  headerBarLeading: widget.items[_currentIndex].headerBarLeading,
                  title: widget.items[_currentIndex].title,
                  actions: widget.items[_currentIndex].actions,
                  body: widget.items[_currentIndex].builder(context),
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                )
              : widget.emptyBody != null
                  ? Container(
                      constraints: const BoxConstraints.expand(),
                      color: ArnaDynamicColor.resolve(ArnaColors.backgroundColor, context),
                      child: widget.emptyBody,
                    )
                  : ArnaScaffold(
                      headerBarLeading: widget.items[0].headerBarLeading,
                      title: widget.items[0].title,
                      actions: widget.items[0].actions,
                      body: widget.items[0].builder(context),
                      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                    ),
        ),
      ],
    );
  }
}

/// Nested page widget.
class _NestedPage extends StatefulWidget {
  /// Creates a nested page.
  const _NestedPage({
    this.headerBarLeading,
    this.title,
    this.actions,
    this.leading,
    required this.items,
    this.trailing,
    this.emptyBody,
    required this.currentIndex,
    required this.onSelected,
    this.resizeToAvoidBottomInset = true,
  });

  /// The leading widget laid out within the header bar.
  final Widget? headerBarLeading;

  /// The title displayed in the header bar.
  final String? title;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The widget to show when no item is selected.
  final Widget? emptyBody;

  /// Current index of the selected item.
  final int currentIndex;

  /// Callback that returns an index when the page changes.
  final ValueChanged<int> onSelected;

  /// Whether the [body] should size itself to avoid the window's bottom inset.
  ///
  /// For example, if there is an onscreen keyboard displayed above the scaffold, the body can be resized to avoid
  /// overlapping the keyboard, which prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true and cannot be null.
  final bool resizeToAvoidBottomInset;

  @override
  State<_NestedPage> createState() => _NestedPageState();
}

/// The [State] for a [_NestedPage].
class _NestedPageState extends State<_NestedPage> {
  late int _currentIndex;

  /// Key to access navigator in the nested layout.
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _currentIndex = widget.currentIndex;
    super.initState();
  }

  void _onPressed(int index) {
    widget.onSelected(index);
    _navigatorKey.currentState!.push(_detailPageRoute(index));
    setState(() => _currentIndex = index);
  }

  void _goBack() {
    widget.onSelected(-1);
    _navigatorKey.currentState!.pop(context);
  }

  ArnaPageRoute<void> _detailPageRoute(int index) {
    return ArnaPageRoute<dynamic>(
      builder: (BuildContext context) {
        final MasterNavigationItem page = widget.items[_currentIndex];
        final String tooltip = MaterialLocalizations.of(context).backButtonTooltip;
        return WillPopScope(
          onWillPop: () async {
            _goBack();
            return false;
          },
          child: BlockSemantics(
            child: ArnaScaffold(
              headerBarLeading: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ArnaIconButton(
                    icon: Icons.arrow_back_outlined,
                    onPressed: _goBack,
                    tooltipMessage: tooltip,
                    semanticLabel: tooltip,
                  ),
                  if (page.headerBarLeading != null) page.headerBarLeading!,
                ],
              ),
              title: page.title,
              actions: page.actions,
              body: page.builder(context),
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: _navigatorKey,
        onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
          return <Route<dynamic>>[
            ArnaPageRoute<dynamic>(
              builder: (BuildContext context) {
                return ArnaScaffold(
                  headerBarLeading: widget.headerBarLeading,
                  title: widget.title,
                  actions: widget.actions,
                  body: _MasterItemBuilder(
                    leading: widget.leading,
                    items: widget.items,
                    trailing: widget.trailing,
                    onPressed: _onPressed,
                    currentIndex: _currentIndex,
                    isNested: true,
                  ),
                  resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                );
              },
            ),
            if (_currentIndex != -1) _detailPageRoute(_currentIndex)
          ];
        },
      ),
    );
  }
}

/// Master item list builder.
class _MasterItemBuilder extends StatelessWidget {
  /// Creates a master item list.
  const _MasterItemBuilder({
    this.leading,
    required this.items,
    this.trailing,
    required this.onPressed,
    required this.currentIndex,
    this.isNested = false,
  });

  /// The leading widget in the master that is placed above the items.
  ///
  /// The default value is null.
  final Widget? leading;

  /// The list of navigation items.
  final List<MasterNavigationItem> items;

  /// The trailing widget in the master that is placed below the items.
  ///
  /// The default value is null.
  final Widget? trailing;

  /// The callback that is called when an item is tapped.
  final Function(int index) onPressed;

  /// Current index of the selected item.
  final int currentIndex;

  /// Whether this builder is used inside nested or not.
  final bool isNested;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (leading != null) leading!,
        Expanded(
          child: ListView.builder(
            controller: ScrollController(),
            itemCount: items.length,
            padding: Styles.small,
            itemBuilder: (BuildContext context, int index) {
              return ArnaMasterItem(
                leading: items[index].leading,
                title: items[index].title,
                subtitle: items[index].subtitle,
                trailing: items[index].trailing,
                onPressed: onPressed,
                itemSelected: !isNested && (index == currentIndex),
                index: index,
                isFocusable: items[index].isFocusable,
                autofocus: items[index].autofocus,
                accentColor: items[index].accentColor,
                cursor: items[index].cursor,
                semanticLabel: items[index].semanticLabel,
              );
            },
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// A navigation item used inside [ArnaMasterDetailScaffold].
class MasterNavigationItem {
  /// Creates a master navigation item.
  const MasterNavigationItem({
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    required this.builder,
    this.headerBarLeading,
    this.actions,
    this.badge,
    this.isFocusable = true,
    this.autofocus = false,
    this.accentColor,
    this.cursor = MouseCursor.defer,
    this.semanticLabel,
  });

  /// The leading widget of the item.
  final Widget? leading;

  /// The title of the item.
  final String? title;

  /// The subtitle of the item.
  final String? subtitle;

  /// The trailing widget of the item.
  final Widget? trailing;

  /// The widget builder of the item.
  final WidgetBuilder builder;

  /// The leading widget laid out within the detailed page's header bar.
  final Widget? headerBarLeading;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [ArnaIconButton]s representing common operations. For less common operations,
  /// consider using a [ArnaPopupMenuButton] as the last action.
  ///
  /// The [actions] become the trailing component of the [NavigationToolbar] built by this widget. The height of each
  /// action is constrained to be no bigger than the [Styles.headerBarHeight].
  final List<Widget>? actions;

  /// The [ArnaBadge] of the item.
  final ArnaBadge? badge;

  /// Whether this item is focusable or not.
  final bool isFocusable;

  /// Whether this item should focus itself if nothing else is already focused.
  final bool autofocus;

  /// The color of the item's focused border.
  final Color? accentColor;

  /// The cursor for a mouse pointer when it enters or is hovering over the item.
  final MouseCursor cursor;

  /// The semantic label of the item.
  final String? semanticLabel;
}
