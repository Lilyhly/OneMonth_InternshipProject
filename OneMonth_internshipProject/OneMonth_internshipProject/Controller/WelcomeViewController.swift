//
//  WelcomeViewController.swift
//  OneMonth_internshipProject
//
//  Created by 洪立妍 on 8/9/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    var userName: String?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        let messageLabel = UILabel()
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)

        if let name = userName {
            messageLabel.text = "\(name)님 환영합니다."
        } else {
            messageLabel.text = "로그인 해주세요"
        }

        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        let logoutButton = UIButton(type: .system)
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        // Add account deletion button
        let deleteAccountButton = UIButton(type: .system)
        deleteAccountButton.setTitle("회원탈퇴", for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
        deleteAccountButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteAccountButton)

        deleteAccountButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    @objc func logoutButtonTapped() {
        UserDefaults.standard.removeObject(forKey: "isLogin")
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func deleteAccountButtonTapped() {
        guard let userId = userId else { return }

        
        
        // Log out user
        UserDefaults.standard.removeObject(forKey: "isLogin")
        navigationController?.popToRootViewController(animated: true)
    }
    
   
}
