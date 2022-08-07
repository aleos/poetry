//
//  PoemTitleCell.swift
//  Poetry
//
//  Created by Alexander Ostrovsky on 03.05.16.
//  Copyright © 2016 Alexander Ostrovsky. All rights reserved.
//

import UIKit
import SwiftUI

struct PoemTitleCell: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.custom("SavoyeLetPlain", size: 26))
            .foregroundColor(Color("text"))
    }
}


struct PoemTitleCell_Previews: PreviewProvider {
    static var previews: some View {
        PoemTitleCell(text: "Я здесь")
            .padding()
            .preferredColorScheme(.dark)
    }
}
