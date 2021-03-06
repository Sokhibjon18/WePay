import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:we_pay/application/product/product_actor/product_actor_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_pay/application/product/product_form/product_form_bloc.dart';
import 'package:we_pay/domain/models/product/product.dart';
import 'package:we_pay/presentation/screens/expense/custom_chart/chart_model.dart';
import 'package:we_pay/presentation/screens/expense/widgets/app_bar.dart';
import 'package:we_pay/presentation/screens/expense/widgets/product_bottom_sheet.dart';
import 'package:we_pay/presentation/screens/expense/widgets/product_item.dart';
import 'package:we_pay/presentation/screens/expense/widgets/total_expenses.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key, required this.apartmentName}) : super(key: key);

  final String apartmentName;

  @override
  State<ExpensePage> createState() => ExpensePageState();
}

class ExpensePageState extends State<ExpensePage> {
  late final width = MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: expencePageAppBar(context, widget.apartmentName),
      body: BlocListener<ProductFormBloc, ProductFormState>(
        listener: (context, state) {
          state.editOption.fold(
            () => null,
            (a) => a.fold(
              (f) {
                String errorMessage = '';
                errorMessage = f.maybeMap(
                  wrongOwner: (value) => value.errorMessage,
                  orElse: () => '',
                );
                if (errorMessage.isNotEmpty) {
                  FlushbarHelper.createInformation(message: errorMessage).show(context);
                }
              },
              (r) {
                productBottomsheet(
                  context.findAncestorStateOfType<ExpensePageState>()!.context,
                  product: r,
                );
              },
            ),
          );
          state.deleteOption.fold(
            () => null,
            (a) => a.fold(
              (f) {
                String errorMessage = '';
                errorMessage = f.maybeMap(
                  wrongOwner: (value) => value.errorMessage,
                  orElse: () => '',
                );
                if (errorMessage.isNotEmpty) {
                  FlushbarHelper.createInformation(message: errorMessage).show(context);
                }
              },
              (r) => null,
            ),
          );
        },
        child: BlocBuilder<ProductActorBloc, ProductActorState>(
          builder: (context, state) {
            return state.maybeMap(
              loadFailure: (loadFailure) => loadFailureWidget(loadFailure),
              loadSuccess: (loadSuccess) => loadSuccessWidget(loadSuccess.productList),
              emptyList: (_) => emptyListWidget(),
              orElse: () => Container(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.read<ProductFormBloc>().add(const ProductFormEvent.initial());
          productBottomsheet(context);
        },
      ),
    );
  }

  Widget emptyListWidget() => const Center(
        child: Text(
          'You don`t have any expences\nfor this month!',
          textAlign: TextAlign.center,
        ),
      );

  Widget loadSuccessWidget(List<Product> products) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              TotalExpenses(products),
              Container(
                height: width * 0.7,
                padding: EdgeInsets.only(top: width * 0.45),
                alignment: Alignment.topCenter,
                width: width,
                child: Align(
                  alignment: Alignment.center,
                  child: Wrap(children: getModelWidget(products)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ProductItem(product: products[index]),
              separatorBuilder: (_, index) {
                return Container(
                  height: 0.5,
                  color: Colors.grey[300],
                );
              },
              itemCount: products.length,
            ),
          )
        ],
      ),
    );
  }

  Widget loadFailureWidget(loadFailure) {
    String errorMessage = loadFailure.failure.map(
      server: (_) => 'Server error',
      permissionDenied: (_) => 'Permission denied',
      unexpected: (v) => v.errorMessage,
    );
    return Center(child: Text(errorMessage));
  }

  List<Widget> getModelWidget(List<Product> products) {
    List<Widget> usersList = [];
    for (ChartModel chartModel in getChartModulsOfUsers(products)) {
      final userWidget = Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Column(
          children: [
            Text(
              chartModel.name,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 2),
            Container(
              decoration: BoxDecoration(
                color: chartModel.color,
                borderRadius: BorderRadius.circular(8),
              ),
              width: MediaQuery.of(context).size.width * 0.2,
              height: 5,
            )
          ],
        ),
      );
      usersList.add(userWidget);
    }
    return usersList;
  }
}
