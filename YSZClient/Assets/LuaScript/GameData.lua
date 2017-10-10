GameData = 
{
    LoginInfo =
    {
        Account = "",
        -- 登陆的账号信息
        PlatformType = PLATFORM_TYPE.PLATFORM_TOURISTS,
        -- 登陆的平台
        AccountName = "",-- 登陆账号名称
    },
    -- 角色的相关信息
    RoleInfo =
    {
        Account = "",
        -- 账号	
        AccountID = 0,
        -- 账号ID	
        AccountName = "",
        -- 账号名称	
        AccountIcon = 0,
        -- 角色头像信息
        DiamondCount = 0,
        -- 砖石数量	
        GoldCount = 0,
        -- 金币数量
        DisplayGoldCount = 0,
        -- 显示金币数量
        RoomCardCount = 0,
        -- 房卡数量	
        FreePlayTime = 0,
        -- 免费试玩次数	
        FreeGoldCount = 0,
        -- 免费金币数
        DisplayFreeGoldCount = 0,
        -- 显示的免费金币数量
        VipLevel = 0,
        -- Vip 等级	
        ChargeCount = 0,
        -- 充值数量

        YesterdayRank = 0,
        -- 昨日金币数
        -- YesterdayWinRank = 0,		-- 昨日赢取金币数
        YesterdayGoldNum = 0,
        -- 昨日资产排名 -1表示未上榜
        -- YesterdayWinNum = 0,		-- 昨日赢取排名 -1表示未上榜

        Cache =
        {
            ChangedGoldCount = 0,
            ChangedFreeGoldCount = 0
        },

        PromoterStep = 0,
        -- 是否是推广员
        InviteCode = 0,
        -- 是否已经填写过邀请码
        IsBindAccount = false,
        -- 是否已绑定账号
        UnreadMailCount = 0,
        -- 未读邮件数量
        ModifyNameCount = 0,-- 修改名称次数
    },


    -- 房间的相关信息
    RoomInfo =
    {
        CurrentRoom = { },
        -- 当前房间信息
        RelationRooms = { },
        -- [1] = {[10000] ={ Count = 5, [1] = {X = 1, Y = 1, Owner = 10001, }
        CurrentRoomChips = { },
        -- 统计信息		
        StatisticsInfo = { },
    },

    -- 排行榜数据
    RankInfo =
    {
        -- [1] = { RankID = 1, AccountName = "", AccountID = 0, VipLevel = 0, HeadIcon = "", RichValue = 0}
        RichList = nil,
        -- 总资产财富榜
        DayOfYear = 0,-- 获取排行榜数据时的日期（一年中的第几天）
    },
    -- 邮件信息
    EmailInfo =
    {
    },

    -- 游戏APP的状态
    GameState = 0,
    -- 大厅操作数据便于返回大厅时
    HallData = { },

    -- 上一次发送小喇叭的时间
    LastSmallHornTime = 0,
    -- 服务器ID
    ServerID = 0,

    IsOpenApplePay = 1,
    -- 是否开启苹果支付,此值在登陆的时候由服务器初始化

    IsPromptedInviteTips = true,
    -- 是否输入了邀请提示

    IsShowInviteBtn = 1,
    -- 是否显示邀请码按钮

    AppVersionCheckResult = - 2,
    -- App版本检查结果

    IsAgreement = true,
    -- 是否同意协议

    GameHistory = { MaxCount = 0, RequestedPage = 0, Datas = { } },
    -- 游戏历史数据

    ancestorCode = 0,
    -- 一代僵尸的邀请码

    ChannelCode = 1,
    -- 玩家注册渠道ID
    ConfirmChannelCode = false,-- 是否已经确认平台ID

    OpenInstallReferralsID,-- OpenInstall推荐人ID
    OpenInstallRoomID,-- OpenInstall房间ID
};

function GameData.InitHallData()
    GameData.HallData = { }
    -- 默认选择 竞咪厅
    GameData.HallData.SelectType = 1

    GameData.HallData.SelectType = CS.AppDefineConst.DefaultSelectType

    GameData.HallData.Data = { }
    -- 竞咪厅默认选择 4
    GameData.HallData.Data[1] = 1
    -- 试水厅默认选择 201
    GameData.HallData.Data[2] = 201
    -- Vip 厅默认选择 1
    GameData.HallData.Data[3] = 1
end

function GameData.InitCurrentRoomInfo()
    GameData.RoomInfo.CurrentRoom =
    {
        MasterID = 0,
        -- 房主ID
        RoomState = 1,
        -- 房间当前阶段
        CountDown = 20,
        -- 倒计时
        RoomID = 0,
        -- 房间ID
        TemplateID = 0,
        -- 房间模板ID
        IsFreeRoom = false,
        -- 是否是试水厅
        IsVipRoom = false,
        -- 是否是VIP厅
        RoleCount = 0,
        -- 房间人数
        Pokers = { },
        -- 存储当前收到的扑克牌信息 格式为：[1] = {PokerType = 1, PokerNumber = 14, Visible = true,}
        MaxRound = 0,
        -- 最大局数
        CurrentRound = 0,
        -- 当前局数
        BankerInfo = { ID = 0, Name = "", Gold = 0, LeftCount = 0, HeadIcon = 0 },
        -- 庄家信息
        CheckRole1 = { ID = 0, Name = "", Icon = 1, },
        -- 龙信息
        CheckRole2 = { ID = 0, Name = "", Icon = 1, },
        -- 虎信息
        GameResult = 0,
        -- 本局结果信息 位运算：1 龙赢，2 虎赢，4 和，8 龙金花 16 龙豹子 32 龙金花
        WinGold = { },
        -- 赢取的金币
        SelectBetValue = 0,
        -- 当前选择下注的金额		
        -- [4(区域编号)] = {[0(自己)]={Value(值) = 0, Rank(排行) = 0 },[1(排行榜1)] = {Name(名称) ="", Value(值) = 0}},
        BetRankList = { },
        -- 自己的押注信息
        BetValues = { },
        -- {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0},
        -- 总计押注金额
        TotalBetValues = { },

        BankerList = { },
        -- 切牌动画中，切的是第几张扑克牌
        CutAniIndex = 0,
        -- 本局追加统计信息事件参数
        AppendStatisticsEventArgs = nil,
    }
end

function GameData.ClearCurrentRoundData()
    GameData.RoomInfo.CurrentRoom.BetRankList = { }
    GameData.RoomInfo.CurrentRoom.BetValues = { }
    GameData.RoomInfo.CurrentRoom.TotalBetValues = { }
    GameData.RoomInfo.CurrentRoom.WinGold = { }
    GameData.RoomInfo.CurrentRoom.Pokers = { }
    GameData.RoomInfo.CurrentRoom.GameResult = 0
    GameData.RoomInfo.CurrentRoom.CheckRole1 = { ID = 0, Name = "", Icon = "", }
    -- 龙信息
    GameData.RoomInfo.CurrentRoom.CheckRole2 = { ID = 0, Name = "", Icon = "", }
    -- 虎信息
    GameData.RoomInfo.CurrentRoom.CutAniIndex = 0
    CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateBetValue, nil)
end

function GameData.SubFloatZeroPart(valueStr)
    local index = string.find(valueStr, ".")
    if index ~= nil then
        local strLength = #valueStr
        for i = strLength, 1, -1 do
            local endChar = string.sub(valueStr, -1)
            if endChar == "0" then
                valueStr = string.sub(valueStr, 1, #valueStr - 1)
            elseif endChar == "." then
                valueStr = string.sub(valueStr, 1, #valueStr - 1)
                break
            else
                break
            end
        end
    end

    return valueStr
end

function GameData.Init()
    GameData.InitCurrentRoomInfo()
    GameData.InitHallData()
end

-- 获取扑克牌的贴图资源名称
function GameData.GetPokerCardSpriteName(pokerCard)
    local cardSpriteName = "sprite_" .. Poker_Type_Define[pokerCard.PokerType] .. "_" .. pokerCard.PokerNumber;
    return cardSpriteName;
end

function GameData.GetPokerCardSpriteNameOfBig(pokerCard)
    local cardSpriteName = "sprite_" .. Poker_Type_Define[pokerCard.PokerType] .. "_b_" .. pokerCard.PokerNumber
    return cardSpriteName
end

function GameData.GetPokerCardBackSpriteNameOfBig(pokerCard)
    return "sprite_Poker_Back_b_01";
end

function GameData.GetPokerDisplaySpriteName(pokerCard)
    if pokerCard ~= nil and pokerCard.Visible then
        return GameData.GetPokerCardSpriteName(pokerCard);
    else
        return GameData.GetPokerCardBackSpriteName(pokerCard);
    end
end

function GameData.GetRolePokerTypeDisplayName(roleType)
    return data.GetString("BRAND_TYPE_" .. GameData.GetRolePokerType(roleType))
end

function GameData.GetRolePokerType(roleType)
    local pokerCards = GameData.RoomInfo.CurrentRoom.Pokers
    if roleType == 1 then
        local pokerCard1 = pokerCards[1]
        local pokerCard2 = pokerCards[2]
        local pokerCard3 = pokerCards[3]
        return GameData.GetPokerType(pokerCard1, pokerCard2, pokerCard3)
    elseif roleType == 2 then
        local pokerCard1 = pokerCards[4]
        local pokerCard2 = pokerCards[5]
        local pokerCard3 = pokerCards[6]
        return GameData.GetPokerType(pokerCard1, pokerCard2, pokerCard3)
    else
        return "角色不正确"
    end
end

function GameData.GetPokerType(pokerCard1, pokerCard2, pokerCard3)
    if pokerCard1 == nil or pokerCard2 == nil or pokerCard3 == nil then
        return BRAND_TYPE.SANPAI
    end

    if pokerCard1.PokerNumber == pokerCard2.PokerNumber
        or pokerCard1.PokerNumber == pokerCard3.PokerNumber
        or pokerCard2.PokerNumber == pokerCard3.PokerNumber then
        if pokerCard1.PokerNumber == pokerCard2.PokerNumber and pokerCard2.PokerNumber == pokerCard3.PokerNumber then
            return BRAND_TYPE.BAOZI
        else
            return BRAND_TYPE.DUIZI
        end
    else
        -- 检验是否是金花
        local isJinHua = false
        if pokerCard1.PokerType == pokerCard2.PokerType then
            if pokerCard1.PokerType == pokerCard3.PokerType then
                isJinHua = true
            end
        end

        local isSunZi = false
        local sortedNumbers = lua_number_sort(pokerCard1.PokerNumber, pokerCard2.PokerNumber, pokerCard3.PokerNumber)
        -- 检验是否是顺子
        if (sortedNumbers[1] + 1) == sortedNumbers[2] then
            if (sortedNumbers[2] + 1) == sortedNumbers[3] then
                isSunZi = true
            end
        end

        if isJinHua and isSunZi then
            return BRAND_TYPE.SHUNJIN
        elseif isJinHua then
            return BRAND_TYPE.JINHUA
        elseif isSunZi then
            return BRAND_TYPE.SHUNZI
        else
            return BRAND_TYPE.SANPAI
        end
    end
end

function GameData.GetPokerCardBackSpriteName(pokerCard)
    return "sprite_Poker_Back_01";
end

function GameData.SetRoomState(roomState)
    GameData.RoomInfo.CurrentRoom.RoomState = roomState
    GameData.RoomInfo.CurrentRoom.CountDown = ROOM_TIME[roomState]
    CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateRoomState, roomState)
end

function GameData.ReduceRoomCountDownValue(deltaValue)
    GameData.RoomInfo.CurrentRoom.CountDown = GameData.RoomInfo.CurrentRoom.CountDown - deltaValue
end

function GameData.UpdateGoldCount(count, reason)
    if reason == 13 or reason == 12 then
        GameData.RoleInfo.Cache.ChangedGoldCount = count - GameData.RoleInfo.GoldCount
        print(string.format("New Gold:%d Old Gold:%d Change Gold:%d", count, GameData.RoleInfo.GoldCount, GameData.RoleInfo.Cache.ChangedGoldCount))
        GameData.RoleInfo.GoldCount = count
    else
        GameData.RoleInfo.GoldCount = count
        GameData.SyncDisplayGoldCount()
    end
end

function GameData.UpdateFreeGoldCount(count, reason)
    if reason == 13 or reason == 12 then
        GameData.RoleInfo.Cache.ChangedFreeGoldCount = count - GameData.RoleInfo.FreeGoldCount
        GameData.RoleInfo.FreeGoldCount = count
    else
        GameData.RoleInfo.FreeGoldCount = count
        GameData.SyncDisplayGoldCount()
    end
end

function GameData.SyncDisplayGoldCount()
    if GameData.RoleInfo.DisplayGoldCount ~= GameData.RoleInfo.GoldCount then
        GameData.RoleInfo.DisplayGoldCount = GameData.RoleInfo.GoldCount
        CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateGold, 1)
        GameData.RoleInfo.Cache.ChangedGoldCount = 0
    elseif GameData.RoleInfo.DisplayFreeGoldCount ~= GameData.RoleInfo.FreeGoldCount then
        GameData.RoleInfo.DisplayFreeGoldCount = GameData.RoleInfo.FreeGoldCount
        CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateGold, 2)
        GameData.RoleInfo.Cache.ChangedFreeGoldCount = 0
    else
        CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateGold, 0)
        GameData.RoleInfo.Cache.ChangedGoldCount = 0
        GameData.RoleInfo.Cache.ChangedFreeGoldCount = 0
    end
end

-- 设置未读邮件数量
function GameData.ResetUnreadMailCount(count)
    GameData.RoleInfo.UnreadMailCount = count
    local eventArg = GameData.CreateUnHandleEventArgsOfEmail(count)
    CS.EventDispatcher.Instance:TriggerEvent(EventDefine.UpdateUnHandleFlag, eventArg)
end

function GameData.CreateUnHandleEventArgsOfEmail(count)
    if count == nil then
        count = 0
    end
    local eventArg = lua_NewTable(UuHandleFlagEventArgs)
    eventArg.UnHandleType = UNHANDLE_TYPE.EMAIL
    eventArg.ContainsUnHandle = count > 0
    eventArg.UnHandleCount = count
    return eventArg
end


function GameData.GetTrendResultSpriteOfTrendItem(roundResult)
    if CS.Utility.GetLogicAndValue(roundResult, WIN_CODE.LONG) == WIN_CODE.LONG then
        return 'sprite_Trend_Icon_1'
    elseif CS.Utility.GetLogicAndValue(roundResult, WIN_CODE.HU) == WIN_CODE.HU then
        return 'sprite_Trend_Icon_2'
    elseif CS.Utility.GetLogicAndValue(roundResult, WIN_CODE.HE) == WIN_CODE.HE then
        return 'sprite_Trend_Icon_4'
    else
        return 'sprite_Trend_Icon_1'
    end
end

-- 获取玩家头像的的贴图资源名称
function GameData.GetRoleIconSpriteName(iconid)
    -- 由于老账号记录为0
    if iconid == 0 then
        iconid = 1
    end
    local iconSpriteName = "sprite_RoleIcon_" .. iconid;
    return iconSpriteName
end