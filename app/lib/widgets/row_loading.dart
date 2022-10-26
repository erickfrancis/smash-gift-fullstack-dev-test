import 'package:flutter/material.dart';

class RowLoading extends StatelessWidget {
  final String? title;
  final double? padding;

  const RowLoading({Key? key, this.title, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title ?? 'Carregando'),
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
