local downloadfile = gg.getFile()
local function downloadform(text)
    if text ~= nil and text ~= "" and text ~= "\n" then
        local outputfiles = io.open(downloadfile,"w")
        if outputfiles then
            outputfiles:write(text)
            outputfiles:close()
        end
    end
end
local iscanupdt = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/update.").content
local download = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/Update.lua").content
local version = "1.0.1"
gg.toast("检查更新中 | Checking for updates")
if iscanupdt ~= version then
    local canupdt = gg.alert("检查到有新版本，是否更新？","不","好的")
    if canupdt == 1 then
        gg.alert("那你随便")
        version = iscanupdt
    end
    if canupdt == 2 then
        gg.alert("好的，正在从存储库调取数据")
        dooutput(download,gg.getFile())
        os.exit(gg.alert("请重启脚本"))
        print(download..gg.getFile())
    end
end
print("Hello world!--这是新版本--1.0.1")
