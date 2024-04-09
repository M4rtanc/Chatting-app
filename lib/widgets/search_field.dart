import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {

  final ValueChanged<String> onChanged;
  final String text;
  final String hintText;

  const SearchField({super.key, required this.onChanged, this.text = "", this.hintText = ""});

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              _searchController.clear();
              widget.onChanged("");
            });
          },
        ) : null,
      ),
    );
  }
}
