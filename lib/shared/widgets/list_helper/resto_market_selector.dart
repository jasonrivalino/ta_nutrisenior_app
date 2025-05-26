import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ta_nutrisenior_app/shared/styles/colors.dart';

class RestoMarketSelectionToggle extends StatefulWidget {
  final int initialIndex;
  final String restoRoute;
  final String marketRoute;

  const RestoMarketSelectionToggle({
    super.key,
    this.initialIndex = 0,
    required this.restoRoute,
    required this.marketRoute,
  });

  @override
  _SelectionToggleState createState() => _SelectionToggleState();
}

class _SelectionToggleState extends State<RestoMarketSelectionToggle> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  void _onSelect(int index) {
    setState(() {
      selectedIndex = index;
    });

    final selectedRoute =
        index == 0 ? widget.restoRoute : widget.marketRoute;

    context.push(selectedRoute);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['Restoran', 'Pusat Belanja'];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double paddingVertical = (screenHeight * 0.045).clamp(20.0, 40.0);

    print('Screen Width: $screenWidth');
    print('Screen Height: $screenHeight');
    print('Padding Vertical: $paddingVertical');

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: (screenHeight * 0.045).clamp(
          20.0,
          screenHeight > 900 ? 40.0 : 25.0,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: screenWidth * 0.7,
          child: Row(
            children: List.generate(options.length, (index) {
              final isSelected = selectedIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onSelect(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.woodland : AppColors.soapstone,
                      border: Border.all(color: AppColors.woodland),
                      borderRadius: BorderRadius.horizontal(
                        left: Radius.circular(index == 0 ? 5 : 0),
                        right: Radius.circular(index == options.length - 1 ? 5 : 0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    child: Text(
                      options[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}