//
//  ViewController.swift
//  OneMonth_internshipProject
//
//  Created by 洪立妍 on 8/8/24.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {

    var usersDictionary: [String: User] = [:]

    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let nameTextField = UITextField()
    let phoneNumberTextField = UITextField()
    let emailTextField = UITextField()
    let birthDateTextField = UITextField()
    let signUpButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setupUI()
    }

    func setupUI() {
        setupTextField(idTextField, placeholder: "아이디")
        setupTextField(passwordTextField, placeholder: "비밀번호", isSecure: true)
        setupTextField(confirmPasswordTextField, placeholder: "비밀번호 확인", isSecure: true)
        setupTextField(nameTextField, placeholder: "이름")
        setupTextField(phoneNumberTextField, placeholder: "전화번호")
        setupTextField(emailTextField, placeholder: "이메일", keyboardType: .emailAddress)
        setupTextField(birthDateTextField, placeholder: "생년월일")

        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)

        layoutUI()
    }

    func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
        view.addSubview(textField)
    }

    func layoutUI() {
        let padding: CGFloat = 70

        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        birthDateTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(birthDateTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }

    @objc func signUpButtonTapped() {
        // Execute user sign-up logic here
        guard let id = idTextField.text, !id.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty,
              let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let birthDate = birthDateTextField.text, !birthDate.isEmpty else {
            // Prompt the user to enter complete information
            showAlert(message: "모든 필수 정보를 입력해주세요")
            return
            
        }
        
        // Check if the ID is already taken
        if usersDictionary[id] != nil {
            showAlert(message: "이미 사용 중인 아이디입니다.")
            return
        }
        
        // Check if passwords match
        if password != confirmPassword {
            showAlert(message: "비밀번호가 일치하지 않습니다")
            return
        }
        
        let newUser = User(id: id, password: password, name: name, phoneNumber: phoneNumber, email: email, birthDate: birthDate)
        usersDictionary[id] = newUser

        // Save user to UserDefaults using encoding
        saveUserToUserDefaults(newUser, forKey: id)

        // After successful registration, you can navigate to another page or display a success message
        showAlert(message: "회원가입 성공했습니다!")
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
