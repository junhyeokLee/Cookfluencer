import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
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
          '개인정보 처리방침',
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
              _buildSection('제1조', '개인정보 수집 항목 및 방법',
                  '수집 항목:\n'
                      '이름, 이메일 주소 (회원 가입 시)\n'
                      '서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보 (서비스 이용 시)\n\n'
                      '수집 방법:\n'
                      '회원가입, 서비스 이용, 고객 문의, 이벤트 참여 등의 과정을 통해 개인정보 수집\n'
                      '자동 수집 장치를 통한 정보 수집 (예: 쿠키)'),
              _buildSection('제2조', '개인정보의 수집 및 이용 목적',
                  '회사는 수집한 개인정보를 다음의 목적을 위해 사용합니다:\n'
                      '회원 관리: 회원제 서비스 제공, 본인 확인\n'
                      '서비스 제공: 콘텐츠 제공, 맞춤형 서비스 제공\n'
                      '서비스 개선: 서비스 이용 기록 분석을 통한 서비스 개선\n'
                      '마케팅 및 광고: 이벤트 및 광고성 정보 제공 (동의한 경우에 한함)'),
              _buildSection('제3조', '개인정보의 보유 및 이용 기간',
                  '회사는 원칙적으로 개인정보 수집 및 이용 목적이 달성된 후에는 해당 정보를 지체 없이 파기합니다. '
                      '다만, 관련 법령에 따라 보관해야 하는 경우는 다음과 같습니다:\n'
                      '계약 또는 청약 철회 등에 관한 기록: 5년\n'
                      '대금 결제 및 재화 등의 공급에 관한 기록: 5년\n'
                      '소비자 불만 또는 분쟁 처리에 관한 기록: 3년'),
              _buildSection('제4조', '개인정보의 제3자 제공',
                  '회사는 이용자의 개인정보를 원칙적으로 외부에 제공하지 않습니다. 다만, 다음의 경우에 한해 개인정보를 제3자에게 제공할 수 있습니다:\n'
                      '이용자가 사전에 동의한 경우\n'
                      '법령의 규정에 의하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우'),
              _buildSection('제5조', '개인정보 처리의 위탁',
                  '회사는 원활한 서비스 제공을 위해 일부 업무를 외부에 위탁할 수 있으며, 이 경우 개인정보 보호를 위해 필요한 조치를 취합니다. '
                      '위탁된 업무의 내용과 수탁자는 다음과 같습니다:\n'
                      '위탁 업무: \n'
                      '수탁자: '),
              _buildSection('제6조', '이용자의 권리 및 행사 방법',
                  '이용자는 언제든지 자신의 개인정보에 대한 열람, 수정, 삭제, 처리 정지 요청을 할 수 있습니다. '
                      '이를 위해 아래의 연락처로 문의하시면, 지체 없이 조치를 취하겠습니다:\n'
                      '이메일: qkrrkawk77@naver.com\n'
                      '전화번호: '),
              _buildSection('제7조', '개인정보 보호를 위한 기술적/관리적 조치',
                  '회사는 이용자의 개인정보를 안전하게 관리하기 위해 다음과 같은 기술적 및 관리적 보호 조치를 시행하고 있습니다:\n'
                      '개인정보를 암호화하여 저장 및 관리\n'
                      '해킹 등 외부 침입에 대비한 보안 시스템 구축\n'
                      '개인정보 취급 직원에 대한 정기적인 교육 실시'),
              _buildSection('제8조', '개인정보의 파기 절차 및 방법',
                  '회사는 개인정보 보유 기간의 경과, 처리 목적 달성 등 개인정보가 불필요하게 되었을 때에는 해당 정보를 지체 없이 파기합니다. '
                      '파기 절차 및 방법은 다음과 같습니다:\n'
                      '파기 절차: 개인정보 보유 기간이 경과한 정보는 내부 방침 및 관련 법령에 따라 파기\n'
                      '파기 방법: 전자적 파일 형태의 정보는 복구 불가능한 방법으로 삭제, 종이 문서 형태의 정보는 분쇄'),
              _buildSection('제9조', '개인정보 처리방침의 변경',
                  '회사는 관련 법령의 개정 또는 내부 방침 변경에 따라 개인정보 처리방침을 변경할 수 있으며, 변경 내용은 시행일 7일 전에 공지합니다.'),
              _buildSection('제10조', '문의',
                  '개인정보 처리방침에 관한 문의 사항이 있으면 아래의 연락처로 문의해 주시기 바랍니다:\n'
                      '이메일: qkrrkawk77@naver.com\n'
                      '전화번호: '),
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