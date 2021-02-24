import 'package:fitness/repository/trainee_repository.dart';
import 'package:fitness/states/authentication_notifier.dart';
import 'package:fitness/states/subscription_notifier.dart';
import 'package:fitness/states/trainers_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'model/Trainee.dart';

final traineeRepoProvider =Provider<TraineeRepository>((ref)=>FbTraineeRepository());
final subscriptionNotifierProvider = StateNotifierProvider((ref)=>SubscriptionsNotifier(ref.watch(traineeRepoProvider)));
final authenticationNotifierProvider = StateNotifierProvider((ref)=>AuthenticationNotifier(ref.watch(traineeRepoProvider)));
final trainersNotifierProvider = StateNotifierProvider((ref)=>TrainersNotifier(ref.watch(traineeRepoProvider)));

//////////////////

class ChatSelectionNotifier extends ChangeNotifier{

  double messageBox_width=0;
  double messageBox_height=0;
  int duration=0;

  show_messages(BuildContext context){
    messageBox_width=MediaQuery.of(context).size.width-30;
    messageBox_height=MediaQuery.of(context).size.height/1.9;
    duration=3;
    notifyListeners();
  }

  hide_messages(BuildContext context){
    messageBox_width=0;
    messageBox_height=0;
    duration=0;
    notifyListeners();
  }
}

final ChatSelectionProvider =ChangeNotifierProvider((ref) => ChatSelectionNotifier());

////////////////////////
class TraineeData with ChangeNotifier {
  Trainee trainee;

  void set_trainee(Trainee t) => trainee=t;
}


final TraineeDataProvider =ChangeNotifierProvider((ref) => TraineeData());