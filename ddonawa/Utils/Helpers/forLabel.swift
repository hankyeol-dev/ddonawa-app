//
//  forLabel.swift
//  ddonawa
//
//  Created by 강한결 on 6/15/24.
//

import Foundation

func _formatString(_ t: String) -> String {
    let numberFormatter: NumberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    return numberFormatter.string(for: Int(t)) ?? ""
}

func _replaceHTMLTag(_ t: String) -> String {
    let patten = "<[^>]+>|&quot;|<b>|</b>"
    return t.replacingOccurrences(of: patten, with: "", options: .regularExpression, range: nil)
}

func _genFormattedDate() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    formatter.locale = Locale(identifier: "ko_KR")

    return formatter.string(from: date)
}
