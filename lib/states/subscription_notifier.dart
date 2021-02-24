import 'package:fitness/model/subscription.dart';
import 'package:fitness/repository/trainee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class SubscriptionsState{
  const SubscriptionsState();
}

class SubscriptionsInitial extends SubscriptionsState{
  const SubscriptionsInitial();
}

class  SubscriptionsLoading extends SubscriptionsState{
  const SubscriptionsLoading();
}

class SubscriptionsLoaded extends SubscriptionsState{
  final List<Subscription> subscriptions;
  const SubscriptionsLoaded(this.subscriptions);
}

class  SubscriptionsError extends SubscriptionsState{
  final String message;
  const SubscriptionsError(this.message);

  @override
  int get hashCode => message.hashCode;
}

class SubscriptionsNotifier extends StateNotifier<SubscriptionsState>{
  final TraineeRepository traineeRepository;
  SubscriptionsNotifier(this.traineeRepository) : super(SubscriptionsInitial());

  Future<void> fetch_subscriptions() async{
    try{
      state=SubscriptionsLoading();
      final result=await traineeRepository.get_all_subscriptions();
      state=SubscriptionsLoaded(result);
    } on NetworkImageLoadException{
      state=SubscriptionsError("error");
    }
  }
}

