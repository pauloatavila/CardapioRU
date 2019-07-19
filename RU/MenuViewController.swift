//
//  MenuViewController.swift
//  RU
//
//  Created by Paulo Atavila on 07/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var viewTamanhoConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewAddiPhoneX: UIView!
    @IBOutlet weak var dataExibicaoLabel: UILabel!
    @IBAction func fecharInfo(_ sender: Any) {
        DispatchQueue.main.async {
            self.infoView.isHidden = true
            if self.iPhoneX {
                self.infoViewAddiPhoneX.isHidden = true
            }
        }
    }
    
    var iPhoneX = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        
        let tamanhoMaximoTela = Int( max(view.frame.width, view.frame.height) )
        if tamanhoMaximoTela >= 812 && UIDevice.current.userInterfaceIdiom != .pad{
            print("iPHONE X or LATTER")
            viewTamanhoConstraint.constant += 20
            iPhoneX = true
        } else {
            print("iphone other => \(tamanhoMaximoTela)")
        }
        
        dataExibicaoLabel.text = dataExibicao()
        
        // Do any additional setup after loading the view.
    }
    
    func fecharMenu(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! MenuTableViewCell
        
        var imagem = ""
        var label = ""
        cell.viewSeparar.isHidden = true
        
        switch indexPath.row {
        case 0...4:
            imagem = "dia"
            if indexPath.row == 0 {
                label = "Segunda-feira"
                if diaSelecionado == "Segunda-feira"{
                    imagem = "diaSelecionado"
                }
            } else if indexPath.row == 1{
                label = "Terça-feira"
                if diaSelecionado == "Terça-feira"{
                    imagem = "diaSelecionado"
                }
            } else if indexPath.row == 2{
                label = "Quarta-feira"
                if diaSelecionado == "Quarta-feira"{
                    imagem = "diaSelecionado"
                }
            } else if indexPath.row == 3{
                label = "Quinta-feira"
                if diaSelecionado == "Quinta-feira"{
                    imagem = "diaSelecionado"
                }
            } else {
                label = "Sexta-feira"
                if diaSelecionado == "Sexta-feira"{
                    imagem = "diaSelecionado"
                }
                cell.viewSeparar.isHidden = false
            }
        case 5:
            imagem = "campus"
            label = "Selecionar Câmpus"
            
        default:
            imagem = "sobre"
            label = "Sobre"
        }
        cell.opcaoImagem.image = UIImage(named: imagem)
        cell.opcaoLabel.text = label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if iPhoneX {
            return 70
        } else {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 5 {
            switch indexPath.row {
            case 0:
                diaSelecionado = "Segunda-feira"
            case 1:
                diaSelecionado = "Terça-feira"
            case 2:
                diaSelecionado = "Quarta-feira"
            case 3:
                diaSelecionado = "Quinta-feira"
            default :
                diaSelecionado = "Sexta-feira"
            }
            self.fecharMenu()
        } else if indexPath.row == 5 {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let alert = UIAlertController(title: "Câmpus", message: "Selecione o câmpus que deseja visualizar o cardápio do RU", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Araguaína", style: .default, handler: { action in
                    print("Araguaína")
                    campusSelecionado = "Araguaína"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Gurupi", style: .default, handler: { action in
                    print("Gurupi")
                    campusSelecionado = "Gurupi"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Palmas", style: .default, handler: { action in
                    print("Palmas")
                    campusSelecionado = "Palmas"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Porto Nacional", style: .default, handler: { action in
                    print("Porto Nacional")
                    campusSelecionado = "Porto Nacional"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: { action in
                    print("Cancelar")
                    tableView.deselectRow(at: indexPath, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Câmpus", message: "Selecione o câmpus que deseja visualizar o cardápio do RU", preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Araguaína", style: .default, handler: { action in
                    print("Araguaína")
                    campusSelecionado = "Araguaína"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Gurupi", style: .default, handler: { action in
                    print("Gurupi")
                    campusSelecionado = "Gurupi"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Palmas", style: .default, handler: { action in
                    print("Palmas")
                    campusSelecionado = "Palmas"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Porto Nacional", style: .default, handler: { action in
                    print("Porto Nacional")
                    campusSelecionado = "Porto Nacional"
                    self.fecharMenu()
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { action in
                    print("Cancelar")
                    tableView.deselectRow(at: indexPath, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            DispatchQueue.main.async {
                self.infoView.isHidden = false
                if self.iPhoneX {
                    self.infoViewAddiPhoneX.isHidden = false
                }
            }
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    //Barra de status branca
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func dataExibicao() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        var texto = ""
        
        switch Calendar.current.component(.weekday, from: date) {
        case 0:
            print("sab")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: -5)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: -1)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 1:
            print("dom")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: 1)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: 5)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 2:
            print("seg")
            let seg = formatter.string(from: date)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: 4)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 3:
            print("ter")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: -1)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: 3)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 4:
            print("qua")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: -2)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: 2)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 5:
            print("qui")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: -3)
            let sex = convertOtherDate(dateString: formatter.string(from: date), valor: 1)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        case 6:
            print("sex")
            let seg = convertOtherDate(dateString: formatter.string(from: date), valor: -4)
            let sex = formatter.string(from: date)
            texto = "De \(arrumaDataString(data: seg)) a \(arrumaDataString(data: sex))"
        default:
            print("default")
        }
        
        return texto
    }
    
    func convertOtherDate(dateString : String, valor: Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        let myDate = dateFormatter.date(from: dateString)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: valor, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(somedateString)")
        return somedateString
    }
    
    func arrumaDataString(data: String) -> String{
        let dataArr = data.components(separatedBy: " ")
        let dia    = dataArr[0]
        let mes = dataArr[1]
        
        return "\(dia)/\(mes)"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
