//
//  ViewController.swift
//  Exp0900
//
//  Created by Mihai Moldovan on 24/07/2018.
//  Copyright © 2018 MLD Software. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var swipeGesture:UISwipeGestureRecognizer!
    
    
    var isTerraformed = false
    
    
    //TEXTURES AND DATA
    
    var textureNames:[String] = ["Mercury","Venus","Moon","Pangeea","Earth HD","Geo Earth","Mars","Jupiter","Saturn","Neptune","Uranus","Io","Enceladus","Ganymede","Callisto","Titan","Iapetus","Triton","Europa","Planet X","Violet","Moore"]
    
    var terraformable:[Bool] = [true,true,true,false,false,false,true,false,false,false,false,true,true,true,true,true,true,true,true,false,false,false]
    
    var statusMatrix:[String] = ["Not occupied","Not occupied","Not occupied","Historical","Habited","Habited","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied","Not occupied"]
    
    
    
    //RADIATION
    
    var radioactiveMatrix:[Bool] = [true,false,false,false,false,false,false,true,true,false,false,false,false,true,true,false,false,false,false,false,true,true]
    
    //THERMODYNAMIC
    
    var temperatureMatrix:[String] = ["66.85","462","-53.15","14.9","14.9","14.9","−63","−108","−139","−201","−197.2","-163.15","−198","-163.15","-139.15","−179.5","-143.15","−235.2","−171.15","Planet X","Violet","Moore"]
    
    var tempTypes:[String] = ["Hell","Hell","Cold","Nice","Nice","Nice","Cold","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Frozen","Planet X","Violet","Moore"]
    
    var lwMatrix:[Bool] = [false,false,false,true,true,true,true,false,false,false,false,false,true,false,false,false,false,false,true,false,false,false]
    
    
    //GRAVITY
    
    var massMatrix:[String] = ["3.3×10^23","4.8×10^24","7.3×10^22","5.9×10^24","5.9×10^24","5.9×10^24","Mars","Jupiter","5.6×10^26","1.0243 × 10^26","(8.6810±0.0013) × 10^25","(8.931938±0.000018) × 10^22","(1.08022±0.00101) × 10^20","1.4×10^23","1.07×10^23","1.3×10^23","Iapetus","Triton","Europa","Planet X","Violet","Moore"]
    
    var gravityMatrix:[String] = ["3.7","8.87","1.62","9.807","9.807","9.807","3.711","24.79","10.44","Neptune","Uranus","Io","0.113","Ganymede","Callisto","Titan","Iapetus","0.779","Europa","Planet X","Violet","Moore"]
    
    var escVelMatrix:[String] = ["4.25","10.36","2.38","11.186","11.186","11.186","5.027","59.5","35.5","Neptune","Uranus","Io","0.239","Ganymede","Callisto","Titan","Iapetus","1.455","Europa","Planet X","Violet","Moore"]
    
    
    
    //GEOMETRIC
    
    
    var radiusMatrix:[String] = ["4.25","10.36","2.38","Pangeea","Earth HD","Geo Earth","5.027","59.5","35.5","Neptune","Uranus","Io","0.239","Ganymede","Callisto","Titan","Iapetus","1.455","Europa","Planet X","Violet","Moore"]
    
    
    
    
    
    var textureSelection:Int = 5
    var hudSw=true
    
    
    
    var temperatureLabel:UILabel!
    var massLabel:UILabel!
    var nameLabel:UILabel!
    var velLabel:UILabel!
    
    
    var nextButton:UIButton!
    var previousButton:UIButton!
    var hudButton:UIButton!
    var terraButton:UIButton!
    var setButton:UIButton!
    
    
    var playerStack:UIStackView!
    var upperStack:UIStackView!
    var leftStack:UIStackView!
    var rightStack:UIStackView!
    
    
    
    
    func initTempLabel(){
        
        
        playerStack = UIStackView(frame: CGRect(x: 0, y: self.view.bounds.height-80, width: self.view.bounds.width, height: 80))
        playerStack.axis = .horizontal
        playerStack.spacing = 0
        playerStack.alignment = .center
        playerStack.distribution = .fillEqually
        //playerStack.tintColor = UIColor.clear
        //playerStack.backgroundColor = UIColor.clear
        
        
        
        
        
        
        
        temperatureLabel = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height+200, width: 400, height: 200))
        temperatureLabel.font = UIFont.systemFont(ofSize: 25)
        temperatureLabel.text = String(temperatureMatrix[textureSelection] + " °C")
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = UIColor.white
        temperatureLabel.alpha = 0.7
        temperatureLabel.center.x = 200
        temperatureLabel.center.y = 60
        
        
        
        self.view.addSubview(temperatureLabel)
        
        
        
        massLabel = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height+400, width: 400, height: 200))
        massLabel.font = UIFont.systemFont(ofSize: 25)
        //massLabel.text = String
        
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height+600, width: 400, height: 200))
        nameLabel.font = UIFont.systemFont(ofSize: 25)
        nameLabel.text = textureNames[textureSelection]
        nameLabel.textAlignment = .center
        nameLabel.textColor = UIColor.white
        nameLabel.center.x = 200
        nameLabel.center.y = 30
        
        
        self.view.addSubview(nameLabel)
        
        
        velLabel = UILabel(frame: CGRect(x: 0, y: self.view.bounds.height+800, width: 400, height: 200))
        velLabel.font = UIFont.systemFont(ofSize: 25)
        
        nextButton = UIButton(type: .roundedRect)
        nextButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        nextButton.setImage(UIImage(named: "next_white"), for: .normal)
        nextButton.center.x = self.view.bounds.width - 60
        nextButton.center.y = self.view.bounds.height - 60
        nextButton.alpha = 0.6
        nextButton.tintColor = UIColor.white
        nextButton.addTarget(self, action: #selector(nextMaterial), for: .touchUpInside)
        //self.view.addSubview(nextButton)
        
        
        previousButton = UIButton(type: .roundedRect)
        previousButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        previousButton.setImage(UIImage(named: "previous_white"), for: .normal)
        previousButton.center.x = 60
        previousButton.center.y = self.view.bounds.height - 60
        previousButton.alpha = 0.6
        previousButton.tintColor = UIColor.white
        previousButton.addTarget(self, action: #selector(previousMaterial), for: .touchUpInside)
        //self.view.addSubview(previousButton)
        
        
        hudButton = UIButton(type: .system)
        hudButton.setImage(UIImage(named: "HUD"), for: .normal)
        hudButton.alpha = 0.5
        hudButton.tintColor = UIColor.lightGray
        hudButton.addTarget(self, action: #selector(hudSwitch), for: .touchUpInside)
        
        terraButton = UIButton(type: .system)
        //terraButton.alpha = 0.9
        terraButton.setImage(UIImage(named: "Terraform"), for: .normal)
        terraButton.tintColor = UIColor.green
        terraButton.alpha = 0.3
        terraButton.addTarget(self, action: #selector(terraform), for: .touchUpInside)
        
        
        setButton = UIButton(type: .system)
        setButton.setImage(UIImage(named: "Settings"), for: .normal)
        setButton.alpha = 0.5
        setButton.tintColor = UIColor.lightGray
        setButton.addTarget(self, action: #selector(terraform), for: .touchUpInside)
        
        playerStack.addArrangedSubview(previousButton)
        playerStack.addArrangedSubview(hudButton)
        playerStack.addArrangedSubview(terraButton)
        playerStack.addArrangedSubview(setButton)
        playerStack.addArrangedSubview(nextButton)
        
        
        self.view.addSubview(playerStack)
        
        
    }
    
    
    @objc func hudSwitch(){
        if(hudSw==true){
            nameLabel.removeFromSuperview()
            temperatureLabel.removeFromSuperview()
            hudSw = !hudSw
        }else{
            initTempLabel()
            hudSw = !hudSw
        }
    }
    
    
    
    @objc func terraform(){
        
        if(terraformable[textureSelection]==true){
            
            if(isTerraformed==false){
        
        let myStr = String("art.scnassets/" + "Terra" + textureNames[textureSelection] + ".jpg")
        
        print(myStr)
        print("Terraforming...")
        
        let newImage = UIImage(named: myStr)
        let material = SCNMaterial()
        material.diffuse.contents = newImage
        
        
        
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name=="Planet"){
                child.geometry?.firstMaterial = material
                
                isTerraformed = true
                refreshBoxes()
            }
        }
                
            }else{
                
                let myStr = String("art.scnassets/" + textureNames[textureSelection] + ".jpg")
                
                print(myStr)
                print("Deterraforming...")
                
                let newImage = UIImage(named: myStr)
                let material = SCNMaterial()
                material.diffuse.contents = newImage
                
                
                
                for child in self.sceneView.scene.rootNode.childNodes{
                    if(child.name=="Planet"){
                        child.geometry?.firstMaterial = material
                        isTerraformed = false
                        refreshBoxes()
                    }
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    
    
    func refreshTempLabel(){
        
        temperatureLabel.text = String(temperatureMatrix[textureSelection] + " °C")
        nameLabel.text = textureNames[textureSelection]
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        
        
        
        // Create a new scene
        let scene = SCNScene()
        
        let position = SCNVector3(0, -0.3, -0.3)
        let sphere = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/Geo Earth.jpg")
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        sphereNode.name = "Planet"
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
        let repAction = SCNAction.repeatForever(action)
        sphereNode.runAction(repAction)
        
        scene.rootNode.addChildNode(sphereNode)
        
        
        
        // Set the scene to the view
        sceneView.scene = scene
        
        initTempLabel()
    }
    
    
    
    
    
    
    
    
    func addMoon(){
        
        let position = SCNVector3(1, -0.2, -0.9)
        let sphere = SCNSphere(radius: 0.3)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/Sun.jpg")
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        sphereNode.name = "Moon"
        let action = SCNAction.rotateBy(x: 0, y: 20, z: 0, duration: 60)
        let repAction = SCNAction.repeatForever(action)
        
        let orbitAction = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 60)
        
        sphereNode.runAction(orbitAction)
        
        
        
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        print("Moon Added" + String(sphereNode.position.x) + String(sphereNode.position.y) + String(sphereNode.position.z))
    }
    
    
    
    
    
    
    
    func refreshBoxes(){
        
        
        
        if(isTerraformed==true){
            
            let material = SCNMaterial()
            let second = SCNMaterial()
            let third = SCNMaterial()
            
            for child in self.sceneView.scene.rootNode.childNodes{
                if(child.name=="Weather Box"){
                    material.diffuse.contents = UIImage(named: "Nice")
                    child.geometry?.firstMaterial = material
                }else if(child.name=="Status Box"){
                    second.diffuse.contents = UIImage(named: "Life")
                    child.geometry?.firstMaterial = second
                }else if(child.name=="Water Box"){
                    third.diffuse.contents = UIImage(named: "Water")
                    child.geometry?.firstMaterial = third
                }
            }
        }else{
            
            addStatus()
            addWaterBox()
            addWeatherBox()
            
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    func addRadioBox(){
        
        //DESTROY OLD RADIO BOX
        
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name == "Radio Box"){
                child.removeFromParentNode()
            }
        }
        
        
        let myImage = UIImage(named: "Radioactive")
        
        let position = SCNVector3(0, -0.13, -0.3)
        let box = SCNBox(width: 0.0, height: 0.03, length: 0.03, chamferRadius: 10)
        let material = SCNMaterial()
        material.diffuse.contents = myImage
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.name = "Radio Box"
        
        let action = SCNAction.rotateBy(x: 0, y: 20, z: 0, duration: 60)
        let repAction = SCNAction.repeatForever(action)
        
        boxNode.runAction(repAction)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
        print("Radio Box Added")
        
    }
    
    
    
    
    
    func addWeatherBox(){
        
        //DESTROY OLD WEATHER BOX
        
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name == "Weather Box"){
                child.removeFromParentNode()
            }
        }
        
        let myImage = getWeatherImage(temp: temperatureMatrix[textureSelection])
        
        let position = SCNVector3(0, -0.2, -0.4)
        let box = SCNBox(width: 0.0, height: 0.03, length: 0.03, chamferRadius: 10)
        let material = SCNMaterial()
        material.diffuse.contents = myImage
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.name = "Weather Box"
        
        let action = SCNAction.rotateBy(x: 0, y: 20, z: 0, duration: 60)
        let repAction = SCNAction.repeatForever(action)
        
        boxNode.runAction(repAction)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
        print("Weather Box Added")
        
    }
    
    
    
    func addStatus(){
        
        //DESTROY OLD STATUS BOX
        
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name == "Status Box"){
                child.removeFromParentNode()
            }
        }
        
        let myImage = getStatusImage()
        
        let position = SCNVector3(-0.05, -0.2, -0.45)
        let box = SCNBox(width: 0.0, height: 0.03, length: 0.03, chamferRadius: 10)
        let material = SCNMaterial()
        material.diffuse.contents = myImage
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.name = "Status Box"
        
        let action = SCNAction.rotateBy(x: 0, y: 20, z: 0, duration: 60)
        let repAction = SCNAction.repeatForever(action)
        
        boxNode.runAction(repAction)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
        print("Status Box Added")
        
        
        
        
    }
    
    
    
    func addWaterBox(){
        
        
        //DESTROY OLD WATER BOX
        
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name == "Water Box"){
                child.removeFromParentNode()
            }
        }
        
        let myImage = getWaterImage()
        
        let position = SCNVector3(-0.05, -0.2, -0.35)
        let box = SCNBox(width: 0.0, height: 0.03, length: 0.03, chamferRadius: 10)
        let material = SCNMaterial()
        material.diffuse.contents = myImage
        box.firstMaterial = material
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.name = "Water Box"
        
        let action = SCNAction.rotateBy(x: 0, y: 20, z: 0, duration: 60)
        let repAction = SCNAction.repeatForever(action)
        
        boxNode.runAction(repAction)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        
        print("Water Box Added")
        
        
        
        
        
        
    }
    
    
    
    
    func getStatusImage()->UIImage{
        
        if(statusMatrix[textureSelection]=="Not occupied"){
            return UIImage(named: "Death")!
        }else if(statusMatrix[textureSelection]=="Habited"){
            return UIImage(named: "Life")!
        }else{
            return UIImage(named: "Why")!
        }
        
        
        
        
    }
    
    
    
    func getWaterImage()->UIImage{
        
        if(lwMatrix[textureSelection]==true){
            return UIImage(named: "Water")!
        }else{
            return UIImage(named: "NoWater")!
        }
        
        
        
        
    }
    
    
    
    
    
    func getWeatherImage(temp: String)->UIImage{
        
        var imgString:String!
        
        
        if(tempTypes[textureSelection]=="Frozen"){
            imgString = "Frozen"
            let image = UIImage(named: imgString)
            return image!
        }else if(tempTypes[textureSelection]=="Hell"){
            imgString = "Hell"
            let image = UIImage(named: imgString)
            return image!
        }else if(tempTypes[textureSelection]=="Nice"){
            imgString = "Nice"
            let image = UIImage(named: imgString)
            return image!
        }else if(tempTypes[textureSelection]=="Cold"){
            imgString = "Cold"
            let image = UIImage(named: imgString)
            return image!
        }else{
            imgString = "Why"
            let image = UIImage(named: imgString)
            return image!
        }
        
        
        
        
    }
    
    
    
    func setWeatherObject()->SCNNode{
        
        let position = SCNVector3(0, 2, -0.3)
        let shape = SCNPlane(width: 0.1, height: 0.1)
        shape.cornerRadius = 5
        shape.cornerSegmentCount = 10
        shape.heightSegmentCount = 10
        shape.widthSegmentCount = 10
        
        
        
        
        let node = SCNNode()
        return node
        
    }
    
    
    
    
    
    func addTemperature(){
        
        
        let label = SCNText(string: String(temperatureMatrix[textureSelection] + " °C"), extrusionDepth: 5)
        label.containerFrame = CGRect(x: 0, y: 2, width: 0.03, height: 0.03)
        label.font = UIFont.systemFont(ofSize: 10)
        
        
        
        let position = SCNVector3(0, -0.2, -0.4)
        let tempObject = SCNPlane(width: 0.03, height: 0.1)
        
        tempObject.cornerRadius = 30
        
        let node = SCNNode(geometry: label)
        node.position = position
        node.name = "Temperature"
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
        let repAction = SCNAction.repeatForever(action)
        node.runAction(repAction)
        
        self.sceneView.scene.rootNode.addChildNode(node)
        
        //let material = SCNMaterial()
        //material.diffuse.contents = getWeatherImage(temp: temperatureMatrix[textureSelection])
        //tempObject.firstMaterial = material
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func getPlanet()->String{
        return String("art.scnassets/" + textureNames[textureSelection] + ".jpg")
    }
    
    
    
    
    
    func refreshMaterial(){
        
        let position = SCNVector3(0, -0.3, -0.3)
        let sphere = SCNSphere(radius: 0.1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: getPlanet())
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        sphereNode.name = "Planet"
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
        let repAction = SCNAction.repeatForever(action)
        sphereNode.runAction(repAction)
        
        for child in sceneView.scene.rootNode.childNodes{
            if(child.name == "Planet"){
                child.removeFromParentNode()
            }
        }
        addTemperature()
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        if(radioactiveMatrix[textureSelection]==true){
            addRadioBox()
        }else{
            for child in self.sceneView.scene.rootNode.childNodes{
                if(child.name=="Radio Box"){
                    child.removeFromParentNode()
                }
            }
        }
        
        //Reset Terraformed Status
        isTerraformed = false
        
        
        addWeatherBox()
        addStatus()
        addWaterBox()
        
        refreshTempLabel()
        
    }
    
    
    
    
    @objc func nextMaterial(){
        if(textureSelection<textureNames.count - 1){
            textureSelection+=1
        }else{
            textureSelection=0
        }
        refreshMaterial()
    }
    
    
    @objc func previousMaterial(){
        if(textureSelection>0){
            textureSelection-=1
        }else{
            textureSelection = textureNames.count - 1
        }
        refreshMaterial()
    }
    
    
    
    
    
    func changeView(){
        
    }
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            
            for child in self.sceneView.scene.rootNode.childNodes{
                if(child.name=="Planet" || child.name=="Weather Box" || child.name=="Status Box" || child.name=="Water Box" || child.name=="Radio Box"){
                    child.removeAllActions()
                }
            }
            
            if(touch.tapCount==4){
                addMoon()
            }
            
            
            
            
        }
    }
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for child in self.sceneView.scene.rootNode.childNodes{
            if(child.name == "Planet" || child.name == "Weather Box" || child.name=="Status Box" || child.name=="Water Box" || child.name=="Radio Box"){
                let action = SCNAction.rotateBy(x: 0, y: CGFloat(2 * Double.pi), z: 0, duration: 10)
                let repAction = SCNAction.repeatForever(action)
                child.runAction(repAction)
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
