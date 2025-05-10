import 'package:fpdart/fpdart.dart';
import 'package:pinterest_clone/core/failure.dart';

typedef EitherUser<T> = Future<Either<Failure, T>>;
