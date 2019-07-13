import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';

class FijkView extends StatefulWidget {
  FijkView(this.player);

  final FijkPlayer player;

  @override
  createState() => _FijkViewState();
}

class _FijkViewState extends State<FijkView> {
  int _textureId = -1;
  int _vWidth = -1;
  int _vHeight = -1;

  @override
  void initState() {
    super.initState();
    _nativeSetup();
    widget.player.addListener(_fijkValueListener);
  }

  Future<void> _nativeSetup() async {
    final int vid = await widget.player.setupSurface();
    print("view setup, vid:" + vid.toString());
    setState(() {
      _textureId = vid;
    });
  }

  void _fijkValueListener() {
    FijkValue value = widget.player.value;
    int width = value.width;
    int height = value.height;
    print("width $width, height $height");
    setState(() {
      _vWidth = width;
      _vHeight = height;
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.release();
    print("FijkView dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: LayoutBuilder(builder: (ctx, constraints) {
        Size s = (_vWidth > 0 && _vHeight > 0)
            ? constraints.constrainSizeAndAttemptToPreserveAspectRatio(
                Size(_vWidth.toDouble(), _vHeight.toDouble()))
            : Size(-1, -1);
        print("FijkView $constraints s: $s");

        return Center(
          child: Container(
            width: s.width > 0.0 ? s.width : constraints.maxWidth,
            height: s.height > 0.0 ? s.height : constraints.maxHeight,
            child: _textureId > 0
                ? Texture(
                    textureId: _textureId,
                  )
                : null,
          ),
        );
      }),
    );
  }
}
