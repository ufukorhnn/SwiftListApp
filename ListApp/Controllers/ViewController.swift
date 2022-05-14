//
//  ViewController.swift
//  ListApp
//
//  Created by Ufuk Orhan on 13.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var alertController = UIAlertController()

    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func didRemoveButtonItemTapped(_ sender: UIBarButtonItem) {
        presentAlert(title: "Uyari",
                     message: "Listedeki butun ogeleri silmek istediginizden emin misiniz?",
                     defaultButtonTitle: "Evet",
                     cancelButtonTitle: "Vazgec") { _ in
            self.data.removeAll()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func didAddBarButtonItemTapped(_ sender: UIBarButtonItem){
        presentAddAlert()
    }
    
    func presentAddAlert() {
        
        presentAlert(title: "Yeni Eleman Ekle",
                     message: nil,
                     defaultButtonTitle: "Ekle",
                     cancelButtonTitle: "Vazgec",
                     isTextFieldAvailable: true,
                     defaultButtonHandle: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                    self.data.append((text)!)
                    self.tableView.reloadData()
                    }
            
                    else {
                        self.presentWarningAlert()
                    }
                })
    }
    
    func presentWarningAlert() {
        presentAlert(title: "Uyari",
                     message: "Liste elemani bos olamaz!",
                     cancelButtonTitle: "Tamam")
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      prefferedStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonHandle: ((UIAlertAction) -> Void)? = nil) {
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
        
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandle)
            alertController.addAction(defaultButton)

        }
        let cancelButton = UIAlertAction(title: cancelButtonTitle, style: .cancel)
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
            
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.presentAlert(title: "Elemani Duzenle",
                             message: nil,
                             defaultButtonTitle: "Duzenle",
                             cancelButtonTitle: "Vazgec",
                             isTextFieldAvailable: true,
                             defaultButtonHandle: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != "" {
                    self.data[indexPath.row] = text!
                        self.tableView.reloadData()
                        }
                
                        else {
                            self.presentWarningAlert()
                        }
                    })
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }
    
}
