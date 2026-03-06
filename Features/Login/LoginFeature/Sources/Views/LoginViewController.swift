//
//  LoginViewController.swift
//  Login
//
//  Created by 여성일 on 3/5/26.
//

import AuthenticationServices
import UIKit
import DesignSystem
import SnapKit
import Then

public final class LoginViewController: BaseViewController {
  private let viewModel: LoginViewModel
  
  public var onLoginSuccess: (() -> Void)?
  
  public init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI
  private let captionLabel = UILabel().then {
    $0.font = .h1
  }
  
  private let subCaptionLabel = UILabel().then {
    $0.text = "독서 여행 기록을 저장하고\n언제든 이어서 읽을 수 있어요"
    $0.numberOfLines = 2
    $0.font = .b1_sb
    $0.textColor = .n20
  }
  
  private let signInButton = ASAuthorizationAppleIDButton().then {
    $0.cornerRadius = 12
  }
  
  override public func configureUI() {
    var highlight = AttributedString("독서 여행")
    highlight.foregroundColor = UIColor.key0
    
    var text = AttributedString("을 떠나볼까요?")
    text.foregroundColor = UIColor.n0
    
    highlight.append(text)
    captionLabel.attributedText = NSAttributedString(highlight)
    
    signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    
    [captionLabel, subCaptionLabel, signInButton].forEach {
      view.addSubview($0)
    }
  }
  
  override public func setupLayout() {
    captionLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(120)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    subCaptionLabel.snp.makeConstraints {
      $0.top.equalTo(captionLabel.snp.bottom).offset(12)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }

    signInButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.height.equalTo(52)
    }
  }
  
  // MARK: - Binding
  public override func bind() {
    viewModel.onLoginSuccess = { [weak self] in
      self?.onLoginSuccess?()
    }
  }
  
  // MARK: - Action
  @objc func didTapSignIn() {
    print("tap")
    let provider = ASAuthorizationAppleIDProvider()
    let request = provider.createRequest()
    
    request.requestedScopes = [.fullName, .email]
    
    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

// MARK: - Method
extension LoginViewController {
  private func presentErrorAlert(message: String) {
    let alert = UIAlertController(
      title: "로그인 실패",
      message: message,
      preferredStyle: .alert
    )

    let confirmAction = UIAlertAction(title: "확인", style: .default)
    alert.addAction(confirmAction)

    present(alert, animated: true)
  }
}

// MARK: - Delegate
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    guard let window = view.window else {
      fatalError("LoginViewController must be in window hierarchy before presenting Apple Sign In.")
    }
    return window
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: any Error
  ) {
    let nsError = error as NSError
    
    if nsError.domain == ASAuthorizationError.errorDomain,
       let code = ASAuthorizationError.Code(rawValue: nsError.code) {
      switch code {
      case .canceled:
        break
      case .failed, .invalidResponse, .notHandled, .unknown:
        presentErrorAlert(message: "로그인에 실패했어요. 다시 시도해주세요.")
      @unknown default:
        presentErrorAlert(message: "알 수 없는 오류가 발생했어요")
      }
    } else {
      presentErrorAlert(message: "알 수 없는 오류가 발생했어요")
    }
  }
  
  public func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      print("Unexpected Credential")
      return
    }
    
    let userId = credential.user
    let email = credential.email ?? "(nil: only on first sign-in)"
    let fullName = [credential.fullName?.familyName, credential.fullName?.givenName]
      .compactMap { $0 }
      .joined()
    
    print("Apple Login Success")
    print("userId: \(userId)")
    print("Email: \(email)")
    print("FullName: \(fullName)")
    
    if let tokenData = credential.identityToken,
       let token = String(data: tokenData, encoding: .utf8) {
      print("identityToken: \(token)")
    } else {
      print("identityToken: nil")
    }
    
    viewModel.handleLoginSuccess()
  }
}
