local iscanupdt, version = "2.0.0" -- 定义本地脚本版本号

local OSF="/storage/emulated/0/"
local DATA=OSF.."Android/data/"
local N=DATA.."VLine-Ti Vts Lite [v2.0.0]-"
local Scriptaddress = gg.getFile()

function existfile(files) -- 定义文件检查
    local localfiles = io.open(files, "r") -- 使用io库打开文件
    if localfiles then -- 存在
        localfiles:close() -- 关闭
        return true -- 返回真
    else -- 否则
        return false -- 返回假
    end
end
function savetext(files, text) -- 定义导出
    local localfiles = io.open(files, "w") -- 使用io库打开文件
    if localfiles then -- 如果文件目录存在
        localfiles:write(text) -- 导出text变量
        localfiles:close() -- 保存并退出
        --return text -- 返回导出内容
    --else
        --return nil -- 返回nil
    end
end
function loadtext(files) -- 定义加载文本
    local localfiles = io.open(files, "r") -- 使用io库打开文件
    if localfiles then -- 如果文件存在
        local content = localfiles:read("*a") -- 读取
        localfiles:close() -- 关闭
        return content -- 返回文本
    else --不存在
        return nil -- 返回nil
    end
end

local TDT = { -- TDT工具箱
    Config = {
        Language = gg.getLocale(),
        Timezone = os.setlocale(Language, "time"),
        TimestampFormat = os.date("%%")
    },
    Date = {
        Year = os.date("%Y"),
        ShortYear = os.date("%y"),
        Week = os.date("%W"),
        WeekDayNumber = os.date("%w"),
        Date = os.date("%x"),
        Month = os.date("%m"),
        Day = os.date("%d"),
        isFestival = false
    },
    Time = {
        Time = os.date("%X"),
        Hour24 = os.date("%H"),
        Hour12 = os.date("%I"),
        Minute = os.date("%M"),
        Second = os.date("%S"),
        AmOrPm = os.date("%p")
    },
    Other = {
        Timestamp = os.date("%Y/%m/%d %H:%M:%S"),
        DateTime = os.date("%c"),
        ShortWeekDayName = os.date("%a"),
        FullWeekDayName = os.date("%A"),
        ShortMonthName = os.date("%b"),
        FullMonthName = os.date("%B")
    },
    Author = "今芷",
    Telegram = "@JZZPD"
} -- TDT工具箱
tsf = N.."[时间戳].cfg" -- 定义时间戳目录
ts = TDT.Date.Day..TDT.Date.Month..TDT.Date.WeekDayNumber..TDT.Date.ShortYear..TDT.Time.Hour12..TDT.Date.Year -- 时间戳内容


function CheckUpdate() --定义检查更新函数
    local iscanupdt_pre = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/update.") -- 定义云端版本号链接
    
    if iscanupdt_pre.content == nil then -- 如果断网
        gg.toast("离线状态，将使用本地脚本\nOffline state, local script will be used")
        iscanupdt = version -- 不弹出更新
    else -- 联网
        iscanupdt = gg.makeRequest("https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/update.").content:gsub("%\n$", "") -- 定义云端版本号
    end

    gg.toast("检查更新中\nChecking for updates") -- 弹出toast对话框
    if iscanupdt ~= version then -- 检查版本如果和云端不符
        local canupdt = gg.alert("检查到有新版本，是否更新？", "好的", "不了") -- 弹出对话框
        if canupdt == 2 then -- 如果用户选择了不
            gg.alert("那你随便") -- 弹窗提示
            version = iscanupdt -- 版本和云端匹配，不再提示更新
        elseif canupdt == 1 then -- 如果更新
            gg.toast("好的，正在从存储库调取数据") --弹窗提示
            local downloadurl = "https://raw.githubusercontent.com/Jin-Zhi/TiVts/main/lua." --定义解析链接
            local download = gg.makeRequest(downloadurl).content --定义云端脚本链接
            local downloadfile = gg.getFile():gsub("%[.-%]", "["..iscanupdt.."]")--导出路径（因为不可以覆盖脚本只能这样了）
            os.exit(savetext(downloadfile,download),savetext(tsf,ts),gg.alert("成功从\""..downloadurl.."\"下载了\n\n\""..download.."\"\n\n至\n\""..downloadfile.."\"\n请使用新脚本！")) --退出并导出+提示
        end
    end
    if iscanupdt_pre.content == nil then
        gg.alert("离线模式")
        savetext(tsf,"离线")
    end
end

if loadtext(tsf) ~= ts then
    savetext(tsf,ts)
    CheckUpdate()
end
--↑云验证 | 元编程↓--

--↑元编程 | 初始化↓--
--调用--
function isNotPowerOfTwo(n)
    return n <= 0 or (n & (n - 1)) ~= 0 -- 返回布尔值
end -- isPowerOfTwo函数结束

-- 根据数字范围返回对应的十六进制长度
function getHexLength(v)
    if v <= 9223372036854775807 and v >= -9223372036854775808 then
        if v >= -9223372036854775808 and v <= 18446744073709551615 then  -- 检查是否在64位有符号整数范围内
            if v >= -2147483648 and v <= 4294967295 then  -- 检查是否在32位有符号整数范围内
               if v >= -32768 and v <= 65535 then  -- 检查是否在16位有符号整数范围内
                    if v >= -128 and v <= 255 then  -- 检查是否在8位有符号整数范围内
                        return 2  -- 1字节
                    else
                        return 4  -- 2字节
                    end
                else
                    return 8  -- 4字节
                end
            else
                return 16  -- 8字节
            end
        else
            return 32  -- 超出范围，使用16字节的DoubleQword
        end
    else
        os.exit(print("阻止了一个错误 | An error was prevented ：\n\n`bad argument #2 to 'string.format' (number: number '"..v.."' has no integer representation) (field 'format')\nlevel = 1, const = 11, proto = 0, upval = 1, vars = 6, code = 39\nCALL v3..v5 v3..v3\n ; PC 14 CODE 018080DD OP 29 A 3 B 3 C 2 Bx 1538 sBx -129533\nstack traceback:\n	[Java]: in ?\n	at luaj.ap.a(Unknown Source:70)\n	at luaj.ap.p(Unknown Source:10)\n	at luaj.lib.StringLib$format.a_(Unknown Source:114)\n	at android.ext.Script$format.a_(Unknown Source:32)\n	at luaj.lib.VarArgFunction.a(Unknown Source:4)\n	at luaj.LuaClosure.a(Unknown Source:1862)\n	at luaj.LuaClosure.a(Unknown Source:16)\n	at luaj.LuaClosure.a(Unknown Source:1838)\n	at luaj.LuaClosure.l(Unknown Source:7)\n	at android.ext.Script.d(Unknown Source:493)\n	at android.ext.Script$ScriptThread.run(Unknown Source:24)\n\n结束 end")) -- 超出lua范围阻止错误
    end
end  -- getHexLength函数结束

-- 将输入字符串分割并重新排列
function splitAndReorder(input)
    local result = {}  -- 创建一个空表用于存储结果
    local length = #input  -- 获取输入字符串的长度
    
    if length % 2 == 0 and length > 0 then  -- 检查字符串长度是否为偶数且大于0
        local numParts = length / 2  -- 计算分割后的部分数量
        for i = 1, numParts do
            local startIndex = (numParts - i) * 2 + 1  -- 计算每部分的起始索引
            local part = string.sub(input, startIndex, startIndex + 1)  -- 提取每部分的子字符串
            table.insert(result, part)  -- 将子字符串插入结果表中
        end
    else -- 否则
        return nil -- 返回nil值
    end
    
    return result  -- 返回分割并重新排列后的结果
end  -- splitAndReorder函数结束

-- 获取数字的十六进制表示，并按照规则分割和重新排列
function getFormattedHex(number, ...)
    local hexLength = ... or getHexLength(number)  -- 获取十六进制长度
    
    if hexLength < 2 or hexLength == nil or isNotPowerOfTwo(hexLength) == true then
        hexLength = getHexLength(number)
    end
    
    local hexString = string.format("%X", number)  -- 将数字转换为十六进制字符串
    
    if #hexString < hexLength then  -- 如果字符串长度小于规定的长度
        hexString = string.rep("0", hexLength - #hexString) .. hexString  -- 在字符串前面补0
    end
    
    local parts = splitAndReorder(hexString)  -- 分割并重新排列
    
    return parts  -- 返回分割并重新排列后的结果
end  -- getFormattedHex函数结束

-- 将分割后的十六进制数组格式化为字符串
function formatHexToString(hexArray)
    local formattedHex = "h"  -- 初始化格式化后的字符串
    for i, v in ipairs(hexArray) do
        formattedHex = formattedHex .. " " .. v  -- 将每部分十六进制值添加到字符串中
    end
    return formattedHex  -- 返回格式化后的字符串
end  -- formatHexToString函数结束


-- 将使用函数简易化
function getHEX(number, ...)
    
    local hexLength = ... -- 定义可变变量
    
    if hexLength == nil then -- 用户没有传入变量
        return formatHexToString(getFormattedHex(number)) -- 直接使用函数
    else -- 用户传入了变量
        return formatHexToString(getFormattedHex(number, hexLength)) -- 增加可变变量在getFormattedHex函数
    end
end -- getHEX函数结束


--[[
注意！getHEX传入第二个变量是非正整偶数则自动获取长度!
Create By 今芷
Telegram @ZZOD
]]--


--CMD--

local T_DB_M_Console = "Console:\n..."
local T_DB_M_Command = "/"
local T_DB_M_Outputs = ""
local CMD_UI_OFFSETS_VALUE = false
local indx = ""
local ESLDO = ""
local perform
local cmd_esl_do
local cmd_esl_bool
---------
--变量--
local offset = 0
local restore = false
local User_Protocol = false
local label,bit
local targetInfo = gg.getTargetInfo()
if targetInfo == nil then
    label = "Unknown Process"
    bit = "nil "
else
    if targetInfo.activities == nil then
        label = "Unknown Process"
        bit = "nil "
    else
        label = targetInfo.activities[1].label
        bit = targetInfo.x64 and "64" or "32"
    end
end
local output_index_pre = 1
output_index = ""..output_index_pre
local outputfile_gsub = Scriptaddress:gsub("%.lua$","-导出第[")
local outputfile = outputfile_gsub..output_index.."]个文件.h"
local output = ""
local name,oname,edv
local ind = 1
local savemodefile-- = Scriptaddress:gsub("%.lua$","-[模式].cfg")
savemodefile = N.."[模式].cfg"
local Temp = {isok = false,ist=false}
local language = gg.getLocale()
local isVIP = gg.isPackageInstalled("cn.jinzhi.sc")
local isAdmin = gg.isPackageInstalled("cn.jznb666.rq.app")
local username = "User"
local language_return,language_tips,language_welcom_tip,isVIP_text,isAdmin_text,language_local,support
local namefile = N.."[用户名 | Username].cfg"
local QZ = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25}
local select,ranges,save
ranges = gg.getRangesList()
select = gg.getSelectedListItems()
save = gg.getListItems();
--函数--
local function dooutput(text)
    if text ~= nil or text ~= "" or text ~= "\n" then
        local outputfiles = io.open(outputfile,"w")
        if outputfiles then
            outputfiles:write(text)
            outputfiles:close()
        end
    end
end
function ESL(lua)
    if lua ~= nil or lua ~= "" then
        perform = load(lua)
        perform()
        ESLDO = "Success"
    else
        ESLDO = "Failure"
    end
end
function aek()

end
--刷新--
local loadnames = loadtext(namefile)
if loadnames then
    username = loadnames
end
local loadmodes = loadtext(savemodefile)
if loadmodes then
    Modes = loadmodes
end
while outputfile == "=?1]个文件.h" do
    outputfile_gsub = N.."-导出第["
    outputfile = ""
end
while existfile(outputfile) do
    output_index_pre = output_index_pre + 1
    output_index = ""..output_index_pre
    outputfile = outputfile_gsub..output_index.."]个文件.h"
end

if language == "zh_CN" then
    language_tips = "zh-CN是您的语言吗？\nIs [zh-CN] your language?"
elseif language == "zh_HK" then
    language_tips = "zh-HK是您的語言嗎？\nIs [zh-HK] your language?"
elseif language == "en_US" then
    language_tips = "en-US是您的语言吗？\nIs [en_US] your language?"
else
    support = false
    language_local = language:gsub("%_$","-")
    language_tips = language.."是您的语言吗？\nIs ["..language.."] your language?"
end
if isVIP == true then
    if isAdmin == false then
        isVIP_text = "VIP"
    else
        isVIP_text = "Admin"
    end
elseif isAdmin == true then
    isVIP_text = "Admin"
elseif isVIP == false then
    isVIP_text = "User"
end

while TDT.Time.Hour24 == os.date("%H") do
    if TDT.Date.isFestival == true then
        
    else
        if TDT.Time.Hour24 == "01" or TDT.Time.Hour24 == "02" or TDT.Time.Hour24 == "03" or TDT.Time.Hour24 == "04" or TDT.Time.Hour24 == "05" then
            Greet = "凌晨，一天的起点，凌晨好呀！咦？怎么这么早就起来啦？早起做到了有没有做到早睡呀？"
        elseif TDT.Time.Hour24 == "06" or TDT.Time.Hour24 == "07" or TDT.Time.Hour24 == "08" then
            Greet = "又是新的一天，每天都要开开心心的噢！"
        elseif TDT.Time.Hour24 == "09" or TDT.Time.Hour24 == "10" or TDT.Time.Hour24 == "11" then
            Greet = "上午好吖！有没有想我呀？"
        elseif TDT.Time.Hour24 == "12" or TDT.Time.Hour24 == "13" then
            Greet = "中午好呀，屏幕前的你，吃饭了嘛？我每时每刻我都在你身边哦！"
        elseif TDT.Time.Hour24 == "14" or TDT.Time.Hour24 == "15" then
            Greet = "下午啦！这个时候最适合睡午觉了，我就不打扰你啦！"
        elseif TDT.Time.Hour24 == "16" or TDT.Time.Hour24 == "17" then
            Greet = "下午要结束了，一天也快到尽头了，明天也爱你呦！"
        elseif TDT.Time.Hour24 == "18" or TDT.Time.Hour24 == "19" then
            Greet = "傍晚了，天开始冷了，注意一点千万别着凉了！！"
        elseif TDT.Time.Hour24 == "20" or TDT.Time.Hour24 == "21" then
            Greet = "晚上了，睡觉注意别冷到了，如果你不睡觉的话要穿好衣服哟！"
        elseif TDT.Time.Hour24 == "22" or TDT.Time.Hour24 == "23" or TDT.Time.Hour24 == "24" then
            Greet = "午夜时分，你怎么还在这？乖，明天再来吧，好好睡觉别累着了！"
        end
        
    end
    break
end
--Main()--
function New()
    local isyourlanguage = gg.alert("["..language.."]-"..language_tips,"No / 不是", "Yes / 是")
    if isyourlanguage == 1 then
        os.exit(gg.alert("抱歉，如果不是您的语言请检查修改器语言配置\nSorry, if it is not your language, please check the modifier language configuration"))
    elseif isyourlanguage == 2 then
        if language == "zh_CN" then
            gg.alert("恭喜您，您的语言在我们的支持语言中")
            language_welcome_tip = "欢迎"
        elseif language == "zh_HK" or  language == "zh_TW" then
            local zhhk_zhtw = gg.alert("抱歉，目前我們祇有簡體中文&英文支持，不過你可以使用簡體中文","使用簡中版","退出","加入計畫")
            if zhhk_zhtw == 1 then
                language_welcome_tip = "欢迎"
                Main()
            elseif zhhk_zhtw == 2 then
                os.exit()
            elseif zhhk_zhtw == 3 then
                os.exit(gg.copyText("@jzyLy"),gg.toast("已複製Telegram聯繫方式"))
            else
                os.exit(gg.alert("參數錯誤！"))
            end
        elseif language == "en_US" then
            local enus = gg.alert("Congratulations, your language is in our supported languages","OK")
        elseif support == false then
            local notsupport = gg.alert("Sorry, your language is not one of our supported languages,You can use the En ver.\n\n\n\n\n\nBut you can participate in our translation program","Use En ver","Exit","Join Program")
            if notsupport == 1 then
                Main()
            elseif notsupport == 2 then
                os.exit()
            elseif notsupport == 3 then
                os.exit(gg.copyText("@jzyLy"),gg.toast("Telegram contacts have been copied."))
            else
                os.exit(gg.alert("Parameter error."))
            end
        end
    NewUser()
    end
end
function NewUser()
    local usernameedit = gg.prompt({"您好，初次使用，请告诉我你的姓名吧！\nHello, first use, please tell me your name!","加入频道 | Join Channel."},{"",true},{"text","checkbox"})
    if usernameedit == nil then
        NewUser()
    else
        if usernameedit[2] == true then
            gg.copyText("@JZZPD")
            gg.toast("已复制 | 已複製 | Copied")
        end
        local airpd_u = usernameedit[1]:gsub("% $","")
        if airpd_u == "" or airpd_u == nil then
            NewUser()
        else
            username = usernameedit[1]
            savetext(namefile,username)
        end
        if usernameedit[1] ~= nil or usernameedit[1] == nil or usernameedit[1] ~= "" or usernameedit[1] == "" or usernameedit[2] ~= nil or usernameedit[2] == nil or usernameedit[2] == false or usernameedit[2] == true then
            gg.alert(language_welcome_tip..","..username.."->".."["..isVIP_text.."]")
            Main()
        else
            New()
        end
    end
end
function T(CHO)
    if CHO == "调试界面" then
        T_DB_M_Command = "/"
        local T_DB_M = gg.prompt(
            {
                T_DB_M_Console,"清除控制台"
            },
            {
                T_DB_M_Command,false
            },
            {
                "text","checkbox"
            }
        )
        if T_DB_M == nil then
            if Modes == "默认模式 | Default Mode" then
                All()
            elseif Modes == "精简模式 | Lite Mode" then
                Lite()
            end
        else
            T_DB_M_Command = T_DB_M[1]
            T_DB_M_Console = T_DB_M_Console.."\n-"..T_DB_M_Command
            if cmd_esl_do ~= true then
                if T_DB_M_Command == "/setbool ui offsets_value true" then
                    CMD_UI_OFFSETS_VALUE = true
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Boolean<<class=ui->table->offest->value=set>>true".."-]\n"
                elseif T_DB_M_Command == "/setstring hellomssages <empty>" then
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."String<<class=ui->table->offest->value=set>>\"\"".."-]\n"
                elseif T_DB_M_Command == "/setbool ui offsets_value false" then
                    CMD_UI_OFFSETS_VALUE = false
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Boolean<<class=ui->table->offest->value=set>>false".."-]\n"
                elseif T_DB_M_Command == "/killprocess" then
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Process<<{ "..label.."="..bit.." }->KillProcess>>success".."-]\n"
                    gg.processKill()
                elseif T_DB_M_Command == "/exit" then
                    os.exit(21)
                elseif T_DB_M_Command == "" or T_DB_M_Command == "/" or T_DB_M_Command == nil then
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Command cannot be empty!".."-]\n"
                elseif T_DB_M_Command == "/esl" then
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Input Lua Do?[Y/n]".."-]\n"
                    cmd_esl_bool = true
                elseif T_DB_M_Command == "/aek" then
                    aek()
                elseif cmd_esl_bool == true then
                    if T_DB_M_Command == "y" or T_DB_M_Command == "Y" then
                   T_DB_M_Console = T_DB_M_Console.."\n[-".."Now in Lua mode, please enter the execution code.".."-]\n"
                    cmd_esl_do = true
                    end if T_DB_M_Command == "n" or T_DB_M_Command == "N" then
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Recover!".."-]\n"
                    end
                    cmd_esl_bool = false
                else
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Invalid command!<=\""..T_DB_M_Command.."\"=>".."-]\n"
                end
            end if cmd_esl_do == true then
                T("调试界面")
                if T_DB_M_Command ~= "" or T_DB_M_Command ~= nil then
                    perform = load(lua)
                    perform()
                else
                    T_DB_M_Console = T_DB_M_Console.."\n[-".."Invalid syntax!<=\""..T_DB_M_Command.."\"=>".."-]\n"
                end
            end
            if T_DB_M[2] == true then
                T_DB_M_Console = "Console:\n[-".."Console prompt cleared!".."-]\n..."
            end
            T("调试界面")
        end
    end
    if CHO == "设置选项" then
        gg.alert("留给后面用的的你点进来干哈？(/\"≡ _ ≡)=\nIt's empty. There's nothing here.")
        JZNB = 1
    end
    if CHO == "SO" then
        local soi = 1
        for i=1,#select do
	        for k,v in pairs(ranges) do
		        if tonumber(select[i].address) >= v["start"] and tonumber(select[i].address) <= v["end"] then			
		            for n,m in pairs(gg.getRangesList(v.internalName)) do
		                if m.start==v.start then
		                    	
	                        output = output..string.format("internalName:"..v["internalName"].."//["..i.."]\n")
	                        soi = soi + 1
                            break
                        end
           		    end
    		    end
		    end
	    end
        gg.toast("扫描了["..soi.."]条值")
        soi = 1
    end
    if CHO == "其他工具" then
        local T_O_T = gg.choice({
            "GG API",
            "返回 | BACK"
        },2)
        if T_O_T == 1 then
            os.exit(gg.setVisible(true),print(gg),print("\nGeter By JinZhi"))
        elseif T_O_T == 2 then
            JZNB = 1
        end
    end
    if CHO == "作者的话" then
        local byjinzhisays = gg.alert("有些小bug懒得修就这样能跑就ok\nSome small bugs are too lazy to fix, so it's OK to use them.\nPATCH(HOOK)_LIB估计得过会儿做\nPATCH (HOOK) _ LIB Estimated to be done later\n每个版本的前3个版本的开源版本我会发出来\nI will send out the open source version of the first three versions of each version.\n当然作者名都是变量因为只是给你学习不是给你二改的\nOf course, the author's name is a variable, because it is only for you to learn, not for you to change.\n\n用户协议 | User Protocol\n1.全开源版本的会放在GitHub上，到时候TG会发，全开源版本禁止二次修改仅供学习参考！\n2.禁止进行二次售卖！\n\n1. The full open source version will be put on GitHub, and TG will release it at that time. The full open source version is forbidden to be modified twice for learning reference only! \n2. Secondary sales are prohibited!\n\n\n\n制作BY:"..TDT.Author.." | Made by "..TDT.Author,"好的 | Agree","跑路咯 | Exit","复制TG并同意 | Coppy TG&agree")
        if byjinzhisays == 1 then
            Lite()
        end
        if byjinzhisays == 2 then 
            os.exit()
        end
        if byjinzhisays == 3 then
            os.exit(gg.copyText(TDT.Telegram),print("已复制 | 已複製 | Copied"))
        end
    end
end
--默认模式()--

--轻量模式()--
function Bypass(Class)
    if Class == "MemoryPatch::createWithHex" then
        local QuZhi = gg.prompt(
            {
                "输入HEX | Enter HEX","自动HEX | Auto Enter HEX","序号后缀 | Enter Suffix","导出路径 | Export Path","是否导出 | Export Or Not","是否数字头 | End Address","是否前值 | Value Address","是否后值 | Address Start","是否偏移 | Offset","SO扫描 | Scan Shared Object","还原旁路 | Restore Bypass","调试功能 | Debug Function","添加序号 | Add Index"
            },
            {
                "00\\x00\\x00\\x00",true,"",outputfile,false,false,false,false,false,false,false,false,false
            },
            {
                "text","checkbox","text","file","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox"
            }
        )
        if QuZhi == nil then
            --[[if Modes == "默认模式 | Default Mode" then
                All()
            elseif Modes == "精简模式 | Lite Mode" then
                Lite()
            end
            Bypass("MemoryPatch::createWithHex")]]
            L("旁路取值")
        else
            if QuZhi[6] == false and QuZhi[7] == false and QuZhi[8] == false and QuZhi[9] == false then
                gg.toast("取值类型不能为空")
                output = ""
                Bypass("MemoryPatch::createWithHex")
            end
            if QuZhi[2]==true then 
                QuZhi[1]=""
            end
            local name = "libUE4.so"
            for i, item in ipairs(select) do
                gg.toast(string.format("正在处理列表第[%d]条值",i))
                if QuZhi[2]==true then
                    QuZhi[1] = getHEX(item.value)
    		    end
                local addr = select[i].address
                for index, value in ipairs(gg.getRangesList("^/data/*.so*$")) do
                    if (value.start <= addr and value["end"] >= addr) then
                        name = value.internalName:gsub("^.*/","")
                    end
                end
            	for k,v in pairs(ranges) do
    		        if tonumber(select[i].address) >= v["start"] and tonumber(select[i].address) <= v["end"] then			
    		            for n,m in pairs(gg.getRangesList(v.internalName)) do
    		                if m.start==v.start then
    		                    if QuZhi[11] == true then
        		                    MemoryPatchBool = "Restore"
    		                    else
    		                        MemoryPatchBool = "Modify"
    		                    end
    		                    if QuZhi[6] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
    		                        output = output .. string.format('MemoryPatch::createWithHex("%s",0x%X,"%s").%s();%s\n',name,v["end"]-select[i].address,QuZhi[1],MemoryPatchBool,indx)
    		                    end
    		                    if QuZhi[7] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
    		                        output = output .. string.format('MemoryPatch::createWithHex(OBFUSCATE("%s"),0x%X,OBFUSCATE("%s")).%s();%s\n',name,select[i].address,QuZhi[1],MemoryPatchBool,indx)
    		                    end
    		                    if QuZhi[8] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
                                    output = output .. string.format('MemoryPatch::createWithHex(OBFUSCATE("%s"),0x%X,OBFUSCATE("%s")).%s();%s\n',name,select[i].address-v["start"],QuZhi[1],MemoryPatchBool,indx)
                                end
                                if QuZhi[9] == true then
                                    local ow_mtc = true
                                    local muchtoo = false
                                    if #select ~= 1 then
                                        muchtoo = true
                                    end
                                    if muchtoo == true then
                                        if CMD_UI_OFFSETS_VALUE == false or QuZhi[12] == false or QuZhi[12] == nil then
                                            local offsetwarning = gg.alert("你要取偏移值对吗？你知不知道取偏移值只能勾一条值？就是第一条！你这样勾太多很危险的QwQ，你不希望我崩掉对吧？赶快点击\"OK\"重新勾选QAQ\n\nYou want to take the offset value, right? Do you know that only one value can be ticked for the offset value? It's number one! You click too many dangerous QwQ like this. You don't want me to crash, do you?QwQ Click \"OK\" to check again.QAQ","我偏不 | No","好的 | Yes")
                                            if offsetwarning == 1 then
                                                os.exit(gg.alert("想什么呢 | Not exactly."))
                                            elseif offsetwarning == 2 then
                                                gg.alert("好的，我在这里等你！୧꒰•̀ᴗ•́꒱୨\nGood!I'll wait for you here!ε٩(๑> ₃ <)۶з")
                                                Bypass("MemoryPatch::createWithHex")
                                            else
                                                local what = gg.alert("？你咋点进来的？快退掉！(||๐_๐)\n？ How did you come in? Get it back! 눈_눈","好的 | OK")
                                                if what ~= 16384 then
                                                    --os.exit()
                                                end
                                            end
                                        end
                                    end
                                    local addr = select[1].address
                                    local name = "NoSo"
                                    for index, value in ipairs(gg.getRangesList("^/data/*.so*$")) do
                                        if (value.start <= addr and value["end"] >= addr) then
    		                                name = value.internalName:gsub("^.*/", "")
    	                                end
                                    end
                                    for index, value in ipairs(save) do
    	                                offset = (value.address - addr)
    	                                if (offset ~= 0) then
            		                        if QuZhi[13] == true then
            		                            indx = "//["..ind.."] | "..QuZhi[3]
            		                        else
            		                            if QuZhi[3] == "" then
            		                                indx = ""
            		                            else
        		                                    indx = "//"..QuZhi[3]
        		                                end
        		                            end
		                                    output = output..string.format('MemoryPatch::createWithHex("%s",0x%X,"%s").%s();%s\n', name,offset,QuZhi[1],MemoryPatchBool)
		                                    ind = ind + 1
                                        end
                                    end
                                end
                    		end
                   		end
              		end
           		end
    	    end
            if QuZhi[10] == true then
    		    T("SO")
    	    end
    	    if QuZhi[5] == true then
    	        dooutput(output)
    	    end
    	    print(output)
            os.exit(gg.setVisible(true))
        end
    end
    if Class == "PATCH_LIB" then
        local QuZhi = gg.prompt(
            {
                "输入HEX | Enter HEX","自动HEX | Auto Enter HEX","序号后缀 | Enter Suffix","导出路径 | Export Path","是否导出 | Export Or Not","是否数字头 | End Address","是否前值 | Value Address","是否后值 | Address Start","是否偏移 | Offset","SO扫描 | Scan Shared Object","HOOK_LIB | HOOK_LIB","调试功能 | Debug Function","添加序号 | Add Index"
            },
            {
                "00\\x00\\x00\\x00",true,"",outputfile,false,false,false,false,false,false,false,false,false
            },
            {
                "text","checkbox","text","file","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox","checkbox"
            }
        )
        if QuZhi == nil then
            --[[if Modes == "默认模式 | Default Mode" then
                All()
            elseif Modes == "精简模式 | Lite Mode" then
                Lite()
            end
            Bypass("PATCH_LIB")]]
            L("旁路取值")
        else
            if QuZhi[6] == false and QuZhi[7] == false and QuZhi[8] == false and QuZhi[9] == false then
                gg.toast("取值类型不能为空")
                output = ""
                Bypass("PATCH_LIB")
            end
            local name = "libUE4.so"
            for i, item in ipairs(select) do
                gg.toast(string.format("正在处理列表第[%d]条值",i))
                if QuZhi[11] == true then
                    QuZhi[1] = ""
                else
                    if QuZhi[2]==true then
                        QuZhi[1] = getHEX(item.value)
                    end
                    QuZhi[1] = "\",\""..QuZhi[1].."\""
    		    end
                local addr = select[i].address
                for index, value in ipairs(gg.getRangesList("^/data/*.so*$")) do
                    if (value.start <= addr and value["end"] >= addr) then
                        name = value.internalName:gsub("^.*/","")
                    end
                end
            	for k,v in pairs(ranges) do
    		        if tonumber(select[i].address) >= v["start"] and tonumber(select[i].address) <= v["end"] then			
    		            for n,m in pairs(gg.getRangesList(v.internalName)) do
    		                if m.start==v.start then
    		                    if QuZhi[11] == true then
        		                    MemoryPatchBool = "PATCH_LIB"
    		                    else
    		                        MemoryPatchBool = "HOOK_LIB"
    		                    end
    		                    if QuZhi[6] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
    		                        output = output .. string.format('%s("%s","0x%X%s);%s\n',MemoryPatchBool,name,v["end"]-select[i].address,QuZhi[1],indx)
    		                    end
    		                    if QuZhi[7] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
    		                        output = output .. string.format('%s("%s","0x%X%s);%s\n',MemoryPatchBool,name,select[i].address,QuZhi[1],indx)
    		                    end
    		                    if QuZhi[8] == true then
    		                        if QuZhi[13] == true then
    		                            indx = "//["..i.."] | "..QuZhi[3]
    		                        else
    		                            if QuZhi[3] == "" then
    		                                indx = ""
    		                            else
    		                                indx = "//"..QuZhi[3]
    		                            end
    		                        end
                                    output = output .. string.format('%s("%s","0x%X%s);%s\n',MemoryPatchBool,name,select[i].address-v["start"],QuZhi[1],indx)
                                end
                                if QuZhi[9] == true then
                                    local ow_mtc = true
                                    local muchtoo = false
                                    if #select ~= 1 then
                                        muchtoo = true
                                    end
                                    if muchtoo == true then
                                        if CMD_UI_OFFSETS_VALUE == false or QuZhi[12] == false or QuZhi[12] == nil then
                                            local offsetwarning = gg.alert("你要取偏移值对吗？你知不知道取偏移值只能勾一条值？就是第一条！你这样勾太多很危险的QwQ，你不希望我崩掉对吧？赶快点击\"OK\"重新勾选QAQ\n\nYou want to take the offset value, right? Do you know that only one value can be ticked for the offset value? It's number one! You click too many dangerous QwQ like this. You don't want me to crash, do you?QwQ Click \"OK\" to check again.QAQ","我偏不 | No","好的 | Yes")
                                            if offsetwarning == 1 then
                                                os.exit(gg.alert("想什么呢 | Not exactly."))
                                            elseif offsetwarning == 2 then
                                                gg.alert("好的，我在这里等你！୧꒰•̀ᴗ•́꒱୨\nGood!I'll wait for you here!ε٩(๑> ₃ <)۶з")
                                                Bypass("PATCH_LIB")
                                            else
                                                local what = gg.alert("？你咋点进来的？快退掉！(||๐_๐)\n？ How did you come in? Get it back! 눈_눈","好的 | OK")
                                                if what ~= 16384 then
                                                    --os.exit()
                                                end
                                            end
                                        end
                                    end
                                    local addr = select[1].address
                                    local name = "NoSo"
                                    for index, value in ipairs(gg.getRangesList("^/data/*.so*$")) do
                                        if (value.start <= addr and value["end"] >= addr) then
    		                                name = value.internalName:gsub("^.*/", "")
    	                                end
                                    end
                                    for index, value in ipairs(save) do
    	                                offset = (value.address - addr)
    	                                if (offset ~= 0) then
            		                        if QuZhi[13] == true then
            		                            indx = "//["..ind.."] | "..QuZhi[3]
            		                        else
            		                            if QuZhi[3] == "" then
            		                                indx = ""
            		                            else
        		                                    indx = "//"..QuZhi[3]
        		                                end
        		                            end
		                                    output = output..string.format('MemoryPatch::createWithHex("%s",0x%X,"%s").%s();%s\n', name,offset,QuZhi[1],MemoryPatchBool)
		                                    ind = ind + 1
                                        end
                                    end
                                end
                    		end
                   		end
              		end
           		end
    	    end
            if QuZhi[10] == true then
    		    T("SO")
    	    end
    	    if QuZhi[5] == true then
    	        dooutput(output)
    	    end
    	    print(output)
            os.exit(gg.setVisible(true))
        end
    end
    
end
function L(CHO)
    if (select == nil or #select == 0) then
        os.exit(gg.setVisible(true),print("请保存值并勾选它！"))
    end
    if CHO == "旁路取值" then
        local SheZhiXuanXiang = gg.choice({
        "MemoryPatch","PATCH_LIB取值器","","返回到上一界面"
        },4,"["..isVIP_text.." | "..username.."],请选择旁路类型\nPlease Select The Bypass Class")
        
        if SheZhiXuanXiang == 1 then
            Bypass("MemoryPatch::createWithHex")
        elseif SheZhiXuanXiang == 2 then
            Bypass("PATCH_LIB")
        elseif SheZhiXuanXiang == 3 then
            L("旁路取值")
        elseif SheZhiXuanXiang == 4 then
            --[[if Modes == "默认模式 | Default Mode" then
                All()
            elseif Modes == "精简模式 | Lite Mode" then]]
                Lite()
            --end
        end
    end
end
--↑初始化 | 主函数↓--
function Main()
Temp.ist = false
if Temp.isok == false then
    local SZMoShiChoices = gg.choice(
        {
            "默认模式 | Default mode",
            "精简模式 | Lite Mode"
        },
        JZNB666,
        "["..
        isVIP_text..
        " | "..
        username..
        "],请选择默认的模式\nPlease Select The Default Model"
    )
        if SZMoShiChoices == 1 then
            Modes = "默认模式 | Default Mode"
        elseif SZMoShiChoices == 2 then
            Modes = "精简模式 | Lite Mode"
        else
            if Modes ~= "默认模式 | Default Mode" or Modes ~= "精简模式 | Lite Mode" then
                Modes = ""
            end
                os.exit(print("已退出选择 | Exited Selection"))
        end
        savetext(savemodefile,Modes)
        print("已选择-Selected: ["..Modes.."] \n请重启脚本 | Please restart the script")
    else
    Main()
    end
    JZNB = 0
end
function All()
    main = gg.choice(
        {
            "默认模式处于优化中 | Lite Mode only",
            "请点击任意选项切换 | Click switch mode"
        },
        JinZhiNB666
    )
    if main ~= 16384 then Main() end
    JZNB=8
end
function Lite()
    main = gg.choice(
        {
            "设置选项 | Script Settings",
            "旁路取值 | Bypass Value",
            "脚本取值[未开发] | GGLua Value[Isn't Opening]",
            "其他工具 | Other Tools",
            "选择模式 | Select Mode",
            "作者的话 | Author Says",
            "调试界面 | Debug Ui",
            "退出脚本 | Exit Script"
        },
        JinZhiNB666,
        string.format(
            "["..
            isVIP_text..
            " | "..
            username..
            "],\n["..
            os.date("%Y/%m/%d (%A) %H:%M:%S {%I'%p}]: ")..
            Greet..
            "\n目标软件 | Aim App:%s %sBit"..
            "\nBY: "..
            TDT.Author..
            "丨TG"..
            TDT.Telegram,
            label,
            bit
        )
    )
        if main == 1 then T("设置选项")
    elseif main == 2 then L("旁路取值")
    elseif main == 3 then --[[L("脚本取值")]]T("设置选项")
    elseif main == 4 then T("其他工具")
    elseif main == 5 then Main()--T("选择样式")
    elseif main == 6 then T("作者的话")
    elseif main == 7 then T("调试界面")
    elseif main == 8 then os.exit()end
    JZNB=6
end
while true do
    if Modes == "默认模式 | Default Mode" or Modes == "精简模式 | Lite Mode" then
        gg.clearResults()
        if gg.isVisible(true) then
            JZNB = 1
        end 
        if JZNB == 1 then
            if Modes == "默认模式 | Default Mode" then
                All()
            elseif Modes == "精简模式 | Lite Mode" then
                Lite()
            end
        end
    elseif existfile(namefile) == false then
        New()
    else
        Main()
    end
end