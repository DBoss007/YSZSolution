local Time = CS.UnityEngine.Time

-- 菜单组件
local mReturnCaiDan = nil

-- PK模块组件
local mVSPK = nil
local mVSPKTable =
{
    PKPlayer1 = nil,
    PKPlayer2 = nil,
    PKVImage = nil,
    PKSImage = nil,
}

-- 玩家组件数据
local PlayerItem =
{
    TransformRoot = nil,
    YQButton = nil,
    ZXButton = nil,
    HeadIcon = nil,
    HandleCD = nil,
    GoldInfo = nil,
    GoldText = nil,
    BetingInfo = nil,
    BetingText = nil,
    BankerPos = nil,
    PokerParent = nil,
    PokerPoint = { },
    KPImage = nil,
    QPImage = nil,
    JZImage = nil,
    GZImage = nil,
}

-- 玩家UI元素集合
local mPlayersUIInfo = { }

-- 玩家下注模块组件
local mMasterXZInfo =
{
    -- 玩家看牌按钮组件
    KPButtonGameObject = nil,
    -- 下注模块组件
    XZButtonGameObject = nil,
    -- 加注模块组件
    JZButtonGameObject = nil,
    JZButton1Text = nil,
    JZButton2Text = nil,
    JZButton3Text = nil,
    JZButton4Text = nil,
}

-- 初始化UI元素
function InitUIElement()
    -- body
    mReturnCaiDan = this.transform:Find('Canvas/CaidanButton/ReturnCaiDan').gameObject
    -- PK模块
    mVSPK = this.transform:Find('Canvas/VSPK').gameObject
    mVSPKTable.PKPlayer1 = this.transform:Find('Canvas/VSPK/PKPlayer1')
    mVSPKTable.PKPlayer2 = this.transform:Find('Canvas/VSPK/PKPlayer2')
    mVSPKTable.PKPlayer2 = this.transform:Find('Canvas/VSPK/PKPlayer2')
    mVSPKTable.PKVImage = this.transform:Find('Canvas/VSPK/PKVImage'):GetComponent('Image')
    mVSPKTable.PKSImage = this.transform:Find('Canvas/VSPK/PKSImage'):GetComponent('Image')

    InitPlayerUIElement()
    -- 玩家下注模块
    this.transform:Find('Canvas/MasterInfo').gameObject:SetActive(true)
    mMasterXZInfo.KPButtonGameObject = this.transform:Find('Canvas/MasterInfo/KPButton').gameObject
    mMasterXZInfo.XZButtonGameObject = this.transform:Find('Canvas/MasterInfo/Buttons').gameObject
    mMasterXZInfo.JZButtonGameObject = this.transform:Find('Canvas/MasterInfo/JZInfo').gameObject
    mMasterXZInfo.JZButton1Text = this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton1/Text'):GetComponent('Text')
    mMasterXZInfo.JZButton2Text = this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton2/Text'):GetComponent('Text')
    mMasterXZInfo.JZButton3Text = this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton3/Text'):GetComponent('Text')
    mMasterXZInfo.JZButton4Text = this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton4/Text'):GetComponent('Text')

end

function InitPlayerUIElement()
    -- body
    local playerRoot = this.transform:Find('Canvas/Players')
    for position = 1, 5, 1 do
        local dataItem = lua_NewTable(PlayerItem)
        local childItem = playerRoot:Find('Player' .. position)
        mPlayersUIInfo[position] = dataItem
        dataItem.TransformRoot = childItem
        dataItem.YQButton = childItem:Find('Head/YQButton')
        dataItem.ZXButton = childItem:Find('Head/ZXButton')
        dataItem.HeadIcon = childItem:Find('Head/HeadIcon'):GetComponent('Image')
        dataItem.HandleCD = childItem:Find('Head/HeadIcon/HandleCD'):GetComponent('Image')
        dataItem.GoldInfo = childItem:Find('GoldInfo')
        dataItem.GoldText = childItem:Find('GoldInfo/GoldIcon/Text'):GetComponent('Text')
        dataItem.BetingInfo = childItem:Find('BetingInfo')
        dataItem.BetingText = childItem:Find('BetingInfo/Text'):GetComponent('Text')
        dataItem.BankerPos = childItem:Find('BankerPos')
        dataItem.PokerParent = childItem:Find('Pokers')
        dataItem.KPImage = childItem:Find('KPImage')
        dataItem.QPImage = childItem:Find('QPImage')
        dataItem.JZImage = childItem:Find('JZImage')
        dataItem.GZImage = childItem:Find('GZImage')
    end

end

-- 还原玩家对应位置到初始状态
function ResetPlayerInfo2Defaul(positionParam)
    -- body
    mPlayersUIInfo[positionParam].YQButton.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].ZXButton.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].HeadIcon.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].HandleCD.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].GoldInfo.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].BetingInfo.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].KPImage.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].QPImage.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].JZImage.gameObject:SetActive(false)
    mPlayersUIInfo[positionParam].GZImage.gameObject:SetActive(false)
end

function SetPlayerHeadIcon(positionParam)
    -- body
    if GameData.RoomInfo.CurrentRoom.ZUJUPlayers[positionParam].PlayerState ~= Player_State.None then
        -- body
        
    end
end


-- 还原UI默认基础显示状态
function RestoreUI2Default()
    -- body
    SetCaidanShow(false)
    VSPKShow(false)
    MasterKPButtonShow(false)
    MasterXZButtonShow(true)
    MasterJZInfoShow(false)

end

function Awake()
    InitUIElement()
    AddButtonHandlers()
    RestoreUI2Default()
end

function Start()
    -- body
end

-- UI 开启
function WindowOpened()
    CS.EventDispatcher.Instance:AddEventListener(EventDefine.InitRoomState, ResetGameRoomToRoomState)
    CS.EventDispatcher.Instance:AddEventListener(EventDefine.UpdateRoomState, RefreshGameRoomByRoomStateSwitchTo)

end

-- UI 关闭
function WindowClosed()
    CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.InitRoomState, ResetGameRoomToRoomState)
    CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.UpdateRoomState, RefreshGameRoomByRoomStateSwitchTo)

end

-- 每一帧更新
function Update()

end

function OnDestroy()
    -- body
end

-- 按钮事件响应绑定
function AddButtonHandlers()
    this.transform:Find('Canvas/CaidanButton'):GetComponent("Button").onClick:AddListener(OnCaidanButtonClick)
    this.transform:Find('Canvas/CaidanButton/ReturnCaiDan/ReturnButton'):GetComponent("Button").onClick:AddListener(OnReturnButtonClick)
    this.transform:Find('Canvas/CaidanButton/ReturnCaiDan/SitUpButton'):GetComponent("Button").onClick:AddListener(OnSitUpButtonClick)
    this.transform:Find('Canvas/CaidanButton/ReturnCaiDan/Image'):GetComponent("Button").onClick:AddListener(OnCaidanHideClick)

    this.transform:Find('Canvas/MasterInfo/KPButton'):GetComponent('Button').onClick:AddListener(OnKPButtonClick)
    this.transform:Find('Canvas/MasterInfo/Buttons/QPButton'):GetComponent('Button').onClick:AddListener(OnQPButtonClick)
    this.transform:Find('Canvas/MasterInfo/Buttons/JZButton'):GetComponent('Button').onClick:AddListener(OnJZButtonClick)
    this.transform:Find('Canvas/MasterInfo/Buttons/GZButton'):GetComponent('Button').onClick:AddListener(OnGZButtonClick)
    this.transform:Find('Canvas/MasterInfo/Buttons/BPButton'):GetComponent('Button').onClick:AddListener(OnBPButtonClick)
    this.transform:Find('Canvas/MasterInfo/JZInfo'):GetComponent('Button').onClick:AddListener(OnJZHideClick)
    this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton1'):GetComponent('Button').onClick:AddListener( function() OnJZButtonOKClick(1) end)
    this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton2'):GetComponent('Button').onClick:AddListener( function() OnJZButtonOKClick(2) end)
    this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton3'):GetComponent('Button').onClick:AddListener( function() OnJZButtonOKClick(3) end)
    this.transform:Find('Canvas/MasterInfo/JZInfo/JZButton4'):GetComponent('Button').onClick:AddListener( function() OnJZButtonOKClick(4) end)

end

---------------------------------------------------------------------------------
-------------------------------按钮响应 call-------------------------------------
-- 菜单按钮 call
function OnCaidanButtonClick()
    -- body
    SetCaidanShow(true)
end

-- 菜单组件隐藏
function OnCaidanHideClick()
    -- body
    SetCaidanShow(false)
end

-- 菜单组件显示设置
function SetCaidanShow(showParam)
    -- body
    if mReturnCaiDan.activeSelf == showParam then
        return
    end
    mReturnCaiDan:SetActive(showParam)
end

-- 推出游戏按钮 call
function OnReturnButtonClick()
    -- body
    print("推出按钮点击")
    SetCaidanShow(false)
    CS.WindowManager.Instance:CloseWindow('GameUI1', false)
end

-- 站起按钮 call
function OnSitUpButtonClick()
    -- body
    print("站起按钮点击")
    SetCaidanShow(false)
end

-------------------------------按钮 call end--------------------------------------------------

function ResetGameRoomToRoomState(currentState)
    canPlaySoundEffect = false
    -- 停止掉所有的协程
    this:StopAllDelayInvoke()
	InitRoomBaseInfos()
	RefreshGameRoomToEnterGameState(currentState, true)
	canPlaySoundEffect = true
end

-- 刷新游戏房间到游戏状态
function RefreshGameRoomToEnterGameState(roomState, isInit)
	if isInit or roomState == ZUJURoomState.Wait then
        -- 调用下GC回收
		lua_Call_GC()
	end
	RefreshStartPartOfGameRoomByState(roomState)
	RefreshWaitPartOfGameRoomByState(roomState, isInit)
	RefreshSubduceBetPartOfGameRoomByState(roomState, isInit)
	RefreshDealPartOfGameRoomByState(roomState, isInit)
	RefreshBettingPartOfGameRoomByState(roomState, isInit)
	RefreshCardVSPartOfGameRoomByState(roomState, isInit)
	RefreshSettlementPartOfGameRoomByState(roomState, isInit)
end


-- ===============【等待开局】【1】ZUJURoomState.Start===============--
-- 等待游戏开局
function RefreshStartPartOfGameRoomByState( roomStateParam, initParam )
    -- body
    if roomStateParam == ZUJURoomState.Start then
        -- body
    end
end

-- ===============【等待准备】【2】 ZUJURoomState.Wait===============--

function RefreshWaitPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

-- ===============【收取底注】【3】 ZUJURoomState.SubduceBet===============--

function RefreshSubduceBetPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

-- ===============【洗牌发牌】【4】 ZUJURoomState.Deal===============--

function RefreshDealPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

-- ===============【下注阶段】【5】 ZUJURoomState.Betting===============--

function RefreshBettingPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

-- ===============弃牌、加注、跟注、比牌===============--

-- 玩家弃牌按钮call
function OnQPButtonClick()
    -- body
    print('弃牌按钮点击')
end

-- 玩家加注按钮call
function OnJZButtonClick()
    -- body
    print('加注按钮点击')
    MasterJZInfoShow(true)
end

-- 玩家跟注按钮call
function OnGZButtonClick()
    -- body
    print('跟注按钮点击')
end

-- 玩家比牌按钮call
function OnBPButtonClick()
    -- body
    print("玩家比牌按钮点击")
end

-- 玩家加注隐藏按钮call
function OnJZHideClick()
    -- body
    print("玩家加注隐藏点击")
    MasterJZInfoShow(false)
end

-- 加注筹码选择call
function OnJZButtonOKClick(jiazhuParam)
    -- body
    print('加注筹码:' .. jiazhuParam)
end


-- 下注按钮显示设置
function MasterXZButtonShow(showParam)
    -- body
    if mMasterXZInfo.XZButtonGameObject.activeSelf == showParam then
        return
    end
    mMasterXZInfo.XZButtonGameObject:SetActive(showParam)
end

-- 加注模块显示设置
function MasterJZInfoShow(showParam)
    -- body
    if mMasterXZInfo.JZButtonGameObject.activeSelf == showParam then
        return
    end
    -- body
    mMasterXZInfo.JZButtonGameObject:SetActive(showParam)
end



-- ===============【比牌阶段】【6】 ZUJURoomState.CardVS===============--


function RefreshCardVSPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

-- 设置VSPK显示
function VSPKShow(showParam)
    -- body
    if mVSPK.activeSelf == showParam then
        return
    end
    mVSPK:SetActive(showParam)
end

-- ===============【结算阶段】【7】 ZUJURoomState.Settlement===============--

function RefreshSettlementPartOfGameRoomByState( roomStateParam, initParam )
    -- body
end

