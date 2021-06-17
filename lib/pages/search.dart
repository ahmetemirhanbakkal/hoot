import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoot/assets/colors.dart';
import 'package:hoot/models/hoot_user.dart';
import 'package:hoot/services/firestore.dart';
import 'package:hoot/views/user_list.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirestoreService _firestore = FirestoreService.getInstance();
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  HootUser _loggedUser;
  List<HootUser> _users = [];

  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context).settings.arguments;
    _loggedUser = args['user'];

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
            preferredSize: Size.fromHeight(2),
            child: _isSearching ? LinearProgressIndicator() : Container(),
          ),
        ),
        body: UserListView(
          loggedUser: _loggedUser,
          users: _users,
        ),
      ),
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
    dynamic result = await _firestore.searchUsers(
      _searchQuery.trim().toLowerCase(),
      _loggedUser.id,
    );
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
