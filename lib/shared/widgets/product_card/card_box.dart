import 'package:flutter/material.dart';
import '../../styles/fonts.dart';

class CardBox extends StatefulWidget {
  final String image;
  final String name;
  final String type;
  final double? rate;
  final String? location;
  final int? percentage;

  const CardBox({
    super.key,
    required this.image,
    required this.name,
    required this.type,
    this.rate,
    this.location,
    this.percentage,
  });

  @override
  State<CardBox> createState() => _CardBoxState();
}

class _CardBoxState extends State<CardBox> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          elevation: 0, // Use shadow from AnimatedContainer instead
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  widget.image,
                  height: MediaQuery.of(context).size.height * 0.125,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.fontBold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      if (widget.type == 'recommend') ...[
                        Text('⭐ ${widget.rate?.toStringAsFixed(1) ?? "-"}'),
                        Text(widget.location ?? ""),
                      ] else if (widget.type == 'discount') ...[
                        Text('Diskon ${widget.percentage ?? 0}%'),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}