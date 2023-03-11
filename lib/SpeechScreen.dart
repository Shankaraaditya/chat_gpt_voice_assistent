import 'package:chat_gpt/api_services.dart';
import 'package:chat_gpt/colors.dart';
import 'package:chat_gpt/model.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  SpeechToText speechToText = SpeechToText();
  var text =
      "Ready to record sir";
  var isListening = false;

  final List<Messege> messege = [];

  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(microseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        glowColor: Colors.red,
        repeat: true,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (details) async {
            var available = await speechToText.initialize();
            if (available) {
              setState(() {
                isListening = true;
                speechToText.listen(onResult: (result) {
                  setState(() {
                    text = result.recognizedWords;
                  });
                });
              });
            }
          },
          onTapUp: (details) async {
            setState(() {
              isListening = false;
            });
            speechToText.stop();

            messege.add(Messege(text: text, type: MessegeType.user));

            var msg = await ApiServices.sendMessege(text);

            setState(() {
              messege.add(
                  Messege(text: msg , type: MessegeType.bot));
            });
          },
          child: CircleAvatar(
            backgroundColor: isListening ? Colors.red : bgColor,
            radius: 35,
            child: const Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('Shankaraditya'),
        centerTitle: true,
        backgroundColor: bgColor,
      ),
      body:
          // SingleChildScrollView(
          //   // reverse: true,
          //   // physics: const BouncingScrollPhysics(),
          // child:
          Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 51, 57, 51),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: ListView.builder(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: messege.length,
                      itemBuilder: (BuildContext context, int index) {
                        var chat = messege[index];
              
                        return ChatBox(chattext: chat.text, type: chat.type);
                      }),
                ),
              ),
            )
          ],
        ),
      ),
      // ),
    );
  }
}

Widget ChatBox({required chattext, required MessegeType? type}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       CircleAvatar(
        backgroundColor:(type== MessegeType.bot)? Colors.purple: bgColor,
        child:(type== MessegeType.bot)? const Icon(Icons.computer,color: Colors.white,) : const Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      const SizedBox(
        width: 12,
      ),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child:  Text(
            "$chattext",
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ],
  );
}
