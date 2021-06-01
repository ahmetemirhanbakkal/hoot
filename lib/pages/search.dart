import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/assets/constants.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirestoreService _firestore = FirestoreService.getInstance();
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  List<HootUser> _users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light
          .copyWith(systemNavigationBarColor: primaryColor),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (_searchQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _clearSearchQuery(),
              ),
          ],
          title: _buildSearchField(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(4),
            child: _isSearching ? LinearProgressIndicator() : Container(),
          ),
        ),
        body: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: EdgeInsets.all(4),
      child: ListView.separated(
        itemBuilder: (context, index) => _buildListItem(context, index),
        separatorBuilder: (context, index) => SizedBox(height: 4),
        itemCount: _users.length,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    HootUser user = _users[index];
    RoundedRectangleBorder roundedRectangleBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(largeRadius),
    );
    return Card(
      shape: roundedRectangleBorder,
      child: InkWell(
        customBorder: roundedRectangleBorder,
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(smallPadding),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: smallPadding),
                  child: Text(
                    user.username,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.person_add,
                  color: secondaryColor,
                ),
                onPressed: () {},
                tooltip: 'Add friend',
              ),
            ],
          ),
        ),
      ),
      color: primaryColorLight,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search user...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => _updateSearchQuery(query),
    );
  }

  void _startSearch() async {
    setState(() => _isSearching = true);
    dynamic result =
        await _firestore.searchUsers(_searchQuery.trim().toLowerCase());
    if (result is List<HootUser>) {
      _users = result;
    }
    setState(() => _isSearching = false);
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      _updateSearchQuery('');
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() => _searchQuery = newQuery);
    _startSearch();
  }
}
