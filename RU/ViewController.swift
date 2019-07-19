//
//  ViewController.swift
//  RU
//
//  Created by Paulo Atavila on 03/10/2018.
//  Copyright © 2018 Paulo Atavila. All rights reserved.
//

import UIKit
import SystemConfiguration //para verificacao de conexao com a internet

//------------ Campus ----------------

struct campusDisponivel:Decodable {
    let campusDisponiveis: [campus]
}

struct campus:Decodable {
    let nomeCampus: String
    let tiposRefeicoes: [tipoRefeicao]
}

struct tipoRefeicao:Decodable {
    let nome: String
}

//----------- Cardapio ---------------

struct campusList:Decodable {
    let campusList: [itensCampus]
}

struct itensCampus:Decodable {
    let nomeCampus: String
    let segunda: itensDia?
    let terca: itensDia?
    let quarta: itensDia?
    let quinta: itensDia?
    let sexta: itensDia?
}

struct itensDia:Decodable {
    let data: String
    let refeicoes: [refeicao]
}

struct refeicao:Decodable {
    let nomeRefeicao: String
    let itens: [tipoItem]
}

struct tipoItem:Decodable{
    let tipoItem: String
    let itens: [itensTipo]
}

struct itensTipo:Decodable{
    let nome: String
}

var cardapioRU:campusList = campusList(campusList: [])
var campusRU:campusDisponivel = campusDisponivel(campusDisponiveis: [])

//variaveis
var campusSelecionado = "Palmas"
var refeicaoSelecionada = "Almoço"
var diaSelecionado = "Segunda-feira"


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //itens da tela
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refeicaoSwitch: UISegmentedControl!
    @IBOutlet weak var diaLabel: UILabel!
    @IBAction func refeicaoSwitchBtt(_ sender: Any) {
        DispatchQueue.main.async {
            refeicaoSelecionada = self.refeicaoSwitch.titleForSegment(at: self.refeicaoSwitch.selectedSegmentIndex) ?? "KAKAKA"
            self.getItensMostrar()
            
        }
        
    }
    @IBOutlet weak var campusCarregando: UIActivityIndicatorView!
    @IBOutlet weak var carregandoCardapioView: CardView!
    @IBOutlet weak var conexaoInternetView: CardView!
    @IBAction func menuBtt(_ sender: Any) {
        print("menu")
        
        let menuView = storyboard?.instantiateViewController(withIdentifier: "MenuView")
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        present(menuView!, animated: false, completion: nil)
    }
    @IBOutlet weak var naoCadastradoView: CardView!
    @IBOutlet weak var ruLabel: UILabel!
    
    
    //itens tela - mudar para iphone X
    @IBOutlet weak var tableConstraintBaixo: NSLayoutConstraint!
    @IBOutlet weak var viewGeralConstraintTamanho: NSLayoutConstraint!
    
    
    
    var cardapio: [Cardapio] = []
    var campusRefeicoes: [Campus] = []
    
    var mostrarCardapio = false
    
    var downloadJsonS = false
    
    var atualizandoTable = false
    
    lazy var refresher: UIRefreshControl = {
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(downloadTudo), for: .valueChanged)
//        if isConnectedToNetwork() {
        
//        } else {
//            DispatchQueue.main.async {
//                self.conexaoInternetView.isHidden = true
//                print("SEM CONEXAO - REFRESH")
//            }
//        }
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DID LOAD")
        
        //dia que é hoje
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MM yyyy"
        
        switch Calendar.current.component(.weekday, from: date) {
        case 0:
            print("sab")
            diaSelecionado = "Sexta-feira"
        case 1:
            print("dom")
            diaSelecionado = "Segunda-feira"
        case 2:
            print("seg")
            diaSelecionado = "Segunda-feira"
        case 3:
            print("ter")
            diaSelecionado = "Terça-feira"
        case 4:
            print("qua")
            diaSelecionado = "Quarta-feira"
        case 5:
            print("qui")
            diaSelecionado = "Quinta-feira"
        case 6:
            print("sex")
            diaSelecionado = "Sexta-feira"
        default:
            print("default")
            diaSelecionado = "Segunda-feira"
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        campusCarregando.isHidden = true
        tableView.refreshControl = refresher
        
        let tamanhoMaximoTela = Int( max(view.frame.width, view.frame.height) )
        if tamanhoMaximoTela >= 812 && UIDevice.current.userInterfaceIdiom != .pad{
            print("iPHONE X or LATTER")
            tableConstraintBaixo.constant += 34
            viewGeralConstraintTamanho.constant += 20
        } else {
            print("iphone other => \(tamanhoMaximoTela)")
        }
        
        
//        var arrayTeste: [Int] = [1,2,3]
//        arrayTeste.remove(at: 1)
//        var index = 4
//        if index > arrayTeste.count {
//
//            index = arrayTeste.count
//            print("mudou index: \(index)")
//        }
//
//        arrayTeste.insert(4, at: index)
//
//        print("ARRAY: ")
//        for itn in arrayTeste {
//            print(itn)
//        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        diaLabel.text = diaSelecionado
        ruLabel.text = "RU \(campusSelecionado)"
        if !downloadJsonS {
            downloadTudo()
//            if isConnectedToNetwork() {
//
//            } else {
//                DispatchQueue.main.async {
//                    self.conexaoInternetView.isHidden = true
//                    print("SEM CONEXAO - DID APPEAR")
//                }
//            }
        } else {
            getTipoRefeicaoCampus()
            getItensMostrar()
        }
        
    }
    
    //FUNCOES DE DOWNLOAD
    @objc
    func downloadTudo(){
        cardapio.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.carregandoCardapioView.isHidden = false
        }
        print("******** Download\n\n")
        downloadJSONCampus()
        downloadJSONCardapio()
    }
    
    func downloadJSONCampus(){
        let jsonUrlStringCampus = "https://sistemas.uft.edu.br/cardapioru/api/campus.json"
        guard let urlCampus = URL(string: jsonUrlStringCampus) else { return }
        
        
        URLSession.shared.dataTask(with: urlCampus) { (data, response, err) in
            guard let data = data else { return }
            
            self.mostrarCardapio = false
            
            DispatchQueue.main.async {
                self.campusCarregando.isHidden = false
                self.campusCarregando.startAnimating()
                self.carregandoCardapioView.isHidden = false
            }
            
            do {
                campusRU = try JSONDecoder().decode(campusDisponivel.self, from: data)
                print(campusRU.campusDisponiveis[0].nomeCampus)
            } catch let jsonErr {
                print("Error serializing json campus: ", jsonErr)
            }
            
            DispatchQueue.main.async {
                self.campusCarregando.isHidden = true
                self.campusCarregando.stopAnimating()
            }
            self.getTipoRefeicaoCampus()
            }.resume()
    }
    
    func downloadJSONCardapio(){
        let jsonUrlStringCardapio = "https://sistemas.uft.edu.br/cardapioru/api/refeicao/semana/v2.json"
        guard let urlCardapio = URL(string: jsonUrlStringCardapio) else { return }
        
        
        URLSession.shared.dataTask(with: urlCardapio) { (data, response, err) in
            guard let data = data else { return }
            print("\n\n\n\n--------------CARDAPIO-------------")
            do {
                cardapioRU = try JSONDecoder().decode(campusList.self, from: data)
//                print(cardapioRU.campusList[1].nomeCampus)
            } catch let jsonErr {
                print("Error serializing json cardapio: ", jsonErr)
            }
            if self.mostrarCardapio {
                self.getItensMostrar()
            }
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
            }
            
            }.resume()
    }
    
    //FUNCOES DE MONTAR O CARDAPIO NA TELA
    func getTipoRefeicaoCampus(){
        campusRefeicoes.removeAll()
        DispatchQueue.main.async {
            self.refeicaoSwitch.removeAllSegments()
        }
        
        
        for campus in campusRU.campusDisponiveis {
            let nomeCamp = campus.nomeCampus
            var refeicoes:[String] = []
            var temCafe = false
            var temAlmoco = false
            var temJantar = false
            for ref in campus.tiposRefeicoes {
                refeicoes.append(ref.nome)
                if ref.nome == "Café"{
                    temCafe = true
                } else if ref.nome == "Almoço" {
                    temAlmoco = true
                } else {
                    temJantar = true
                }
            }
            campusRefeicoes.append(Campus(nomeCampus: nomeCamp, refeicoesDisponiveis: refeicoes))
            if nomeCamp == campusSelecionado {
                
                var index = 0
                if temCafe {
                    DispatchQueue.main.async {
                        self.refeicaoSwitch.insertSegment(withTitle: "Café", at: index, animated: true)
                        index += 1
                    }
                }
                if temAlmoco {
                    DispatchQueue.main.async {
                        self.refeicaoSwitch.insertSegment(withTitle: "Almoço", at: index, animated: true)
                        index += 1
                    }
                }
                if temJantar {
                    DispatchQueue.main.async {
                        self.refeicaoSwitch.insertSegment(withTitle: "Jantar", at: index, animated: true)
                        index += 1
                    }
                }
                DispatchQueue.main.async {
                    self.refeicaoSwitch.selectedSegmentIndex = 0
                    self.carregandoCardapioView.isHidden = true
                }
                self.refeicaoSwitchBtt((Any).self)
                mostrarCardapio = true
            }
        }
        
    }
    
    
    func getItensMostrar(){
        
        cardapio.removeAll()
        
        var tipoOrdena = 2
        if refeicaoSelecionada == "Almoço" || refeicaoSelecionada == "Jantar" {
            tipoOrdena = 1
        }
        
        print("REFEICAO SELECIONADA: \(refeicaoSelecionada)")
        
        print("NUM de refeicoes: \(cardapioRU.campusList.count)")
        
        var achouCampus = false
        
        for campus in cardapioRU.campusList {
            if campus.nomeCampus == campusSelecionado {
                
                achouCampus = true
                
                var diaSel:itensDia?
                
                print("dia selecionado: \(diaSelecionado)")
                
                switch diaSelecionado {
                case "Segunda-feira":
                    print("seg")
                    diaSel = campus.segunda
                    
                case "Terça-feira":
                    
                    diaSel = campus.terca
                    
                case "Quarta-feira":
                    diaSel = campus.quarta
                    
                case "Quinta-feira":
                    diaSel = campus.quinta
                    
                case "Sexta-feira":
                    diaSel = campus.sexta
                    
                default:
                    print("erro?")
                }
                
                if diaSel != nil {
                    DispatchQueue.main.async {
                        self.naoCadastradoView.isHidden = true
//                        self.conexaoInternetView.isHidden = true
                    }
                    for refeicao in (diaSel?.refeicoes)! {
                        if refeicao.nomeRefeicao == refeicaoSelecionada {
                            for card in refeicao.itens {
                                let tipo = card.tipoItem
                                var descricao = ""
                                var flag = 0
                                
                                for opcoes in card.itens {
                                    if flag == 0 {
                                        descricao = opcoes.nome.capitalizingFirstLetter()
                                    } else if flag == card.itens.count-1{
                                        descricao += " e \(opcoes.nome.lowercased())"
                                    } else {
                                        descricao += ", \(opcoes.nome.lowercased())"
                                    }
                                    flag += 1
                                }
                                cardapio.append(Cardapio(tipoPrato: tipo, descricaoPrato: descricao, imagem: getImagem(tipoItem: tipo)))
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.naoCadastradoView.isHidden = false
//                        self.conexaoInternetView.isHidden = true
                    }
                    print("Cardápio não adicionado")
                }
                DispatchQueue.main.async {
                    self.ordenaRefeicao(tipo: tipoOrdena)
                    self.tableView.reloadData()
                    if self.cardapio.count > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
                    }
                }
                
            }
        }
        if !achouCampus {
            DispatchQueue.main.async {
                self.naoCadastradoView.isHidden = false
//                self.conexaoInternetView.isHidden = true
            }
        }
    }
    
    func getImagem(tipoItem: String)->String{
        switch tipoItem {
        case "Acompanhamento":
            return "acompanhamento"
        case "Suco":
            return "suco"
        case "Salada":
            return "salada"
        case "Guarnição":
            return "guarnicao"
        case "Prato Principal":
            return "principal"
        case "Sobremesa":
            return "sobremesa"
        case "Opção Vegetariana":
            return "vegetariano"
        case "Bebidas":
            return "bebidas"
        case "Produtos de Panificação":
            return "panificacao"
        case "Frios":
            return "frios"
        case "Acompanhamentos":
            return "acompanhamentos"
        case "Frutas":
            return "frutas"
        case "Outras Preparações":
            return "preparacoes"
        default:
            return "vegetariano"
        }
    }
    
    
    //CONFIGURANDO A TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardapio.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RefeicaoTableViewCell
        
        let item = cardapio[indexPath.row]
        
        cell.itemRefeicao.text = item.tipoPrato
        cell.itemImagem.image = UIImage(named: item.imagem)
        cell.itemDescricao.text = item.descricaoPrato
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 142
    }
    
    //Barra de status branca
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func ordenaRefeicao(tipo: Int){
        
        var sequencia: [String]
        
        if tipo == 1 {
            sequencia = ["Salada", "Acompanhamento", "Guarnição", "Prato Principal", "Opção Vegetariana", "Suco", "Sobremesa"]
        } else {
            sequencia = ["Produtos de Panificação", "Frios", "Acompanhamentos", "Outras Preparações", "Bebidas", "Frutas"]
        }
        
        var cardapioOrdenado: [Cardapio] = []
        
        for it in sequencia {
            for tipo in cardapio {
                if tipo.tipoPrato == it {
                    cardapioOrdenado.append(tipo)
                }
            }
        }
        
        cardapio = cardapioOrdenado
        
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
