import 'package:flutter/material.dart';
import 'package:slider_like/slider_like.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider like',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _maxHeight = 400;
  static const _maxThumbSize = 56;

  double _height = 200;
  double _thumbSize = 28;

  void _onLike(BuildContext context, double value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Liked with value $value')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slider like'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              children: [
                Text('Slider height $_height'),
                Slider(
                  min: 0.2,
                  onChanged: (value) => setState(() => _height = value * _maxHeight),
                  value: _height / _maxHeight,
                ),
                Text('Thumb size $_thumbSize'),
                Slider(
                  min: 0.2,
                  onChanged: (value) => setState(() => _thumbSize = value * _maxThumbSize),
                  value: _thumbSize / _maxThumbSize,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Long press to like'),
                  SliderLike(
                    size: Size(20, _height),
                    thumbSize: Size.square(_thumbSize),
                    startBehavior: SliderLikeStartBehavior.longPress,
                    onLike: (value) => _onLike(context, value),
                    child: const LikeButton(),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Drag to like'),
                  SliderLike(
                    size: Size(20, _height),
                    thumbSize: Size.square(_thumbSize),
                    startBehavior: SliderLikeStartBehavior.drag,
                    onLike: (value) => _onLike(context, value),
                    child: const LikeButton(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Icon(Icons.favorite),
      ),
    );
  }
}
