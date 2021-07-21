//
//  EmployeeTableViewCell.swift
//  test2
//
//  Created by Карина Каримова on 26.06.2021.
//


import UIKit
import Contacts
import ContactsUI

class EmpoyeeCell: UITableViewCell {
    var safeArea: UILayoutGuide!
    let contactsIcon = UIButton(type: .custom)
    var contacts = EmployeeViewModel()
    var onTap: ((CNContact) -> Void)?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        safeArea = layoutMarginsGuide
        setupButton()
    }
    
    func setupButton(){
        
        contactsIcon.setImage(UIImage(named: K.contactIcon), for: .normal)
        
        contentView.addSubview(contactsIcon)
        
        contactsIcon.translatesAutoresizingMaskIntoConstraints = false
        contactsIcon.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        contactsIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contactsIcon.widthAnchor.constraint(equalToConstant: 35).isActive = true
        contactsIcon.heightAnchor.constraint(equalToConstant: 35).isActive = true
        contactsIcon.addTarget(self,
                               action: #selector(buttonAction),
                               for: .touchUpInside)
    }
    
    func check(str: String){
        if contacts.matchContacts(str){
            contactsIcon.isHidden = false
        } else {
            contactsIcon.isHidden = true
        }
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        if let data = contacts.contact{
            onTap?(data)
        }
    }
}

