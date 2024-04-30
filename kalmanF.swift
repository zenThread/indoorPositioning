//
//  kalmanF.swift
//  indoorPositioning
//
//  Created by isaiah childs on 9/7/20.
//  Copyright © 2020 isaiah childs. All rights reserved.
//

import Foundation
import UIKit

class kFilter{
    public var estimatedRSSI = 0.0 // Calculated rssi
      
      private var processNoise = 0.125 // Process noise
      private var measurementNoise = 0.8 // Measurement noise
      private var errorCovarianceRSSI = 0.0 // Calculated covariance
      
      private var isInitialized = false // Initialization flag
      
       func applyFilter(rssi:Double) -> Double{
          var priorRSSI = 0.0
          var kalmanGain = 0.0
          var priorErrorCovarianceRSSI = 0.0
          
          if (!isInitialized) {
              priorRSSI = rssi
              priorErrorCovarianceRSSI = 1.0
              isInitialized = true
          } else {
              priorRSSI = estimatedRSSI
              priorErrorCovarianceRSSI = errorCovarianceRSSI + processNoise
          }

          kalmanGain = priorErrorCovarianceRSSI / (priorErrorCovarianceRSSI + measurementNoise)
          estimatedRSSI = priorRSSI + (kalmanGain * (rssi - priorRSSI))
          errorCovarianceRSSI = (1 - kalmanGain) * priorErrorCovarianceRSSI
          return estimatedRSSI
      }
}

