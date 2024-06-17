//
//  ViewController.swift
//  ddonawa
//
//  Created by 강한결 on 6/13/24.
//

import UIKit
import SnapKit

class VCSettingProfile: UIViewController {
    var userSelectedId: Int?
    lazy var selectedImageId = 0
    
    private let isSavedUser = User.isSavedUser
    private let profileView = VProfile(
        viewType: .onlyProfileImage,
        isNeedToRandom: true,
        imageArray: genProfileImageArray()
    )
    private let profileImageUpdateView = VButtonUpdateImage()
    private let profileImageUpdateButton = UIButton()
    private let nickField = VUnderlinedTextField(Texts.Placeholders.ONBOARDING_NICK.rawValue)
    private let indicatingLabel = VIndicatingLabel()
    private let confirmButton = VButton(Texts.Buttons.ONBOARDING_CONFIRM.rawValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav(navTitle: Texts.Navigations.ONBOARDING_PROFILE_SETTING.rawValue, left: genLeftGoBackBarButton(), right: nil)
        configureView()
        configureTxF()
        configureProfileImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ProfileImage.getOrSetId != 0 {
            self.setSelectedImageId(ProfileImage.getOrSetId)
        }
    }
}

extension VCSettingProfile {
    
    func configureView() {
        view.backgroundColor = .systemBackground
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        view.addSubview(profileView)
        view.addSubview(profileImageUpdateView)
        profileImageUpdateView.addSubview(profileImageUpdateButton)
        view.addSubview(nickField)
        view.addSubview(indicatingLabel)
        view.addSubview(confirmButton)
        
        profileView.snp.makeConstraints {
            $0.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Figure._profile_lg)
        }
        
        profileImageUpdateView.snp.makeConstraints {
            $0.centerX.equalTo(profileView.snp.centerX).offset(44)
            $0.bottom.equalTo(profileView.snp.bottom).inset(20)
            $0.size.equalTo(36)
        }
        
        profileImageUpdateButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        nickField.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(44)
        }
        
        indicatingLabel.snp.makeConstraints {
            $0.top.equalTo(nickField.snp.bottom).offset(8)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(indicatingLabel.snp.bottom).offset(40)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(56)
        }
    }
    
    private func configureProfileImage() {
        profileImageUpdateButton.addTarget(self, action: #selector(goProfileImageSelectPage), for: .touchUpInside)
    }
    
    private func configureConfirmButton() {
        if confirmButton.isEnabled {
            confirmButton.addTarget(self, action: #selector(saveUser), for: .touchUpInside)
        }
    }
}

extension VCSettingProfile {
    
    @objc
    func endEditing() {
        nickField.endEditing(true)
        nickField.fieldOutFocus()
    }
    
    @objc
    func goProfileImageSelectPage() {
        let vc = VCSelectProfileImage()
        vc.setProfileImage(getProfileImageById(profileView.getPresentImage()))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func saveUser() {
        guard let nickname = nickField.text else { return }
        User.getOrSaveUser = User(
            nickname: nickname,
            image: ProfileImage(
                id: selectedImageId,
                sourceName: getProfileImageById(selectedImageId).sourceName))
        _dismissViewStack(TCMain())
    }
    
    func setSelectedImageId(_ id: Int) {
        selectedImageId = id
        profileView.setImage(getProfileImageById(selectedImageId))
    }
}

extension VCSettingProfile: UITextFieldDelegate {
    private func configureTxF() {
        nickField.delegate = self
        confirmButton.changeColorByDisabled()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nickField.fieldOnFocus()
        indicatingLabel.startEditing()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                if text.count - 1 < 2 {
                    indicatingLabel.isLowerThanTwo()
                    confirmButton.changeColorByDisabled()
                }
                return true
            }
        }
        
        if text.isEmpty {
            indicatingLabel.isEmpty()
            confirmButton.changeColorByDisabled()
        }
        
        if isContainsNumber(string) {
            indicatingLabel.isContainsNumber()
            confirmButton.changeColorByDisabled()
            return false
        }
        
        if isContainsSpecialLetter(string) {
            indicatingLabel.isContainsSpecialLetter()
            confirmButton.changeColorByDisabled()
            return false
        }
        
        if text.count + 1 > 10 {
            nickField.endEditing(true)
            return false
        }
        
        if text.count + 1 < 2 {
            indicatingLabel.isLowerThanTwo()
            confirmButton.changeColorByDisabled()
        } else {
            indicatingLabel.isSuccess()
            confirmButton.changeColorByEnabled()
            configureConfirmButton()
        }
        return true
    }
    
    
    private func isContainsSpecialLetter(_ c: String) -> Bool {
        return c == "@" || c == "#" || c == "$" || c == "%"
    }
    
    private func isContainsNumber(_ c: String) -> Bool {
        return Int(c) != nil
    }
}
