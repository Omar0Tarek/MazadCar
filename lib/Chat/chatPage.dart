import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Models/chat.dart';
import 'package:mazadcar/Models/message.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Widgets/showMessage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatPage extends StatefulWidget {
  final UserModel targetuser;
  final Chat chat;

  const ChatPage({
    Key? key,
    required this.targetuser,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _focusNode = FocusNode();

  XFile? imagefile;

  focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListener);
    super.dispose();
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "Upload Image",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    imageSelect(ImageSource.gallery);
                  },
                  leading: Icon(
                    Icons.photo_album,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Gallery",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  onTap: () {
                    // Navigator.pop(context);
                    // await availableCameras().then((value) => Navigator.push(
                    //         context, MaterialPageRoute(builder: (context) {
                    //       return CameraPage(
                    //         cameras: value,
                    //         chatroom: widget.chatroom,
                    //         currentuser: widget.currentuser,
                    //         targetuser: widget.targetuser,
                    //       );
                    //     })));
                  },
                  leading: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Camera",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void imageSelect(ImageSource source) async {
    XFile? pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      cropImage(pickedimage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
    ));

    // if (cropedImage != null) {
    //   setState(() {
    //     imagefile = XFile(cropedImage.path);
    //   });
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => PreviewImage(
    //                 picture: imagefile,
    //                 chat: widget.chat.id,
    //                 currentuser: widget.currentuser,
    //                 targetuser: widget.targetuser,
    //               )));
    // }
  }

  TextEditingController msgcontroller = TextEditingController();

  void sendmessage() async {
    String message = msgcontroller.text.trim();
    msgcontroller.clear();
    if (message != "") {
      Message newMessage = Message(
        id: Uuid().v1(),
        content: message,
        senderID: FirebaseAuth.instance.currentUser!.uid,
        senderName: FirebaseAuth.instance.currentUser!.displayName!,
        timeStamp: DateTime.now(),
      );

      Map<String, dynamic> mess = {
        "content": newMessage.content,
        "senderID": newMessage.senderID,
        "senderName": newMessage.senderName,
        "timeStamp": newMessage.timeStamp
      };

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chat.id)
          .collection("messages")
          .doc(newMessage.id)
          .set(mess);

      widget.chat.lastMessageDate = DateTime.now();
      widget.chat.lastMessage = message;

      await FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chat.id)
          .set({
        "sellerID": widget.chat.sellerID,
        "buyerID": widget.chat.buyerID,
        "adID": widget.chat.adID,
        "lastMessage": widget.chat.lastMessage,
        "lastMessageDate": widget.chat.lastMessageDate,
        "adName": widget.chat.adName,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          toolbarHeight: 70,
          elevation: 5,
          scrolledUnderElevation: 5,
          backgroundColor: Color(0xffFFFFFF),
          automaticallyImplyLeading: true,
          leading: BackButton(color: Colors.black),
          title: SizedBox(
            width: 290,
            height: 59,
            child: Row(
              children: [
                SizedBox(
                  width: 65,
                  height: 70,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(widget.targetuser.profilepic.toString()),
                    //  child: Image.network(widget.image!),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.targetuser.name.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // actions: [
          //   Row(
          //     children: [
          //       Image.asset(
          //         'assets/images/video.png',
          //         height: 35,
          //         width: 35,
          //       ),
          //       const SizedBox(
          //         width: 6,
          //       ),
          //       Image.asset(
          //         'assets/images/more.png',
          //         height: 35,
          //         width: 35,
          //       ),
          //     ],
          //   ),
          // ],
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: ShowMessages(
                    chatroom: widget.chat,
                    targetuser: widget.targetuser,
                  ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20, left: 20),
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color(0xffF3F3F3),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xffDBDBDB),
                            blurRadius: 15,
                            spreadRadius: 1.5,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardAppearance: Brightness.dark,
                        //textInputAction: TextInputAction.continueAction,
                        controller: msgcontroller,
                        maxLines: 35,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Message...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            color: Color(0xffB5B4B4),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 19,
                            left: 20,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 10, right: 10),
                            child: GestureDetector(
                              onTap: () {
                                EmojiPicker();
                              },
                              child: Image.asset(
                                "assets/images/smile.png",
                                color: Colors.black,
                                height: 27,
                                width: 27,
                              ),
                            ),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 3, right: 15),
                            child: InkWell(
                              onTap: () {
                                showPhotoOptions();
                              },
                              child: Image.asset(
                                "assets/images/camera.png",
                                height: 27,
                                width: 27,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        right: 0,
                        left: 10,
                      ),
                      child: FloatingActionButton(
                        elevation: 15,
                        onPressed: () {},
                        child: ElevatedButton(
                          onPressed: () {
                            sendmessage();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xffFFFFFF),
                            backgroundColor: Color(0xff2865DC),
                            shape: CircleBorder(),
                            disabledForegroundColor:
                                Color(0xff2865DC).withOpacity(0.38),
                            disabledBackgroundColor:
                                Color(0xff2865DC).withOpacity(0.12),
                            padding: EdgeInsets.all(10),
                          ),
                          child: Image.asset(
                            "assets/images/send1.png",
                            color: Colors.white,
                            height: 36,
                            width: 27,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
