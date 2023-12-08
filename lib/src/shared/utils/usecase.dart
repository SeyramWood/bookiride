import 'package:dartz/dartz.dart';
import '../errors/failure.dart';

abstract class UseCase<Type, P> {
  Future<Either<Failure, Type>> call(P params);
}

class Param<T> {
  final T data;

  Param(this.data);
}

class NoParams {
  NoParams();
}

class MultiParams<T1, T2, T3> {
  final T1 data1;
  final T2 data2;
  T3? data3;

  MultiParams(this.data1, this.data2, {this.data3});
}
