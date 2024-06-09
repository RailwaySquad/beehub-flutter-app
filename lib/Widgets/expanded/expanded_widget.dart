import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:flutter/material.dart';

class ExpandedWidget extends StatefulWidget {
  final String text;
  const ExpandedWidget({super.key, required this.text});

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}
class _ExpandedWidgetState extends State<ExpandedWidget> {
  late String firstHalf;
  late String secondHalf;
  bool flag = true;
  @override
  void initState(){
    super.initState();
    if(widget.text.length>123){
      firstHalf =widget.text.substring(0,123);
      secondHalf =widget.text.substring(124,widget.text.length);
    }else{
      firstHalf = widget.text;
      secondHalf = "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
      ?Text(widget.text)
      :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( 
            flag? firstHalf
            :widget.text
            ),
          const SizedBox(height: 5,),
          InkWell(
            onTap: (){
              setState(() {
                flag = !flag;
              });
            },
            child: const Row(
            children: [
              Text("Show more", style: TextStyle(color: TColors.textSecondary),),
              Icon(Icons.keyboard_arrow_down,color: TColors.textSecondary,)
            ],
          ),
          )
        ],
      )
    );
  }
}