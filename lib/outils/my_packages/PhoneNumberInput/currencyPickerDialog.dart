import 'package:flutter/material.dart';

import '/providers/theme/elements/main.dart';
import '../../constantes/colors.dart';
import 'utils/countries.dart';
import 'utils/country.dart';
import 'utils/my_alert_dialog.dart';
import 'utils/typedefs.dart';

class CurrencyPickerDialog extends StatefulWidget {
  final ValueChanged<Country>? onValuePicked;

  final Widget? title;

  final EdgeInsetsGeometry? titlePadding;

  final EdgeInsetsGeometry contentPadding;

  final String? semanticLabel;

  /// Filters the available country list
  final ItemFilter? itemFilter;

  final ItemBuilder? itemBuilder;

  final Widget divider;

  final bool isDividerEnabled;

  final bool isSearchable;

  final InputDecoration? searchInputDecoration;

  final Color? searchCursorColor;

  final Widget? searchEmptyView;

  CurrencyPickerDialog({
    Key? key,
    this.onValuePicked,
    this.title,
    this.titlePadding,
    this.contentPadding = const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 16.0),
    this.semanticLabel,
    this.itemFilter,
    this.itemBuilder,
    this.isDividerEnabled = false,
    this.divider = const Divider(
      height: 0.0,
    ),
    this.isSearchable = false,
    this.searchInputDecoration,
    this.searchCursorColor,
    this.searchEmptyView,
  }) : super(key: key);

  @override
  SingleChoiceDialogState createState() {
    return new SingleChoiceDialogState();
  }
}

class SingleChoiceDialogState extends State<CurrencyPickerDialog> {
  List<Country>? _allCountries;

  List<Country>? _filteredCountries;

  @override
  void initState() {
    _allCountries =
        countryList.where(widget.itemFilter ?? acceptAllCountries).toList();

    _filteredCountries = _allCountries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      title: _buildHeader(),
      contentPadding: widget.contentPadding,
      semanticLabel: widget.semanticLabel,
      content: _buildContent(context),
      isDividerEnabled: widget.isDividerEnabled,
      divider: widget.divider,
    );
  }

  _buildContent(BuildContext context) {
    return _filteredCountries!.isNotEmpty
        ? ListView(
            shrinkWrap: true,
            children: _filteredCountries!
                .map((item) => SimpleDialogOption(
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(item)
                          : Text(
                              item.name!,
                              style:
                                  ThemeElements(context: context).styleText(),
                            ),
                      onPressed: () {
                        widget.onValuePicked!(item);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
          )
        : widget.searchEmptyView ??
            Center(
              child: Text(
                'Pays inconnu.',
                style: ThemeElements(context: context).styleText(),
              ),
            );
  }

  _buildHeader() {
    return widget.isSearchable
        ? Column(
            children: [
              _buildTitle(),
              _buildSearchField(),
            ],
          )
        : _buildTitle();
  }

  _buildTitle() {
    return widget.titlePadding != null
        ? Padding(
            padding: widget.titlePadding!,
            child: widget.title,
          )
        : widget.title;
  }

  _buildSearchField() {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(color: dBlackLeger),
      textAlign: TextAlign.start,
      cursorColor: widget.searchCursorColor,
      decoration:
          widget.searchInputDecoration ?? InputDecoration(hintText: 'Search'),
      onChanged: (String value) {
        setState(() {
          _filteredCountries = _allCountries!
              .where((Country country) =>
                  country.name!.toLowerCase().startsWith(value.toLowerCase()) ||
                  country.phoneCode!.startsWith(value) ||
                  country.currencyCode!.toLowerCase().startsWith(value) ||
                  country.currencyName!.toLowerCase().startsWith(value) ||
                  country.isoCode!
                      .toLowerCase()
                      .startsWith(value.toLowerCase()))
              .toList();
        });
      },
    );
  }
}
