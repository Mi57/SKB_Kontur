//
//  ContactDetailsTableViewCell.swift
//  SKB_Kontur
//
//  Created by Admin on 01/08/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

final class ContactDetailsTableViewCell: UITableViewCell {
    
    weak var delegate: CellAction?
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var educationPeriodLBL: UILabel!
    @IBOutlet weak var temperamentLBL: UILabel!
    @IBOutlet weak var bioLBL: UILabel!
    
    @IBOutlet weak var phoneNumberBTN: UIButton!
    
    @IBAction func makePhoneCall(_ sender: UIButton) {
        delegate?.performCellActionWithType(.phoneCall)
    }
    
    func fillWithContact(_ contact: ContactRealmObject?){
        
        let educationStartDate = contact?.educationPeriod?.start.convertFromStringToDate()
        let educationEndDate = contact?.educationPeriod?.end.convertFromStringToDate()
        nameLBL.text = contact?.name
        educationPeriodLBL.text = (educationStartDate ?? "")
            + " – "
            + (educationEndDate ?? "")
        temperamentLBL.text = contact?.temperament
        phoneNumberBTN.setTitle(contact?.phone, for: .normal)
        bioLBL.text = contact?.biography
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
