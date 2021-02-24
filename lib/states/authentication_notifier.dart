import 'package:fitness/model/Trainee.dart';
import 'package:fitness/model/subscription.dart';
import 'package:fitness/repository/trainee_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthernticationState{
  const AuthernticationState();
}

class AuthenticationInitial extends AuthernticationState{
  const AuthenticationInitial();
}

class  AuthenticationLoading extends AuthernticationState{
  const AuthenticationLoading();
}

class AuthenticationLoaded extends AuthernticationState{
  final Trainee trainee;
  const AuthenticationLoaded(this.trainee);
}

class  AuthenticationError extends AuthernticationState{
  final String message;
  const AuthenticationError(this.message);

  @override
  int get hashCode => message.hashCode;
}

class AuthenticationNotifier extends StateNotifier<AuthernticationState>{
  final TraineeRepository traineeRepository;
  AuthenticationNotifier(this.traineeRepository) : super(AuthenticationInitial());

  Future<void> authenticate_trainee(String id) async{
    try{
      state=AuthenticationLoading();
      final result=await traineeRepository.get_trainee(id);
      state=AuthenticationLoaded(result);
    } on NetworkImageLoadException{
      state=AuthenticationError("error");
    }
  }
}

