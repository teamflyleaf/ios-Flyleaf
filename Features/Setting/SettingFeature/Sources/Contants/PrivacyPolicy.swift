//
//  PrivacyPolicy.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

enum PrivacyPolicy {
  enum Update {
    static let content = """
    2026년 4월 21일 마지막으로 업데이트 됨
    """
  }
  
  enum Outline {
    static let title = "개요"
    static let content = """
      Flyleaf (이하 '회사')은 이용자의 개인정보를 소중히 생각하며, 관련 법령을 준수합니다.
      「개인정보 보호법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 등 관련 법령에 따라 이용자의 개인정보를 보호하고 관련한 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보처리방침을 수립·공개합니다.\n
      회사는 본 앱에서 이용자의 개인정보를 수집하거나 저장, 처리하지 않습니다.
      다만, 서비스 운영상 불가피하게 수집될 수 있는 최소한의 정보는 아래와 같이 처리합니다.
      """
  }
  
  enum Section1 {
    static let title = "제1조(개인정보의 수집 및 이용)"
    static let content = """
      회사는 본 애플리케이션(이하 "앱")을 통해 이용자의 개인정보를 직접적으로 수집하지 않습니다.\n
      1. 서비스 이용 과정에서 자동 수집되는 정보
        - 서비스 품질 향상, 오류 분석, 통계 분석 등을 위하여 앱 이용 과정에서 자동으로 생성·수집되는 정보(기기 정보, 운영체제 버전, 이용 기록 등)가 있을 수 있습니다.
      """
  }
  
  enum Section2 {
    static let title = "제2조(자동 수집 정보 및 쿠키)"
    static let content = """
      회사는 앱의 운영 과정에서 자동으로 생성되는 정보(기기명, OS 버전, IP 주소, 접속 기록, 오류 로그 등)만을 수집할 수 있으며, 이용자가 직접 개인정보를 입력하건나 제공해야 하는 경우는 없습니다.
      쿠키는 별도로 사용하지 않습니다.
      """
  }
  
  enum Section3 {
    static let title = "제3조(개인정보의 제3자 제공 및 위탁)"
    static let content = """
      회사는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다.
      단, 법령에 특별한 규정이 있는 경우 또는 수사기관의 요청 등 관련 법령에 따라 제공이 필요한 경우에는 예외로 합니다.
      """
  }
  
  enum Section4 {
    static let title = "제4조(개인정보 보호책임자)"
    static let content = """
      이용자의 개인정보 보호와 관련된 문의, 불만처리, 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정합니다.\n
      - 개인정보 보호책임자: 여성일
      - 이메일: seongil_yeo@naver.com\n
      회사는 수집된 정보를 이용 목적 달성 시 또는 이용자의 요청 시 지체 없이 파기하며, 관련 법령에 따라 보존이 필요한 경우에는 해당 기간 동안 안전하게 보관 후 파기합니다.
      """
  }
  
  enum Section5 {
    static let title = "제5조(권익침해 구제방법)"
    static let content = """
      이용자는 개인정보와 관련된 문의, 신고, 상담이 필요한 경우 아래 기관에 문의할 수 있습니다.\n
      - 개인정보침해센터: 국번없이 118 (privacy.kisa.or.kr)
      - 개인정보분쟁조정위원회: 1833-6972 (www.kopico.go.kr)
      - 대검찰청: 1301 (www.spo.go.kr)
      - 경찰청: 182 (ecrm.cyber.go.kr)
      """
  }
  
  enum Section6 {
    static let title = "제6조(방침의 변경)"
    static let content = """
      본 방침은 관련 법령 및 회사 정책에 따라 변경될 수 있으며, 변경 시 앱 내에 공지합니다.
      """
  }
  
  enum Section7 {
    static let title = "부칙"
    static let content = """
      본 방침은 2026년 4월 21일부터 시행합니다.
      """
  }
}
