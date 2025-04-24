import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart'; // Import the image_picker package
import 'dart:io'; // Import dart:io for File class

// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 텍스트 필드 컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        leading: IconButton( // 뒤로가기 버튼
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 이동
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 로그인 처리 로직
                String id = _idController.text;
                String password = _passwordController.text;

                // 여기에서 데이터베이스와 비교하여 로그인 처리
                print('ID: $id, Password: $password');

                // 로그인 성공/실패에 따라 다른 화면으로 이동
                // 예: 로그인 성공 시 내 정보 화면으로 이동
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserInfoScreen(),
                  ),
                );

                // 만약 로그인 실패한다면
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('로그인 실패')),
                // );
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // ID 찾기 페이지로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FindIdPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'ID 찾기',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text(' / '),
                GestureDetector(
                  onTap: () {
                    // 비밀번호 찾기 페이지로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const FindPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Password 찾기',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Text(' / '),
                GestureDetector(
                  onTap: () {
                    // 회원가입 페이지로 이동
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ID 찾기 페이지
class FindIdPage extends StatelessWidget {
  const FindIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID 찾기'),
        leading: IconButton( // 뒤로가기 버튼
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 이동
          },
        ),
      ),
      body: const Center(
        child: Text('ID 찾기 페이지'),
      ),
    );
  }
}

// 비밀번호 찾기 페이지
class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기'),
        leading: IconButton( // 뒤로가기 버튼
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 이동
          },
        ),
      ),
      body: const Center(
        child: Text('비밀번호 찾기 페이지'),
      ),
    );
  }
}

// 회원가입 페이지
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        leading: IconButton( // 뒤로가기 버튼
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 이동
          },
        ),
      ),
      body: const Center(
        child: Text('회원가입 페이지'),
      ),
    );
  }
}

// 내 정보 페이지
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // 텍스트 필드 컨트롤러
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _belongsController = TextEditingController();

  String _profileImagePath = ''; // 프로필 이미지 경로 저장 변수
  //final ImagePicker picker = ImagePicker(); // ImagePicker 인스턴스 생성

  // 성별 선택을 위한 변수
  String _selectedGender = '남성'; // 기본값 설정
  final List<String> _genders = ['남성', '여성'];

  @override
  void dispose() {
    // 컨트롤러 해제
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _phoneNumController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _belongsController.dispose();
    super.dispose();
  }

  // 프로필 이미지 선택 함수
  Future<void> _getImage() async {
    //final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택, XFile로 변경

    // if (pickedFile != null) {
    //   setState(() {
    //     _profileImagePath = pickedFile.path; // 선택한 이미지 경로 저장
    //   });
    // } else {
    //   print('No image selected.'); // 이미지 선택 안했을 경우 출력
    // }
  }

  @override
  Widget build(BuildContext context) {
    // 로그인 상태 확인 (가정: 로그인이 안 된 상태)
    bool isLoggedIn = false; // 실제 로그인 상태에 따라 변경

    if (!isLoggedIn) {
      // 로그인이 안 된 경우 로그인 페이지로 이동
      return const LoginPage(); //  LoginPage 위젯 반환.
    }

    // 로그인이 된 경우 내 정보 페이지 표시
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        leading: IconButton( // 뒤로가기 버튼
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 이전 페이지로 이동
          },
        ),
      ), // AppBar title 변경
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // 스크롤 가능하도록 추가
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center( // 프로필 이미지를 Center로 감싸서 가운데 정렬
                child: GestureDetector( // 이미지를 클릭 가능하도록 GestureDetector로 감쌈
                  onTap: _getImage, // 클릭시 _getImage 함수 호출
                  child: CircleAvatar( // 동그란 프로필 이미지
                    radius: 50, // 이미지 크기
                    backgroundImage: _profileImagePath.isNotEmpty
                        ? FileImage(File(_profileImagePath)) // 이미지가 있을 경우 FileImage 사용, FileImage으로 래핑
                        : const AssetImage('assets/default_profile.png') as ImageProvider, // 없을 경우 기본 이미지 사용
                    child: _profileImagePath.isEmpty // 이미지가 없을 경우에만 카메라 아이콘 표시
                        ? const Icon(Icons.camera_alt, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('성별: '),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedGender,
                    onChanged: (String? newValue) {
                      if (newValue != null) { // null check 추가
                        setState(() {
                          _selectedGender = newValue;
                        });
                      }
                    },
                    items: _genders
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: '주소'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumController,
                decoration: const InputDecoration(labelText: '전화번호'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'ID'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _belongsController,
                decoration: const InputDecoration(labelText: '소속'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 저장 버튼 클릭 시 처리 로직
                  // 각 컨트롤러의 text 값을 가져와서 처리
                  String name = _nameController.text;
                  String age = _ageController.text;
                  String address = _addressController.text;
                  String phoneNum = _phoneNumController.text;
                  String id = _idController.text;
                  String password = _passwordController.text;
                  String belongs = _belongsController.text;

                  // 여기에서 데이터베이스에 저장하는 로직을 구현해야 합니다.
                  // print statements are for debugging purposes, replace with actual database interaction
                  print('이름: $name');
                  print('성별: $_selectedGender');
                  print('나이: $age');
                  print('주소: $address');
                  print('전화번호: $phoneNum');
                  print('ID: $id');
                  print('Password: $password');
                  print('소속: $belongs');
                  print('프로필 이미지 경로: $_profileImagePath'); // 추가된 부분: 프로필 이미지 경로 출력

                  // Show a dialog to confirm the information.
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('입력 정보 확인'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('이름: $name'),
                              Text('성별: $_selectedGender'),
                              Text('나이: $age'),
                              Text('주소: $address'),
                              Text('전화번호: $phoneNum'),
                              Text('ID: $id'),
                              Text('Password: $password'),
                              Text('소속: $belongs'),
                              Text('프로필 이미지 경로: $_profileImagePath'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('확인'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

