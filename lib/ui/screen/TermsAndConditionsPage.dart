import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로 가기 버튼
            },
          ),
        ),
        title: Text(
          '이용 약관',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('제1조', '목적',
                  '본 약관은 쿡플루언서(이하 "서비스")가 제공하는 서비스의 이용 조건 및 절차, '
                      '이용자와 서비스 제공자의 권리와 의무, 책임 사항 및 기타 필요한 사항을 규정하는 것을 목적으로 합니다.'),
              _buildSection('제2조', '용어의 정의',
                  '"서비스"란 쿡플루언서 앱 및 웹사이트를 통해 제공되는 모든 콘텐츠 및 관련 제반 서비스를 의미합니다.\n'
                      '"이용자"란 본 약관에 따라 쿡플루언서의 서비스를 이용하는 회원 및 비회원을 말합니다.\n'
                      '"회원"이란 서비스에 가입하여 서비스를 이용하는 자를 말하며, "비회원"이란 서비스에 가입하지 않고 서비스를 이용하는 자를 말합니다.\n'
                      '"콘텐츠"란 텍스트, 이미지, 영상 등의 다양한 형태로 제공되는 레시피 및 관련 자료를 의미합니다.'),
              _buildSection('제3조', '약관의 효력 및 변경',
                  '본 약관은 이용자가 서비스에 가입하거나 이용함과 동시에 효력이 발생합니다.\n'
                      '쿡플루언서는 관련 법령을 준수하며, 필요한 경우 본 약관을 변경할 수 있습니다. 약관 변경 시에는 변경된 내용을 서비스 내 공지사항을 통해 고지합니다.\n'
                      '변경된 약관은 공지한 날로부터 7일 후부터 효력이 발생하며, 이용자가 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.'),
              _buildSection('제4조', '서비스의 제공 및 변경',
                  '쿡플루언서는 다음과 같은 서비스를 제공합니다:\n'
                      '레시피 검색 및 추천\n'
                      '인플루언서 콘텐츠 탐색\n'
                      '레시피 저장 및 북마크 기능\n'
                      '쿡플루언서는 이용자의 편의 및 서비스 개선을 위해 서비스 내용을 추가하거나 변경할 수 있으며, 이에 따른 변경 사항은 사전에 공지합니다.'),
              _buildSection('제5조', '서비스 이용 계약의 성립',
                  '이용자가 회원가입 절차를 완료하고 본 약관에 동의함으로써 이용 계약이 성립됩니다.\n'
                      '서비스 이용을 위해 제공되는 개인 정보는 별도의 개인정보 처리방침에 따라 보호됩니다.'),
              _buildSection('제6조', '이용자의 의무',
                  '이용자는 다음 행위를 해서는 안 됩니다:\n'
                      '타인의 개인정보를 도용하거나 허위 정보를 등록하는 행위\n'
                      '서비스에 게시된 정보를 무단으로 복제, 배포, 수정하는 행위\n'
                      '서비스 운영을 방해하거나 부정한 방법으로 이용하는 행위\n'
                      '이용자는 서비스 내에서 제공되는 콘텐츠를 개인적인 목적으로만 이용해야 하며, 상업적 목적으로 무단 이용할 수 없습니다.'),
              _buildSection('제7조', '서비스 제공자의 권리 및 의무',
                  '쿡플루언서는 관련 법령과 본 약관을 준수하며, 지속적이고 안정적인 서비스를 제공할 의무가 있습니다.\n'
                      '쿡플루언서는 서비스 운영과 관련하여 발생한 문제에 대해 적절히 해결할 책임이 있으며, 이용자가 불편 사항을 제기할 경우 신속하게 대응해야 합니다.'),
              _buildSection('제8조', '서비스 이용 제한',
                  '쿡플루언서는 다음의 경우 서비스 이용을 제한할 수 있습니다:\n'
                      '이용자가 본 약관을 위반한 경우\n'
                      '서비스의 정상적인 운영을 방해하는 경우\n'
                      '서비스 이용 제한 시, 쿡플루언서는 사전 통지 후 조치를 취하며, 긴급한 경우 사후 통지할 수 있습니다.'),
              _buildSection('제9조', '개인정보 보호',
                  '쿡플루언서는 이용자의 개인정보를 중요시하며, 개인정보 보호 관련 법령에 따라 이를 보호하기 위한 조치를 취합니다.\n'
                      '개인정보 처리에 관한 세부 내용은 개인정보 처리방침을 따릅니다.'),
              _buildSection('제10조', '지적 재산권',
                  '서비스 내 제공되는 모든 콘텐츠(레시피, 이미지, 영상 등)에 대한 저작권 및 지적 재산권은 쿡플루언서에 귀속됩니다.\n'
                      '이용자는 쿡플루언서의 콘텐츠를 사전 동의 없이 무단 복제, 배포, 판매할 수 없습니다.'),
              _buildSection('제11조', '면책 조항',
                  '쿡플루언서는 천재지변, 전쟁, 테러 등 불가항력적인 사유로 인해 서비스를 제공하지 못할 경우 책임을 지지 않습니다.\n'
                      '쿡플루언서는 이용자의 귀책 사유로 발생한 손해에 대해 책임을 지지 않습니다.'),
              _buildSection('제12조', '계약 해지 및 서비스 탈퇴',
                  '이용자는 언제든지 서비스 탈퇴를 요청할 수 있으며, 탈퇴 시 서비스 이용 기록 및 개인정보는 삭제됩니다.\n'
                      '쿡플루언서는 이용자가 본 약관을 위반할 경우 서비스 이용 계약을 해지할 수 있습니다.'),
              _buildSection('제13조', '분쟁 해결 및 준거법',
                  '본 약관과 관련된 모든 분쟁은 대한민국 법령을 따르며, 분쟁이 발생할 경우 서비스 제공자의 주소지를 관할하는 법원을 전속 관할로 합니다.\n'
                      '이용자와 쿡플루언서 간의 분쟁은 가능한 상호 협의를 통해 해결하도록 노력합니다.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String sectionNumber, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$sectionNumber $title',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 조 제목 스타일
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16), // 내용 스타일
        ),
        SizedBox(height: 16),
      ],
    );
  }
}