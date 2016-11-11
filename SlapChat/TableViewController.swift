
import UIKit
import CoreData

class TableViewController: UITableViewController {

    var store = DataStore.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchData()
        print("is it working or not")
        
        if store.messages.isEmpty {
            print("did it go through the data fetching process really")
            store.generateTestData()
        }
//        deleteAllMsgs()
        self.tableView.reloadData()
        
//        sleep(5)
//        deleteAllMsgs()
//        tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        store.fetchData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.messages.count
    }

   
    func deleteAllMsgs(){
        store.deleteAllMessages()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let message = store.messages[indexPath.row]
        cell.textLabel?.text = message.content
        return cell
      
    }
    
    
   
    }
