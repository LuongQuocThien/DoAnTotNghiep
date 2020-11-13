//
//  EditProfileViewController.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Photos

final class EditProfileViewController: ViewController {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var bioTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var emailAddressTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!

    private var imagePicker = UIImagePickerController()
    var viewModel = EditProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getProfile()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        configUI()
    }

    func updateView() {
        thumbnailImageView.setImageWithURL(viewModel.thumbnail)
        firstNameTextField.text = viewModel.firstname
        genderTextField.text = viewModel.gender
        emailAddressTextField.text = viewModel.email
        lastNameTextField.text = viewModel.lastname
        phoneNumberTextField.text = String(viewModel.phone)
        bioTextField.text = viewModel.infomation
    }

    // Firebase
    func updateUIFirebase() {
        thumbnailImageView.setImageWithURL(Session.shared.avatarUrlSring)
        firstNameTextField.text = Session.shared.firstName
        emailAddressTextField.text = Session.shared.email
        lastNameTextField.text = Session.shared.lastName
        phoneNumberTextField.text = ""
        bioTextField.text = ""
    }

    func getProfile() {
        viewModel.getProfile { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
//                this.updateView()
                this.updateUIFirebase()
            case .failure(let error):
                this.alert(error: error)
            }
        }
    }

    private func configUI() {
        thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.size.width / 2
        configNavigationBar()
    }

    private func configNavigationBar() {
        title = App.Profile.edit
        let saveButton = UIBarButtonItem(title: "Lưu lại", style: .plain, target: self, action: #selector(saveChangeProfile))
        navigationItem.rightBarButtonItem = saveButton
    }

    @IBAction private func selectImageButtonTouchUpInside(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose source for avatar image!", preferredStyle: .actionSheet)
        let openGallery = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            guard let this = self else { return }
            this.selectImageFromGallery()
        }
        let openCamera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let this = self else { return }
            this.openCamera()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        actionSheet.addAction(openGallery)
        actionSheet.addAction(openCamera)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - Take image frome Gallery
    private func selectImageFromGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Open Camera
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: Touch Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - ObjectC
    @objc func saveChangeProfile() {
        // TODO: - Send post request to update profile
    }
}

// MARK: - Extension UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbnailImageView.image = selectedImage
        }
    }
}
