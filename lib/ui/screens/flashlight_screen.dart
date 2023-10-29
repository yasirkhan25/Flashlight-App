import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashlightScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const FlashlightScreen(this.cameras, {super.key});

  @override
  _FlashlightScreenState createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  CameraController? _controller;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    _controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleFlashlight() async {
    if (_controller != null) {
      try {
        if (_isFlashOn) {
          await _controller!.setFlashMode(FlashMode.off);
          setState(() {
            _isFlashOn = false;
          });
        } else {
          await _controller!.setFlashMode(FlashMode.torch);
          setState(() {
            _isFlashOn = true;
          });
        }
      } catch (e) {
        print('Error toggling flashlight: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller!.value.isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Flashlight'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator(color: Colors.red,)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Flashlight'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _toggleFlashlight,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100)),
                padding: const EdgeInsets.all(20),
                child: Icon(
                  _isFlashOn ? Icons.flash_off : Icons.flash_on,
                  size: 48.0,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              _isFlashOn ? 'Flashight ON' : 'Flashlight OFF',
              style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
