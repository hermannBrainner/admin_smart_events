import 'package:flutter/material.dart';

import '/outils/size_configs.dart';
import 'views.dart';

class PageViewerTile<String> extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const PageViewerTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {
        popBillet(
            context: context,
            onlyLastPage: true,
            modePage: this.value.toString());
      },
      onLongPress: () => onChanged(value),
      child: _customRadioButton,
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;

    final icon = Icon(
      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
      color: isSelected ? Colors.blue : null,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: SizeConfig.blockSizeVertical * 30,
          width: SizeConfig.blockSizeHorizontal * 40,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1, vertical: 8),
          decoration: BoxDecoration(
            color: null,
            borderRadius:
                BorderRadius.circular(SizeConfig.blockSizeHorizontal * 2),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              billetView(onlyLastPage: true, mode: value.toString())

              //  Center( child: ,)
            ],
          ),
        ),
        IconButton(
          icon: icon,
          padding: EdgeInsets.symmetric(vertical: 2),
          onPressed: () => onChanged(value),
        )
      ],
    );
  }
}
