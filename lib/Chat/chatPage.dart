import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mazadcar/Chat/cameraPage.dart';
import 'package:mazadcar/Chat/targetAD.dart';
import 'package:mazadcar/Chat/targetuserInfo.dart';
import 'package:mazadcar/Models/car.dart';
import 'package:mazadcar/Models/chat.dart';
import 'package:mazadcar/Models/message.dart';
import 'package:mazadcar/Models/userModel.dart';
import 'package:mazadcar/Widgets/previewImage.dart';
import 'package:mazadcar/Widgets/showMessage.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class ChatPage extends StatefulWidget {
  final UserModel targetuser;
  final UserModel currentUser;
  final Chat chat;
  final Car ad;

  const ChatPage(
      {Key? key,
      required this.targetuser,
      required this.chat,
      required this.currentUser,
      required this.ad});

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
                  onTap: () async {
                    Navigator.pop(context);
                    await availableCameras().then((value) => Navigator.push(
                            context, MaterialPageRoute(builder: (context) {
                          return CameraPage(
                            cameras: value,
                            chatroom: widget.chat,
                            currentuser: widget.currentUser,
                            targetuser: widget.targetuser,
                            ad: widget.ad,
                          );
                        })));
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

    if (cropedImage != null) {
      setState(() {
        imagefile = XFile(cropedImage.path);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PreviewImage(
                  picture: imagefile,
                  chatroom: widget.chat,
                  currentuser: widget.currentUser,
                  targetuser: widget.targetuser,
                  ad: widget.ad)));
    }
  }

  TextEditingController msgcontroller = TextEditingController();

  void sendmessage() async {
    String message = msgcontroller.text.trim();
    msgcontroller.clear();
    print(message);
    if (message != "") {
      Message newMessage = Message(
        id: const Uuid().v1(),
        content: message,
        senderID: FirebaseAuth.instance.currentUser!.uid,
        senderName: widget.currentUser.name,
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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) {
                        return FirebaseAuth.instance.currentUser!.uid ==
                                widget.ad.sellerId
                            ? TargetUser(
                                targetUser: widget.targetuser, ad: widget.ad)
                            : TargetAD(targetAD: widget.ad);
                      }),
                    ),
                  );
                },
                icon: Icon(
                  Icons.info,
                  color: Colors.black,
                ))
          ],
          shape: Border(bottom: BorderSide(color: Colors.black, width: 1)),
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
                  width: 45,
                  height: 70,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: FirebaseAuth.instance.currentUser!.uid ==
                            widget.ad.sellerId
                        ? NetworkImage(widget.targetuser.profilepic.toString())
                        : NetworkImage(
                            jsonDecode(widget.ad.imageURL)[0].toString()),
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
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.ad.sellerId
                          ? widget.targetuser.name.toString()
                          : widget.ad.make +
                              " " +
                              widget.ad.model +
                              " " +
                              widget.ad.year,
                      style: GoogleFonts.inter(
                        fontSize: 17,
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
                        autofocus: true,
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
                          // suffixIcon: Padding(
                          //   padding: const EdgeInsets.only(
                          //       top: 0, left: 3, right: 15),
                          //   child: InkWell(
                          //       onTap: () {
                          //         showPhotoOptions();
                          //       },
                          //       child: Icon(Icons.attach_file_sharp)),
                          // ),
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
                            print("yes");
                            sendmessage();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0xffFFFFFF),
                            backgroundColor: Colors.black,
                            shape: CircleBorder(),
                            disabledForegroundColor:
                                Colors.black.withOpacity(0.38),
                            disabledBackgroundColor:
                                Colors.black.withOpacity(0.12),
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
