//
//  TermsOfService.swift
//  Setting
//
//  Created by 여성일 on 4/21/26.
//

enum TermsOfService {
  enum Section1 {
    static let title = "제1조(목적)"
    static let content = """
      이 약관은 Flyleaf(이하 '회사')가 제공하는 서비스의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
      """
  }
  
  enum Section2 {
    static let title = "제2조(정의)"
    static let content = """
      '이용자'란 본 약관에 따라 회사가 제공하는 서비스를 이용하는 모든자를 말합니다.
      """
  }
  
  enum Section3 {
    static let title = "제3조(약관의 효력 및 변경)"
    static let content = """
      본 약관은 서비스 내에 게시함으로써 효력이 발생합니다.
      회사는 관련 법령을 위배하지 않는 범위 내에서 약관을 변경할 수 있으며, 변경 시 서비스 내에 공지합니다.
      """
  }
  
  enum Section4 {
    static let title = "제4조(서비스의 제공 및 변경)"
    static let content = """
      회사는 연중무휴, 1일 24시간 서비스를 제공합니다.
      단, 시스템 점검 등 불가피한 사유가 있는 경우 서비스 제공이 일시 중단될 수 있습니다.
      서비스의 내용은 회사의 정책에 따라 변경될 수 있습니다.
      """
  }
  
  enum Section5 {
    static let title = "제5조(개인정보보호)"
    static let content = """
      회사는 본 서비스 이용과 관련하여 최소한의 개인정보만을 수집·이용합니다.
      회사는 이용자의 개인정보를 별도로 저장하거나 로그인·회원정보와 연계하지 않습니다.
      기타 개인정보 관련 사항은 별도의 개인정보처리방침에 따릅니다.
      """
  }
  
  enum Section6 {
    static let title = "제6조(저작권)"
    static let content = """
      서비스 내 제공되는 책 정보, 이미지 등 모든 컨텐츠의 저작권은 해당 원저작자 또는 정당한 권리자에게 귀속됩니다.\n
      이용자는 회사가 정한 범위 내에서만 이를 개인적, 비상업적 용도로 이용할 수 있으며, 이를 위반하여 발생하는 문제에 대한 책임은 이용자 본인에게 있습니다.
      """
  }
  
  enum Section7 {
    static let title = "제7조(면책)"
    static let content = """
      회사는 천재지변 등 불가항력 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.
      또한 이용자의 귀책사유로 인한 서비스 이용 장애에 대해서도 책임을 지지 않습니다.
      """
  }
  
  enum Section8 {
    static let title = "제8조(관할법원 및 준거법)"
    static let content = """
      서비스와 관련된 분쟁은 대한민국 법을 적용하며, 관할법원은 민사소송법에 따릅니다.
      """
  }
  
  enum Section9 {
    static let title = "부칙"
    static let content = """
      본 약관은 2026년 4월 21일부터 시행합니다.
      """
  }
}
