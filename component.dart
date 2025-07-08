//  import 'dart:convert'; import 'package:flutter/material.dart';

// class ComponentBuilder {
//   final BuildContext context;
//   final Function(String) onSend;
//   final bool isUser;

// ComponentBuilder({
//     required this.context,
//     required this.onSend,
//     required this.isUser,
//   });

// Widget buildComponent(Map<String, dynamic> data) {
//     final type = data['type'];
//     final isUser = data['from'] == 'user';

//     switch (type) {
//       case 'textfield':
//         TextEditingController textController = TextEditingController();
//         return chatBubble(
//           isUser: isUser,
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: textController,
//                   decoration: InputDecoration(
//                     hintText: data['label'] ?? 'Enter text',
//                     filled: true,
//                     fillColor: Colors.grey.shade100,
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               IconButton(
//                 icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
//                 onPressed: () {
//                   final text = textController.text.trim();
//                   if (text.isNotEmpty) {
//                     onSend(text);
//                   }
//                 },
//               ),
//             ],
//           ),
//         );

// case 'form':
//     final fields = data['fields'] as List;
//     final Map<String, dynamic> localValues = {};
//     final Map<String, TextEditingController> controllers = {};
//     final Map<String, bool> checkboxStates = {};
//     final Map<String, double> sliderValues = {};
//     final Map<String, String> radioValues = {};

//     return chatBubble(
//       isUser: isUser,
//       child: StatefulBuilder(
//         builder: (context, setLocalState) {
//           List<Widget> formWidgets = [];

//           for (var field in fields) {
//             final key = field['key'];
//             final type = field['type'];
//             final label = field['label'];

//             switch (type) {
//               case 'textfield':
//                 controllers[key] = TextEditingController();
//                 formWidgets.add(
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
//                         SizedBox(height: 4),
//                         TextField(
//                           controller: controllers[key],
//                           decoration: InputDecoration(
//                             hintText: 'Enter $label',
//                             filled: true,
//                             fillColor: Colors.grey.shade100,
//                             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//                 break;

//               case 'dropdown':
//                 final options = field['options'] ?? [];
//                 localValues[key] ??= options.isNotEmpty ? options[0]['value'] : null;

//                 formWidgets.add(
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
//                         SizedBox(height: 4),
//                         Container(
//                           padding: EdgeInsets.symmetric(horizontal: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: DropdownButtonFormField(
//                             isExpanded: true,
//                             value: localValues[key],
//                             decoration: InputDecoration.collapsed(hintText: ''),
//                             items: options.map<DropdownMenuItem>((opt) {
//                               return DropdownMenuItem(
//                                 value: opt['value'],
//                                 child: Text(opt['label']),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setLocalState(() {
//                                 localValues[key] = value;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//                 break;

//               case 'checkbox':
//                 checkboxStates[key] = checkboxStates[key] ?? false;
//                 formWidgets.add(
//                   CheckboxListTile(
//                     title: Text(label),
//                     value: checkboxStates[key],
//                     onChanged: (value) {
//                       setLocalState(() {
//                         checkboxStates[key] = value ?? false;
//                       });
//                     },
//                   ),
//                 );
//                 break;

//               case 'slider':
//                 sliderValues[key] = sliderValues[key] ?? 0.0;
//                 formWidgets.add(
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('$label: ${sliderValues[key]!.toStringAsFixed(1)}'),
//                       Slider(
//                         min: 0,
//                         max: 100,
//                         divisions: 10,
//                         value: sliderValues[key]!,
//                         onChanged: (value) {
//                           setLocalState(() {
//                             sliderValues[key] = value;
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//                 break;

//               case 'radio':
//                 final options = field['options'] ?? [];
//                 radioValues[key] = radioValues[key] ?? (options.isNotEmpty ? options[0]['value'] : null);
//                 formWidgets.add(
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
//                       Column(
//                         children: options.map<Widget>((opt) {
//                           return RadioListTile<String>(
//                             title: Text(opt['label']),
//                             value: opt['value'],
//                             groupValue: radioValues[key],
//                             onChanged: (value) {
//                               setLocalState(() {
//                                 radioValues[key] = value!;
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 );
//                 break;

//               default:
//                 formWidgets.add(
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: Text('Unsupported field type: $type'),
//                   ),
//                 );
//             }
//           }

//           formWidgets.add(
//             Padding(
//               padding: const EdgeInsets.only(top: 16),
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     for (var entry in controllers.entries) {
//                       localValues[entry.key] = entry.value.text;
//                     }
//                     for (var entry in checkboxStates.entries) {
//                       localValues[entry.key] = entry.value;
//                     }
//                     for (var entry in sliderValues.entries) {
//                       localValues[entry.key] = entry.value;
//                     }
//                     for (var entry in radioValues.entries) {
//                       localValues[entry.key] = entry.value;
//                     }
//                     onSend(jsonEncode(localValues));
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).primaryColor,
//                   ),
//                   child: Text('Submit'),
//                 ),
//               ),
//             ),
//           );

//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
//             ),
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: formWidgets,
//             ),
//           );
//         },
//       ),
//     );

//   default:
//     return chatBubble(
//       isUser: isUser,
//       child: Text(data['label'] ?? 'Unsupported widget'),
//     );
// }

// }

// Widget chatBubble({required Widget child, required bool isUser}) {
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: child,
//       ),
//     );
//   }
// }


import 'dart:convert'; import 'package:flutter/material.dart';

class ComponentBuilder { final Function(String) onSend; bool isUser;

ComponentBuilder({required this.onSend, this.isUser = false});

Widget buildComponent(Map<String, dynamic> data) {
    final type = data['type'];
    isUser = data['from'] == 'user';

    switch (type) {
      case 'form':
        return _buildForm(data);
      default:
        return _wrapMessage(buildGenericWidget(data, onSend));
    }
  }

Widget _wrapMessage(Widget child, {bool isForm = false}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: isForm ? EdgeInsets.zero : EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isUser
                    ? [Color(0xFF0052CC), Color(0xFF0066FF)]
                    : [Color(0xFFE0F0FF), Color(0xFFCCEAFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }

Widget _buildForm(Map<String, dynamic> data) {
    final fields = data['fields'] as List;
    final title = data['label'] ?? 'Fill the form';
    Map<String, dynamic> formValues = {};
    Map<String, TextEditingController> controllers = {};

return StatefulBuilder(
  builder: (context, setState) {
    void updateFormValue(String key, dynamic value) {
      setState(() => formValues[key] = value);
    }

    void resetForm() {
      setState(() {
        formValues.clear();
        controllers.forEach((key, ctrl) => ctrl.clear());
      });
    }

    List<Widget> widgets = [
      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      SizedBox(height: 8),
    ];

    for (var field in fields) {
      final key = field['key'];
      final type = field['type'];

      // if (type == 'text') {
      //   controllers[key] = TextEditingController();
      // }

      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: buildGenericWidget(
          field,
           onSend,
          insideForm: true,
          onFormValueChanged: updateFormValue,
          formValues: formValues,
        ),
      ));
    }

    // widgets.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     TextButton(onPressed: resetForm, child: Text("Reset")),
    //     ElevatedButton.icon(
    //       onPressed: () {
    //         if (formValues.isEmpty) return;
    //         onSend(jsonEncode(formValues));
    //       },
    //       icon: Icon(Icons.send),
    //       label: Text("Submit", style: TextStyle(color: Colors.white),),
    //       style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0052CC)),
    //     )
    //   ],
    // ));

    return _wrapMessage(
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets,
        ),
      ),
      isForm: true,
    );
  },
);

}

Widget buildGenericWidget(
    Map<String, dynamic> data,
    dynamic onSendCallback, {
    bool insideForm = false,
    Map<String, dynamic>? formValues,
    Function(String key, dynamic value)? onFormValueChanged,
  }) {
    final type = data['type'];
    final label = data['label'] ?? '';
    final key = data['name'] ?? label.toLowerCase().replaceAll(' ', '');
    final onSend = onSendCallback;

switch (type) {
      case 'text':
        return Text(
          data['text'],
          style: TextStyle(fontSize: 16, color: Colors.black),
        );
 case 'textfield':
        TextEditingController textController = TextEditingController();
        return  Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    hintText: data['label'] ?? 'Enter text',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.send, color: Colors.black),
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isNotEmpty) {
                    onSend(text);
                  }
                },
              ),
            ],
          );
          
                        
case 'checkbox_group':
        List<Map<String, dynamic>> checkboxOptions =
            (data['options'] as List).map<Map<String, dynamic>>((opt) {
              if (opt is String) return {'label': opt, 'value': opt};
              return {'label': opt['label'], 'value': opt['value']};
            }).toList();

  List selected = (formValues?[key] ?? []).cast();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(data['text'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        SizedBox(height: 5,),
      ...checkboxOptions.map((opt) {
        final isChecked = selected.contains(opt['value']);
        return CheckboxListTile(
          title: Text(opt['label']),
          value: isChecked,
          activeColor: Color(0xFF0052CC),
          onChanged: (val) {
             selected[opt['value']] = val ?? false;
             if (insideForm && onFormValueChanged != null) {
              onFormValueChanged(key, val);
            } else {
              onSend(jsonEncode({key: val}));
            }
          },
        );
      }).toList(),
    ],
  );
  // Map<String, bool> selected = {
  //       for (var opt in data['options']) opt['value']: false
  //     };
  //      return StatefulBuilder(
  //       builder: (context, setState) => Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //            Text(data['text'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
  //            SizedBox(height: 5,),
  //         data['options'].map<Widget>((opt) {
  //           return CheckboxListTile(
  //             title: Text(opt['label'], style: TextStyle( color:  Colors.white, fontSize: 12)),
  //             fillColor: WidgetStateProperty.all<Color>(Color(0XFF0050A0)),
  //             value: selected[opt['value']],
  //              onChanged: (val) => {
  //               setState(() {
  //             selected[opt['value']] = val ?? false;
  //           if (insideForm && onFormValueChanged != null) {
  //             onFormValueChanged(key, val);
  //           } else {
  //             onSend(jsonEncode({key: val}));
  //           }
  //             }),
  //             }
              
             
  //           );
  //         }).toList(),
  //         ]
  //       ),
  //     );

case 'radio_group':
  List<Map<String, dynamic>> radioOptions =
            (data['options'] as List).map<Map<String, dynamic>>((opt) {
              if (opt is String) return {'label': opt, 'value': opt};
              return {'label': opt['label'], 'value': opt['value']};
            }).toList();

  var selected = formValues?[key] ?? radioOptions.first['value'];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(data['text'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        SizedBox(height: 5,),
      ...radioOptions.map((opt) {
        return RadioListTile(
          title: Text(opt['label']),
          value: opt['value'],
          groupValue: selected,
          activeColor: Color(0xFF0052CC),
          onChanged: (val)  {
          
       selected = val.toString();
         if (insideForm && onFormValueChanged != null) {
              onFormValueChanged(key, val);
            } else {
              onSend(jsonEncode({key: val}));
            }
              
              
          },
        );
      }).toList()
    ],
  );

case 'dropdown':
  

  String? selected;
      return StatefulBuilder(
        builder: (context, setState) => 
         Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(data['text'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
             SizedBox(height: 5,),
        DropdownButtonFormField(
  
                decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(),
    ),
          items: (data['options'] as List)
              .map((opt) => DropdownMenuItem(
                    value: opt['value'],
                    child: Text(opt['label'], style: TextStyle( color:  Colors.blueGrey, fontSize: 12), ),
                  
                  ))
              .toList(),
          onChanged: (val) =>
          {
             setState(() { 
            selected = val.toString();
            if (insideForm && onFormValueChanged != null) {
        onFormValueChanged(key, val);
      } else {
        onSend(jsonEncode({key: val}));
      }
            
            }),
          }
        ),
          ]
         )
      );

case 'slider':
  // double value = (formValues?[key] ?? (data['min'] ?? 0)).toDouble();
  // return Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //      Text(data['text']?? "Choose", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
  //            SizedBox(height: 5,),
  //     Slider(
  //       value: value,
  //       min: (data['min'] ?? 0).toDouble(),
  //       max: (data['max'] ?? 100).toDouble(),
  //       divisions: data['divisions'] ?? 10,
  //       activeColor: Color(0xFF0052CC),
  //       label: value.toStringAsFixed(0),
  //       onChanged: (val) {
  //         onFormValueChanged?.call(key, val);
  //       },
  //     ),
  //   ],
  // );

    double value = (data['value'] as num).toDouble();
     return StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data['label']} (${value.round()})', style: TextStyle( color:  Colors.white, fontSize: 12)),
            Slider(
              activeColor: Colors.blueGrey,
              value: value,
              min: (data['min'] as num).toDouble(),
              max: (data['max'] as num).toDouble(),
              divisions: data['dCivisions'],
              onChanged: (val) => {
                  setState(() { 
            if (insideForm && onFormValueChanged != null) {
        onFormValueChanged(key, val);
      } else {
        onSend(jsonEncode({key: val}));
      }
                  
                  })
              }
            )  
          ],
        ),
      );

case 'button':
  return ElevatedButton(
    onPressed: () => onSend(jsonEncode(formValues)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF0052CC),
    ),
    child: Text( data['text'], style: TextStyle(color: Colors.white), ),
  );

case 'image':
  final imageUrl = data['value'] ?? data['url'] ?? '';
  return imageUrl.isNotEmpty
      ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            width: 250,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Text('Image load failed'),
          ),
        )
      : Text('No image provided');

default:
  return Text('Unsupported widget type: $type');

} }

} 
