import 'package:flutter/material.dart';
import 'package:my_notes/note.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, required this.title, required this.selectedContent});

  final String title;
  final Note selectedContent;

  @override
  State<ViewScreen> createState() => ViewScreenState();
}

class ViewScreenState extends State<ViewScreen> {
  TextEditingController forHeadline = TextEditingController();
  TextEditingController forContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    forHeadline.text = widget.selectedContent.headline;
    forContent.text = widget.selectedContent.content;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: 
          Card(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                      Text("${"created: ${widget.selectedContent.created.day < 10 ? "0${widget.selectedContent.created.day}" : widget.selectedContent.created.day}. ${widget.selectedContent.created.month < 10 ? "0${widget.selectedContent.created.month}" : widget.selectedContent.created.month}. ${widget.selectedContent.created.year} / ${widget.selectedContent.created.hour < 10 ? "0${widget.selectedContent.created.hour}" : widget.selectedContent.created.hour}"}:${widget.selectedContent.created.minute < 10 ? "0${widget.selectedContent.created.minute}" : widget.selectedContent.created.minute}"),
                      Text("${"last edited: ${widget.selectedContent.lastEdit.day < 10 ? "0${widget.selectedContent.lastEdit.day}" : widget.selectedContent.lastEdit.day}. ${widget.selectedContent.lastEdit.month < 10 ? "0${widget.selectedContent.lastEdit.month}" : widget.selectedContent.lastEdit.month}. ${widget.selectedContent.lastEdit.year} / ${widget.selectedContent.lastEdit.hour < 10 ? "0${widget.selectedContent.lastEdit.hour}" : widget.selectedContent.lastEdit.hour}"}:${widget.selectedContent.lastEdit.minute < 10 ? "0${widget.selectedContent.lastEdit.minute}" : widget.selectedContent.lastEdit.minute}"),
                      Expanded(
                        flex: 0,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Title",
                          ),
                          controller: forHeadline,
                          maxLength: 30,
                          maxLines: 1,
                          onChanged: (s) => widget.selectedContent.setContent(forHeadline, forContent),
                        )
                      ),
                      const Divider(),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Text",
                          ),
                          controller: forContent,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          onChanged: (s) => widget.selectedContent.setContent(forHeadline, forContent),
                        )
                      ),
                    ]
                  ),
                )
              ],
            ),
          ),
        );
      }
  }
