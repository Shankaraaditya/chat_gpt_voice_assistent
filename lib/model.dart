enum MessegeType { user, bot }

class Messege {
  Messege({required this.text, required this.type});

  String? text;
  MessegeType? type;
}
