//
//  ViewController.swift
//  OrthanServerAdmin
//
//  Created by Angel Bonet on 12/03/2019.
//  Copyright © 2019 Innovaorto. All rights reserved.
//

import Cocoa

// Clase para ejecutar comando shell
class Helper {
    static func shell(launchPath path: String, arguments args: [String]) -> String {
        let task = Process()
        task.launchPath = path
        task.arguments = args
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        task.waitUntilExit()
        
        return(output!)
    }
}


class ViewController: NSViewController {
    
    
    @IBOutlet weak var infoLabel: NSTextField!
    @IBOutlet weak var sayProgress: NSProgressIndicator!
    @IBOutlet weak var startServerButton: NSButton!
    @IBOutlet weak var stopServerButton: NSButton!
    
    var task: Process!
    var outputTimer: Timer?
    var appName: String!
    var statusOrthanc: String!
    //let statusOrthanc = "off"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        infoLabel.stringValue = "Orthanc Server Detenido"
        self.infoLabel.textColor = NSColor.systemPink
        
        // Carga el valor de autoarranque desde las preferencias
        let autoStartValue = UserDefaults.standard.bool(forKey: "startPrefCheck")
        
        // Obtiene el estado del server on|off
        statusOrthanc = orthancIsRunning()
        // Activa o desactiva los botones en funcion del estado del server
        if statusOrthanc == "on" {
            startServerButton.isEnabled = false
            stopServerButton.isEnabled = true
        } else {
            startServerButton.isEnabled = true
            stopServerButton.isEnabled = false
        }
        
        // En caso de autoarranque activo arranca el server si esta detenido
        if autoStartValue == true && statusOrthanc == "off" {
            onServer()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // Funcion para comprobar si Orthanc esta en funcionamiento
    func orthancIsRunning() -> String {
        let running = Helper.shell(launchPath: "/bin/ps", arguments: ["-Ao comm"])
        if running.contains("/Applications/Orthanc/Orthanc") {
            let statusOrthanc = "on"
            self.infoLabel.stringValue = "Orthanc Server en funcionamiento"
            self.infoLabel.textColor = NSColor.systemGreen
            print("Orthanc Activo") // Solo en consola debug
            print(statusOrthanc) // Solo en consola debug
            startServerButton.isEnabled = false
            return(statusOrthanc)
        } else {
            let statusOrthanc = "off"
            print("Orthanc inactivo") // Solo en consola debug
            print(statusOrthanc) // Solo en consola debug
            return(statusOrthanc)
        }
    }
    
    
    // Funcion del cuadro de dialogo estandar para confirmar acciones
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    // Funcion de arranque del servidor
    func onServer() {
        infoLabel.stringValue = "Iniciando Orthanc Server"
        self.infoLabel.textColor = NSColor.systemOrange
        let OrthancPath = "/Applications/Orthanc/Orthanc"
        // 08/04/2019 Sustituyo dos lineas para definir argumentos por una variable de argmentos en formato array
        //let OrthancConfigPath = "/Applications/Orthanc/configOSX.json --verbose --logdir=/var/logs/orthanc/"
        //let argumentsOrthanc = [OrthancConfigPath]
        let argumentsOrthanc = ["/Applications/Orthanc/configOSX.json", "--verbose", "--logdir=/var/log/orthanc/"]

        startServerButton.isEnabled = false
        stopServerButton.isEnabled = true
        sayProgress.startAnimation(self)
        
        task = Process.init()
        task.launchPath = OrthancPath
        task.arguments = argumentsOrthanc
        self.task.launch()
        
        DispatchQueue.global().async {
            // this runs in a worker thread, so the UI remains responsive
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 2.0)
                self.infoLabel.stringValue = "Orthanc Server en funcionamiento"
                self.infoLabel.textColor = NSColor.systemGreen
                self.sayProgress.stopAnimation(self)
            }
            self.task.waitUntilExit()
            DispatchQueue.main.async {
                // do so in the main thread
                if let timer = self.outputTimer {
                    timer.invalidate()
                    self.outputTimer = nil
                }
            }
        }
    }
    
    // Funcion de parada del servidor
    func offServer() {
        let answer = dialogOKCancel(question: "¿Quiere detener Orthanc?", text: "")
        if answer {
            // En caso de que el server estuviera activo previamente se usa este apartado para detenerlo
            if task == nil {
                _ = Helper.shell(launchPath: "/usr/bin/killall", arguments: ["Orthanc"])
            // En caso de que el server se haya iniciado desde la propia app se usa este apartado para detenerlo
            } else {
                task.terminate()
                task.waitUntilExit()
                if let timer = self.outputTimer {
                    timer.invalidate()
                    self.outputTimer = nil
                }
            }
            infoLabel.stringValue = "Orthanc Server Detenido"
            self.infoLabel.textColor = NSColor.systemRed
            stopServerButton.isEnabled = false
            startServerButton.isEnabled = true
        }
    }
  
    // Funcion del boton de arranque del servidor
    @IBAction func startServer(_ sender: Any) {
        onServer()
    }
    
    // Funcion del botón de parada del servidor
    @IBAction func stopServer(_ sender: Any) {
        offServer()
    }
}

