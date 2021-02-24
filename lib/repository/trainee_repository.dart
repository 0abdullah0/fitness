import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/model/Message.dart';
import 'package:fitness/model/Trainee.dart';
import 'package:fitness/model/Trainer.dart';
import 'package:fitness/model/subscription.dart';

abstract class TraineeRepository {
  Future<List<Subscription>> get_all_subscriptions();
  Future<Trainee> get_trainee(String id);
  Future<List<Trainer>> get_trainers(List trainersIds);
  Future<void> send_message(Message message,String chatId);
}

class FbTraineeRepository implements TraineeRepository {
  @override
  Future<List<Subscription>> get_all_subscriptions() async{
    // TODO: implement get_all_subscriptions
    List<Subscription> all_subscriptions=[];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Subscription").get();
    var list_of_subscription = querySnapshot.docs;

    list_of_subscription.forEach((document) {
      all_subscriptions.add(Subscription(
        document.data()["Duration"],document.data()["Freezed_availbilty"],
          document.data()["Offer_description"],document.data()["Price"],
          document.data()["Subscription_description"],document.data()["hasOffer"]
      ));
    });
    return all_subscriptions;
  }

  @override
  Future<Trainee> get_trainee(String id) async{
    // TODO: implement authenticate_trainee
    Trainee trainee;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Trainee").doc(id).get();
    if(documentSnapshot.exists)
      trainee=Trainee(documentSnapshot.id,documentSnapshot.data()["Name"],documentSnapshot.data()["Gender"],
          documentSnapshot.data()["Region"],documentSnapshot.data()["isAttened"],
          documentSnapshot.data()["Photo_url"], documentSnapshot.data()["isFreezed"],
          documentSnapshot.data()["Age"], documentSnapshot.data()["Phone"],documentSnapshot.data()["TrainersList"]);
    else
      trainee=Trainee("","", "", "", false,"", false, 0, 0,[]);
    return trainee;
  }

  @override
  Future<List<Trainer>> get_trainers(List trainersIds) async{
    // TODO: implement get_trainers
    List<Trainer> trainers=[];
    for(int index=0;index<trainersIds.length;++index){
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Trainer").doc(trainersIds[index]).get();
      trainers.add(Trainer(documentSnapshot.id,documentSnapshot.data()["Name"],documentSnapshot.data()["Photo_url"]
          ,documentSnapshot.data()["Gender"], documentSnapshot.data()["Phone"]));
    }
    return trainers;
  }

  @override
  Future<void> send_message(Message message,String chatId) async{
    // TODO: implement send_message
    DocumentReference doc = FirebaseFirestore.instance.collection("Messages").
    doc(chatId).collection("Chat").doc();
    await doc.set({
      "Message":message.message_text,
      "Sender_id": message.sender_id,
      "time":message.timestamp
    }).then((value) => print("Message Added"));
  }

}

