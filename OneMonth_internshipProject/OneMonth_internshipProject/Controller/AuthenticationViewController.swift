//
//  WelcomeViewController.swift
//  OneMonth_internshipProject
//
//  Created by 洪立妍 on 8/8/24.
//

import UIKit
import CoreData
import SnapKit



class AuthenticationViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)
    let signUpButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    func setupUI() {
        setupTextField(idTextField, placeholder: "아이디")
        setupTextField(passwordTextField, placeholder: "비밀번호", isSecure: true)

        loginButton.setTitle("로그인", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

        layoutUI()
    }

    func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = isSecure
        view.addSubview(textField)
    }

    func layoutUI() {
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(180)
        }

        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        func saveUserToCoreData(user: User) {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
            newUser.setValue(user.id, forKey: "id")
            newUser.setValue(user.password, forKey: "password")
            newUser.setValue(user.name, forKey: "name")
            newUser.setValue(user.phoneNumber, forKey: "phoneNumber")
            newUser.setValue(user.email, forKey: "email")
            newUser.setValue(user.birthDate, forKey: "birthDate")
            
            do {
                try context.save()
                print("User saved successfully")
            } catch {
                print("Failed to save user: \(error)")
            }
        }
        func retrieveUserFromCoreData(byID id: String) -> User? {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                if let result = try context.fetch(request).first as? NSManagedObject {
                    let user = User(
                        id: result.value(forKey: "id") as! String,
                        password: result.value(forKey: "password") as! String,
                        name: result.value(forKey: "name") as! String,
                        phoneNumber: result.value(forKey: "phoneNumber") as! String,
                        email: result.value(forKey: "email") as! String,
                        birthDate: result.value(forKey: "birthDate") as! String
                    )
                    return user
                }
            } catch {
                print("Failed to retrieve user: \(error)")
            }
            
            return nil
        }
        
        func updateUserInCoreData(user: User) {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "id == %@", user.id)
            
            do {
                if let result = try context.fetch(request).first as? NSManagedObject {
                    result.setValue(user.password, forKey: "password")
                    result.setValue(user.name, forKey: "name")
                    result.setValue(user.phoneNumber, forKey: "phoneNumber")
                    result.setValue(user.email, forKey: "email")
                    result.setValue(user.birthDate, forKey: "birthDate")
                    
                    try context.save()
                    print("User updated successfully")
                }
            } catch {
                print("Failed to update user: \(error)")
            }
        }
        func deleteUserFromCoreData(byID id: String) {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                if let result = try context.fetch(request).first as? NSManagedObject {
                    context.delete(result)
                    try context.save()
                    print("User deleted successfully")
                }
            } catch {
                print("Failed to delete user: \(error)")
            }
        }
    }

    @objc func loginButtonTapped() {
        guard let idToLogin = idTextField.text, !idToLogin.isEmpty,
              let passwordToLogin = passwordTextField.text, !passwordToLogin.isEmpty else {
            // Prompt the user to enter ID and password
            showAlert(message: "아이디와 비밀번호를 입력해주세요")
            return
        }
        
        if let user = retrieveUserFromUserDefaults(forKey: idToLogin), user.password == passwordToLogin {
            UserDefaults.standard.setValue(idToLogin, forKey: "isLogin")

            // Create and present HomeViewController
            let homeViewController = HomeViewController()
            homeViewController.userName = user.name
            homeViewController.userId = idToLogin
            navigationController?.pushViewController(homeViewController, animated: true)
        } else {
            showAlert(message: "로그인 실패했습니다. 아이디 또는 비밀번호를 확인하세요.")
        }
    }
    
    func showAlert(message: String) {
         let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @objc func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        present(signUpViewController, animated: true, completion: nil)
    }
}
