//
//  Constants.swift
//  uParker-SwiftUI
//
//  Created by Smetana, Ryan on 12/16/22.
//

import SwiftUI

let primaryColor: Color = Color("uParkerBlue")
let secondaryColor: Color = .white
let gradientEnd: Color = Color("GradientEnd")
let backgroundGradient: LinearGradient = LinearGradient(colors: [gradientEnd, primaryColor, primaryColor, gradientEnd], startPoint: .topLeading, endPoint: .bottomTrailing)

let MBAccessKey: String = "pk.eyJ1IjoicnlzbWV0IiwiYSI6ImNrZXZ5OHU4bDBoMG8ycmw5YWdjcG11bnkifQ.uREplVHezS8CYP4djva__Q"

//let tabBarHeight: CGFloat = 49
//let tabViewDividerPadding: CGFloat = 8
let searchBarHeight: CGFloat = 50

let states = [  "---Select State---",
                "AK - Alaska",
                "AL - Alabama",
                "AR - Arkansas",
                "AZ - Arizona",
                "CA - California",
                "CO - Colorado",
                "CT - Connecticut",
                "DE - Delaware",
                "FL - Florida",
                "GA - Georgia",
                "HI - Hawaii",
                "IA - Iowa",
                "ID - Idaho",
                "IL - Illinois",
                "IN - Indiana",
                "KS - Kansas",
                "KY - Kentucky",
                "LA - Louisiana",
                "MA - Massachusetts",
                "MD - Maryland",
                "ME - Maine",
                "MI - Michigan",
                "MN - Minnesota",
                "MO - Missouri",
                "MS - Mississippi",
                "MT - Montana",
                "NC - North Carolina",
                "ND - North Dakota",
                "NE - Nebraska",
                "NH - New Hampshire",
                "NJ - New Jersey",
                "NM - New Mexico",
                "NV - Nevada",
                "NY - New York",
                "OH - Ohio",
                "OK - Oklahoma",
                "OR - Oregon",
                "PA - Pennsylvania",
                "RI - Rhode Island",
                "SC - South Carolina",
                "SD - South Dakota",
                "TN - Tennessee",
                "TX - Texas",
                "UT - Utah",
                "VA - Virginia",
                "VT - Vermont",
                "WA - Washington",
                "WI - Wisconsin",
                "WV - West Virginia",
                "WY - Wyoming"
]

let stateAbbreviations = [
    "AK",    "AL",    "AR",    "AZ",    "CA",    "CO",    "CT",    "DE",    "FL",    "GA",    "HI",    "IA",    "ID",    "IL",    "IN",    "KS",    "KY",    "LA",    "MA",    "MD",    "ME",    "MI",    "MN",    "MO",    "MS",    "MT",    "NC",    "ND",    "NE",    "NH",    "NJ",    "NM",    "NV",    "NY",    "OH",    "OK",    "OR",    "PA",    "RI",    "SC",    "SD",    "TN",    "TX",    "UT",    "VA",    "VT",    "WA",   "WI",    "WV",    "WY"
]
