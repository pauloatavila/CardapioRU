//
//  Campus.swift
//  RU
//
//  Created by Paulo Atavila on 04/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import Foundation

class Campus {
    var nomeCampus: String //
    var refeicoesDisponiveis: [String] //
    
    init(nomeCampus: String, refeicoesDisponiveis:[String]){
        self.nomeCampus = nomeCampus
        self.refeicoesDisponiveis = refeicoesDisponiveis
    }
}
