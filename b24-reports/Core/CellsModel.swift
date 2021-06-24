//
//  CellsModel.swift
//  b24-reports
//
//  Created by leomac on 24.06.2021.
//

import Foundation
//import UIKit

struct CellsModel {
    var title: String
    var subTitle: String
    
    static func fetchCells () -> [CellsModel] {
        let firstItem = CellsModel(title: "Новичок", subTitle: "Первый займ 0%")
        let secondItem = CellsModel(title: "Старт", subTitle: "До 5000 руб.")
        
        return [firstItem, secondItem]
    }
}
