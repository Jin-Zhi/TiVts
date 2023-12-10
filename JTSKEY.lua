local MsgLcl,MsgNfd
local time = { -- time工具箱
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
} -- time工具箱
jz={}
jz.lj=gg.prompt({"选择文件",},{gg.getFile()},{"file",})
jz.newlj=jz.lj[1]..".lua"
jz.dump=string.dump
jz.nr=io.open(jz.lj[1], 'r'):read('*a')
jz.nr=jz.nr.."\n"
jz.num=50
jz.snc=' while"WSZNBO"~="WSZNBO"do WSZNBO="WSZNBO"WSZNBO="WSZZQO"WSZZQO=18e306,18e305 '..'end '
jz.snc1=' if"WSZNBO"~="WSZNBO"then print()end '
jz.snc=jz.snc:rep(jz.num*26*2)..jz.snc1:rep(jz.num*26*2)
jz.nr=" while'WSZNBO'~='WSZNBO'do WSZZQO="..string.rep("(function(...)end)(",jz.num*2)..string.rep(")",jz.num*2).."end "..jz.snc..jz.nr..string.rep("(function(...)end)(",jz.num*2)..string.rep(")",jz.num*2)
jz.bs=[[



加入Telegram频道 @JZZPD
如果你是买来的，那你被骗了
如果被骗请TG联系 @JZYLY
GitHub链接翻得到自己翻下面
更新时间:]]..time.Date.Year..[[年]]..time.Date.Month..[[月]]..time.Date.Day..[[日-]]..time.Time.Time..[[


]]MsgLcl = [[# TiVts

# TiVts

最新版本3.0.0，如果不是这个版本请点击检查更新！


>3.0.0内容:
>
>1.修复了一些问题
>
>2.完善脚本取值
>
>3.将返回键全部变成取消键

The latest version is 3.0.0, if it is not this version, please click to check for updates!


>3.0.0 Content:
>
>1.Fixed some problems
>
>2.Perfecting script value
>
>3.Turn all back keys into cancel keys

]]MsgNfd = [[]]
jz.nr="(function(...)"..jz.nr.."\nend)([["..jz.bs.."\n\n\n\n\n"..MsgLcl.."]])"
jz.newnr=jz.dump(load(jz.nr),true)
gg.internal2(load(jz.newnr), jz.newlj)
jz.newnr=io.open(jz.newlj, 'r'):read('*a')
jz.newnr=jz.newnr:gsub("linedefined [^\n]+","linedefined 0")
jz.newnr=jz.newnr:gsub("lastlinedefined [^\n]+","lastlinedefined 0")
jz.newnr=jz.newnr:gsub("numparams [^\n]+","numparams 250")
jz.newnr=jz.newnr:gsub("is_vararg [^\n]+","is_vararg 250")
jz.newnr =jz.newnr:gsub("maxstacksize [^\n]+","maxstacksize 250")
jz.newnr=jz.dump(load(jz.newnr),true)
jz.newnr=jz.newnr:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00),string.char(0x00,0x00,0x00,0x00),15)
jz.newnr=jz.newnr:gsub(string.char(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xFA,0xFA,0xFA),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA))
jz.newnr=jz.newnr:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x4E,0x42,0x4F),string.char(0x04,0x11,0x27,0x00,0x00)..string.rep(string.char(6),10000))
jz.newnr=jz.newnr:gsub(string.char(0x04,0x07,0x00,0x00,0x00,0x57,0x53,0x5A,0x5A,0x51,0x4F,0x00),string.char(0x04,0x00,0x00,0x00,0x00))
jz.newnr=jz.newnr:gsub(string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),32),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFA,0xFA,0xFA)..string.rep(string.char(0),24)..string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF))
jz.newnr=jz.newnr:gsub(string.char(0x2E,0x02,0x68,0x83,0x02,0xA2,0xB9,0x7F),string.char(0x00,0x00,0x00,0x00,0x00,0x00,0xF0,0xFF))
jz.newnr=jz.newnr:gsub(string.char(0xF2,0x34,0x53,0x9C,0x9B,0x81,0x84,0x7F),string.char(0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF))
jz.newnr=jz.newnr:gsub(string.char(0x01,0x00,0x00,0x00,0x1f,0x00,0x80,0x00),string.char(0x01,0x00,0x00,0x00,0xDF,0xFF,0x00,0x00))
jz.newnr=jz.newnr:gsub(string.char(0x80,0x06,0x00,0x41,0x00,0x1D,0x40,0x80,0x00),string.char(0x80,0x17,0x00,0x41,0x00,0x1D,0x40,0x80,0x00))
io.open(jz.newlj, "w"):write(jz.newnr):close()