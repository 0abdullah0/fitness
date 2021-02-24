import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/constants.dart';
import 'package:fitness/model/Message.dart';
import 'package:fitness/providers.dart';
import 'package:fitness/states/trainers_notifier.dart';
import 'package:fitness/widgets/Loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_anywhere_menus/flutter_anywhere_menus.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{

  String selectedName="";
  String selectedPhoto="";
  String selectedId="";
  bool showMessages;
  int lastMessageIndex;
  final _textController = TextEditingController();
  final _controller = ScrollController();
  ScrollPhysics disableScrolling=NeverScrollableScrollPhysics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showMessages=false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read(trainersNotifierProvider).fetch_trainers(context.read(TraineeDataProvider).trainee.trainersList);
          });
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset:false,
      body: ListView(
        shrinkWrap: true,
        physics:ScrollPhysics(),
        children: [
          Container(
              decoration: BoxDecoration(
                gradient: Constants.backgroundColor,
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ProviderListener(
                provider: trainersNotifierProvider.state,
                onChange: (context,state){
                  if(state is TrainersError)
                  {
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: Consumer(
                  builder: (context,watch,child){
                    final selectionProvider=watch(ChatSelectionProvider);
                    final state=watch(trainersNotifierProvider.state);
                    final traineeDataProvider=watch(TraineeDataProvider);
                    if(state is TrainersLoading)
                      return Center(child: ColorLoader());
                    if(state is TrainersLoaded)
                      return SafeArea(
                        child: Column(
                          children: [
                            SizedBox(height: 10.0,),
                            Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width-20 ,
                                  height: MediaQuery.of(context).size.height/7,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all( Radius.circular(40)),
                                      color: Colors.black54,
                                      boxShadow: [BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      )]
                                  ),
                                  child: ListView.builder(
                                      itemCount: state.trainers.length,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index) {
                                        return InkWell(
                                          onTap:() async{
                                            selectionProvider.hide_messages(context);
                                            selectedName ="${state.trainers[index].name}";
                                            selectedPhoto="assets/images/avatar.png";
                                            selectedId="${state.trainers[index].id}";
                                            showMessages=true;
                                            await Future.delayed(const Duration(seconds: 1), (){
                                              selectionProvider.show_messages(context);
                                              _controller
                                                  .jumpTo(_controller.position.maxScrollExtent);
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Badge(
                                                      child: CircleAvatar(
                                                        backgroundColor: Colors.grey[300],
                                                        backgroundImage: ExactAssetImage("assets/images/avatar.png"),
                                                        radius: 25.0,//radius of the circle avatar
                                                      ),
                                                      badgeColor: Colors.green,
                                                      position: BadgePosition.topEnd(end: 7,top: -3),
                                                    ),
                                                    SizedBox(height: 5.0,),
                                                    Text("${state.trainers[index].name}",style: TextStyle(color: Colors.white),softWrap: true,)
                                                  ],
                                                ),
                                                SizedBox(width: 5.0,),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                            ),
                            SizedBox(height: 10.0,),
                            Visibility(
                              visible: showMessages,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Badge(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: ExactAssetImage("assets/images/avatar.png"),
                                      radius: 25.0,//radius of the circle avatar
                                    ),
                                    badgeColor: Colors.green,
                                    position: BadgePosition.topEnd(end: 7,top: -3),
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("${selectedName}",style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: showMessages,
                                    child: AnimatedContainer(
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.only(topRight:  Radius.circular(40),bottomLeft:Radius.circular(40) ),
                                      ),
                                      curve: Curves.bounceOut,
                                      height: selectionProvider.messageBox_height,
                                      width: selectionProvider.messageBox_width,
                                      duration: Duration(seconds: selectionProvider.duration),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance.collection("Messages").
                                            doc(traineeDataProvider.trainee.id+"+"+selectedId).collection("Chat").orderBy("time",descending: false).
                                            limit(25).snapshots(),
                                            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshots){
                                              if(!snapshots.hasData)
                                                return Center(child: Text("You can chat with ${selectedName} now"),);
                                              else
                                                return Expanded(
                                                  flex: 4,
                                                  child: ListView.builder(
                                                    controller: _controller,
                                                    shrinkWrap: true,
                                                    physics: ScrollPhysics(),
                                                    itemBuilder: (context,index){
                                                      lastMessageIndex=snapshots.data.docs.length;
                                                      return Row(
                                                        mainAxisAlignment:snapshots.data.docs[index].data()["Sender_id"]==traineeDataProvider.trainee.id?MainAxisAlignment.start:MainAxisAlignment.end,
                                                        children: [
                                                          Flexible(
                                                            child: ChatBubble(
                                                              clipper: ChatBubbleClipper1(type:snapshots.data.docs[index].data()["Sender_id"]==traineeDataProvider.trainee.id?BubbleType.receiverBubble:BubbleType.sendBubble),
                                                              alignment:snapshots.data.docs[index].data()["Sender_id"]==traineeDataProvider.trainee.id?Alignment.bottomLeft:Alignment.bottomRight,
                                                              margin: EdgeInsets.fromLTRB(0, 15, 5,0),
                                                              backGroundColor: snapshots.data.docs[index].data()["Sender_id"]==traineeDataProvider.trainee.id?Colors.blue:Colors.orangeAccent,
                                                              child: Container(
                                                                constraints: BoxConstraints(
                                                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                                                ),
                                                                child: Text(
                                                                  "${snapshots.data.docs[index].data()["Message"]} \n ${snapshots.data.docs[index].data()["time"].toDate().toString()}",
                                                                  style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: Visibility(
                                                              visible:snapshots.data.docs[index].data()["Sender_id"]==traineeDataProvider.trainee.id,
                                                              child: Menu(
                                                                child: MaterialButton(
                                                                  child: Text('...',style: TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold),),
                                                                ),
                                                                menuBar: MenuBar(
                                                                  drawArrow: true,
                                                                  itemPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                                                  menuItems: [
                                                                    MenuItem(
                                                                      child: Icon(Icons.delete, color: Colors.grey[600]),
                                                                      onTap: () {},
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                    itemCount: snapshots.data.docs.length,
                                                  ),
                                                );
                                            },
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextField(
                                                style: TextStyle(color: Colors.white),
                                                controller: _textController,
                                                decoration: InputDecoration(
                                                    hintStyle: TextStyle(color: Colors.white),
                                                    hintText: "type somthing here...",
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0,
                                                        )
                                                    ),
                                                    enabledBorder: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 0,
                                                        )),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(30),
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 3,
                                                        )),
                                                    suffixIcon: InkWell(
                                                      child: Icon(Icons.send,size: 25,color: Colors.blue,),
                                                      onTap: (){
                                                        String chatId=traineeDataProvider.trainee.id+"+"+selectedId;
                                                        Message message=Message(_textController.text,Timestamp.now(),traineeDataProvider.trainee.id);
                                                        if(_textController.text.isNotEmpty)
                                                        {
                                                          context.read(traineeRepoProvider).send_message(message,chatId);
                                                          _textController.clear();
                                                          Timer(
                                                              Duration(milliseconds: 100),
                                                                  () => _controller
                                                                  .jumpTo(_controller.position.maxScrollExtent));
                                                        }
                                                      },
                                                    )
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    return ColorLoader();
                  },
                ),
              )
          ),
        ],
      )
    );
  }
}
