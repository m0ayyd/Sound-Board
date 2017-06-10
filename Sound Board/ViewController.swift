//
//  ViewController.swift
//  Sound Board
//
//  Created by the Luckiest on 6/10/17.
//  Copyright © 2017 the Luckiest. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sounds : [Sound] = []
    
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sound = sounds[indexPath.row]
        cell.textLabel?.text = sound.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sound = sounds[indexPath.row]
        do{
            audioPlayer = try AVAudioPlayer(data: sound.audio! as Data)
            audioPlayer?.play()
        } catch {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            sounds = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        } catch {}
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sound = sounds[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(sound)
            do{
                sounds = try context.fetch(Sound.fetchRequest())
                tableView.reloadData()
            } catch {}
        }
    }

}

