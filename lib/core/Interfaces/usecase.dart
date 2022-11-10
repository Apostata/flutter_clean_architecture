import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture/core/utils/errors/failure.dart';

abstract class IUseCase<Output, Input> {
  Future<Either<Failure, Output>> call(Input params);
}
