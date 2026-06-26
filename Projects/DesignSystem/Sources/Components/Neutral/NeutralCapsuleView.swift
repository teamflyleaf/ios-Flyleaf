import UIKit
import SnapKit
import Then

/// 아이콘과 텍스트를 함께 표시하는 캡슐 형태의 라벨 컴포넌트입니다.
///
/// ```swift
/// let capsule = NeutralCapsuleView()
/// capsule.configure(image: .calendar, text: "2026.03.01")
/// ```
///
/// - Note:
///   - Auto Layout 사용 시 별도의 height 제약 없이 intrinsicContentSize를 통해 높이가 결정됩니다.
///   - intrinsicContentSize를 기반으로 크기가 계산되므로, Auto Layout 사용 시 별도의 width 제약이 필요 없습니다.
///   - 높이 24로 고정입니다.
///   - 좌우 패딩은 각각 10로 적용됩니다.
///   - 이미지가 없는 경우 자동으로 숨겨지며, 텍스트만 표시됩니다.
public final class NeutralCapsuleView: BaseView {
  public override var intrinsicContentSize: CGSize {
    let contentWidth = stackView.systemLayoutSizeFitting(
      UIView.layoutFittingCompressedSize
    ).width
    
    return CGSize(width: 10 + contentWidth + 10, height: 24)
  }
  
  // MARK: - UI
  private let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.tintColor = .key0
    $0.snp.makeConstraints {
      $0.width.height.equalTo(12)
    }
  }
  
  private let titleLabel = UILabel().then {
    $0.font = .c3
    $0.textColor = .key0
    $0.numberOfLines = 1
    $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    $0.setContentHuggingPriority(.required, for: .horizontal)
  }
  
  private lazy var stackView = UIStackView(arrangedSubviews: [
    imageView,
    titleLabel
  ]).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 4
  }
  
  public override func configureUI() {
    backgroundColor = .n30
    layer.cornerRadius = 12
    clipsToBounds = true
    
    addSubview(stackView)
  }
  
  public override func setupLayout() {
    snp.makeConstraints {
      $0.height.equalTo(24)
    }
    
    stackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().inset(10)
      $0.centerY.equalToSuperview()
    }
  }
  
  // MARK: - Public Method
  public func configure(
    image: UIImage?,
    text: String
  ) {
    imageView.image = image?.resized(12, 12)
    imageView.isHidden = (image == nil)
    titleLabel.text = text
    
    invalidateIntrinsicContentSize()
  }
}
