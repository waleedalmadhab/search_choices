import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';

const EdgeInsetsGeometry _kAlignedButtonPadding =
    EdgeInsetsDirectional.only(start: 16.0, end: 4.0);
const EdgeInsets _kUnalignedButtonPadding = EdgeInsets.zero;

/// Class mainly used internally to set a value to NotGiven by its type
class NotGiven {
  const NotGiven();
}

/// Class used internally as a tuple with 2 items.
class Tuple2<E1, E2>{
  /// First item of the tuple
  E1 item1;
  /// Second item of the tuple
  E2 item2;
  Tuple2(this.item1,this.item2);
}

/// Class used internally as a tuple with 3 items.
class Tuple3<E1, E2, E3>{
  /// First item of the tuple
  E1 item1;
  /// Second item of the tuple
  E2 item2;
  /// Third item of the tuple
  E3 item3;
  Tuple3(this.item1,this.item2,this.item3);
}

/// Class used to send pointers to variables instead of the variable directly so that the called function can update the variable value
class PointerThisPlease<T> {
  /// Value to be pointed to that can be changed by the called method.
  T value;

  /// Simple constructor that sets the value that can be updated by a called method.
  PointerThisPlease(this.value);
}

/// Function mainly called internally to transform an [object] (either a Widget, a String or a Function returning a Widget or a String) to a Widget
/// If a Function is passed as [object], it can have as arguments either nothing or:
/// * [parameter], [context], [updateParent]
/// * [parameter], [context]
/// * [parameter], [updateParent]
/// * [context], [updateParent]
/// * [parameter]
/// * [context]
/// * [updateParent]
Widget? prepareWidget(dynamic object,
    {dynamic parameter = const NotGiven(),
    Function? updateParent,
    BuildContext? context,
    Function? stringToWidgetFunction}) {
  if (object == null) {
    return (null);
  }
  if (object is Widget) {
    return (object);
  }
  if (object is String) {
    if (stringToWidgetFunction == null) {
      return (Text(
        object,
      ));
    } else {
      return (stringToWidgetFunction(object));
    }
  }
  if (object is Function) {
    dynamic objectResult = NotGiven();
    if (!(parameter is NotGiven) && context != null && updateParent != null) {
      try {
        objectResult = object(parameter, context, updateParent);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven &&
        !(parameter is NotGiven) &&
        context != null) {
      try {
        objectResult = object(parameter, context);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven &&
        !(parameter is NotGiven) &&
        updateParent != null) {
      try {
        objectResult = object(parameter, updateParent);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven && context != null && updateParent != null) {
      try {
        objectResult = object(context, updateParent);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven && !(parameter is NotGiven)) {
      try {
        objectResult = object(parameter);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven && context != null) {
      try {
        objectResult = object(context);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven && updateParent != null) {
      try {
        objectResult = object(updateParent);
      } on NoSuchMethodError {
        objectResult = NotGiven();
      }
    }
    if (objectResult is NotGiven) {
      try {
        objectResult = object();
      } on NoSuchMethodError {
        objectResult = Text(
          "Call failed",
          style: TextStyle(color: Colors.red),
        );
      }
    }
    return (prepareWidget(objectResult,
        stringToWidgetFunction: stringToWidgetFunction));
  }
  return (Text(
    "Unknown type: ${object.runtimeType.toString()}",
    style: TextStyle(color: Colors.red),
  ));
}

/// SearchChoices widget that allows the opening of a searchable dropdown.
/// Use the [SearchChoices.single] factory if only one item needs to be selected.
/// Use the [SearchChoices.multiple] factory if user must be able to select multiple items at once.
class SearchChoices<T> extends StatefulWidget {
  /// [items] with __child__: [Widget] displayed ; __value__: any object with .toString() used to match search keyword.
  final List<DropdownMenuItem<T>>? items;

  /// [onChanged] [Function] with parameter: __value__ not returning executed after the selection is done.
  final Function? onChanged;

  /// [value] value to be preselected.
  final T? value;

  /// [style] used for the hint if it is given is [String].
  final TextStyle? style;

  /// [searchHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed at the top of the search dialog box.
  final dynamic searchHint;

  /// [hint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed before any value is selected or after the selection is cleared.
  final dynamic hint;

  /// [disabledHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed instead of hint when the widget is displayed.
  final dynamic disabledHint;

  /// [icon] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed next to the selected item or the hint if none.
  final dynamic icon;

  /// [underline] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed below the selected item or the hint if none.
  final dynamic underline;

  /// [doneButton] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed at the top of the search dialog box.
  final dynamic doneButton;

  /// [label] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed above the selected item or the hint if none.
  final dynamic label;

  /// [closeButton] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed at the bottom of the search dialog box.
  final dynamic closeButton;

  /// [displayClearIcon] whether or not to display an icon to clear the selected value.
  final bool displayClearIcon;

  /// [clearIcon] [Icon] to be used for clearing the selected value.
  final Icon clearIcon;

  /// [iconEnabledColor] [Color] to be used for enabled icons.
  final Color? iconEnabledColor;

  /// [iconDisabledColor] [Color] to be used for disabled icons.
  final Color? iconDisabledColor;

  /// [iconSize] for the icons next to the selected value (icon and clearIcon).
  final double iconSize;

  /// [isExpanded] can be necessary to avoid pixel overflows (zebra symptom).
  final bool isExpanded;

  /// [isCaseSensitiveSearch] only used when searchFn is not specified.
  final bool isCaseSensitiveSearch;

  /// [searchFn] [Function] with parameters: __keyword__, __items__ returning [List<int>] as the list of indexes for the items to be displayed.
  final Function? searchFn;

  /// [onClear] [Function] with no parameter not returning executed when the clear icon is tapped.
  final Function? onClear;

  /// [selectedValueWidgetFn] [Function] with parameter: __item__ returning [Widget] to be used to display the selected value.
  final Function? selectedValueWidgetFn;

  /// [keyboardType] used for the search.
  final TextInputType keyboardType;

  /// [validator] [Function] with parameter: __value__ returning [String] displayed below selected value when not valid and null when valid.
  final Function? validator;

  /// [multipleSelection] indicates whether user can select one or more items.
  final bool multipleSelection;

  /// [selectedItems] indexes of items to be preselected.
  final List<int> selectedItems;

  /// [displayItem] [Function] with parameters: __item__, __selected__ returning [Widget] to be displayed in the search list.
  final Function? displayItem;

  /// [dialogBox] whether the search should be displayed as a dialog box or as a menu below the selected value if any.
  final bool dialogBox;

  /// [menuConstraints] [BoxConstraints] used to define the zone where to display the search menu. Example: BoxConstraints.tight(Size.fromHeight(250)) . Not to be used for dialogBox = true.
  final BoxConstraints? menuConstraints;

  /// [readOnly] [bool] whether to let the user choose the value to select or just present the selected value if any.
  final bool readOnly;

  /// [menuBackgroundColor] [Color] background color of the menu whether in dialog box or menu mode.
  final Color? menuBackgroundColor;

  /// [rightToLeft] [bool] mirrors the widgets display for right to left languages defaulted to false.
  final bool rightToLeft;

  /// [autofocus] [bool] automatically focuses on the search field bringing up the keyboard defaulted to true.
  final bool autofocus;

  /// [selectedAggregateWidgetFn] [Function] with parameter: __list of widgets presenting selected values__ , returning [Widget] to be displayed to present the selected items.
  final Function? selectedAggregateWidgetFn;

  /// [padding] [double] sets the padding around the DropdownButton, defaulted to 10.0.
  final double padding;

  /// [setOpenDialog] [Function] sets the function to call to set the function to call in order to open the dialog with the search terms string as a parameter, defaulted to null.
  final Function? setOpenDialog;

  /// [buildDropDownDialog] [Function] controls the layout of the dropdown dialog.
  /// If null, equivalent to:
  /// ```
  /// (Widget titleBar, Widget searchBar, Widget list, Widget closeButton, BuildContext dropDownContext,){
  /// return AnimatedContainer(
  ///      padding: MediaQuery.of(dropDownContext).viewInsets,
  ///      duration: const Duration(milliseconds: 300),
  ///      child: Card(
  ///        color: widget.menuBackgroundColor,
  ///        margin: EdgeInsets.symmetric(
  ///            vertical: widget.dialogBox ? 10 : 5,
  ///            horizontal: widget.dialogBox ? 10 : 4),
  ///        child: Container(
  ///          constraints: widget.menuConstraints,
  ///          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
  ///          child: Column(
  ///            mainAxisAlignment: MainAxisAlignment.start,
  ///            crossAxisAlignment: CrossAxisAlignment.start,
  ///            mainAxisSize: MainAxisSize.min,
  ///            children: <Widget>[
  ///              titleBar,
  ///              searchBar,
  ///              list,
  ///              closeButton,
  ///            ],
  ///          ),
  ///        ),
  ///      ),
  ///    );
  /// }
  /// ```
  final Widget Function(
    Widget titleBar,
    Widget searchBar,
    Widget list,
    Widget closeButton,
    BuildContext dropDownContext,
  )? buildDropDownDialog;

  /// [searchInputDecoration] [InputDecoration] sets the search bar decoration.
  final InputDecoration? searchInputDecoration;

  /// [itemsPerPage] [int] if set, organizes the search list per page with the given number of items displayed per page. Must give [currentPage].
  final int? itemsPerPage;

  /// [currentPage] [PointerThisPlease<int>] if [itemsPerPage] is set, holds the page number for the search items to be displayed.
  final PointerThisPlease<int>? currentPage;

  /// [customPaginationDisplay] [Widget Function(Widget listWidget, int totalFilteredItemsNb, Function updateSearchPage)] if [itemsPerPage] is set, customizes the display and the handling of the pagination on the search list.
  final Widget Function(Widget listWidget, int totalFilteredItemsNb,
      Function updateSearchPage)? customPaginationDisplay;

  /// [futureSearchFn] [Future<int> Function(String keyword, List<DropdownMenuItem> itemsListToClearAndFill, int pageNb)] used to search items from the network. Must clear and fill the [itemsListToClearAndFill] with the returned items (up to [itemsPerPage] if set). Must return an [int] with the total number of results (allows the handling of pagination).
  final Future<Tuple2<List<DropdownMenuItem>,int>> Function(String? keyword, List<DropdownMenuItem> itemsListToClearAndFill, String? orderBy, bool? orderAsc, Map<String,String>? filters, int? pageNb)? futureSearchFn;

  /// [futureSearchOrderOptions] [Map<String, Set<Object>>] when [futureSearchFn] is set, can be used to display search order options specified in the form {"order1Name":{"icon":order1IconWidget,"values":["value1",{"value2":order1Value2Widget}]}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  final Map<String, Set<Object>>? futureSearchOrderOptions;

  /// [futureSearchFilterOptions] [Map<String, Map<String, Object>>] when [futureSearchFn] is set, can be used to display search filters specified in the form {"filter1Name":{"icon":filter1IconWidget,"values":["value1",{"value2":filter1Value2Widget}}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  final Map<String, Map<String, Object>>? futureSearchFilterOptions;

  /// [futureSelectedValues] [List<T>] contains the list of selected values in case of future search in multiple selection mode.
  final List<T>? futureSelectedValues;


  /// Search choices Widget with a single choice that opens a dialog or a menu to let the user do the selection conveniently with a search.
  ///
  /// * [items] with __child__: [Widget] displayed ; __value__: any object with .toString() used to match search keyword.
  /// * [onChanged] [Function] with parameter: __value__ not returning executed after the selection is done.
  /// * [value] value to be preselected.
  /// * [style] used for the hint if it is given is [String].
  /// * [searchHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed at the top of the search dialog box.
  /// * [hint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed before any value is selected or after the selection is cleared.
  /// * [disabledHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed instead of hint when the widget is displayed.
  /// * [icon] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed next to the selected item or the hint if none.
  /// * [underline] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed below the selected item or the hint if none.
  /// * [doneButton] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed at the top of the search dialog box.
  /// * [label] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed above the selected item or the hint if none.
  /// * [closeButton] [String]|[Widget]|[Function] with parameter: __value__ returning [String]|[Widget] displayed at the bottom of the search dialog box.
  /// * [displayClearIcon] whether or not to display an icon to clear the selected value.
  /// * [clearIcon] [Icon] to be used for clearing the selected value.
  /// * [iconEnabledColor] [Color] to be used for enabled icons.
  /// * [iconDisabledColor] [Color] to be used for disabled icons.
  /// * [iconSize] for the icons next to the selected value (icon and clearIcon).
  /// * [isExpanded] can be necessary to avoid pixel overflows (zebra symptom).
  /// * [isCaseSensitiveSearch] only used when searchFn is not specified.
  /// * [searchFn] [Function] with parameters: __keyword__, __items__ returning [List<int>] as the list of indexes for the items to be displayed.
  /// * [onClear] [Function] with no parameter not returning executed when the clear icon is tapped.
  /// * [selectedValueWidgetFn] [Function] with parameter: __item__ returning [Widget] to be used to display the selected value.
  /// * [keyboardType] used for the search.
  /// * [validator] [Function] with parameter: __value__ returning [String] displayed below selected value when not valid and null when valid.
  /// * [assertUniqueValue] whether to run a consistency check of the list of items.
  /// * [displayItem] [Function] with parameters: __item__, __selected__ returning [Widget] to be displayed in the search list.
  /// * [dialogBox] whether the search should be displayed as a dialog box or as a menu below the selected value if any.
  /// * [menuConstraints] [BoxConstraints] used to define the zone where to display the search menu. Example: BoxConstraints.tight(Size.fromHeight(250)) . Not to be used for dialogBox = true.
  /// * [readOnly] [bool] whether to let the user choose the value to select or just present the selected value if any.
  /// * [menuBackgroundColor] [Color] background color of the menu whether in dialog box or menu mode.
  /// * [rightToLeft] [bool] mirrors the widgets display for right to left languages defaulted to false.
  /// * [autofocus] [bool] automatically focuses on the search field bringing up the keyboard defaulted to true.
  /// * [selectedAggregateWidgetFn] [Function] with parameter: __list of widgets presenting selected values__ , returning [Widget] to be displayed to present the selected items.
  /// * [padding] [double] sets the padding around the DropdownButton, defaulted to 10.0.
  /// * [setOpenDialog] [Function] sets the function to call to set the function to call in order to open the dialog with the search terms string as a parameter, defaulted to null.
  /// * [buildDropDownDialog] [Function] controls the layout of the dropdown dialog.
  /// * [searchInputDecoration] [InputDecoration] sets the search bar decoration.
  /// * [itemsPerPage] [int] if set, organizes the search list per page with the given number of items displayed per page.
  /// * [currentPage] [PointerThisPlease<int>] if [itemsPerPage] is set, holds the page number for the search items to be displayed.
  /// * [customPaginationDisplay] [Widget Function(Widget listWidget, int totalFilteredItemsNb, Function updateSearchPage)] if [itemsPerPage] is set, customizes the display and the handling of the pagination on the search list.
  /// * [futureSearchFn] [Future<Tuple2<List<DropdownMenuItem>,int>> Function(String keyword, List<DropdownMenuItem> itemsListToClearAndFill, int pageNb)] used to search items from the network. Must clear and fill the [itemsListToClearAndFill] with the returned items (up to [itemsPerPage] if set). Must return an [int] with the total number of results (allows the handling of pagination).
  /// * [futureSearchOrderOptions] [Map<String, Set<Object>>] when [futureSearchFn] is set, can be used to display search order options specified in the form {"order1Name":{"icon":order1IconWidget,"values":["value1",{"value2":order1Value2Widget}]}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  /// * [futureSearchFilterOptions] [Map<String, Map<String, Object>>] when [futureSearchFn] is set, can be used to display search filters specified in the form {"filter1Name":{"icon":filter1IconWidget,"values":["value1",{"value2":filter1Value2Widget}}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  factory SearchChoices.single({
    Key? key,
    List<DropdownMenuItem<T>>? items,
    Function? onChanged,
    T? value,
    TextStyle? style,
    dynamic searchHint,
    dynamic hint,
    dynamic disabledHint,
    dynamic icon = const Icon(Icons.arrow_drop_down),
    dynamic underline,
    dynamic doneButton,
    dynamic label,
    dynamic closeButton = "Close",
    bool displayClearIcon = true,
    Icon clearIcon = const Icon(Icons.clear),
    Color? iconEnabledColor,
    Color? iconDisabledColor,
    double iconSize = 24.0,
    bool isExpanded = false,
    bool isCaseSensitiveSearch = false,
    Function? searchFn,
    Function? onClear,
    Function? selectedValueWidgetFn,
    TextInputType keyboardType = TextInputType.text,
    Function? validator,
    bool assertUniqueValue = true,
    Function? displayItem,
    bool dialogBox = true,
    BoxConstraints? menuConstraints,
    bool readOnly = false,
    Color? menuBackgroundColor,
    bool rightToLeft = false,
    bool autofocus = true,
    Function? selectedAggregateWidgetFn,
    double padding = 10.0,
    Function? setOpenDialog,
    Widget Function(
      Widget titleBar,
      Widget searchBar,
      Widget list,
      Widget closeButton,
      BuildContext dropDownContext,
    )?
        buildDropDownDialog,
    InputDecoration? searchInputDecoration,
    int? itemsPerPage,
    PointerThisPlease<int>? currentPage,
    Widget Function(Widget listWidget, int totalFilteredItemsNb,
            Function updateSearchPage)?
        customPaginationDisplay,
    Future<Tuple2<List<DropdownMenuItem>,int>> Function(String? keyword, List<DropdownMenuItem> itemsListToClearAndFill, String? orderBy, bool? orderAsc, Map<String,String>? filters, int? pageNb)? futureSearchFn,
    Map<String, Set<Object>>? futureSearchOrderOptions,
    Map<String, Map<String, Object>>? futureSearchFilterOptions,
  }) {
    return (SearchChoices._(
      key: key,
      items: items,
      onChanged: onChanged,
      value: value,
      style: style,
      searchHint: searchHint,
      hint: hint,
      disabledHint: disabledHint,
      icon: icon,
      underline: underline,
      iconEnabledColor: iconEnabledColor,
      iconDisabledColor: iconDisabledColor,
      iconSize: iconSize,
      isExpanded: isExpanded,
      isCaseSensitiveSearch: isCaseSensitiveSearch,
      closeButton: closeButton,
      displayClearIcon: displayClearIcon,
      clearIcon: clearIcon,
      onClear: onClear,
      selectedValueWidgetFn: selectedValueWidgetFn,
      keyboardType: keyboardType,
      validator: validator,
      label: label,
      searchFn: searchFn,
      multipleSelection: false,
      doneButton: doneButton,
      displayItem: displayItem,
      dialogBox: dialogBox,
      menuConstraints: menuConstraints,
      readOnly: readOnly,
      menuBackgroundColor: menuBackgroundColor,
      rightToLeft: rightToLeft,
      autofocus: autofocus,
      selectedAggregateWidgetFn: selectedAggregateWidgetFn,
      padding: padding,
      setOpenDialog: setOpenDialog,
      buildDropDownDialog: buildDropDownDialog,
      searchInputDecoration: searchInputDecoration,
      itemsPerPage: itemsPerPage,
      currentPage: currentPage,
      customPaginationDisplay: customPaginationDisplay,
      futureSearchFn:futureSearchFn,
      futureSearchOrderOptions:futureSearchOrderOptions,
      futureSearchFilterOptions:futureSearchFilterOptions,
    ));
  }

  /// Search choices Widget with a multiple choice that opens a dialog or a menu to let the user do the selection conveniently with a search.
  ///
  /// * [items] with __child__: [Widget] displayed ; __value__: any object with .toString() used to match search keyword.
  /// * [onChanged] [Function] with parameter: __selectedItems__ not returning executed after the selection is done.
  /// * [selectedItems] indexes of items to be preselected.
  /// * [style] used for the hint if it is given is [String].
  /// * [searchHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed at the top of the search dialog box.
  /// * [hint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed before any value is selected or after the selection is cleared.
  /// * [disabledHint] [String]|[Widget]|[Function] with no parameter returning [String]|[Widget] displayed instead of hint when the widget is displayed.
  /// * [icon] [String]|[Widget]|[Function] with parameter: __selectedItems__ returning [String]|[Widget] displayed next to the selected items or the hint if none.
  /// * [underline] [String]|[Widget]|[Function] with parameter: __selectedItems__ returning [String]|[Widget] displayed below the selected items or the hint if none.
  /// * [doneButton] [String]|[Widget]|[Function] with parameter: __selectedItems__ returning [String]|[Widget] displayed at the top of the search dialog box. Cannot be null in multiple selection mode.
  /// * [label] [String]|[Widget]|[Function] with parameter: __selectedItems__ returning [String]|[Widget] displayed above the selected items or the hint if none.
  /// * [closeButton] [String]|[Widget]|[Function] with parameter: __selectedItems__ returning [String]|[Widget] displayed at the bottom of the search dialog box.
  /// * [displayClearIcon] whether or not to display an icon to clear the selected values.
  /// * [clearIcon] [Icon] to be used for clearing the selected values.
  /// * [iconEnabledColor] [Color] to be used for enabled icons.
  /// * [iconDisabledColor] [Color] to be used for disabled icons.
  /// * [iconSize] for the icons next to the selected values (icon and clearIcon).
  /// * [isExpanded] can be necessary to avoid pixel overflows (zebra symptom).
  /// * [isCaseSensitiveSearch] only used when searchFn is not specified.
  /// * [searchFn] [Function] with parameters: __keyword__, __items__ returning [List<int>] as the list of indexes for the items to be displayed.
  /// * [onClear] [Function] with no parameter not returning executed when the clear icon is tapped.
  /// * [selectedValueWidgetFn] [Function] with parameter: __item__ returning [Widget] to be used to display the selected values.
  /// * [keyboardType] used for the search.
  /// * [validator] [Function] with parameter: __selectedItems__ returning [String] displayed below selected values when not valid and null when valid.
  /// * [displayItem] [Function] with parameters: __item__, __selected__ returning [Widget] to be displayed in the search list.
  /// * [dialogBox] whether the search should be displayed as a dialog box or as a menu below the selected values if any.
  /// * [menuConstraints] [BoxConstraints] used to define the zone where to display the search menu. Example: BoxConstraints.tight(Size.fromHeight(250)) . Not to be used for dialogBox = true.
  /// * [readOnly] [bool] whether to let the user choose the value to select or just present the selected value if any.
  /// * [menuBackgroundColor] [Color] background color of the menu whether in dialog box or menu mode.
  /// * [rightToLeft] [bool] mirrors the widgets display for right to left languages defaulted to false.
  /// * [autofocus] [bool] automatically focuses on the search field bringing up the keyboard defaulted to true.
  /// * [selectedAggregateWidgetFn] [Function] with parameter: __list of widgets presenting selected values__ , returning [Widget] to be displayed to present the selected items.
  /// * [padding] [double] sets the padding around the DropdownButton, defaulted to 10.0.
  /// * [setOpenDialog] [Function] sets the function to call to set the function to call in order to open the dialog with the search terms string as a parameter, defaulted to null.
  /// * [buildDropDownDialog] [Function] controls the layout of the dropdown dialog.
  /// * [searchInputDecoration] [InputDecoration] sets the search bar decoration.
  /// * [itemsPerPage] [int] if set, organizes the search list per page with the given number of items displayed per page.
  /// * [currentPage] [int] if [itemsPerPage] is set, holds the page number for the search items to be displayed.
  /// * [customPaginationDisplay] [Widget Function(Widget listWidget, int totalFilteredItemsNb, Function updateSearchPage)] if [itemsPerPage] is set, customizes the display and the handling of the pagination on the search list.
  /// * [futureSearchFn] [Future<Tuple2<List<DropdownMenuItem>,int>> Function(String keyword, List<DropdownMenuItem> itemsListToClearAndFill, int pageNb)] used to search items from the network. Must clear and fill the [itemsListToClearAndFill] with the returned items (up to [itemsPerPage] if set). Must return an [int] with the total number of results (allows the handling of pagination).
  /// * [futureSearchOrderOptions] [Map<String, Set<Object>>] when [futureSearchFn] is set, can be used to display search order options specified in the form {"order1Name":{"icon":order1IconWidget,"values":["value1",{"value2":order1Value2Widget}]}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  /// * [futureSearchFilterOptions] [Map<String, Map<String, Object>>] when [futureSearchFn] is set, can be used to display search filters specified in the form {"filter1Name":{"icon":filter1IconWidget,"values":["value1",{"value2":filter1Value2Widget}}}. Please refer to the documentation example: https://github.com/lcuis/search_choices/blob/master/example/lib/main.dart.
  /// * [futureSelectedValues] [List<T>] contains the list of selected values in case of future search in multiple selection mode.
  factory SearchChoices.multiple({
    Key? key,
    required List<DropdownMenuItem<T>> items,
    Function? onChanged,
    List<int> selectedItems = const [],
    TextStyle? style,
    dynamic searchHint,
    dynamic hint,
    dynamic disabledHint,
    dynamic icon = const Icon(Icons.arrow_drop_down),
    dynamic underline,
    dynamic doneButton = "Done",
    dynamic label,
    dynamic closeButton = "Close",
    bool displayClearIcon = true,
    Icon clearIcon = const Icon(Icons.clear),
    Color? iconEnabledColor,
    Color? iconDisabledColor,
    double iconSize = 24.0,
    bool isExpanded = false,
    bool isCaseSensitiveSearch = false,
    Function? searchFn,
    Function? onClear,
    Function? selectedValueWidgetFn,
    TextInputType keyboardType = TextInputType.text,
    Function? validator,
    Function? displayItem,
    bool dialogBox = true,
    BoxConstraints? menuConstraints,
    bool readOnly = false,
    Color? menuBackgroundColor,
    bool rightToLeft = false,
    bool autofocus = true,
    Function? selectedAggregateWidgetFn,
    double padding = 10.0,
    Function? setOpenDialog,
    Widget Function(
      Widget titleBar,
      Widget searchBar,
      Widget list,
      Widget closeButton,
      BuildContext dropDownContext,
    )?
        buildDropDownDialog,
    InputDecoration? searchInputDecoration,
    int? itemsPerPage,
    PointerThisPlease<int>? currentPage,
    Widget Function(Widget listWidget, int totalFilteredItemsNb,
            Function updateSearchPage)?
        customPaginationDisplay,
    Future<Tuple2<List<DropdownMenuItem>,int>> Function(String? keyword, List<DropdownMenuItem> itemsListToClearAndFill, String? orderBy, bool? orderAsc, Map<String,String>? filters, int? pageNb)? futureSearchFn,
    Map<String, Set<Object>>? futureSearchOrderOptions,
    Map<String, Map<String, Object>>? futureSearchFilterOptions,
    List<T>? futureSelectedValues,
  }) {
    return (SearchChoices._(
      key: key,
      items: items,
      style: style,
      searchHint: searchHint,
      hint: hint,
      disabledHint: disabledHint,
      icon: icon,
      underline: underline,
      iconEnabledColor: iconEnabledColor,
      iconDisabledColor: iconDisabledColor,
      iconSize: iconSize,
      isExpanded: isExpanded,
      isCaseSensitiveSearch: isCaseSensitiveSearch,
      closeButton: closeButton,
      displayClearIcon: displayClearIcon,
      clearIcon: clearIcon,
      onClear: onClear,
      selectedValueWidgetFn: selectedValueWidgetFn,
      keyboardType: keyboardType,
      validator: validator,
      label: label,
      searchFn: searchFn,
      multipleSelection: true,
      selectedItems: selectedItems,
      doneButton: doneButton,
      onChanged: onChanged,
      displayItem: displayItem,
      dialogBox: dialogBox,
      menuConstraints: menuConstraints,
      readOnly: readOnly,
      menuBackgroundColor: menuBackgroundColor,
      rightToLeft: rightToLeft,
      autofocus: autofocus,
      selectedAggregateWidgetFn: selectedAggregateWidgetFn,
      padding: padding,
      setOpenDialog: setOpenDialog,
      buildDropDownDialog: buildDropDownDialog,
      searchInputDecoration: searchInputDecoration,
      itemsPerPage: itemsPerPage,
      currentPage: currentPage,
      customPaginationDisplay: customPaginationDisplay,
      futureSearchFn:futureSearchFn,
      futureSearchOrderOptions:futureSearchOrderOptions,
      futureSearchFilterOptions:futureSearchFilterOptions,
      futureSelectedValues: futureSelectedValues,
    ));
  }

  SearchChoices._({
    Key? key,
    this.items,
    this.onChanged,
    this.value,
    this.style,
    this.searchHint,
    this.hint,
    this.disabledHint,
    this.icon,
    this.underline,
    this.iconEnabledColor,
    this.iconDisabledColor,
    this.iconSize = 24.0,
    this.isExpanded = false,
    this.isCaseSensitiveSearch = false,
    this.closeButton,
    this.displayClearIcon = true,
    this.clearIcon = const Icon(Icons.clear),
    this.onClear,
    this.selectedValueWidgetFn,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.label,
    this.searchFn,
    this.multipleSelection = false,
    this.selectedItems = const [],
    this.doneButton,
    this.displayItem,
    required this.dialogBox,
    this.menuConstraints,
    required this.readOnly,
    this.menuBackgroundColor,
    required this.rightToLeft,
    required this.autofocus,
    this.selectedAggregateWidgetFn,
    this.padding = 10,
    this.setOpenDialog,
    this.buildDropDownDialog,
    this.searchInputDecoration,
    this.itemsPerPage,
    this.currentPage,
    this.customPaginationDisplay,
    this.futureSearchFn,
    this.futureSearchOrderOptions,
    this.futureSearchFilterOptions,
    this.futureSelectedValues,
  })  : assert(!multipleSelection || doneButton != null),
        assert(menuConstraints == null || !dialogBox),
        assert(itemsPerPage == null || currentPage != null,
            "currentPage must be given if itemsPerPage is given"),
        assert(futureSearchOrderOptions==null||futureSearchFn!=null,"futureSearchOrderOptions is of no use if futureSearchFn is not set"),
        assert(futureSearchFilterOptions==null||futureSearchFn!=null,"futureSearchFilterOptions is of no use if futureSearchFn is not set"),
        assert(futureSearchFn==null||searchFn==null,"futureSearchFn and searchFn cannot work together"),
        assert((futureSearchFn==null)!=(items==null),"must either have futureSearchFn or items but not both"),
        assert (futureSearchFn==null||(multipleSelection?(futureSelectedValues!=null&&value==null):(true&&futureSelectedValues==null)),"${multipleSelection?"futureSelectedValues":"value"} must be set if futureSearchFn is set in ${multipleSelection?"multiple":"single"} selection mode while ${multipleSelection?"value":"futureSelectedValues"} must not be set"),
        super(key: key);

  @override
  _SearchChoicesState<T> createState() => _SearchChoicesState();
}

class _SearchChoicesState<T> extends State<SearchChoices<T>> {
  List<int>? selectedItems;
  PointerThisPlease<bool> displayMenu = PointerThisPlease<bool>(false);
  Function? updateParent;

  List<T> futureSelectedValues=[];

  TextStyle get _textStyle =>
      widget.style ??
      (_enabled && !(widget.readOnly)
          ? Theme.of(context).textTheme.subtitle1
          : Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: _disabledIconColor)) ??
      TextStyle();
  bool get _enabled =>
      (widget.items?.isNotEmpty??false||widget.futureSearchFn != null) &&
      (widget.onChanged != null || widget.onChanged is Function);

  Color? get _enabledIconColor {
    if (widget.iconEnabledColor != null) {
      return widget.iconEnabledColor;
    }
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.grey.shade700;
      case Brightness.dark:
        return Colors.white70;
    }
  }

  Color? get _disabledIconColor {
    if (widget.iconDisabledColor != null) {
      return widget.iconDisabledColor;
    }
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        return Colors.grey.shade400;
      case Brightness.dark:
        return Colors.white10;
    }
  }

  Color? get _iconColor {
    // These colors are not defined in the Material Design spec.
    return (_enabled && !(widget.readOnly)
        ? _enabledIconColor
        : _disabledIconColor);
  }

  bool get valid {
    if (widget.validator == null) {
      return (true);
    }
    return (widget.validator!(selectedResult) == null);
  }

  bool get hasSelection {
    if(widget.futureSearchFn!=null){
      return (futureSelectedValues.isNotEmpty);
    }
    return (selectedItems != null && ((selectedItems?.isNotEmpty) ?? true));
  }

  dynamic get selectedResult {
    if(widget.futureSearchFn!=null){
      if(widget.multipleSelection) {
        return (futureSelectedValues);
      }
      if(futureSelectedValues.isNotEmpty){
        return(futureSelectedValues.first);
      }
      return(null);
    }
    return (widget.multipleSelection
        ? selectedItems
        : selectedItems?.isNotEmpty ?? false
            ? widget.items![selectedItems?.first ?? 0].value
            : null);
  }

  updateSelectedItems({dynamic sel = const NotGiven()}) {
    if(widget.futureSearchFn!=null){
      return;
    }
    List<int>? updatedSelectedItems;
    if (widget.multipleSelection) {
      if (!(sel is NotGiven)) {
        updatedSelectedItems = sel as List<int>;
      } else {
        updatedSelectedItems = List<int>.from(widget.selectedItems);
      }
    } else {
      T? val = !(sel is NotGiven) ? sel as T : widget.value;
      if (val != null) {
        int? i = indexFromValue(val);
        if (i != null && i != -1) {
          updatedSelectedItems = [i];
        }
      } else {
        updatedSelectedItems = null;
      }
      if (updatedSelectedItems == null) updatedSelectedItems = [];
    }
    selectedItems?.retainWhere((element) =>
    updatedSelectedItems?.any((selected) => selected == element) ?? false);
    updatedSelectedItems.forEach((selected) {
      if (!(selectedItems?.any((element) => selected == element) ?? true)) {
        selectedItems?.add(selected);
      }
    });
  }

  updateSelectedValues({dynamic sel = const NotGiven()}) {
    if (widget.futureSearchFn == null) {
      return;
    }
    List<T>? updatedFutureSelectedValues;
    if (widget.multipleSelection) {
      if (!(sel is NotGiven)) {
        updatedFutureSelectedValues = sel as List<T>;
      } else {
        updatedFutureSelectedValues = List<T>.from(widget.futureSelectedValues!);
      }
    } else {
      T? val = !(sel is NotGiven) ? sel as T : widget.value;
      if (val != null) {
        updatedFutureSelectedValues = [val];
      }
        if (updatedFutureSelectedValues == null) updatedFutureSelectedValues = [];
      }
      futureSelectedValues.retainWhere((element) =>
      updatedFutureSelectedValues?.any((selected) => selected == element) ?? false);
      updatedFutureSelectedValues.forEach((selected) {
        if (!(futureSelectedValues.any((element) => selected == element))) {
          futureSelectedValues.add(selected);
        }
      });
    }

    int? indexFromValue(T value) {
    assert(widget.futureSearchFn==null,"got a futureSearchFn with a call to indexFromValue");
      return (widget.items!.indexWhere((item) {
        return (item.value == value);
      }));
    }

    @override
    void initState() {
      if (widget.setOpenDialog != null) {
        widget.setOpenDialog!(showDialogOrMenu);
      }
      if (widget.futureSearchFn != null) {
        futureSelectedValues = [];
        if(widget.futureSelectedValues!=null) {
          futureSelectedValues.addAll(widget.futureSelectedValues!);
        }
        updateParent = (sel) {
          if (!(sel is NotGiven)) {
            widget.onChanged!(sel);
            updateSelectedValues(sel: sel);
          }
        };
        updateSelectedValues();
      }
      else {
        selectedItems = [];
        selectedItems?.addAll(widget.selectedItems);
        updateParent = (sel) {
          if (!(sel is NotGiven)) {
            widget.onChanged!(sel);
            updateSelectedItems(sel: sel);
          }
        };
        updateSelectedItems();
      }
      super.initState();
    }

    @override
    void didUpdateWidget(SearchChoices oldWidget) {
      super.didUpdateWidget(oldWidget as SearchChoices<T>);
      if (widget.futureSearchFn != null) {
        updateSelectedValues();
      }
      else {
        updateSelectedItems();
      }
    }

    Widget menuWidget({String searchTerms = ""}) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateFromBuilder) {
            return (DropdownDialog(
              items: widget.items,
              hint: prepareWidget(widget.searchHint),
              isCaseSensitiveSearch: widget.isCaseSensitiveSearch,
              closeButton: widget.closeButton,
              keyboardType: widget.keyboardType,
              searchFn: widget.searchFn,
              multipleSelection: widget.multipleSelection,
              selectedItems: selectedItems,
              doneButton: widget.doneButton,
              displayItem: widget.displayItem,
              validator: widget.validator,
              dialogBox: widget.dialogBox,
              displayMenu: displayMenu,
              menuConstraints: widget.menuConstraints,
              menuBackgroundColor: widget.menuBackgroundColor,
              style: widget.style,
              iconEnabledColor: widget.iconEnabledColor,
              iconDisabledColor: widget.iconDisabledColor,
              callOnPop: () {
                if (!widget.dialogBox &&
                    widget.onChanged != null &&
                    selectedResult != null) {
                  widget.onChanged!(selectedResult);
                }
                setState(() {});
              },
              updateParent: (value) {
                updateParent!(value);
                setStateFromBuilder(() {});
              },
              rightToLeft: widget.rightToLeft,
              autofocus: widget.autofocus,
              initialSearchTerms: searchTerms,
              buildDropDownDialog: widget.buildDropDownDialog,
              searchInputDecoration: widget.searchInputDecoration,
              itemsPerPage: widget.itemsPerPage,
              currentPage: widget.currentPage,
              customPaginationDisplay: widget.customPaginationDisplay,
              futureSearchFn: widget.futureSearchFn,
              futureSearchOrderOptions: widget.futureSearchOrderOptions,
              futureSearchFilterOptions: widget.futureSearchFilterOptions,
              futureSelectedValues: futureSelectedValues,
            ));
          });
    }

    showDialogOrMenu(String searchTerms) async {
      if (widget.dialogBox) {
        await showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return (menuWidget(searchTerms: searchTerms));
            });
        if (widget.onChanged != null && selectedResult != null) {
          widget.onChanged!(selectedResult);
        }
      } else {
        displayMenu.value = true;
      }
      if (mounted) {
        setState(() {});
      }
    }

    @override
    Widget build(BuildContext context) {
      final List<Widget> items =
      _enabled ? List<Widget>.from(widget.items??[]) : <Widget>[];
      int? hintIndex;
      if (widget.hint != null ||
          (!_enabled &&
              prepareWidget(widget.disabledHint, parameter: updateParent) !=
                  null)) {
        final Widget? emplacedHint = _enabled
            ? prepareWidget(widget.hint)
            : DropdownMenuItem<Widget>(
            child:
            prepareWidget(widget.disabledHint, parameter: updateParent) ??
                prepareWidget(widget.hint) ??
                SizedBox.shrink());
        hintIndex = items.length;
        items.add(DefaultTextStyle(
          style: _textStyle.copyWith(color: Theme
              .of(context)
              .hintColor),
          child: IgnorePointer(
            child: emplacedHint,
            ignoringSemantics: false,
          ),
        ));
      }
      Widget innerItemsWidget;
      List<Widget> list = [];
      if(widget.futureSearchFn==null) {
        selectedItems?.forEach((item) {
          if(!(item is NotGiven)) {
            list.add(widget.selectedValueWidgetFn != null
                ? widget.selectedValueWidgetFn!(widget.items![item].value)
                : items[item]);
          }
        });
      }
      else{
        futureSelectedValues.forEach((element) {
          if(!(element is NotGiven)) {
            list.add(widget.selectedValueWidgetFn != null
                ? widget.selectedValueWidgetFn!(element)
                : element is String ? Text(element) : element);
          }
        });
      }
      if ((list.isEmpty && hintIndex != null)||(list.length==1&&list.first is NotGiven)) {
        innerItemsWidget = items[hintIndex??0];
      } else {
        innerItemsWidget = widget.selectedAggregateWidgetFn != null
            ? widget.selectedAggregateWidgetFn!(list)
            : Column(
          children: list,
        );
      }
      final EdgeInsetsGeometry padding = ButtonTheme
          .of(context)
          .alignedDropdown
          ? _kAlignedButtonPadding
          : _kUnalignedButtonPadding;
      Widget? clickable = !_enabled &&
          prepareWidget(widget.disabledHint, parameter: updateParent) != null
          ? prepareWidget(widget.disabledHint, parameter: updateParent)
          : InkWell(
          key: Key(
              "clickableResultPlaceHolder"),
          //this key is used for running automated tests
          onTap: widget.readOnly || !_enabled
              ? null
              : () async {
            await showDialogOrMenu("");
          },
          child: Row(
            textDirection:
            widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
            children: <Widget>[
              widget.isExpanded
                  ? Expanded(child: innerItemsWidget)
                  : innerItemsWidget,
              IconTheme(
                data: IconThemeData(
                  color: _iconColor,
                  size: widget.iconSize,
                ),
                child:
                prepareWidget(widget.icon, parameter: selectedResult) ??
                    SizedBox.shrink(),
              ),
            ],
          ));

      Widget result = DefaultTextStyle(
        style: _textStyle,
        child: Container(
          padding: padding.resolve(Directionality.of(context)),
          child: Row(
            textDirection:
            widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              widget.isExpanded
                  ? Expanded(child: clickable ?? SizedBox.shrink())
                  : clickable ?? SizedBox.shrink(),
              !widget.displayClearIcon
                  ? SizedBox()
                  : InkWell(
                onTap: hasSelection && _enabled && !widget.readOnly
                    ? () {
                  clearSelection();
                }
                    : null,
                child: Container(
                  padding: padding.resolve(Directionality.of(context)),
                  child: Row(
                    textDirection: widget.rightToLeft
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconTheme(
                        data: IconThemeData(
                          color:
                          hasSelection && _enabled && !widget.readOnly
                              ? _enabledIconColor
                              : _disabledIconColor,
                          size: widget.iconSize,
                        ),
                        child: widget.clearIcon,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      final double bottom = 8.0;
      var validatorOutput;
      if (widget.validator != null) {
        validatorOutput = widget.validator!(selectedResult);
      }
      var labelOutput = prepareWidget(widget.label, parameter: selectedResult,
          stringToWidgetFunction: (string) {
            return (Text(string,
                textDirection:
                widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(color: Colors.blueAccent, fontSize: 13)));
          });
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          labelOutput ?? SizedBox.shrink(),
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(widget.padding),
                child: result,
              ),
              widget.underline is NotGiven
                  ? SizedBox.shrink()
                  : Positioned(
                left: 0.0,
                right: 0.0,
                bottom: bottom,
                child: prepareWidget(widget.underline,
                    parameter: selectedResult) ??
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: valid
                                      ? Color(0xFFBDBDBD)
                                      : Colors.red,
                                  width: 0.0))),
                    ),
              ),
            ],
          ),
          valid
              ? SizedBox.shrink()
              : validatorOutput is String
              ? Text(
            validatorOutput,
            textDirection: widget.rightToLeft
                ? TextDirection.rtl
                : TextDirection.ltr,
            style: TextStyle(color: Colors.red, fontSize: 13),
          )
              : validatorOutput,
          displayMenu.value ? menuWidget() : SizedBox.shrink(),
        ],
      );
    }

    clearSelection() {
      if(widget.futureSearchFn==null) {
        selectedItems?.clear();
      }
      else{
        futureSelectedValues.clear();
      }
      if (widget.onChanged != null) {
        widget.onChanged!(selectedResult);
      }
      if (widget.onClear != null) {
        widget.onClear!();
      }
      setState(() {});
    }
  }

/// Class mainly used internally to display the available choices. Cannot be made private because of automated testing.
class DropdownDialog<T> extends StatefulWidget {
  /// See SearchChoices class.
  final List<DropdownMenuItem<T>>? items;

  /// See SearchChoices class.
  final Widget? hint;

  /// See SearchChoices class.
  final bool isCaseSensitiveSearch;

  /// See SearchChoices class.
  final dynamic closeButton;

  /// See SearchChoices class.
  final TextInputType? keyboardType;

  /// See SearchChoices class.
  final Function? searchFn;

  /// See SearchChoices class.
  final bool multipleSelection;

  /// See SearchChoices class.
  final List<int>? selectedItems;

  /// See SearchChoices class.
  final Function? displayItem;

  /// See SearchChoices class.
  final dynamic doneButton;

  /// See SearchChoices class.
  final Function? validator;

  /// See SearchChoices class.
  final bool dialogBox;

  /// See SearchChoices class.
  final PointerThisPlease<bool> displayMenu;

  /// See SearchChoices class.
  final BoxConstraints? menuConstraints;

  /// Function to be called whenever the dialogbox is poped or the menu gets closed.
  final Function? callOnPop;

  /// See SearchChoices class.
  final Color? menuBackgroundColor;

  /// Function called to update the parent screen when necessary. Calls setState.
  final Function? updateParent;

  /// See SearchChoices class.
  final TextStyle? style;

  /// See SearchChoices class.
  final Color? iconEnabledColor;

  /// See SearchChoices class.
  final Color? iconDisabledColor;

  /// See SearchChoices class.
  final bool rightToLeft;

  /// See SearchChoices class.
  final bool autofocus;

  /// Used for the setOpenDialog. This allows the dialogbox to be opened with search terms preset from an external button as shown in example `Single dialog open and set search terms`.
  final String initialSearchTerms;

  /// See SearchChoices class.
  final Widget Function(
    Widget titleBar,
    Widget searchBar,
    Widget list,
    Widget closeButton,
    BuildContext dropDownContext,
  )? buildDropDownDialog;

  /// See SearchChoices class.
  final InputDecoration? searchInputDecoration;

  /// See SearchChoices class.
  final int? itemsPerPage;

  /// See SearchChoices class.
  final PointerThisPlease<int>? currentPage;

  /// See SearchChoices class.
  final Widget Function(Widget listWidget, int totalFilteredItemsNb,
      Function updateSearchPage)? customPaginationDisplay;

  /// See SearchChoices class.
  final Future<Tuple2<List<DropdownMenuItem>,int>> Function(String? keyword, List<DropdownMenuItem> itemsListToClearAndFill, String? orderBy, bool? orderAsc, Map<String,String>? filters, int? pageNb)? futureSearchFn;

  /// See SearchChoices class.
  final Map<String, Set<Object>>? futureSearchOrderOptions;

  /// See SearchChoices class.
  final Map<String, Map<String, Object>>? futureSearchFilterOptions;

  /// See SearchChoices class.
  final List<T>? futureSelectedValues;

  DropdownDialog({
    Key? key,
    this.items,
    this.hint,
    this.isCaseSensitiveSearch = false,
    this.closeButton,
    this.keyboardType,
    this.searchFn,
    required this.multipleSelection,
    this.selectedItems,
    this.displayItem,
    this.doneButton,
    this.validator,
    required this.dialogBox,
    required this.displayMenu,
    this.menuConstraints,
    this.callOnPop,
    this.menuBackgroundColor,
    this.updateParent,
    this.style,
    this.iconEnabledColor,
    this.iconDisabledColor,
    required this.rightToLeft,
    required this.autofocus,
    required this.initialSearchTerms,
    this.buildDropDownDialog,
    this.searchInputDecoration,
    this.itemsPerPage,
    this.currentPage,
    this.customPaginationDisplay,
    this.futureSearchFn,
    this.futureSearchOrderOptions,
    this.futureSearchFilterOptions,
    this.futureSelectedValues,
  }) : super(key: key);

  _DropdownDialogState<T> createState() => _DropdownDialogState<T>();
}

class _DropdownDialogState<T> extends State<DropdownDialog> {
  TextEditingController txtSearch = TextEditingController();
  TextStyle defaultButtonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  List<int> shownIndexes = [];
  Function? searchFn;
  String? latestKeyword;

  bool futureSearch=false;
  Future<Tuple2<List<DropdownMenuItem>,int>>? futureSearchResults;

  _DropdownDialogState();

  dynamic get selectedResult {
    if(futureSearch){
      if(widget.multipleSelection){
        return(widget.futureSelectedValues);
      }
      if(widget.futureSelectedValues!.isNotEmpty){
        return(widget.futureSelectedValues!.first);
      }
      return(null);
    }
    return (widget.multipleSelection
        ? widget.selectedItems
        : widget.selectedItems?.isNotEmpty ?? false
            ? widget.items![widget.selectedItems?.first ?? 0].value
            : null);
  }

  void _updateShownIndexes(
    String? keyword,
  ) {
    assert(!futureSearch,"cannot update shown indexes while doing a network search as all returned are displayed (potentially with pagination)");
    if (keyword != null) {
      latestKeyword = keyword;
    }
    if (latestKeyword != null) {
      shownIndexes = searchFn!(latestKeyword, widget.items);
    }
  }

  @override
  void initState() {
    if(widget.futureSearchFn!=null){
      futureSearch=true;
    }
    else {
      if (widget.searchFn != null) {
        searchFn = widget.searchFn;
      } else {
        Function matchFn;
        if (widget.isCaseSensitiveSearch) {
          matchFn = (item, keyword) {
            return (item.value.toString().contains(keyword));
          };
        } else {
          matchFn = (item, keyword) {
            return (item.value
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()));
          };
        }
        searchFn = (keyword, items) {
          List<int> shownIndexes = [];
          int i = 0;
          widget.items!.forEach((item) {
            if (matchFn(item, keyword) || (keyword?.isEmpty ?? true)) {
              shownIndexes.add(i);
            }
            i++;
          });
          return (shownIndexes);
        };
      }
      assert(searchFn != null);
    }
    widget.currentPage?.value = 1;
    if (widget.initialSearchTerms.isNotEmpty) {
      txtSearch.text = widget.initialSearchTerms;
      searchForKeyword(txtSearch.text);
    } else {
      searchForKeyword('');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildDropDownDialog != null) {
      return (widget.buildDropDownDialog!(
          titleBar(), searchBar(), listWithPagination(), closeButtonWrapper(), context));
    }
    return AnimatedContainer(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 300),
      child: Card(
        color: widget.menuBackgroundColor,
        margin: EdgeInsets.symmetric(
            vertical: widget.dialogBox ? 10 : 5,
            horizontal: widget.dialogBox ? 10 : 4),
        child: Container(
          constraints: widget.menuConstraints,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              titleBar(),
              searchBar(),
              listWithPagination(),
              closeButtonWrapper(),
            ],
          ),
        ),
      ),
    );
  }

  bool get valid {
    if (widget.validator == null) {
      return (true);
    }
    return (widget.validator!(selectedResult) == null);
  }

  /// Widget displayed above the search bar.
  Widget titleBar() {
    var validatorOutput;
    if (widget.validator != null) {
      validatorOutput = widget.validator!(selectedResult);
    }

    Widget validatorOutputWidget = valid || !widget.dialogBox
        ? SizedBox.shrink()
        : validatorOutput is String
            ? Text(
                validatorOutput,
                textDirection:
                    widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
                style: TextStyle(color: Colors.red, fontSize: 13),
              )
            : validatorOutput;

    Widget? doneButtonWidget =
        widget.multipleSelection || widget.doneButton != null
            ? prepareWidget(widget.doneButton,
                parameter: selectedResult,
                context: context,
                updateParent: widget.updateParent,
                stringToWidgetFunction: (string) {
                return (TextButton.icon(
                    onPressed: !valid
                        ? null
                        : () {
                            pop();
                            setState(() {});
                          },
                    icon: Icon(Icons.close),
                    label: Text(
                      string,
                      textDirection: widget.rightToLeft
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    )));
              })
            : SizedBox.shrink();
    return widget.hint != null
        ? Container(
            margin: EdgeInsets.only(bottom: 8),
            child: Row(
                textDirection:
                    widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  prepareWidget(widget.hint) ?? SizedBox.shrink(),
                  Column(
                    children: <Widget>[
                      doneButtonWidget ?? SizedBox.shrink(),
                      validatorOutputWidget
                    ],
                  ),
                ]),
          )
        : Container(
            child: Column(
              children: <Widget>[
                doneButtonWidget ?? SizedBox.shrink(),
                validatorOutputWidget
              ],
            ),
          );
  }

  /// Basically splits the search between the searchFn and the futureSearchFn cases.
  void searchForKeyword(String? keyword){
    if(futureSearch){
      _doFutureSearch(keyword);
    }
    else{
      _updateShownIndexes(keyword);
    }
  }

  /// Refreshes the displayed list with the network search results.
  Future<Tuple2<List<DropdownMenuItem>,int>>? _doFutureSearch(String? keyword){
    futureSearchResults=widget.futureSearchFn!(
        keyword,
        widget.items??[],//TODO: try to remove this
        null,
        null,
        null,
        widget.currentPage?.value??1,
    );
    return(futureSearchResults);
  }

  /// Search bar where the user can type text to look for the items to select.
  Widget searchBar() {
    return Container(
      child: Stack(
        children: <Widget>[
          TextField(
            textDirection:
                widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
            controller: txtSearch,
            decoration: widget.searchInputDecoration != null
                ? widget.searchInputDecoration
                : widget.rightToLeft
                    ? InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          size: 24,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      )
                    : InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
            style: widget.style,
            autofocus: widget.autofocus,
            onChanged: (value) {
              widget.currentPage?.value = 1;
              searchForKeyword(value);
              setState(() {});
            },
            keyboardType: widget.keyboardType,
          ),
          txtSearch.text.isNotEmpty
              ? Positioned(
                  right: widget.rightToLeft ? null : 0,
                  left: widget.rightToLeft ? 0 : null,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        widget.currentPage?.value = 1;
                        searchForKeyword('');
                        setState(() {
                          txtSearch.text = '';
                        });
                      },
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        width: 32,
                        height: 32,
                        child: Center(
                          child: Icon(
                            Icons.close,
                            size: 24,
                            color: txtSearch.text.isEmpty
                                ? widget.iconDisabledColor
                                : widget.iconEnabledColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  /// Closes the dialog box or the menu depending on the selected mode.
  pop() {
    if (widget.dialogBox) {
      Navigator.pop(context);
    } else {
      widget.displayMenu.value = false;
      if (widget.callOnPop != null) {
        widget.callOnPop!();
      }
    }
  }

  void deselectItem(int index,T value){
    if(futureSearch) {
      widget.futureSelectedValues?.remove(value);
    }
    else {
      widget.selectedItems?.remove(index);
    }
  }

  void selectItem(int index,T value){
    if(!widget.multipleSelection){
      if(futureSearch) {
        widget.futureSelectedValues?.clear();
      }
      else {
        widget.selectedItems?.clear();
      }
    }
    if(futureSearch) {
      widget.futureSelectedValues?.add(value);
    }
    else {
      widget.selectedItems?.add(index);
    }
  }

  void itemTapped(int index,T value, bool itemSelected){
    if (widget.multipleSelection&&itemSelected) {
      setState(() {
          deselectItem(index, value);
      });
    } else {
      selectItem(index, value);
      if (!widget.multipleSelection&&widget.doneButton == null) {
        pop();
      } else {
        setState(() {});
      }
    }
  }

  /// Returns whether an item is selected. Relies on index in case of non future list of items.
  bool isItemSelected(int index,T value){
    if(futureSearch){
      return(widget.futureSelectedValues!.contains(value));
    }
    return(widget.selectedItems?.contains(index)??false);
  }

  /// Builds the list display from the given list of [DropdownMenuItem] along with the [bool] indicating whether the item is selected or not and the [int] as the index in the [selectedItems] list.
  Widget listDisplay(List<Tuple3<int,DropdownMenuItem<dynamic>,bool>> itemsToDisplay){
    return
    Expanded(
      child: Scrollbar(
        child: ListView.builder(
          itemBuilder: (context, index) {
            int itemIndex = itemsToDisplay[index].item1;
            DropdownMenuItem item = itemsToDisplay[index].item2;
            bool isItemSelected = itemsToDisplay[index].item3;
            Widget? displayItemResult;
            if (widget.displayItem != null) {
              try {
                displayItemResult = widget.displayItem!(item, isItemSelected);
              } on NoSuchMethodError {
                displayItemResult =
                    widget.displayItem!(item, isItemSelected, (value) {
                      widget.updateParent!(value);
                      widget.currentPage?.value = 1;
                      searchForKeyword(null);
                    });
              }
            }
            return InkWell(
              onTap: () {
                itemTapped(itemIndex, item.value, isItemSelected);
              },
              child:
              widget.displayItem == null
                  ? widget.multipleSelection ? (Row(
                  textDirection: widget.rightToLeft
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    Icon(
                      isItemSelected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Flexible(child: item),
                  ]))
                  : item
                  : displayItemResult,
            );
          },
          itemCount: itemsToDisplay.length,
        ),
      ),
    );
  }

//  Widget prepareTheListWidget(){
//
//  }

  /// Displays the list of items filtered based on the search terms with pagination.
  Widget listWithPagination() {
    List<int> pagedShownIndexes = [];
    bool displayPages = true;
    if(!futureSearch) {
      if (widget.itemsPerPage == null ||
          widget.itemsPerPage! >= shownIndexes.length) {
        pagedShownIndexes = shownIndexes;
        displayPages = false;
      } else {
        if (widget.currentPage!.value < 1 ||
            widget.currentPage!.value >
                (shownIndexes.length / widget.itemsPerPage!).ceil()) {
          widget.currentPage!.value = 1;
        }
        for (int i = widget.itemsPerPage! * (widget.currentPage!.value - 1);
        i < widget.itemsPerPage! * (widget.currentPage!.value) &&
            i < shownIndexes.length;
        i++) {
          pagedShownIndexes.add(shownIndexes[i]);
        }
      }
    }
    else{
      if(widget.itemsPerPage == null){
        displayPages=false;
      }
    }

    List<Tuple3<int,DropdownMenuItem<dynamic>,bool>> itemsToDisplay;

    if(futureSearch){
      Widget errorRetryButton=Column(children:[SizedBox(height:15),Center(child: ElevatedButton.icon(onPressed: () {
        _doFutureSearch(latestKeyword);
      }, icon: Icon(Icons.repeat), label: Text("Error - retry")),)]);
      return(
      FutureBuilder(
        future: _doFutureSearch(latestKeyword),
        builder: (context,AsyncSnapshot<Tuple2<List<DropdownMenuItem>,int>> snapshot) {
          if (snapshot.hasError) {
            return (errorRetryButton);
          }
          if (!snapshot.hasData||snapshot.connectionState == ConnectionState.waiting) {
            return (Column(children:[SizedBox(height:15),Center(child: CircularProgressIndicator(),)]));
          }
          if (snapshot.data == null) {
            return (Column(children:[SizedBox(height:15),Center(child: Text("-"),)]));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Tuple2<List<DropdownMenuItem>, int>data = snapshot.data!;
            int nbResults = data.item2;
            if(data.item1.length==0){
              return (Column(children:[SizedBox(height:15),Center(child: Text("-"),)]));//no results
            }
            itemsToDisplay =
                data.item1.map<Tuple3<int, DropdownMenuItem<dynamic>, bool>>((
                    DropdownMenuItem item) {
                  return (Tuple3<int, DropdownMenuItem<dynamic>, bool>(
                      -1, item,
                      isItemSelected(-1, item.value!)));
                }).toList();
            Widget scrollBar = listDisplay(itemsToDisplay);
            if (widget.itemsPerPage == null ||
                nbResults <= itemsToDisplay.length) {
              return (scrollBar);
            }
            // Handle the pagination
            return (scrollBar);
          }
          print("connection state: ${snapshot.connectionState.toString()}");
          return (errorRetryButton);
        },
      )
      );
    }


      itemsToDisplay =
          pagedShownIndexes.map<Tuple3<int, DropdownMenuItem<T>, bool>>((
              int index) {
            return (Tuple3<int, DropdownMenuItem<T>, bool>(
                index, widget.items![index] as DropdownMenuItem<T>,
                isItemSelected(index, widget.items![index].value)));
          }).toList();
    Widget scrollBar=listDisplay(itemsToDisplay);
    
    if (!displayPages) {
      return (scrollBar);
    }
    
    Function updateSearchPage = () {
      searchForKeyword(latestKeyword);
      setState(() {});
    };
    
    if (widget.customPaginationDisplay != null) {
      return (widget.customPaginationDisplay!(
          scrollBar, shownIndexes.length, updateSearchPage));
    }
    
    bool first = widget.currentPage!.value == 1;
    bool last = widget.currentPage!.value >=
        (shownIndexes.length / widget.itemsPerPage!).ceil();
    
    Widget previousPageButton = IconButton(
      icon: Icon(
        widget.rightToLeft ? Icons.chevron_right : Icons.chevron_left,
        color: first ? Colors.grey : Colors.blue,
      ),
      onPressed: first
          ? null
          : () {
              widget.currentPage!.value--;
              updateSearchPage();
            },
    );
    
    Widget nextPageButton = IconButton(
      icon: Icon(
        widget.rightToLeft ? Icons.chevron_left : Icons.chevron_right,
        color: last ? Colors.grey : Colors.blue,
      ),
      onPressed: last
          ? null
          : () {
              widget.currentPage!.value++;
              updateSearchPage();
            },
    );
    
    return (Expanded(
        child: Column(children: [
      SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        widget.rightToLeft ? nextPageButton : previousPageButton,
        Text(
            "${widget.currentPage!.value}/${(shownIndexes.length / widget.itemsPerPage!).ceil()}"),
        widget.rightToLeft ? previousPageButton : nextPageButton,
      ]),
      scrollBar,
    ])));
  }

  /// Returns the close button after the list of items or its replacement.
  Widget closeButtonWrapper() {
    return (prepareWidget(widget.closeButton,
            parameter: selectedResult, context: context, updateParent: (sel) {
          widget.updateParent!(sel);
          setState(() {});
        }, stringToWidgetFunction: (string) {
          return (Container(
            child: Row(
              textDirection:
                  widget.rightToLeft ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    pop();
                  },
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 2),
                      child: Text(
                        string,
                        textDirection: widget.rightToLeft
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        style: defaultButtonStyle,
                        overflow: TextOverflow.ellipsis,
                      )),
                )
              ],
            ),
          ));
        }) ??
        SizedBox.shrink());
  }
}
