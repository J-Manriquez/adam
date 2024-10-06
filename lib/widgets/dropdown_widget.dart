import 'package:flutter/material.dart';
import 'package:ADAM/models/font_size_model.dart';
import 'package:ADAM/models/theme_model.dart'; // Importamos el modelo de tema
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

Widget buildDropdownField(
    String labelText,
    List<String> items,
    String? selectedItem,
    ValueChanged<String?> onChanged,
    double dropdownWidth,
    BuildContext context) {
      
  final themeModel = Provider.of<ThemeModel>(context, listen: false);
  final fontSizeModel = Provider.of<FontSizeModel>(context, listen: false);

  const double itemHeight = 40;
  const double dividerThickness = 1.5;

  return Container(
    width: dropdownWidth,
    child: DropdownButtonFormField2<String>(
      value: selectedItem,
      decoration: InputDecoration(
        labelText: labelText, 
        labelStyle: TextStyle(color: themeModel.secondaryTextColor, fontSize: fontSizeModel.textSize),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: themeModel.secondaryButtonColor.withOpacity(0.5),
            width: 4.0,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: themeModel.primaryButtonColor,
            width: 2.0,
          ),
        ),
      ),
      items: items.asMap().entries.map((entry) {
        int index = entry.key;
        String item = entry.value;

        return DropdownMenuItem<String>(
          value: item,
          child: Container(
            height: itemHeight,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: themeModel.secondaryTextColor,
                        fontSize: fontSizeModel.subtitleSize,
                      ),
                    ),
                  ),
                ),
                if (index < items.length - 1)
                  Divider(
                    color: themeModel.primaryIconColor,
                    thickness: dividerThickness,
                    height: dividerThickness,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: TextStyle(
        color: themeModel.secondaryTextColor,
        fontSize: fontSizeModel.subtitleSize,
      ),
      isExpanded: true,
      dropdownDecoration: BoxDecoration(
        color: themeModel.primaryButtonColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4),
        ],
      ),
      itemHeight: itemHeight,
      buttonHeight: itemHeight*0.5,
      buttonPadding: EdgeInsets.only(left: 0, right: 8),
      alignment: AlignmentDirectional.centerStart,
      selectedItemBuilder: (BuildContext context) {
        return items.map<Widget>((String item) {
          return Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              item,
              style: TextStyle(
                color: themeModel.secondaryTextColor,
                fontSize: fontSizeModel.subtitleSize,
              ),
            ),
          );
        }).toList();
      },
    ),
  );
}