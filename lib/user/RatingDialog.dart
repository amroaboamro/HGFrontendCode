import 'package:flutter/material.dart';
import 'package:head_gasket/global.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RatingDialog extends StatefulWidget {
  final workerEmail, workerName;

  RatingDialog({required this.workerEmail, required this.workerName});

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0.0;

  Future<void> _submitRating() async {
    print(_rating.toString() + "  " + widget.workerEmail);
    try {
      final url = Uri.parse(global.ip + '/rateWorker/' + widget.workerEmail);
      final response = await http.patch(
        url,
        body: {
          'rating': _rating.toString(),
        },
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Rating submitted successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pop();
      } else {
        Fluttertoast.showToast(
          msg: 'Error submitting rating. StatusCode: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate ' + widget.workerName),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Please rate this worker '),
          SizedBox(height: 16.0),
          SmoothStarRating(
            rating: _rating,
            onRatingChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
            starCount: 5,
            size: 40,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.star_half,
            defaultIconData: Icons.star_border,
            spacing: 2.0,
            color: Colors.amber,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _submitRating();
          },
          child: Text('Submit'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
