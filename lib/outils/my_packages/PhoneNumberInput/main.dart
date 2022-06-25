import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../providers/theme/elements/main.dart';
import '../../constantes/colors.dart';
import 'currencyPickerDialog.dart';
import 'formatter/as_you_type_formatter.dart';
import 'itemFlag.dart';
import 'utils/country.dart';
import 'utils/main.dart';

class PhoneNumberInput extends StatefulWidget {
  final Country defaultCountry;
  final TextEditingController phoneCodeCtrl;
  final TextEditingController phoneNumberCtrl;

  const PhoneNumberInput(
      {Key? key,
      required this.defaultCountry,
      required this.phoneNumberCtrl,
      required this.phoneCodeCtrl})
      : super(key: key);
  @override
  State<PhoneNumberInput> createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  Country? _selectedCountry;

  void _openCurrencyPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CurrencyPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(
                  isCollapsed: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Un pays",
                  hintStyle:
                      TextStyle(color: dBlackLeger, fontSize: 20, height: 1.4),
                  prefixIcon: Icon(Icons.search, color: dBlack),
                ),
                isSearchable: true,
                title: Text('Choisissez votre pays'),
                onValuePicked: (Country country) => setState(() {
                      _selectedCountry = country;
                      widget.phoneCodeCtrl.text = country.phoneCode ?? "";
                    }),
                itemBuilder: _buildCurrencyDialogItem)),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (true) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              MaterialButton(
                  padding: EdgeInsets.zero,
                  minWidth: 0,
                  onPressed: _openCurrencyPickerDialog,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ItemFlag(
                        country: _selectedCountry ?? widget.defaultCountry),
                  )),
            ],
          ),
          SizedBox(width: 12),
        ],
        Flexible(
            child: TextFormField(
          scrollPadding: const EdgeInsets.all(20.0),
          textDirection: TextDirection.ltr,
          controller: widget.phoneNumberCtrl,
          keyboardType: TextInputType.phone,
          validator: (val) => val!.length < 8 ? "Mauvais numero" : null,
          style: ThemeElements(context: context).styleTextFieldTheme,
          decoration: InputDecoration(
            hintText: "Numero téléphone",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(bottom: 15, left: 0),
          ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(15),
            AsYouTypeFormatter(
              isoCode:
                  _selectedCountry?.isoCode ?? widget.defaultCountry.isoCode!,
              phoneCode: _selectedCountry?.phoneCode ??
                  widget.defaultCountry.phoneCode!,
              onInputFormatted: (TextEditingValue value) {
                widget.phoneNumberCtrl.value = value;
              },
            )
          ],
        ))
      ],
    ));
  }

  Widget _buildCurrencyDialogItem(Country country) => Row(
        children: <Widget>[
          CountryUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text(
            "${country.phoneCode}",
            style: ThemeElements(context: context).styleText(),
          ),
          SizedBox(width: 8.0),
          Flexible(
              child: Text(
            country.name ?? '',
            style: ThemeElements(context: context).styleText(),
          ))
        ],
      );
}
