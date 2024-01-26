//
//  FeedViewController.swift
//  FotografPaylasmaUygulamasi
//
//  Created by Süleyman Ayyılmaz on 19.01.2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var emailDizisi = [String]()
    var yorumDizisi = [String]()
    var gorselDizisi = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        firebaseVeriAl()
    }

    func firebaseVeriAl() {
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Post").order(by: "tarih", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot else {
                print("Snapshot is nil.")
                return
            }

            // Temizleme işlemini buraya ekledik
            self.emailDizisi.removeAll(keepingCapacity: false)
            self.gorselDizisi.removeAll(keepingCapacity: false)
            self.yorumDizisi.removeAll(keepingCapacity: false)

            for document in snapshot.documents {
                if let gorselUrl = document.get("gorselurl") as? String {
                    self.gorselDizisi.append(gorselUrl)
                }
                if let yorum = document.get("yorum") as? String {
                    self.yorumDizisi.append(yorum)
                }
                if let email = document.get("email") as? String {
                    self.emailDizisi.append(email)
                }
            }

            // Reload the table view data after fetching data
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailDizisi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.emailText.text = emailDizisi[indexPath.row]
        cell.yorumText.text = yorumDizisi[indexPath.row]
        cell.postİmageView.sd_setImage(with: URL(string: self.gorselDizisi[indexPath.row]))
        return cell
    }
}
