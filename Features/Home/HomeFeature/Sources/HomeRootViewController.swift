//
//  HomeRootViewController.swift
//  Home
//
//  Created by 여성일 on 3/1/26.
//

import UIKit

public final class HomeRootViewController: UIViewController {
  
  public init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    let label = UILabel()
    label.text = "Flyleaf Home"
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
