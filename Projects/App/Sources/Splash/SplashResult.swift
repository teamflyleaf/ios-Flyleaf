//
//  SplashResult.swift
//  App
//
//  Created by 여성일 on 5/30/26.
//

import ReadingJourneyInterface

enum SplashResult {
  case needsLogin
  case readyToMain([ReadingJourney])
}
