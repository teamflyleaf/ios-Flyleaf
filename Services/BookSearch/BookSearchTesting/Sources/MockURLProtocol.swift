//
//  MockURLProtocol.swift
//  BookSearch
//
//  Created by 여성일 on 4/9/26.
//

import Foundation

public final class MockURLProtocol: URLProtocol {
  /// 요청을 처리할 클로저입니다.
  ///
  /// 테스트 코드에서 설정하며,
  /// 들어온 `URLRequest`에 대해 원하는 `URLResponse`와 `Data`를 반환합니다.
  ///
  /// - Returns:
  ///   - URLResponse: 서버 응답 (HTTPURLResponse 또는 일반 URLResponse)
  ///   - Data: 응답 데이터 (JSON 등)
  ///
  /// - Throws:
  ///   - 에러를 던지면 네트워크 에러 상황을 시뮬레이션할 수 있습니다.
  public static var requestHandler: ((URLRequest) throws -> (URLResponse?, Data))?
  
  /// 해당 요청을 이 Protocol이 처리할지 여부를 결정합니다.
  ///
  /// - Returns: 항상 true → 모든 요청을 가로챔
  public override class func canInit(with request: URLRequest) -> Bool {
    true
  }
  
  /// 요청을 canonical form으로 변환합니다.
  /// 여기서는 별도 처리 없이 그대로 반환합니다.
  public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    request
  }
  
  /// 실제 요청을 처리하는 핵심 메서드입니다.
  ///
  /// URLSession이 네트워크 요청을 시작하면 이 메서드가 호출됩니다.
  ///
  /// 동작 흐름:
  /// 1. requestHandler 실행
  /// 2. response 전달
  /// 3. data 전달
  /// 4. 완료 처리
  public override func startLoading() {
    guard let handler = Self.requestHandler else {
      fatalError("MockURLProtocol.requestHandler가 설정되지 않았습니다.")
    }
    
    do {
      // 테스트에서 정의한 mock 응답 생성
      let (response, data) = try handler(request)
      
      // 1. response 전달
      if let response {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
      }
      
      // 2. data 전달
      client?.urlProtocol(self, didLoad: data)
      
      // 3. 요청 완료
      client?.urlProtocolDidFinishLoading(self)
    } catch {
      // 에러 발생 시 네트워크 실패로 전달
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  /// 요청 취소 시 호출됩니다.
  ///
  /// 현재 mock에서는 별도 처리 없음
  public override func stopLoading() {}
}
