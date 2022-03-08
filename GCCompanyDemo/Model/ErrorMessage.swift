//
//  ErrorMessage.swift
//  GCCompany
//
//  Created by 박승태 on 2022/03/06.
//

import Foundation

struct ErrorMessage {
    
    static let registerFavoriteHotel: String  = "관심 있는 호텔을 등록해주세요."
    static let failedAddFavorite: String      = "즐겨찾기 등록에 실패했습니다. \n다시 시도해주세요."
    static let failedRemoveFavorite: String   = "즐겨찾기 해제에 실패했습니다. \n다시 시도해주세요."
    
    static let defaultAPIFailed: String       = "예기치 못한 오류가 발생했습니다. \n잠시 후 다시 시도해주세요."
    static let defaultAPIServer: String       = "일시적으로 이용이 불가능합니다. \n잠시 후 다시 시도해주세요."
}
