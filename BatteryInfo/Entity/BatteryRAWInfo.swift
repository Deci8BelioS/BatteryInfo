import Foundation

// 定义一个结构体来存储IO接口提供的电池原始信息
struct BatteryRAWInfo {
    var bootPathUpdated: Int?
    var serialNumber: String? // 电池序列号
    var voltage: Int? // 当前电压
    var instantAmperage: Int?  // 当前电流
    var currentCapacity: Int? // 当前电量百分比
    var appleRawCurrentCapacity: Int? // 当前电池剩余的毫安数
    var designCapacity: Int?  // 电池设计容量
    var nominalChargeCapacity: Int? // 电池当前的最大容量
    var isCharging: Bool?             // 是否充电
    var cycleCount: Int?              // 循环次数
    var temperature: Int?             // 电池温度
    var batteryData: BatteryData?     // 嵌套 BatteryData
    var lifetimeData: LifetimeData?   // 嵌套 LifetimeData
    var kioskMode: KioskMode?         // 嵌套 KioskMode
    var adapterDetails: AdapterDetails? // 充电器信息
    var chargerData: ChargerData?     // 嵌套 ChargerData
    var maximumCapacity: String?
}

extension BatteryRAWInfo {
    init(dict: [String: Any]) {
        self.bootPathUpdated = dict["BootPathUpdated"] as? Int
        self.serialNumber = dict["Serial"] as? String
        self.voltage = dict["Voltage"] as? Int
        self.instantAmperage = dict["InstantAmperage"] as? Int
        self.currentCapacity = dict["CurrentCapacity"] as? Int
        self.appleRawCurrentCapacity = dict["AppleRawCurrentCapacity"] as? Int
        self.designCapacity = dict["DesignCapacity"] as? Int
        self.nominalChargeCapacity = dict["NominalChargeCapacity"] as? Int
        self.isCharging = (dict["IsCharging"] as? Int) == 1
        self.cycleCount = dict["CycleCount"] as? Int
        self.temperature = dict["Temperature"] as? Int
        
        if let nominal = nominalChargeCapacity, let design = designCapacity, design > 0 {
            self.maximumCapacity = BatteryDataController.getFormatMaximumCapacity(nominalChargeCapacity: nominal, designCapacity: design)
        } else {
            self.maximumCapacity = nil
        }
        
        if let batteryDataDict = dict["BatteryData"] as? [String: Any] {
            self.batteryData = BatteryData(dict: batteryDataDict)
        }
        
        if let lifetimeDataDict = dict["LifetimeData"] as? [String: Any] {
            self.lifetimeData = LifetimeData(dict: lifetimeDataDict)
        }
        
        if let kioskModeDict = dict["KioskMode"] as? [String: Any] {
            self.kioskMode = KioskMode(dict: kioskModeDict)
        }
        
        if let chargerDataDict = dict["ChargerData"] as? [String: Any] {
            self.chargerData = ChargerData(dict: chargerDataDict)
        }
        
        if let adapterDataDict = dict["AdapterDetails"] as? [String: Any] {
            self.adapterDetails = AdapterDetails(dict: adapterDataDict)
        }
    }
}
