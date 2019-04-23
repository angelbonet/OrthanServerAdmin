//
//  PrefsViewController.swift
//  OrthanServerAdmin
//
//  Created by admin on 13/03/2019.
//  Copyright © 2019 Innovaorto. All rights reserved.
//

import Cocoa


class PrefsViewController: NSViewController {
    
    @IBOutlet weak var autoStartServer: NSButtonCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // Si el valor del check button cambia lo vuelca en el valor de preferencias
    @IBAction func autoStartServerCheck(_ sender: Any) {
        let estadoPref = autoStartServer.state
        UserDefaults.standard.set(estadoPref, forKey: "startPrefCheck")
        //print(estadoPref) // Activo solo para propositos de debug
    }
  
}
