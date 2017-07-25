//
//  ViewController.swift
//  SwiftUITestDemo
//
//  Created by Abc on 22/07/17.
//  Copyright © 2017 Websmith Solution. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,XMLParserDelegate
{
    @IBOutlet weak var txt_Username: UITextField!
    @IBOutlet weak var txt_Password: UITextField!
    @IBOutlet weak var tbl_City: UITableView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var lbl_Vol: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    
    var mutableData = NSMutableData()
    var dataString = NSMutableString()
    var currentElementName:NSString = ""
    
    var refreshControl = UIRefreshControl()
    var alert = UIAlertController()
    
    var arr_CityName = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tbl_City.isEditing = true
        tbl_City.isHidden = true
        arr_CityName = ["Rajkot","Surat","Ahmedabad","Jamnagar","Baroda","Bombay"]
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tbl_City.addSubview(refreshControl)
    }
    func refresh()
    {
        alert = UIAlertController(title: "Roster Refreshed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        refreshControl.endRefreshing()
    }
    @IBAction func onClickLogin(sender: UIButton)
    {
        if(txt_Username.text == "")
        {
            alert = UIAlertController(title: "Error", message: "Please Enter Username", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else if(txt_Password.text == "")
        {
            let alert = UIAlertController(title: "Error", message: "Please Enter Password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        else
        {
            print("Login successfully")
            tbl_City.isHidden = false
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        cell.textLabel?.text = arr_CityName[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        
    }
    @IBAction func sliderValueChanged(_ slider: UISlider)
    {
         lbl_Vol.text = String(format: "%.0f", slider.value)
    }
    @IBAction func actionConvert(sender : UIButton)
    {
        /*  GlobalDataClass.apiCode = "UUFkZXY="
         GlobalDataClass.apiKey = "69b08d70-b0cf-42b8-9a79-7362169942bc-81ac9d1d-2972-45e7-af47-1bdb5f7d7467"
         GlobalDataClass.service = "http://mobileapi.beehivesoftware.in/BeehiveMobileService.svc"*/
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Header xmlns=\"http://beehivehronline.com/v1\"><APICode>\("UUFkZXY=")</APICode><APIKey>\("69b08d70-b0cf-42b8-9a79-7362169942bc-81ac9d1d-2972-45e7-af47-1bdb5f7d7467")</APIKey></soap:Header><soap:Body><GetTravelDefault xmlns=\"http://tempuri.org/\"><userid>\("5")</userid></GetTravelDefault></soap:Body></soap:Envelope>"
        
        let urlString = "\("http://mobileapi.beehivesoftware.in/BeehiveMobileService.svc")"
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        //var msgLength = String(countElements(soapMessage))
        let msgLength = String(soapMessage.characters.count)
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        theRequest.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        
        theRequest.addValue("http://tempuri.org/IBeehiveMobileService/GetTravelDefault", forHTTPHeaderField: "SOAPAction")
        
        theRequest.httpMethod = "POST"
        
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)!
        
        connection.start()
    }
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!)
    {
        mutableData.length=0
    }
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!)
    {
        mutableData.append(data)
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection!)
    {
        let str = NSString(data: mutableData as Data, encoding: String.Encoding.utf8.rawValue)
        print(str!)
        
        let xmlParser: XMLParser! = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
    }
    func connection(_ connection: NSURLConnection, didFailWithError error: NSError)
    {
        print(error)
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        dataString.setString("")
       // currentElementName = elementName as NSString
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        dataString.append(string)
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        let index = elementName.characters.index(elementName.startIndex, offsetBy: 2)
        let str = "\(dataString)"
        print("elementName:",str)
        
        if(elementName == "a:IsError")
        {
            print("string:",dataString)
            dataString = "true"
            if(dataString == "true")
            {
                alert = UIAlertController(title: "ServiceError", message: "Service error", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func valueChange(sender: UISwitch)
    {
        if(switchControl.isOn)
        {
            print("switch is set to On")
        }
        else
        {
            alert = UIAlertController(title: "SwitchError", message: "Switch Error", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}


