import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let versionCode = "1.1.9"
    
    private var tableView = UITableView()
    
    private let settingsUtils = SettingsUtils.instance
    
    private let tableTitleList = [nil, NSLocalizedString("MaximumCapacityAccuracy", comment: ""), NSLocalizedString("About", comment: "")]
    
    private let tableCellList = [[NSLocalizedString("LanguageSettings", comment: ""), NSLocalizedString("DisplaySettings", comment: ""), NSLocalizedString("DataRecordSettings", comment: "")], [NSLocalizedString("KeepOriginal", comment: ""), NSLocalizedString("Ceiling", comment: ""), NSLocalizedString("Round", comment: ""), NSLocalizedString("Floor", comment: "")], [NSLocalizedString("Version", comment: ""), "GitHub", "Havoc", NSLocalizedString("ThanksForXiaoboVlog", comment: "")]]
    // NSLocalizedString("ShowCPUFrequency", comment: "")
    
    // 标记一下每个分组的编号，防止新增一组还需要修改好几处的代码
    private let maximumCapacityAccuracyAtSection = 1
    private let aboutAtSection = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Settings", comment: "")
        
        // iOS 15 之后的版本使用新的UITableView样式
        if #available(iOS 15.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: .zero, style: .grouped)
        }

        // 设置表格视图的代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册表格单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // 将表格视图添加到主视图
        view.addSubview(tableView)

        // 设置表格视图的布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableTitleList.count
    }
    
    // MARK: - 设置每个分组的Cell数量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellList[section].count
    }
    
    // MARK: - 设置每个分组的顶部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableTitleList[section]
    }
    
    // MARK: - 设置每个分组的底部标题 可以为分组设置尾部文本，如果没有尾部可以返回 nil
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            return NSLocalizedString("AutoRefreshDataFooterMessage", comment: "")
        }
        return nil
    }
    
    // MARK: - 构造每个Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.accessoryView = .none
        cell.selectionStyle = .none
        
        cell.textLabel?.text = tableCellList[indexPath.section][indexPath.row]
        cell.textLabel?.numberOfLines = 0 // 允许换行
        
        if indexPath.section == 0 {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default // 启用选中效果
        } else if indexPath.section == maximumCapacityAccuracyAtSection {
            cell.selectionStyle = .default
            if indexPath.row == settingsUtils.getMaximumCapacityAccuracy().rawValue {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else if indexPath.section == aboutAtSection { // 关于
            if indexPath.row == 0 {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                cell.textLabel?.text = tableCellList[indexPath.section][indexPath.row]
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? NSLocalizedString("Unknown", comment: "")
                if version != versionCode { // 判断版本号是不是有人篡改
                    cell.detailTextLabel?.text = versionCode
                } else {
                    cell.detailTextLabel?.text = version
                }
                cell.selectionStyle = .none
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .default // 启用选中效果
            }
        }
            
        return cell
    }
    
    // MARK: - Cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let languageSettingsViewController = LanguageSettingsViewController()
                languageSettingsViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(languageSettingsViewController, animated: true)
            } else if indexPath.row == 1 {
                let displaySettingsViewController = DisplaySettingsViewController()
                displaySettingsViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(displaySettingsViewController, animated: true)
            } else if indexPath.row == 2 {
                let dataRecordSettingsViewController = DataRecordSettingsViewController()
                dataRecordSettingsViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(dataRecordSettingsViewController, animated: true)
            }
        } else if indexPath.section == maximumCapacityAccuracyAtSection { // 切换设置
            // 取消之前的选择
            tableView.cellForRow(at: IndexPath(row: settingsUtils.getMaximumCapacityAccuracy().rawValue, section: indexPath.section))?.accessoryType = .none
            // 保存选项
            settingsUtils.setMaximumCapacityAccuracy(value: indexPath.row)
            // 设置当前的cell选中状态
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else if indexPath.section == aboutAtSection {
            if indexPath.row == 1 {
                if let url = URL(string: "https://github.com/DevelopCubeLab/BatteryInfo") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 2 {
                if let url = URL(string: "https://havoc.app/package/batteryinfo") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if indexPath.row == 3 {
                if let url = URL(string: "https://m.xiaobovlog.cn/") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
