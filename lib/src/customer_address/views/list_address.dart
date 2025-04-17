// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/main.dart';
import 'package:shipping_address/src/customer_address/models/list_address_model.dart';
import 'package:shipping_address/src/customer_address/providers/customer_provider.dart';
import 'package:shipping_address/src/customer_address/views/manage_address.dart';

class ListAddress extends StatefulWidget {
  const ListAddress({super.key});

  @override
  State<ListAddress> createState() => _ListAddressState();
}

class _ListAddressState extends State<ListAddress> {
  int? _selectedIndex;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoadingProvider>(context, listen: false).show();

      Provider.of<CustomerProvider>(
        context,
        listen: false,
      ).loadAddressList().then((value) {
        Provider.of<LoadingProvider>(context, listen: false).hide();
      });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 45,
        title: Text(
          'Daftar Alamat',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        actionsPadding: EdgeInsets.only(right: 3),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.manageAddress);
            },
            icon: Icon(Icons.add),
          ),

          Consumer<CustomerProvider>(
            builder: (context, customerP, _) {
              return IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Konfirmasi'),
                        content: Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Tidak'),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Ya'),
                          ),
                        ],
                      );
                    },
                  ).then((value) async {
                    if (value == true) {
                      Provider.of<LoadingProvider>(
                        context,
                        listen: false,
                      ).show();
                      await customerP.fetchLogout(context).then((value) {
                        Provider.of<LoadingProvider>(
                          context,
                          listen: false,
                        ).hide();
                      });
                    } else {
                      return;
                    }
                  });
                },
                icon: Icon(Icons.logout_outlined),
              );
            },
          ),
        ],
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, customerP, _) {
          return ListView.separated(
            // controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              var currentIndex = customerP.listAddressModel[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: _cardList(
                  currentIndex,
                  isSelected: _selectedIndex == index,
                  isPrimary:
                      currentIndex.addressId == customerP.primaryAddressId,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 8);
            },
            itemCount: customerP.listAddressModel.length,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Consumer<CustomerProvider>(
          builder: (context, customerP, _) {
            return CustomButton.normalCustomButton(
              text: 'Jadikan Alamat Utama',
              onTap: () {
                if (_selectedIndex != null && _selectedIndex! >= 0) {
                  customerP.makeAddressPrimary(_selectedIndex!);
                  setState(() {
                    _selectedIndex = null;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Alamat berhasil dijadikan utama'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pilih alamat terlebih dahulu')),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _cardList(
    ListAddressModel address, {
    required bool isSelected,
    required bool isPrimary,
  }) {
    return Card(
      color:
          isSelected
              ? Colors.blue.shade50
              : isPrimary
              ? Colors.green.shade50
              : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        side:
            isSelected
                ? BorderSide(color: Colors.blue, width: 1.5)
                : isPrimary
                ? BorderSide(color: Colors.green.shade50, width: 1.5)
                : BorderSide(color: Colors.grey.shade100, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.home),
              title: Text(
                address.addressLabel ?? '-',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ManageAddress(
                                isEdit: true,
                                index: address.addressId,
                              ),
                        ),
                      );
                    },
                    child: Icon(Icons.edit_outlined),
                  ),
                  SizedBox(width: 12),
                  Consumer<CustomerProvider>(
                    builder: (context, customerP, _) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi'),
                                content: Text(
                                  'Apakah Anda yakin ingin menghapus alamat ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Tidak'),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Ya'),
                                  ),
                                ],
                              );
                            },
                          ).then((value) async {
                            if (value == true) {
                              Provider.of<LoadingProvider>(
                                context,
                                listen: false,
                              ).show();
                              await customerP
                                  .fetchDeleteAddress(
                                    context,
                                    address.addressId!,
                                  )
                                  .then((value) {
                                    Provider.of<LoadingProvider>(
                                      context,
                                      listen: false,
                                    ).hide();
                                  });
                            } else {
                              return;
                            }
                          });
                        },
                        child: Icon(Icons.delete_outline_outlined),
                      );
                    },
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person),
              title: Text(
                address.name ?? '-',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone),
              title: Text(
                address.phoneNumber ?? '-',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on),
              title: Text(
                address.addressMap ?? '-',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
