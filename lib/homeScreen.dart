import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _images = [
    'https://picsum.photos/id/1005/400/700',
    'https://picsum.photos/id/1015/400/700',
    'https://picsum.photos/id/1025/400/700',
    'https://picsum.photos/id/1005/400/700',
    'https://picsum.photos/id/1015/400/700',
    'https://picsum.photos/id/1025/400/700',
    'https://picsum.photos/id/1005/400/700',
    'https://picsum.photos/id/1015/400/700',
    'https://picsum.photos/id/1025/400/700',
  ];

  int _currentIndex = 0;
  Offset _offset = Offset.zero;
  double _angle = 0;
  bool _isDragging = false;

  void _onSwipeLeft() {
    print("Swiped Left → Action");
  }

  void _onSwipeRight() {
    print("Swiped Right ← Action");
  }

  void _onDragEnd(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final swipeThreshold = 0.4 * screenWidth; // 60% of screen width

    if (_offset.dx > swipeThreshold) {
      _onSwipeRight();
      _dismissCard();
    } else if (_offset.dx < -swipeThreshold) {
      _onSwipeLeft();
      _dismissCard();
    } else {
      // Reset position if not enough swipe distance
      setState(() {
        _offset = Offset.zero;
        _angle = 0;
      });
    }
  }

  // void _showNextImage() {
  //   setState(() {
  //     _offset = Offset.zero;
  //     _angle = 0;
  //     _currentIndex = (_currentIndex + 1) % _images.length;
  //   });
  // }

  void _dismissCard() {
    setState(() {
      if (_images.isNotEmpty) {
        _images.removeAt(0); // show next card
      }
      _offset = Offset.zero;
      _angle = 0;
      _isDragging = false;
    });
  }

  void _simulateSwipe(bool isLike) {
    final swipeDistance =
        MediaQuery
            .of(context)
            .size
            .width * 0.4; // 40% of screen width
    final swipeDirection = isLike ? swipeDistance : -swipeDistance;

    // Update the offset to simulate a swipe
    setState(() {
      _offset = Offset(swipeDirection, 0);
      _angle = 0.002 * _offset.dx; // Adjust tilt intensity based on swipe
    });

    // Simulate the swipe action after a short delay (for the swipe effect)
    Future.delayed(Duration(milliseconds: 150), () {
      if (isLike) {
        _onSwipeRight(); // Perform the LIKE action
      } else {
        _onSwipeLeft(); // Perform the NOPE action
      }

      _dismissCard(); // Dismiss the card after swipe
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children:
          List.generate(_images.length, (index) {
            if (index < _currentIndex) return SizedBox.shrink();
            final isTop = index == _currentIndex;

            return Positioned.fill(
              child:
              isTop
                  ? GestureDetector(
                onPanStart: (_) {
                  _isDragging = true;
                },
                onPanUpdate: (details) {
                  setState(() {
                    _offset += details.delta;
                    _angle =
                        0.002 *
                            _offset
                                .dx; // Adjust this for tilt intensity
                  });
                },
                onPanEnd: (_) {
                  _isDragging = false;
                  _onDragEnd(context);
                },
                child: Transform.translate(
                  offset: _offset,
                  child: Transform.rotate(
                    angle: _angle,
                    child: CardImage(
                      url: _images[index],
                      onHeartPressed: () => _simulateSwipe(true),
                      // Like button
                      onCrossPressed: () => _simulateSwipe(false),
                      // Nope button

                    ),
                  ),
                ),
              )
                  : CardImage(
                url: _images[index],
                onHeartPressed: () => _simulateSwipe(true),
                // Like button
                onCrossPressed: () => _simulateSwipe(false),
                // Nope button

              ),
            );
          }).reversed.toList(),
        ),
        // Stack(
        //   children: List.generate(_images.length, (index) {
        //     if (index < _currentIndex) return const SizedBox.shrink();
        //
        //     final isTop = index == _currentIndex;
        //
        //     // If the card is the top card (the one that can be dragged)
        //     return Positioned.fill(
        //       child: isTop
        //           ? _buildDraggableCard(
        //         url: _images[index],
        //         index: index,
        //         isTop: isTop,
        //         offset: _offset,
        //         isDragging: _isDragging,
        //       )
        //           : CardImage(
        //         url: _images[index], // Card image for other cards
        //         onHeartPressed: () => _simulateSwipe(true),
        //         onCrossPressed: () => _simulateSwipe(false),
        //         offset: isTop ? _offset : Offset.zero, // Only apply offset for the top card
        //         isDragging: isTop ? _isDragging : false, // Only apply dragging effect for the top card
        //         isTopCard: isTop, // Flag for the top card
        //       ),
        //     );
        //   }).reversed.toList(),
        // ),
      ),
    );
  }

//   Widget _buildDraggableCard({
//     required String url,
//     required int index,
//     required bool isTop,
//     required Offset offset,
//     required bool isDragging,
//   }) {
//     // Your draggable card logic goes here
//     return GestureDetector(
//       onPanStart: (_) {
//         _isDragging = true;
//       },
//       onPanUpdate: (details) {
//         setState(() {
//           _offset += details.delta;
//           _angle = 0.002 * _offset.dx; // Adjust tilt intensity
//         });
//       },
//       onPanEnd: (_) {
//         _isDragging = false;
//         _onDragEnd(context);
//       },
//       child: Transform.translate(
//         offset: offset,
//         child: Transform.rotate(
//           angle: _angle,
//           child: CardImage(
//             url: url,
//             onHeartPressed: () => _simulateSwipe(true),
//             onCrossPressed: () => _simulateSwipe(false),
//             offset: offset,
//             isDragging: isDragging,
//             isTopCard: isTop, // Pass isTop to CardImage
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CardImage extends StatelessWidget {
//   final String url;
//   final VoidCallback onHeartPressed;
//   final VoidCallback onCrossPressed;
//   final Offset offset;
//   final bool isDragging;
//   final bool isTopCard;
//
//   const CardImage({
//     required this.url,
//     required this.onHeartPressed,
//     required this.onCrossPressed,
//     required this.offset,
//     required this.isDragging,
//     required this.isTopCard,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double opacity = (offset.dx.abs() / (screenWidth * 0.15)).clamp(0, 1);
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Background Image
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(url),
//                 fit: BoxFit.cover,
//               ),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black45,
//                   blurRadius: 20,
//                   spreadRadius: 5,
//                 ),
//               ],
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//
//           // LIKE / NOPE Overlay only on top card and when dragging
//           if (isTopCard && isDragging && offset.dx.abs() > 5)
//             Positioned(
//               top: 60,
//               left: offset.dx > 0 ? 20 : null,
//               right: offset.dx < 0 ? 20 : null,
//               child: Opacity(
//                 opacity: opacity,
//                 child: RotatedBox(
//                   quarterTurns: offset.dx > 0 ? -1 : 1,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: offset.dx > 0 ? Colors.green : Colors.red,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       offset.dx > 0 ? "LIKE" : "NOPE",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//           // Bottom Info & Buttons
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 const Text(
//                   "John Doe",
//                   style: TextStyle(
//                     fontSize: 24,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 10, color: Colors.black)],
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   "New York • Manhattan",
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.white70,
//                     shadows: [Shadow(blurRadius: 10, color: Colors.black)],
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: const CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.close, color: Colors.red),
//                       ),
//                       onPressed: onCrossPressed,
//                     ),
//                     const SizedBox(width: 30),
//                     IconButton(
//                       icon: const CircleAvatar(
//                         backgroundColor: Colors.white,
//                         child: Icon(Icons.favorite, color: Colors.pink),
//                       ),
//                       onPressed: onHeartPressed,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
}

class CardImage extends StatelessWidget {
  final String url;
  final VoidCallback onHeartPressed; // Callback for heart press
  final VoidCallback onCrossPressed; // Callback for cross press

  const CardImage({
    required this.url,
    required this.onHeartPressed,
    required this.onCrossPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // Bottom Overlay Info
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                SizedBox(height: 4),
                // City & Area
                Text(
                  "New York • Manhattan",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                  ),
                ),
                SizedBox(height: 12),
                // Icons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Cancel Icon
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.red),
                      ),
                      onPressed: onCrossPressed,
                    ),
                    SizedBox(width: 30),
                    // Like Icon
                    IconButton(
                      icon: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite, color: Colors.pink),
                      ),
                      onPressed: onHeartPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class CardImage extends StatelessWidget {
//   final String url;
//
//   const CardImage({required this.url});
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: NetworkImage(url),
//           fit: BoxFit.cover,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black45,
//             blurRadius: 20,
//             spreadRadius: 5,
//           ),
//         ],
//       ),
//     );
//   }
// }
