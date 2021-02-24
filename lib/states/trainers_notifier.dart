import 'package:fitness/model/Trainer.dart';
import 'package:fitness/model/subscription.dart';
import 'package:fitness/repository/trainee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TrainersState{
  const TrainersState();
}

class TarinersInitial extends TrainersState{
  const TarinersInitial();
}

class  TrainersLoading extends TrainersState{
  const TrainersLoading();
}

class TrainersLoaded extends TrainersState{
  final List<Trainer> trainers;
  const TrainersLoaded(this.trainers);
}

class  TrainersError extends TrainersState{
  final String message;
  const TrainersError(this.message);

  @override
  int get hashCode => message.hashCode;
}

class TrainersNotifier extends StateNotifier<TrainersState>{
  final TraineeRepository traineeRepository;
  TrainersNotifier(this.traineeRepository) : super(TarinersInitial());

  Future<void> fetch_trainers(List trainersIds) async{
    try{
      state=TrainersLoading();
      final result=await traineeRepository.get_trainers(trainersIds);
      state=TrainersLoaded(result);
    } on NetworkImageLoadException{
      state=TrainersError("error");
    }
  }
}

