//
//  ViewController.swift
//  indoorPositioning
//
//  Created by isaiah childs on 4/5/20.
//  Copyright © 2020 isaiah childs. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import CoreServices
import NetworkExtension
//import CocoaMQTT
import CoreMotion




class ViewController: UIViewController,CLLocationManagerDelegate,rootchange {
    func editdelegate(nam:String,xdelta:Float) {
       
        if (nam == "nx"){nx = Double(xdelta)}
        if (nam == "ny"){ny = Double(xdelta)}
        if (nam == "Beacon 2 Degree"){b1Deg = Int(xdelta)}
        if (nam == "Beacon 3 Degree"){b2Deg = Int(xdelta)}
        if (nam == "Beacon 2 Distance"){b1Dis = Double(xdelta)}
        if (nam == "Beacon 3 Distance"){b2Dis = Double(xdelta)}
        
        
        
        
    }
    
    @IBOutlet weak var txtRange:UILabel!
    @IBOutlet weak var orientate:UILabel!
    @IBOutlet weak var avg:UILabel!
    @IBOutlet weak var xAxis:NSLayoutConstraint!
    @IBOutlet weak var yAxis:NSLayoutConstraint!
    @IBOutlet weak var space:UIView!
    @IBOutlet weak var homeBool:UILabel!
    @IBOutlet weak var nodex:NSLayoutConstraint!
    @IBOutlet weak var nodey:NSLayoutConstraint!
    @IBOutlet weak var nodeb1x:NSLayoutConstraint!
       @IBOutlet weak var nodeb1y:NSLayoutConstraint!
    @IBOutlet weak var nodeb2x:NSLayoutConstraint!
    @IBOutlet weak var nodeb2y:NSLayoutConstraint!
    @IBOutlet weak var nodeb3x:NSLayoutConstraint!
    @IBOutlet weak var nodeb3y:NSLayoutConstraint!
    @IBOutlet weak var nodeb4x:NSLayoutConstraint!
    @IBOutlet weak var nodeb4y:NSLayoutConstraint!
    var angle:Double = 0;
    var startX = Double(0)
    var startY = Double(0)
    var xPos = Double(0)
    var yPos = Double(0)
    var pb1 : [String:Float]!
    var pb2 : [String:Float]!
    var pb3 : [String:Float]!
    var xarray = Array<Double>()
    var yarray = Array<Double>()
    var b1max : Float!
    var b2max : Float!
    var b3max : Float!
    var b4max : Float!
    var i = 0;
    var tx = -60.0;
    @IBOutlet weak var rad1w:NSLayoutConstraint!
    @IBOutlet weak var rad1h:NSLayoutConstraint!
      @IBOutlet weak var rad2w:NSLayoutConstraint!
      @IBOutlet weak var rad2h:NSLayoutConstraint!
      @IBOutlet weak var rad3w:NSLayoutConstraint!
      @IBOutlet weak var rad3h:NSLayoutConstraint!
      @IBOutlet weak var rad4w:NSLayoutConstraint!
      @IBOutlet weak var rad4h:NSLayoutConstraint!
    @IBOutlet weak var rad1:UIView!
    @IBOutlet weak var rad2:UIView!
    @IBOutlet weak var rad3:UIView!
    @IBOutlet weak var rad4:UIView!
    var nx = -3.2956075727//-4.238455363982
     var ny = 2.63544120448//2.7768235939
    var b1Deg = 11
    var b1Dis = 0.8300717747125683 //75
    var b2Deg = 0
    var b2Dis = 0.43592481688503515 //72.5
    var b3dis = 0.31174979930529256 //65
    var b3deg = 90;
    var motionmanager = CMMotionManager();
    var b1filter = kFilter();
    var b2filter = kFilter();
    var b3filter = kFilter();
    var b4filter = kFilter();
    var locationManager : CLLocationManager!
    //avg: x = 2.462654400820598 | y = 7.1561359270039295
   // let mqttClient = CocoaMQTT(clientID: "mqtt_lights_1", host: "192.168.1.221", port: 1883)//1833//1883
    
  
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//
//       let v = [
//           "x" : 0.3,
//           "y" : 0
//       ] as [String:Float]
//        pb1 = sine(deg: Float(b1Deg), opp: Float(b1Dis)) //376 //1.99  //60
//           pb2 = sine(deg: Float(b2Deg), opp: Float(b2Dis)) //585 //3.47 //48 //68
//      pb3 = v
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
//
//           self.nodey.constant = max(CGFloat((ny/10)) * space.frame.size.height,0)
//                     self.nodex.constant = (CGFloat((nx/10)) * space.frame.size.width) + space.frame.size.width/2
//
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "edittable"{
//            let nav = segue.destination as! UINavigationController
//            let displayVC = nav.topViewController as! setupTableViewController
//            displayVC.delegate = self
//            displayVC.x = ["nx":nx,
//                     "ny":ny,
//                     "Beacon 2 Degree":b1Deg,
//                     "Beacon 3 Degree":b2Deg,
//                     "Beacon 2 Distance":b1Dis,
//                "Beacon 3 Distance":b2Dis
//            ] as NSDictionary
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        b1Dis = dis(rssi: Double(-72.5))
        b2Dis = dis(rssi: Double(-75))
        b3dis = dis(rssi: Double(-65))
       
  
        print(sine(deg: Float(b1Deg), opp: Float(b1Dis)))
         print(sine(deg: Float(b2Deg), opp: Float(b2Dis)))
        print(sine(deg: Float(b3deg), opp: Float(b3dis)))
        
        
        pb1 = sine(deg: Float(b1Deg), opp: Float(b1Dis)) //376 //1.99  //60
        pb2 = sine(deg: Float(b2Deg), opp: Float(b2Dis)) //585 //3.47 //48 //68
        pb3 = sine(deg: Float(b3deg), opp: Float(b3dis))
        //pb3 = v
        b1max = powf((powf(pb1["x"]!, 2) + powf(pb1["y"]!, 2)), 0.5)
        b2max = powf((powf(pb1["x"]!, 2) + powf(pb1["y"]!, 2)), 0.5)
        b3max = powf((powf(pb2["x"]!, 2) + powf(pb2["y"]!, 2)), 0.5)
        b4max = powf((powf(pb3["x"]!, 2) + powf(pb3["y"]!, 2)), 0.5)
        
     locationManager = CLLocationManager()
     locationManager.delegate = self
     locationManager.requestAlwaysAuthorization()
       rad1.layer.cornerRadius = rad1.frame.size.width/2
                  rad2.layer.cornerRadius = rad2.frame.size.width/2
                  rad3.layer.cornerRadius = rad3.frame.size.width/2
                 rad4.layer.cornerRadius = rad4.frame.size.width/2
        let m = max(pb1["x"]!,pb2["x"]!,pb3["x"]!)
        let my = max(pb1["y"]!,pb2["y"]!,pb3["y"]!)
      
        self.nodey.constant = max(CGFloat((ny/10)) * space.frame.size.height,0)
                  self.nodex.constant = (CGFloat((nx/10)) * space.frame.size.width) + space.frame.size.width/2
        self.nodeb1x.constant = (CGFloat(0) * space.frame.width) + 15
        self.nodeb1y.constant = CGFloat(0) * space.frame.height
        self.nodeb2x.constant = (CGFloat((pb1["x"]!/m)) * space.frame.width)
               self.nodeb2y.constant = CGFloat((pb1["y"]!/my)) * space.frame.height - 15
        self.nodeb3x.constant = (CGFloat((pb2["x"]!/m)) * space.frame.width)
               self.nodeb3y.constant = CGFloat((pb2["y"]!/my)) * space.frame.height - 15
        self.nodeb4x.constant = (CGFloat((pb3["x"]!/m)) * space.frame.width) - 15
        //self.nodeb4x.constant = space.frame.width
               self.nodeb4y.constant = CGFloat((pb3["y"]!/my)) * space.frame.height
       
        
        // Do any additional setup after loading the view.
    }
    func maxX(){
        
    }
    func sine(deg:Float,opp:Float) -> [String:Float]{
        if deg == 90{
            let sinus = (sin(deg * Float(Double.pi) / Float(180))) * opp
            let cosine = 0
             return ["x":Float(sinus),"y":Float(cosine)]
        }else{
        let sinus = (sin(deg * Float(Double.pi) / Float(180))) * opp
        let cosine = (cos(deg * Float(Double.pi) / Float(180))) * opp

            return ["x":Float(sinus),"y":Float(cosine)]
            
        }
    }
    func cose(deg:Float,adj:Float) -> Float{
          
          let cosine = (cos(deg * Float(Double.pi) / 180)) * adj


          return Float(cosine)
      }
    func getBRegion() -> CLBeaconRegion{
       
        let beaconRegion = CLBeaconRegion(uuid: NSUUID.init(uuidString: "C7C1A1BF-BB00-4CAD-8704-9F2D2917DED2")! as UUID, identifier: "INDOOR")
        
        return beaconRegion
    }
    func getBRegion2() -> CLBeaconRegion{
       
        let br2 = CLBeaconRegion(uuid: NSUUID.init(uuidString: "E95D422C-C46C-11EA-87D0-0242AC130003")! as UUID, identifier: "INDOOR_2")
        return br2
    }
   
    @IBAction func getRange(_ sender: Any){
       // mqttClient.publish("rpi/HA",withString: "{{x:2},{y:3}}")
        //startScanning(bregion: getBRegion())
       startScanning(bregion: getBRegion2())
    }
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//
//                }
//            }
//        }
//    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func avg(xavg:[Double])->Double{
        let suma = xavg.reduce(0,+)
        return suma/Double(xavg.count)
        
    }
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        self.orientate.text = "\(newHeading.magneticHeading)"
     if newHeading.magneticHeading - 90 <= 0 {
                             self.angle = newHeading.magneticHeading + 270
                         }else{
                             self.angle = newHeading.magneticHeading - 90
                         }
        
       
        homevector()
       
        
    }
    func triggerDevice(targetx:Double,targety:Double,x:Double,y:Double,ang:Int) -> Bool{
        
        let yslope = targety - y
        let xslope = targetx - x
       var dgr = 0
       
        if yslope <= 0{
            if xslope <= 0{
                 dgr = 270
            }else{
                 dgr = 180
            }
        }else{
            if xslope <= 0 {
                 dgr = 360
            }else{
                 dgr = 90
            }
        }
        
        
            let ptany = Double(dgr) - (atan(yslope/xslope) * 180 / Double.pi)
      
    
       
        return Int(self.angle - 15)...Int(self.angle + 15) ~= abs(Int(ptany))
        
        
        
    }
    func getHomedevice(x:Double,y:Double,ang:Int,x2:Double,y2:Double){
        let distance = sqrt(((x2 - x) * (x2 - x)) + ((y2-y) * (y2-y)))
        let ysinmin = (sin(Float(ang-5) * Float(Double.pi) / 180)) * Float(distance)
        let xcosmin = (cos(Float(ang-5) * Float(Double.pi) / 180)) * Float(distance)
        let ysinmax = (sin(Float(ang+5) * Float(Double.pi) / 180)) * Float(distance)
        let xcosmax = (cos(Float(ang+5) * Float(Double.pi) / 180)) * Float(distance)
        let min = (ysinmin/xcosmin)
        let max = (ysinmax/xcosmax)
        //y = m(x - x_1) + y_1
       // print("\(min) \(max)")
    }
        
    func homevector(){
        let xang = abs(abs((self.angle)/90) - (self.angle/90).rounded(.up)) * 90
                             let hbool = self.triggerDevice(targetx: nx, targety: ny, x: xPos, y: yPos, ang:Int(xang))
                             if hbool {
                                 space.backgroundColor = UIColor.red
                             }else{
                                 space.backgroundColor = UIColor.systemGreen
                             }
                             homeBool.text = "\(hbool)"
              
    }
    func dis(rssi:Double) -> Double{
        let txCalibratedPower = tx
        if rssi == 0{
            return -1
        }else{
        let ratio = Double(exactly:rssi)!/Double(txCalibratedPower)
            return pow(10.0, ratio)
        }}
    func organizeBeacons(bx:[CLBeacon],mx:NSNumber) -> CLLocationAccuracy{
        
//        if bx[0].major == mx{
//            return b1filter.applyFilter(rssi: bx[0].accuracy)
//               } else if bx[1].major == mx{
//                     return b2filter.applyFilter(rssi: bx[1].accuracy)
//                      } else if bx[2].major == mx{
//            return b3filter.applyFilter(rssi: bx[2].accuracy)
//                             }else if bx[3].major == mx{
//            return b4filter.applyFilter(rssi: bx[3].accuracy)
//               }else {return 0}
       
        if bx[0].major == mx{
           let rssix = b1filter.applyFilter(rssi: Double(bx[0].rssi))

            return dis(rssi: rssix)
        } else if bx[1].major == mx{
                    let rssix = b2filter.applyFilter(rssi: Double(bx[1].rssi))

                              return dis(rssi: rssix)
               } else if bx[2].major == mx{
                           let rssix = b3filter.applyFilter(rssi: Double(bx[2].rssi))

                                     return dis(rssi: rssix)
                      }else if bx[3].major == mx{
                                  let rssix = b4filter.applyFilter(rssi: Double(bx[3].rssi))

                                            return dis(rssi: rssix)
        }else {return 0}
        
    }
    func checkbeacon(maj:NSNumber) -> [String:NSLayoutConstraint]{
        if maj == 50{
            let retx = [
                "h":rad1h,
                "w":rad1w
            ] as [String:NSLayoutConstraint]
            return retx
        }else if maj == 25{
            let retx = [
                "h":rad2h,
                "w":rad2w
            ] as [String:NSLayoutConstraint]
            return retx
        } else if maj == 5{
            let retx = [
                "h":rad3h,
                "w":rad3w
            ] as [String:NSLayoutConstraint]
            return retx
        } else if maj == 0{
            let retx = [
                "h":rad4h,
                "w":rad4w,
                
            ] as [String:NSLayoutConstraint]
            return retx
        }
        return [:]
    }
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if beacons.count == 1{
            print(beacons[0].rssi)
            if beacons[0].rssi != 0{
            let m = max(pb1["x"]!,pb2["x"]!,pb3["x"]!)
            let bradius = checkbeacon(maj: beacons[0].major)
                let nn = b1filter.applyFilter(rssi: Double(beacons[0].rssi))
                let r = b2filter.applyFilter(rssi: nn)
            print(b2max)
                bradius["h"]!.constant = CGFloat((r*2)/Double(b2max)) * space.frame.width
            bradius["w"]!.constant = CGFloat((r*2)/Double(b2max)) * space.frame.width
            rad1.layer.cornerRadius = CGFloat(r*2)/2
            rad2.layer.cornerRadius = CGFloat(r*2)/2
            rad3.layer.cornerRadius = CGFloat(r*2)/2
            rad4.layer.cornerRadius = CGFloat(r*2)/2
            
                self.txtRange.text = "\(nn) \(r)"
                self.avg.text = "\(beacons[0].rssi) \(beacons[0].proximity)"
                
            }
        }
        if beacons.count > 3{
            if beacons[0].accuracy <= 0 || beacons[1].accuracy <= 0 || beacons[2].accuracy <= 0 || beacons[3].accuracy <= 0{
           
            
        }else{
                
                
                
//                xarray.append(beacons[0].accuracy)
//                let sumArray = xarray.reduce(0, +)
//
//                let avgArrayXValue = sumArray / Double(xarray.count)
//
//                yarray.append(beacons[1].accuracy)
//                let sumArrayY = yarray.reduce(0, +)
//
//                let avgArrayYValue = sumArrayY / Double(yarray.count)
//                self.avg.text = "\(avgArrayXValue) | \(avgArrayYValue)"
               
                let newB = beacons.sorted(by:{Int($0.major) > Int($1.major)})
               
                
                let b1 = min(organizeBeacons(bx: beacons, mx: 50),Double(b3max))


                let b2 = min(organizeBeacons(bx: beacons, mx: 25),Double(b2max))

                let b3 = min(organizeBeacons(bx: beacons, mx: 5),Double(b3max))

                let b4 = min(organizeBeacons(bx: beacons, mx: 0),Double(b3max))
//                let b1 = organizeBeacons(bx: beacons, mx: 50)
//                            let b2 = organizeBeacons(bx: beacons, mx: 25)
//                            let b3 = organizeBeacons(bx: beacons, mx: 5)
//                            let b4 = organizeBeacons(bx: beacons, mx: 0)

                self.txtRange.text = "\(b1) \(b2) \(b3) \(b4)"
//                self.txtRange.sizeToFit()
                let mutiplier = 0.4;
                      rad1h.constant = CGFloat(b1/mutiplier) * space.frame.size.width - 15
                         rad1w.constant = CGFloat(b1/mutiplier) * space.frame.size.width - 15
                         rad1.layer.cornerRadius = (CGFloat(b1/mutiplier) * space.frame.size.width - 15)/2
                         rad2h.constant = CGFloat(b2/mutiplier) * space.frame.size.width - 15
                         rad2w.constant = CGFloat(b2/mutiplier) * space.frame.size.width - 15
                          rad2.layer.cornerRadius = (CGFloat(b2/mutiplier) * space.frame.size.width - 15)/2
                        rad3h.constant = CGFloat(b3/mutiplier) * space.frame.size.width - 15
                         rad3w.constant = CGFloat(b3/mutiplier) * space.frame.size.width - 15
                          rad3.layer.cornerRadius = (CGFloat(b3/mutiplier) * space.frame.size.width - 15)/2
                         rad4h.constant = CGFloat(b4/mutiplier) * space.frame.size.width - 15
                         rad4w.constant = CGFloat(b4/mutiplier) * space.frame.size.width - 15
                         rad4.layer.cornerRadius = (CGFloat(b4/mutiplier) * space.frame.size.width - 15)/2
                let k = myTrilateration(r1: Float(b1), r2: Float(b2), r3:Float(b3),r4:Float(b4), x1: 0, y1: 0, x2:(-pb1["x"]!), y2: pb1["y"]!, x3: pb2["x"]!,y3: pb2["y"]!,x4: -pb3["x"]!,y4: pb3["y"]!)

                self.avg.text = "X: \(k.x!) Y: \(k.y!)"
                self.xPos = k.x!
                self.yPos = k.y!
              //  let pos = getMeetingPoints(distanceA: Float(b1), distanceB: Float(b2), distanceC: Float(b3), pointA1: 0, pointA2: 0, pointB1: pb1[0], pointB2: pb1[1], pointC1: -pb2[0], pointC2: pb2[1])

                self.yAxis.constant = max(CGFloat((yPos)) * space.frame.size.height,0)
                self.xAxis.constant = (CGFloat((xPos)) * space.frame.size.width) + space.frame.size.width
               homevector()
            //manager.stopRangingBeacons(satisfying: getBRegion2().beaconIdentityConstraint)
                
                
            }
            
        }
    }
     func normValue(point: Point) -> Double {
        var norm:Double?
        norm = pow(pow(point.x!, 2) + pow(point.y!, 2) , 0.5)
        return norm!
    }
    func trilateration(point1: Point, point2: Point, point3: Point,point4:Point, r1: Double, r2:Double, r3: Double,r4:Double
    ) -> Point {
           
           //Unit vector in a direction from point1 to point 2
           var p1p2:Double = pow(pow(point2.x! - point1.x! , 2.0) + pow(point2.y! - point1.y!, 2.0), 0.5)
           
           let ex = Point(xx: (point2.x! - point1.x!) / p1p2, yy: (point2.y! - point1.y!) / p1p2)
           
           let aux = Point(xx: point3.x! - point1.x!, yy: point3.y! - point1.y!)
           
           //Signed magnitude of the x component
           let i: Double = ((ex.x)! * (aux.x)!) + ((ex.y)! * aux.y!)
           
           //The unit vector in the y direction.
           let aux2 = Point(xx: point3.x! - point1.x! - (i * (ex.x)!), yy: point3.y! - point1.y! - (i * (ex.y)!))
           
           let ey = Point(xx: (aux2.x!) / self.normValue(point: aux2), yy: (aux2.y!) / self.normValue(point: aux2))
           
           //The signed magnitude of the y component
           let j:Double = ((ey.x)! * (aux.x)!) + ((ey.y)! * (aux.y)!)
           
           //Coordinates
           let x:Double = (pow(r1, 2) - pow(r2, 2) + pow(p1p2, 2)) / (2 * p1p2)
           let y:Double = ((pow(r1, 2) - pow(r3, 2) + pow(i, 2) + pow(j, 2))/(2 * j)) - (i * x/j)
           
           //Result coordinates
           let finalX:Double = point1.x! + x * ex.x! + y * (ey.x)!
           let finalY:Double = point1.y! + x * ex.y! + y * (ey.y)!
           
           let location = Point(xx: finalX, yy: finalY)
           
           return location
       }
    
   
    func myTrilateration(r1:Float, r2:Float, r3:Float,r4:Float, x1:Float,y1:Float, x2:Float, y2:Float, x3:Float, y3:Float,x4:Float,y4:Float) -> Point{
          let A = 2*x2 - 2*x1
         let B = 2*y2 - 2*y1
         let C = powf(r1, 2) - powf(r2, 2) - powf(x1, 2) + powf(x2,2) - powf(y1,2) + powf(y2, 2)
    
        let D = 2*x3 - 2*x2
         let E = 2*y3 - 2*y2
         let F = powf(r2, 2) - powf(r3, 2) - powf(x2, 2) + powf(x3,2) - powf(y2,2) + powf(y3, 2)
        let G = 2*x4 - 2*x3
        let H = 2*y4 - 2*y3
        let I = powf(r3, 2) - powf(r4, 2) - powf(x3, 2) + powf(x4,2) - powf(y3,2) + powf(y4, 2)
        let j = powf(A, 2) + powf(D, 2) + powf(G, 2)
        let k = (A*B) + (D*E) + (G*H)
        let n = powf(B, 2) + powf(E, 2) + powf(H, 2)
        let t = (C*A) + (F*D) + (G*I)
        let r = (B*C) + (E*F) + (H*I)
       
         let x = (t - ((k*r)-(t*k*k))/((j*n) - (k*t)))
         let y = ((j*r)-(t*k))/((j*n)-(k*t))
    

        return Point(xx:Double(x),yy:Double(y))
    }
    func getMeetingPoints(distanceA:Float, distanceB:Float, distanceC:Float, pointA1:Float, pointA2:Float, pointB1:Float, pointB2:Float, pointC1:Float, pointC2:Float) -> [String:Float]{
   // var w, z, x, y, y2;
 let w = distanceA * distanceA - distanceB * distanceB - pointA1 * pointA1 - pointA2 * pointA2 + pointB1 * pointB1 + pointB2 * pointB2;
let z = distanceB * distanceB - distanceC * distanceC - pointB1 * pointB1 - pointB2 * pointB2 + pointC1 * pointC1 + pointC2 * pointC2;
   let x = (w * (pointC2 - pointB2) - z * (pointB2 - pointA2)) / (2 * ((pointB1 - pointA1) * (pointC2 - pointB2) - (pointC1 - pointB1) * (pointB2 - pointA2)));
   var y = (w - 2 * x * (pointB1 - pointA1)) / (2 * (pointB2 - pointA2));
   let y2 = (z - 2 * x * (pointC1 - pointB1)) / (2 * (pointC2 - pointB2));
    y = (y + y2) / 2;
    
        return ["x":x,
                "y":y
        ];
    }
     
    func startScanning(bregion:CLBeaconRegion) {
      

        locationManager.startMonitoring(for: bregion)
        
     locationManager.startUpdatingHeading()
       
        
        locationManager.startRangingBeacons(satisfying: bregion.beaconIdentityConstraint)
   
    }


}

class Point: NSObject {
    
    var x: Double?
    var y: Double?
    
    init(xx:Double, yy:Double) {
        x = xx
        y = yy
    }
    
}
protocol rootchange {
    func editdelegate(nam:String,xdelta:Float)
}

