import 'package:flutter/material.dart';

class ChangeRequest extends StatefulWidget {
  final String currentUserId;

  ChangeRequest({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => ChangeRequestState(currentUserId: currentUserId);
}

class ChangeRequestState extends State<ChangeRequest> {
  ChangeRequestState({Key key, @required this.currentUserId});

  String currentUserId;

  @override
  Widget build(BuildContext context) {

    //Retrieve list of user IDs

    //remove own user

    //save usernames to something for use later

    //Use User IDs to access user schedules in database

    //loop through schedules and find every user not working on given day

    //show list of users not working that day as buttons or dropdown

    //show selected users scheduled days other then selected day and ones current user isn't already working

    //add document containing both user IDs and both days that will be switched

    /////////////////////////////////////////////////// New Page

    //Query database to see if any request documents exist

    //if documents exists then show them as buttons

    //when button is selected give user option to accept or deny request

    //if deny then delete request

    //if accepted move document to manager request collection

    /////////////////////////////////////////////////// New Page

    //Query database to see if any manger requests exist

    //if so list them as buttons

    //when clicked give two options, approve or deny

    //if denied then delete request

    //if accepted then use both given user ids and the given dates and times to swap schedules

    throw UnimplementedError();
  }

