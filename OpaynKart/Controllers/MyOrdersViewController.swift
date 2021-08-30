//
//  MyOrdersViewController.swift
//  OpaynKart
//
//  Created by OPAYN on 17/08/21.
//

import UIKit

class MyOrdersViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtersBtn: UIButton!
    
    //MARK:- Variables
    
    var viewModel = MyOrdersViewModel()
    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        self.navigationWithBack(navtTitle: "My Orders")
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        filtersBtn.changeButtonLayout()
        filtersBtn.changeFontSize()
        self.ordersTableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        myOrdersAPI()
    }
    
    //MARK:- Custom Methods
    
    //MARK:- Objc Methods
    
    //MARK:- IBActions
    
    @IBAction func tappedFilters(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
}

//MARK:- TableView Delegates

extension MyOrdersViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.myorders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "MyOrdersTableViewCell") as! MyOrdersTableViewCell
        cell.orderImage.changeViewLayout()
        cell.orderImage.changeLayout()
        cell.deliveredOnLbl.text = "Order Id: \(viewModel.myorders[indexPath.row].orderID ?? "")"
        cell.productDetailsLbl.text = "Price: $\(viewModel.myorders[indexPath.row].total ?? "")"
        cell.orderImage.sd_setImage(with: URL(string: viewModel.myorders[indexPath.row].products?.first?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "placeholder Image"), options: .highPriority, context: nil)
        let orderDate = Singleton.sharedInstance.UTCToLocal(date: viewModel.myorders[indexPath.row].created_at ?? "", fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "yyyy-MM-dd")
        cell.dateLbl.text = orderDate
        cell.quantityLbl.text = "Total Qty: \(viewModel.myorders[indexPath.row].products?.count ?? 0)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubOrderDetailsViewController") as! SubOrderDetailsViewController
        vc.forIndex = indexPath.row
        vc.viewModel = self.viewModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK:- API Calls

extension MyOrdersViewController{
    
    func myOrdersAPI(){
        Indicator.shared.showProgressView(self.view)
        viewModel.myOrders { isSuccess, message in
            Indicator.shared.hideProgressView()
            if isSuccess{
                self.ordersTableView.reloadData()
            }
            else{
                self.showToast(message: message)
            }
        }
    }
    
}
