import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/view/notes/notes_list_view.dart';
import 'dart:developer' as devtools show log;
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}



class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [

          IconButton(onPressed:() {
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
          },
           icon: const Icon(Icons.add)),
          //three dot selection button code
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch(value){
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialogue(context);
                  devtools.log(shouldlogout.toString());
                  if (shouldlogout){
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                  }
                  
              }
            },
            
            itemBuilder:(context){
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('logout'),),
                
              ];
            } ,
          ),
        ] ,
      ),
      
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot)  {
                  switch(snapshot.connectionState){
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData){                      
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote:(note)async{
                            await _notesService.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(createOrUpdateNoteRoute,arguments:note );

                          },);
                     }else{
                        
                        return const CircularProgressIndicator();
                      }
                  default:
                    return const CircularProgressIndicator();
                  }
                },
              );
            default: return const CircularProgressIndicator();
              
          }

        },
      ),
    );
  }
}

