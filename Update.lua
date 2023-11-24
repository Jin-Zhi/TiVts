local version = "1.0.1" --定义本地脚本版本号
local iscanupdt = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/update.").content:gsub("%\n$","") --定义云端版本号
gg.toast("检查更新中 | Checking for updates") --弹出toast对话框
local downloadfile = gg.getFile():gsub("%.lua$","").."["..iscanupdt.."].lua"--导出路径（因为不可以覆盖脚本只能这样了）
local function downloadform(files,text) --定义函数
    local downloadfiles = io.open(files,"w") --使用io库打开文件目录
    if downloadfiles then --如果文件目录存在
        downloadfiles:write(text) --导出text变量
        downloadfiles:close() --保存并退出
    end
end
if iscanupdt ~= version then --检查版本如果和云端不符
    local canupdt = gg.alert("检查到有新版本，是否更新？","好的","不了") --弹出对话框
    if canupdt == 2 then --如果用户选择了不
        gg.alert("那你随便") --弹窗提示
        version = iscanupdt --版本和云端匹配，不再提示更新
    elseif canupdt == 1 then --如果更新
        gg.alert("好的，正在从存储库调取数据") --弹窗提示
        local download = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/Update.lua").content --定义云端脚本链接
        os.exit(downloadform(downloadfile,download)) --退出并导出
    end
end
print("Hello world!--这是新版本1.0.1") --演示
