//
//  UploadViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Süleyman Ayyılmaz on 19.01.2024.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yorumTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
    }

    @objc func gorselSec() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func yukleButtonTiklandi(_ sender: Any) {
        // Add your upload logic here

        guard let selectedImage = imageView.image else {
            hataMesajıGoster(title: "Hata", message: "Lütfen bir fotoğraf seçin.")
            return
        }

        guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
            hataMesajıGoster(title: "Hata", message: "Fotoğrafı işlerken bir hata oluştu.")
            return
        }

        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")

        let uuid = UUID().uuidString
        let imageReference = mediaFolder.child("\(uuid).jpeg")

        imageReference.putData(imageData, metadata: nil) { (storageMetadata, error) in

            if let error = error {
                self.hataMesajıGoster(title: "Error", message: error.localizedDescription)
                return
            }

            imageReference.downloadURL { (url, error) in
                if let error = error {
                    self.hataMesajıGoster(title: "Error", message: error.localizedDescription ?? "Hata aldınız, Tekrar Deneyiniz")
                    return
                }

                if let imageUrl = url?.absoluteString {
                    print("Image uploaded successfully. URL: \(imageUrl)")
                    self.uploadToFirestore(imageUrl: imageUrl)
                }
            }
        }
    }

    func uploadToFirestore(imageUrl: String) {
        let firestoreDatabase = Firestore.firestore()

        let firestorePost: [String: Any] = [
            "gorselurl": imageUrl,
            "yorum": yorumTextField.text ?? "",
            "email": Auth.auth().currentUser?.email ?? "",
            "tarih": FieldValue.serverTimestamp()
        ]

        firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
            if let error = error {
                self.hataMesajıGoster(title: "Hata", message: error.localizedDescription ?? "Hata aldınız, Tekrar Deneyiniz")
            } else {
                // Handle success if needed
                
                self.imageView.image = UIImage(named: "add")
                self.yorumTextField.text = ""
                self.tabBarController?.selectedIndex = 0
            }
        }
    }

    func hataMesajıGoster(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
