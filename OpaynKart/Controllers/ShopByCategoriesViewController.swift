//
//  ShopByCategoriesViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 18/08/21.
//

import UIKit

class ShopByCategoriesViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    //MARK:- Variables
    
    var homeViewModel = ProductsCategoryViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        self.navigationWithBack(navtTitle: "Categories")
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    
}

//MARK:- TableView Delegates

extension ShopByCategoriesViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.home?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoryTableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell") as! CategoryTableViewCell
       
        if !cell.isLayoutDone{
        cell.categoryImage.changeLayout()
        cell.descriptonLbl.changeFontSize()
        cell.titleLbl.changeFontSize()
            cell.isLayoutDone = true
            
            if UIDevice.current.userInterfaceIdiom == .pad{
                cell.categoryImageWidth.constant = 150
                cell.categoryImageHeight.constant = 150
            }
        }
        cell.titleLbl.text = homeViewModel.home?.categories?[indexPath.row].name ?? ""
       // cell.descriptonLbl.text = homeViewModel.home?.categories?[indexPath.row].parent ?? ""
        cell.categoryImage.sd_setImage(with: URL(string: URLS.baseUrl.getDescription() + (homeViewModel.home?.categories?[indexPath.row].image ?? "")), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
