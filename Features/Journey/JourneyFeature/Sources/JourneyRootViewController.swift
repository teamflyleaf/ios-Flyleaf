//
//  JourneyRootViewController.swift
//  JourneyFeature
//
//  Created by 여성일 on now.
//

import UIKit

public final class JourneyRootViewController: UIViewController {

  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground

    let label = UILabel()
    label.text = "Journey"
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)

    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}