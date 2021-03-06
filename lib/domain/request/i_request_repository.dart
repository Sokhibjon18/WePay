import 'package:dartz/dartz.dart';
import 'package:we_pay/domain/models/request/request.dart';
import 'package:we_pay/domain/request/request_failure.dart';

abstract class IRequestRepository {
  Future<Either<RequestFailure, RequestOperations>> sendRequestToJoin(String apartmentId);
  Future<Either<RequestFailure, RequestOperations>> acceptRequest(RequestToJoin request);
  Future<Either<RequestFailure, RequestOperations>> rejectRequest(String requestId);
}
