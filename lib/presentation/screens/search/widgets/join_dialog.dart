import 'package:flutter/material.dart';
import 'package:we_pay/application/request/request_bloc.dart';
import 'package:we_pay/domain/models/apartment/apartment.dart';
import 'package:we_pay/presentation/constants/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinDialog extends StatelessWidget {
  const JoinDialog({Key? key, required this.apartment}) : super(key: key);

  final Apartment apartment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.hardEdge,
        child: Container(
          color: white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                color: green,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Join request',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: Text(
                  '${apartment.region}, ${apartment.district}, ${apartment.street}, ${apartment.houseNumber}${apartment.flatNumber.isEmpty ? '' : ', ${apartment.flatNumber}'}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const SizedBox(
                        height: 40,
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      height: 32,
                      alignment: Alignment.topCenter,
                      width: 1,
                      color: Colors.grey[300]),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<RequestBloc>().add(RequestEvent.sendJoinRequest(apartment));
                      },
                      child: const SizedBox(
                        height: 40,
                        child: Text(
                          'Send',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
