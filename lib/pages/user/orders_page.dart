import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/user/order_detail_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(
        title: getTranslated(context, StringKeys.orders),
        leadingIcon: Icons.arrow_back_ios_rounded,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: userRepository.orderList.map((order) {
            // DateTime dateTime = DateFormat("dd.MM.yyyy HH:mm").parse(order.time.toString());
            DateTime dateTime = DateTime.parse(order.time.toString());
            String newFormat = DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
            return ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(newFormat),
              trailing: const Padding(
                padding: EdgeInsets.zero,
                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
              ),
              onTap: () {
                userRepository.selectedOrder = order;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrderDetailPage(),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
