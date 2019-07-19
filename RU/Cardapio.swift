//
//  Cardapio.swift
//  RU
//
//  Created by Paulo Atavila on 04/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import Foundation

class Cardapio {
    var tipoPrato: String //
    var descricaoPrato: String //
    var imagem: String //
    
    init(tipoPrato: String, descricaoPrato:String, imagem:String){
        self.tipoPrato = tipoPrato
        self.descricaoPrato = descricaoPrato
        self.imagem = imagem
    }
}
