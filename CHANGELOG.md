## 2.0.21

* Updated license date. Fixed a deprecation warning in pub.dev with isAlwaysShown.
* Fixed increasing or decreasing size between hint, enabled, disabled, selected states. Thanks @vaibhavjoshi247 https://github.com/lcuis/search_choices/issues/81
* Added fieldDecoration. Thanks @rhernandez-itemsoft https://github.com/lcuis/search_choices/issues/78
* Added clearSearchIcon. Thanks @gslender https://github.com/lcuis/search_choices/issues/73

## 2.0.20

* Added dropDownDialogPadding parameter. Thanks @Macacoazul01 https://github.com/lcuis/search_choices/issues/77

## 2.0.19

* ScrollBar parameter isAlwaysShown is back instead of thumbVisibility as it broke the build as shown in https://github.com/lcuis/search_choices/issues/70
* Working with stable flutter channel on GitHub CI/CD instead of dev channel.

## 2.0.18

* Added fieldPresentationFn for the needs of https://github.com/lcuis/search_choices/issues/69 . Thanks @sajiyabro98 .

## 2.0.17

* Bug 63 1.1 Click on dropdown button while menu is opened doesn't close menu. Thanks @Macacoazul01 https://github.com/lcuis/search_choices/issues/63
* Enhancement 63 1.2 Pop menu from onChanged. Thanks @Macacoazul01 https://github.com/lcuis/search_choices/issues/63
* Enhancement 63 2.2 Pop menu from updateParent. Thanks @Macacoazul01 https://github.com/lcuis/search_choices/issues/63
* Bug 63 3. Delete last item from menu causes index error. Thanks @Macacoazul01 https://github.com/lcuis/search_choices/issues/63

## 2.0.16

* Added searchDelay to give some time before search function is called in Future and non-Future cases. Thanks @rhernandez-itemsoft https://github.com/lcuis/search_choices/issues/58

## 2.0.15

* Customize error - retry button through new parameter futureSearchRetryButton. Thanks @rhernandez-itemsoft https://github.com/lcuis/search_choices/issues/56

## 2.0.14

* Use of context for onChange was potentially breaking situations where Widget was already disposed. Thanks @bondjpf https://github.com/lcuis/search_choices/issues/51

## 2.0.13

* Removed issue example from example project.

## 2.0.12

* Trying to comply with the pub.dev formatting.

## 2.0.11

* Trying to comply with the pub.dev formatting.
* Fixed some gradle problems: https://jeroenmols.com/blog/2021/02/04/migratingjcenter/

## 2.0.10

* Trying to comply with the pub.dev formatting.

## 2.0.9

* Trying to comply with the pub.dev formatting unmentioned requirements.

## 2.0.8

* Calling non future items onTap if not null when list item is tapped. Thanks @EbrahimMosaaed https://github.com/lcuis/search_choices/issues/49
* Fixed some typos.
* Added the following example code to the README: Multi dialog paged future

## 2.0.7

* Fixed bug: Multi future selected items did not appear as selected when reopening the list. Thanks @bhimpratapsingh https://github.com/lcuis/search_choices/issues/44
* Fixed bug: future search dialog box iOS: filter doesn't change list. https://github.com/lcuis/search_choices/issues/46
* Added an example: Multi dialog paged future

## 2.0.6

* Added emptyListWidget parameter. Thanks @KhatibFX https://github.com/lcuis/search_choices/issues/42
* Added onTap parameter. Thanks @KhatibFX https://github.com/lcuis/search_choices/issues/26
* Removed useless DropdownButtonNoSelDisp class.

## 2.0.5

* Corrected bug on pagination: scroll down and move to next page or type a new keyword, the scroll remained down.
* Improved documentation.

## 2.0.4

* Added pagination with itemsPerPage, currentPage and customPaginationDisplay parameters
* Added possibility to perform future/network searches with order and filter selections through the addition of the futureSearchFn, futureSearchOrderOptions, futureSearchFilterOptions and futureSelectedValues parameters

## 2.0.3

* New searchInputDecoration parameter, thanks @develogo https://github.com/lcuis/search_choices/pull/35

## 2.0.2

* Lets implementation control dropdown dialog layout display through buildDropDownDialog function, thanks @slavap https://github.com/lcuis/search_choices/issues/23 and https://github.com/lcuis/search_choices/issues/22

## 2.0.1

* Improved dartdoc documentation.
* Added dartdoc command script that is not affected by the issue where dartdoc tries to parse SDK libraries.
* Added linux release and mentioned windows as a possibility.

## 2.0.0

* Migrated to sound null safety with Flutter 2, thanks @Raphael-Jose-Ferraro-IRForever https://github.com/lcuis/search_choices/issues/31
* Added padding parameter to set the padding around the DropdownButton, thanks to @luis-cruzt https://github.com/lcuis/search_choices/pull/27
* Migrated buttons to non-deprecated versions
* Added the possibility to call the dialog with the search terms from a button, thanks to @ettiennelr https://github.com/lcuis/search_choices/issues/30

## 1.0.17

* Present selected values in a custom widget through selectedAggregateWidgetFn. Thanks @slavap https://github.com/lcuis/search_choices/issues/12

## 1.0.16

* avoid deprecated subhead warning in pub.dev
* search field autofocus parameter, thanks @slavap https://github.com/lcuis/search_choices/issues/11
* not displaying validation twice when in menu mode, thanks @geriby23 https://github.com/lcuis/search_choices/issues/10

## 1.0.15

* Bug: menu mode didn't open choices when on hosted web. https://github.com/lcuis/search_choices/issues/9 and https://github.com/icemanbsi/searchable_dropdown/issues/39

## 1.0.14

* Surrounded the DropdownDialog with a StatefulBuilder to allow the refresh of the display when there is a call to updateParent through a setState.

## 1.0.13

* surrounded a setState by an if statement to check that mounted is set to true
* corrected issue 8: ios compile error: search_choices_for_push-Swift.h file not found. Thanks @jaspervdbijl !

## 1.0.12

* improvement of the selection update logic
* consecutive adaptation of the examples

## 1.0.11

* bug: allow multiselection dialog select all to update when outside a tab bar: https://github.com/icemanbsi/searchable_dropdown/issues/21#issuecomment-599198943 thanks to @ettiennelr

## 1.0.10

* bug: allow selection update from outside the plugin: https://github.com/icemanbsi/searchable_dropdown/issues/21 (thanks to @ettiennelr and @lechuk)

## 1.0.9

* adapted dropdown list display to support multiple selection editable list
* added an example of multiple selection editable list

## 1.0.8

* added rightToLeft parameter to README

## 1.0.7

* made it possible to make a dark mode without changing the theme with an example
* added an example for ellipsis text overflow handling
* made it possible to support right to left languages with an example

## 1.0.6

* selectable items can be added and removed by the user

## 1.0.5

* added demonstration for disabled and readOnly
* test formatted
* added readOnly and menuBackgroundColor parameters
* clear icon disabled when Widget is disabled

## 1.0.4

* minor changes to CI/CD
* git cleanups

## 1.0.3

* minor improvements to README

## 1.0.2

* minor improvements to README

## 1.0.1

* CI/CD improved automated deployment

## 0.0.1

Improvements on a pull request that was probably changing too many things to be accepted of the great icemanbsi's searchable_dropdown:
https://github.com/icemanbsi/searchable_dropdown/pull/11
Part of the pull request I proposed:
* keyboardType
* validator
* label
* searchFn
* multipleSelection

New with this repository:
* demo app with a gallery as tabs or as a single page (change through a switch)
* automated testing
* continuous integration (CI)
* continuous deployment (CD)
* license is MIT
* split constructors between single and multiple selection
* comments on the constructors
* selection can be done in a menu, not just a dialog box
* solution to allow flexibility to provide a String, a Widget or a Function that returns either one of String or Widget for several components of the Widget
* documentation
* keyboard doesn't overlap dialog
