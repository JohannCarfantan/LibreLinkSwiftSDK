import Foundation

public struct loginRequestBody {
    var email: String
    var password: String
}

public struct LoginRequestAnswer: Decodable {
    let status: Int
    let data: LoginAnswerData
         
    struct LoginAnswerData: Decodable {
        let user: LoginAnswerUserData
        let messages: LoginAnswerMessages
        let notifications: LoginAnswerNotifications
        let authTicket: LoginAnswerAuthTicket
        let invitations: [String]?
        let trustedDeviceToken: String
    }
    
    struct LoginAnswerUserData: Decodable {
        let id: String
        let firstName: String
        let lastName: String
        let email: String
        let country: String
        let uiLanguage: String
        let communicationLanguage: String
        let accountType: String
        let uom: String
        let dateFormat: String
        let timeFormat: String
        let emailDay: [Int]
        let system: LoginAnswerUserDataSystem
        let details: LoginAnswerUserDataEmpty
        let created: Int
        let lastLogin: Int
        let programs: LoginAnswerUserDataEmpty
        let dateOfBirth: Int
        let practices: LoginAnswerUserDataEmpty
        let devices: LoginAnswerUserDataEmpty
        let consents: LoginAnswerUserDataConsents
    }
    
    struct LoginAnswerUserDataEmpty: Decodable {}
    
    struct LoginAnswerUserDataSystem: Decodable {
        let messages: LoginAnswerUserDataSystemMessages
    }
    
    struct LoginAnswerUserDataSystemMessages: Decodable {
        let firstUsePhoenix: Int
        let firstUsePhoenixReportsDataMerged: Int?
        let lluGettingStartedBanner: Int
        let lluNewFeatureModal: Int
        let lluOnboarding: Int?
        let lvWebPostRelease: String?
    }
    
    struct LoginAnswerUserDataConsents: Decodable {
        let llu: LoginAnswerUserDataConsentsLlu?
    }
    
    struct LoginAnswerUserDataConsentsLlu: Decodable {
        let policyAccept: Int
        let touAccept: Int
    }
    
    struct LoginAnswerMessages: Decodable {
        let unread: Int
    }
    
    struct LoginAnswerNotifications: Decodable {
        let unresolved: Int
    }
    
    struct LoginAnswerAuthTicket: Decodable {
        let token: String
        let expires: Int
        let duration: Int
    }
}

public struct GetConnectionsRequestAnswer: Decodable {
    let status: Int
    let data: [Datum]
    let ticket: Ticket
}

public struct ReadRawResponse: Decodable {
    let status: Int
    let data: ReadData
    let ticket: Ticket
}

struct Datum: Decodable {
    let id: String
    let patientId: String
    let country: String
    let status: Int
    let firstName: String
    let lastName: String
    let targetLow: Int
    let targetHigh: Int
    let uom: Int
    let sensor: Sensor;
    let alarmRules: AlarmRules;
    let glucoseMeasurement: Glucose;
    let glucoseItem: Glucose;
    let glucoseAlarm: Bool?
    let patientDevice: PatientDevice
    let created: Int
}

struct Ticket: Decodable {
    let token: String
    let expires: Int
    let duration: Int
}

struct Sensor: Decodable {
    let deviceId: String
    let sn: String
    let a: Int
    let w: Int
    let pt: Int
}

struct AlarmRules: Decodable {
    let c: Bool
    let h: H
    let f: F
    let l: F
    let nd: Nd
    let p: Int
    let r: Int
    let std: Std
}

struct F: Decodable {
    let th: Float
    let thmm: Float
    let d: Float
    let tl: Float
    let tlmm: Float
    let on: Bool?
}

struct H: Decodable {
    let on: Bool?
    let th: Float
    let thmm: Float
    let d: Float
    let f: Float
}

struct Nd: Decodable {
    let i: Float
    let r: Float
    let l: Float
}

struct Std: Decodable {}

public struct ReadData: Decodable {
    let connection: Connection
    let activeSensors: [ActiveSensor]
    let graphData: [GlucoseItem]
}

struct Glucose: Decodable {
    let FactoryTimestamp: String
    let Timestamp: String
    let type: Int
    let ValueInMgPerDl: Int
    let TrendArrow: Int
    let TrendMessage: Int?
    let MeasurementColor: Int
    let GlucoseUnits: Int
    let Value: Int
    let isHigh: Bool
    let isLow: Bool
}

struct PatientDevice: Decodable {
    let did: String
    let dtid: Int
    let v: String
    let ll: Int
    let hl: Int
    let u: Int
    let fixedLowAlarmValues: FixedLowAlarmValues;
    let alarms: Bool
}

struct FixedLowAlarmValues: Decodable {
    let mgdl: Float
    let mmoll: Float
}

struct Device: Decodable {
    let did: String
    let dtid: Float
    let v: String
    let ll: Float
    let hl: Float
    let u: Float
    let fixedLowAlarmValues: FixedLowAlarmValues;
    let alarms: Bool
}

struct ActiveSensor: Decodable {
    let sensor: Sensor
    let device: Device
}

public struct GlucoseItem: Decodable {
    let FactoryTimestamp: String
    let Timestamp: String
    let type: Int
    let ValueInMgPerDl: Float
    let TrendArrow: Float?
    let TrendMessage: Int?
    let MeasurementColor: Int
    let GlucoseUnits: Int
    let Value: Int
    let isHigh: Bool
    let isLow: Bool
}

struct Connection: Decodable {
    let id: String
    let patientId: String
    let country: String
    let status: Int
    let firstName: String
    let lastName: String
    let targetLow: Int
    let targetHigh: Int
    let uom: Int
    let sensor: Sensor
    let alarmRules: AlarmRules
    let glucoseMeasurement: GlucoseItem
    let glucoseItem: GlucoseItem
    let glucoseAlarm: Bool?
    let patientDevice: Device
    let created: Int
}
