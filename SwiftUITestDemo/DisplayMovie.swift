//
//  DisplayMovie.swift
//  SwiftUITestDemo
//
//  Created by Abc on 24/07/17.
//  Copyright © 2017 Websmith Solution. All rights reserved.
//

import Foundation

struct MovieInfo {
    var movieID: Int!
    var title: String!
    var category: String!
    var year: Int!
    var movieURL: String!
    var coverURL: String!
    var watched: Bool!
    var likes: Int!
}

class DisplayMovie: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    let attackers = [ "4 attackers", "5 attackers", "6 attackers" ]
    let setters = [ "2 setters", "1 setter" ]

    @IBOutlet weak var tblMovies: UITableView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var lbl_PickerValue: UILabel!
    
    // MARK: Custom Properties
    
    var movies: [MovieInfo]!
    
    var selectedMovieIndex: Int!
    override func viewDidLoad()
    {
        tblMovies.delegate = self
        tblMovies.dataSource = self
        
        picker.delegate = self
        picker.dataSource = self
        
        updatePickerValue()
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        movies = DBManager.shared.loadMovies()
       
        if(movies == nil)
        {
            let alert = UIAlertController(title: "DBError", message:"" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            //alert.show(ViewController, sender: nil)
            present(alert, animated: true, completion: nil)

        }
        tblMovies.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (movies != nil) ? movies.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentMovie = movies[indexPath.row]
        
        cell.textLabel?.text = currentMovie.title
       // cell.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: currentMovie.coverURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
                }
            }
        }).resume()
        
        return cell
    }
    
    fileprivate func updatePickerValue()
    {
        let attackersFormation = attackers[picker.selectedRow(inComponent: 0)]
        let settersFormation = setters[picker.selectedRow(inComponent: 1)]
        let formation = "\(attackersFormation), \(settersFormation)"
        lbl_PickerValue.text = formation
    }
}
extension DisplayMovie: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? attackers.count : setters.count
    }
}

extension DisplayMovie: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? attackers[row] : setters[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updatePickerValue()
    }
}

extension DisplayMovie: UIPickerViewAccessibilityDelegate
{
    func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
        return component == 0 ? "Attackers Formation" : "Setters Formation"
    }
}

