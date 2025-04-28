import 'package:flutter/material.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'bible_model.dart';
import 'dbhelper.dart';
import 'myInfo.dart'; // myInfo.dart 파일을 import 합니다.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BibleScreen(),
    );
  }
}

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  _BibleScreenState createState() => _BibleScreenState();
}

//displaying screen num 1.
class _BibleScreenState extends State<BibleScreen> {
  List<BibleBook> books = [];
  int selectedAb = 1; // 1: 구약, 2: 신약
  BibleBook? selectedBook;
  int selectedChapter = 1;
  List<BibleVerse> verses = [];
  double _fontSize = 16.0; // 기본 글자 크기
  int _selectedIndex = 0; // 현재 선택된 탭의 인덱스
  bool _isLoading = true; // 로딩 상태 추가
  final List<double> _fontSizes = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]; // 폰트 크기 옵션
  
  // 하이라이트 색상 옵션 (선택 가능하도록 Map으로 변경) -> how about change it from mapping to dropdown?
  //TODO -> changing name of color from hex code to string.
  final Map<String, Color> _highlightColors = {
    'F1B840': const Color(0xFFF1B840),
    'F592BB': const Color(0xFFF592BB),
    'B4B4B4': const Color(0xFFB4B4B4),
    '7878E1': const Color(0xFF7878E1),
  };
  //TODO -> applying changing color to each script.
  Set<String> _selectedHighlightColors = {}; // 선택된 하이라이트 색상 저장

  // 폰트 크기 선택에 사용할 단어
  final String _fontSizeExample = "은광교회";

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    // 로딩 시작
    setState(() {
      _isLoading = true;
    });
    books = await DatabaseHelper.instance.getBibleBooks(selectedAb);
    if (books.isNotEmpty) {
      selectedBook = books.first;
    }
    await _loadVerses(); // await 추가
    // 로딩 완료
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadVerses() async {
    if (selectedBook != null) {
      verses = await DatabaseHelper.instance.getVerses(selectedBook!.bibleId, selectedChapter);
      setState(() {});
    }
  }

  // 즐겨찾기 업데이트 함수 -> screen num2(fav scripts screen에 update.)
  Future<void> _updateFavorite(BibleVerse verse) async {
    verse.isFavorite = !verse.isFavorite;
    await DatabaseHelper.instance.updateVerse(verse);
    setState(() {});
  }

  // 하이라이트 업데이트 함수
  Future<void> _updateHighlight(BibleVerse verse, Set<String> colors) async { // Set<String>으로 변경
    verse.highlightColor = colors.join(','); // 선택된 색상들을 쉼표로 구분된 문자열로 저장
    await DatabaseHelper.instance.updateVerse(verse);
    setState(() {});
  }

  // 폰트 크기 선택 다이얼로그
  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('글자 크기 선택'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<double>( // DropdownButton으로 변경
                    value: _fontSize,
                    items: _fontSizes.map((size) {
                      return DropdownMenuItem<double>(
                        value: size,
                        child: Text(
                          _fontSizeExample, // 폰트 크기 예시 텍스트
                          style: TextStyle(fontSize: size),
                        ),
                      );
                    }).toList(),
                    onChanged: (double? value) { // null 허용
                      if (value != null) { // null 체크 추가
                        setState(() {
                          _fontSize = value;
                        });
                      }
                    },
                  ),
                  Text('글자 크기: ${_fontSize.toStringAsFixed(1)}'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // SharedPreferencesHelper.setFontSize(_fontSize); // SharedPreferences에 저장 (추후 구현)
                setState(() {}); // 변경된 폰트 크기를 화면에 반영
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('성경 앱')),
      body: _isLoading // 로딩 상태에 따라 화면 표시
          ? _buildLoadingScreen() // 로딩 화면 표시
          : _buildBody(), // 본문 위젯 호출
      bottomNavigationBar: _buildBottomNavigationBar(), // 하단 탭 네비게이션 호출
    );
  }

  // 로딩 화면 위젯
  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(), // 기본 로딩 인디케이터로 변경
    );
  }

  // 본문 위젯
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // 성경 탭
        return Column(
          children: [
            Row( // 수정된 부분: DropdownButton들을 Row로 묶음
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectedAb = 1;
                    _loadBooks();
                  },
                  child: const Text('구약'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectedAb = 2;
                    _loadBooks();
                  },
                  child: const Text('신약'),
                ),
                IconButton( // 폰트 크기 조절 버튼
                  icon: Icon(Icons.format_size),
                  onPressed: () {
                    _showFontSizeDialog();
                  },
                ),
              ],
            ),
            Row( // 추가된 Row: 제목 드롭다운과 장 드롭다운을 나란히 배치
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<BibleBook>(
                  value: selectedBook,
                  items: books.map((book) {
                    return DropdownMenuItem<BibleBook>(
                      value: book,
                      child: Text(book.title),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBook = value;
                      selectedChapter = 1;
                      _loadVerses();
                    });
                  },
                ),
                const SizedBox(width: 10), // 간격 추가
                DropdownButton<int>(
                  value: selectedChapter,
                  items: (selectedBook != null)
                      ? List.generate(
                    80, // selectedBook!.chapterCount,
                        (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('${index + 1}장'),
                      );
                    },
                  ).toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      selectedChapter = value!;
                      _loadVerses();
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: (verses.isNotEmpty)
                  ? ListView.builder(
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  final verse = verses[index];
                  // verse.highlightColor가 쉼표로 구분된 문자열일 경우 처리
                  List<String> highlightColors = verse.highlightColor.isNotEmpty
                      ? verse.highlightColor.split(',')
                      : [];
                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${verse.verse}절 ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: _fontSize, // 적용된 폰트 크기
                            ),
                          ),
                          TextSpan(
                            text: verse.script,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: _fontSize, // 적용된 폰트 크기
                              backgroundColor: highlightColors.isNotEmpty
                                  ? Color(int.parse(highlightColors.first,
                                  radix: 16)) // 첫 번째 색상 적용
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(verse.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            _updateFavorite(verse);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.highlight),
                          onPressed: () {
                            _showHighlightColorDialog(verse); // 하이라이트 색상 선택 다이얼로그 표시
                          },
                        ),
                      ],
                    ),
                  );
                },
              )
                  : const Center(
                child: Text("성경을 선택하세요"),
              ),
            ),
          ],
        );
      case 1: // 즐겨찾기 탭
        return const Center(child: Text('즐겨찾기 화면'));
      case 2: // 출석 탭
        return const Center(child: Text('출석 화면'));
      case 3: // 내 정보 탭
        return const UserInfoScreen(); // 내 정보 탭을 UserInfoScreen()으로 변경
      default:
        return const Center(child: Text('잘못된 탭 선택'));
    }
  }

  // 하이라이트 색상 선택 다이얼로그
  void _showHighlightColorDialog(BibleVerse verse) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('형광펜'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0, // 간격 설정
                  runSpacing: 4.0,
                  children: _highlightColors.entries.map((entry) { //_highlightColors.entries
                    final colorName = entry.key;
                    final color = entry.value;
                    final isSelected =
                    _selectedHighlightColors.contains(colorName);
                    return ChoiceChip(
                      label: Text(colorName),
                      selected: isSelected,
                      onSelected: (bool? selected) {
                        if (selected != null) {
                          setState(() {
                            if (selected) {
                              _selectedHighlightColors.add(colorName);
                            } else {
                              _selectedHighlightColors.remove(colorName);
                            }
                          });
                        }
                      },
                      backgroundColor: color,
                      selectedColor: color.withOpacity(0.7), // 선택된 색상 약간 더 어둡게
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateHighlight(verse, _selectedHighlightColors);
                Navigator.of(context).pop();
              },
              child: const Text('저장'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  // 하단 탭 네비게이션
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: '성경',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: '즐겨찾기',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: '출석',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '내 정보',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed, // 탭이 4개 이상일 경우 fixed 지정
    );
  }
}

