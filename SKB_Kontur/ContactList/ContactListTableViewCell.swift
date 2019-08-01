//
//  ContactListTableViewCell.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLBL: UILabel!
    @IBOutlet weak var contactPhoneNumberLBL: UILabel!
    @IBOutlet weak var contactTemperamentLBL: UILabel!
    
    func fillWithContact(_ contact: ContactRealmObject?){
        
        contactNameLBL.text = contact?.name
        contactPhoneNumberLBL.text = contact?.phone
        contactTemperamentLBL.text = contact?.temperament
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
