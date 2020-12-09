//
//  EditProfileViewController.swift
//  MyApp
//
//  Created by THIEN LUONG Q. on 3/5/19.
//  Copyright © 2019 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper

protocol EditProfileViewControllerDelegate: class {

    func controller(_ controller: EditProfileViewController, needPerform action: EditProfileViewController.Action)
}

final class EditProfileViewController: ViewController, UINavigationControllerDelegate {

    enum Action {
        case reloadProfile
    }

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var bioTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var emailAddressTextField: UITextField!
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!

    private var imagePicker = UIImagePickerController()
    var viewModel = EditProfileViewModel()
    let datePicker = UIDatePicker()
    let genderPicker: UIPickerView = UIPickerView()
    let gender = ["Nam", "Nữ", "Khác"]
    var avatar: UIImage?
    weak var delegate: EditProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        getProfile()
        configTextField()
        showDatePicker()
        showGenderPicker()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
        configUI()
    }

    func configTextField() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        bioTextField.delegate = self
        genderTextField.delegate = self
        emailAddressTextField.delegate = self
        phoneNumberTextField.delegate = self
        dateOfBirthTextField.delegate = self
        addressTextField.delegate = self
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
        HUD.show()
        var ref: DatabaseReference!
        ref = Database.database().reference(withPath: "response/user")
        ref.queryOrdered(byChild: "email").queryEqual(toValue: Session.shared.email)
            .observe(.value, with: { [weak self] (snapshot) in
                guard let this = self else { return }
                HUD.dismiss()
                let dataSnapShots: [DataSnapshot] = snapshot.children.allObjects as? [DataSnapshot] ?? []
                var items: [[String: Any]] = []
                for data in dataSnapShots {
                    if let jsonObject = data.value as? [String: Any] {
                        items.append(jsonObject)
                    }
                }
                let users = Mapper<NewUser>().mapArray(JSONArray: items)
                guard let user = users.first else { return }
                this.thumbnailImageView.setImageWithURL(user.avatarUrlString)
                this.firstNameTextField.text = user.firstName
                this.lastNameTextField.text = user.lastName
                this.emailAddressTextField.text = user.email
                this.addressTextField.text = user.address
                this.phoneNumberTextField.text = user.phone
                this.dateOfBirthTextField.text = user.dateOfBirth
                this.genderTextField.text = user.gender == 0 ? "Nam" : user.gender == 1 ? "Nữ" : "Khác"
                this.bioTextField.text = user.info

            }) { [weak self] (error) in
                guard let this = self else { return }
                HUD.dismiss()
                this.alert(error: error, handler: nil)
        }
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
        let actionSheet = UIAlertController(title: "", message: "Chọn nguồn để tải ảnh lên", preferredStyle: .actionSheet)
        let openGallery = UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            guard let this = self else { return }
            this.selectImageFromGallery()
        }
        let openCamera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            guard let this = self else { return }
            this.openCamera()
        }
        let cancel = UIAlertAction(title: "Huỷ bỏ", style: .cancel) { _ in }
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

    func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date

        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xác nhận", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ bỏ", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = datePicker
    }

    func showGenderPicker() {
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Xác nhận", style: .plain, target: self, action: #selector(doneGenderPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Huỷ bỏ", style: .plain, target: self, action: #selector(cancelGenderPicker))
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        genderTextField.inputAccessoryView = toolbar

        genderTextField.inputView = genderPicker
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.reloadAllComponents()
    }

    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }

    @objc func doneGenderPicker() {
        genderTextField.text = gender[genderPicker.selectedRow(inComponent: 0)]
        self.view.endEditing(true)
    }

    @objc func cancelGenderPicker() {
        self.view.endEditing(true)
    }

    // MARK: Touch Action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - ObjectC
    @objc func saveChangeProfile() {
        // TODO: - Send post request to update profile
        uploadMedia()
    }

    func uploadMedia() {
        HUD.show()
        guard let avatar = avatar else {
            HUD.dismiss()
            updateProfile(isUpdateAvatar: false, avatarURL: "")
            return
        }

        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("images/comments/\(imageName).jpg")
        if let uploadData = UIImageJPEGRepresentation(avatar, 0.3) {
            storageRef.putData(uploadData, metadata: nil) { [weak self] (metaData, error) in
                guard let this = self else { return }
                HUD.dismiss()
                if let error = error {
                    this.alert(error: error)
                    return
                } else {
                    storageRef.downloadURL(completion: { (url, error) in
                        guard let urlString = url?.absoluteString else { return }
                        this.updateProfile(isUpdateAvatar: true, avatarURL: urlString)
                    })
                }
            }
        }
    }

    func updateProfile(isUpdateAvatar: Bool, avatarURL: String) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let dateOfBirth = dateOfBirthTextField.text,
            let address = addressTextField.text,
            let phone = phoneNumberTextField.text,
            let info = bioTextField.text else { return }

        var data = ["firstName": firstName,
                    "lastName": lastName,
                    "gender": genderPicker.selectedRow(inComponent: 0),
                    "address": address,
                    "dateOfBirth": dateOfBirth,
                    "phone": phone,
                    "info": info] as [String : Any]
        if isUpdateAvatar {
            data["avatar"] = avatarURL
        }

        HUD.show()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("response").child("user").child(Session.shared.userId).updateChildValues(data)

        // set user session
        Session.shared.firstName = firstName
        Session.shared.lastName = lastName
        Session.shared.address = address
        Session.shared.avatarUrlSring = avatarURL

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            HUD.dismiss()
            self.showAlert(title: "", message: "Thay đổi thông tin thành công!", buttons: ["Xác nhận"], handler: { (_) in
                self.delegate?.controller(self, needPerform: .reloadProfile)
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

// MARK: - Extension UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatar = selectedImage
            thumbnailImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
}
