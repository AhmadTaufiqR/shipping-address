import 'package:flutter/material.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';

class ListAddress extends StatefulWidget {
  ListAddress({super.key});

  @override
  State<ListAddress> createState() => _ListAddressState();
}

class _ListAddressState extends State<ListAddress> {
  int? _selectedIndex;
  List<int> _alamatList = List.generate(20, (index) => index);

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
        actionsPadding: EdgeInsets.symmetric(horizontal: 5),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.manageAddress);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          int currentIndex = _alamatList[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = currentIndex;
              });
            },
            child: _cardList(currentIndex),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 12);
        },
        itemCount: _alamatList.length,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
        child: CustomButton.normalCustomButton(
          text: 'Jadikan Alamat Utama',
          onTap: () {
            if (_selectedIndex != null) {
              setState(() {
                _alamatList.remove(_selectedIndex);
                _alamatList.insert(0, _selectedIndex!);
                _selectedIndex = _alamatList.first;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _cardList(int index) {
    final isSelected = index == _selectedIndex;
    return Card(
      color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        side:
            isSelected
                ? BorderSide(color: Colors.blue, width: 1.5)
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
                'Rumah Siapa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: () {}, child: Icon(Icons.edit)),
                  SizedBox(width: 12),
                  GestureDetector(onTap: () {}, child: Icon(Icons.delete)),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person),
              title: Text(
                'Steven',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.phone),
              title: Text(
                '1234567890',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            Divider(color: Colors.grey.shade300),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on),
              title: Text(
                'Jl. Jogja',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
