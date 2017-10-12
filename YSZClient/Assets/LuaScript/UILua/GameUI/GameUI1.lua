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

end

-- UI 关闭
function WindowClosed()
    CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.InitRoomState, ResetGameRoomToRoomState)

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
    print('菜单按钮点击')
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

-- ===============发牌阶段===============--


-- ===============轮流下注阶段===============--

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

-- ===============玩家自己看牌阶段===============--

-- 设置搓牌组件显示
function ShowPokerHandle(show)

    if mPokerHandle.activeSelf == show then
        return
    end
    mPokerHandle:SetActive(show)
end

function StartEnterCheckAnimation(isHandler, isAni)
    isStartEnterCheckAnimation = true
    -- 对应角色的扑克牌
    local pokerCard1 = mRoomData.ZHUJUPlayerList[5].Pokers[4]
    local pokerCard2 = mRoomData.ZHUJUPlayerList[5].Pokers[5]
    -- 设置 可操作的牌
    local handleCard1 = this.transform:Find('Canvas/PokerHandle/HandleCard1'):GetComponent("PageCurl")
    handleCard1:ResetSprites(GameData.GetPokerCardBackSpriteNameOfBig(pokerCard1), GameData.GetPokerCardSpriteNameOfBig(pokerCard1))

    local handleCard2 = this.transform:Find('Canvas/PokerHandle/HandleCard2'):GetComponent("PageCurl")
    handleCard2:ResetSprites(GameData.GetPokerCardBackSpriteNameOfBig(pokerCard2), GameData.GetPokerCardSpriteNameOfBig(pokerCard2))
    handleCard1.UserData = 4
    handleCard1.gameObject:SetActive(false)
    handleCard2.UserData = 5
    handleCard2.gameObject:SetActive(false)
    local pokerCard1Item = mPLAYERS_SOLT[5].Cards[4]
    local pokerCard2Item = mPLAYERS_SOLT[5].Cards[5]
    pokerCard1Item.gameObject:SetActive(true)
    pokerCard2Item.gameObject:SetActive(true)

    AddEventOfHandlePokerCard(handleCard1)
    AddEventOfHandlePokerCard(handleCard2)
    pokerCard1Item:GetComponent("Image"):ResetSpriteByName(GameData.GetPokerCardSpriteNameOfBig(pokerCard1))
    pokerCard2Item:GetComponent("Image"):ResetSpriteByName(GameData.GetPokerCardSpriteNameOfBig(pokerCard2))
    local handleJoint1 = this.transform:Find('Canvas/PokerHandle/Points/HandlePoint1')
    local handleJoint2 = this.transform:Find('Canvas/PokerHandle/Points/HandlePoint2')
    CheckStartAnimation(pokerCard1Item, mPLAYERS_SOLT[5].Points[4], handleJoint1, handleCard1, isAni)
    CheckStartAnimation(pokerCard2Item, mPLAYERS_SOLT[5].Points[5], handleJoint2, handleCard2, isAni)
    RefreshOpenPokerCardButtonState(true)
    -- RefreshHandlePokerCardVisibleChanged(pokerIndex1, true)
    -- RefreshHandlePokerCardVisibleChanged(pokerIndex2, true)
end

-- 刷新开拍按钮状态
function RefreshOpenPokerCardButtonState(isActive)

    ShowOpenPokerButton(isActive)
    isUpdateOpenPokerCountDown = isActive

end

-- 更新玩家开牌按钮CD
function UpdateOpenPokerCardCountDown()
    if isUpdateOpenPokerCountDown == true then
        local countDown = mRoomData.CountDown
        if countDown < 0 then
            countDown = 0
        end
        mButtonOpenText.text = lua_FormatToCountdownStyle(countDown)
    end
end

function CheckStartAnimation(cardItem, from, to, handleCard, isAni)
    handleCard.transform.position = to.position
    if isAni then
        local script = cardItem.gameObject:AddComponent(typeof(CS.UITweenTransform))
        script.from = from
        script.to = to
        script.duration = 0.4
        script:OnFinished("+",( function() CheckStartAnimationEnd(cardItem, script, handleCard) end))
        script:Play(true)
    else
        lua_Paste_Transform_Value(cardItem, to)
        CheckStartAnimationEnd(cardItem, script, handleCard)
    end
end

function CheckStartAnimationEnd(cardItem, script, handleCard)
    CS.UnityEngine.Object.Destroy(script)
    cardItem.gameObject:SetActive(false)
    handleCard.gameObject:SetActive(true)
    handleCard:ResetPageCurl(444, 300, true, true)
end

function AddEventOfHandlePokerCard(handleCard)
    handleCard:OpenCardCallBack('-', OpenOneCard)
    handleCard:OpenCardCallBack('+', OpenOneCard)
end

function OpenOneCard(userData)
    local pokerIndex = tonumber(userData)
    -- 搓牌自己的4.5张
    local index = pokerIndex
    -- 4/5
    local isLastOne = false

    if index == 4 then
        mRoomData.ZHUJUPlayerList[5].Pokers[4].Visible = true
        local pokerCard = mRoomData.ZHUJUPlayerList[5].Pokers[pokerIndex + 1]
        if (pokerCard.Visible) then
            isLastOne = true
        end
    else
        index = 5
        mRoomData.ZHUJUPlayerList[5].Pokers[5].Visible = true
        local pokerCard = mRoomData.ZHUJUPlayerList[5].Pokers[pokerIndex - 1]
        if (pokerCard.Visible) then
            isLastOne = true
        end
    end
    if isLastOne then
        NetMsgHandler.Send_CS_ZJRoom_CuoPai()
        HandleOpenPokerCardAnimationStepOne()
        ShowOpenPokerButton(false)
    else

    end
end

local isOpenPokerCardAnimation = false

-- 有玩家的开牌动画1
function HandleOpenPokerCardAnimationStepOne()
    isStartEnterCheckAnimation = false
    isOpenPokerCardAnimation = true
    for i = 1, 2, 1 do
        local pokerIndex = i + 3
        local pokerCard = mRoomData.ZHUJUPlayerList[5].Pokers[pokerIndex]
        local cardItem = mPLAYERS_SOLT[5].Cards[pokerIndex]
        SetTablePokerCardVisible(cardItem, true)
        cardItem.gameObject:SetActive(true)
        local pageCurl = this.transform:Find('Canvas/PokerHandle/HandleCard' .. i):GetComponent("PageCurl")
        pageCurl.gameObject:SetActive(false)
        lua_Clear_AllUITweener(cardItem)
        if pageCurl.IsSpriteRotated then
            cardItem.eulerAngles = CS.UnityEngine.Vector3(0, 0, 90)
            local script = cardItem.gameObject:AddComponent(typeof(CS.UITweenRotation))
            script.from = CS.UnityEngine.Vector3(0, 0, 90)
            script.to = CS.UnityEngine.Vector3.zero
            script.duration = 0.2
            script:OnFinished("+",( function() CS.UnityEngine.Object.Destroy(script) end))
            script:Play(true)
        else
            cardItem.eulerAngles = CS.UnityEngine.Vector3(0, 0, 0)
        end
    end
    this:DelayInvoke(0.3, function() HandleOpenPokerCardAnimationStepTwo() end)
end

-- 有玩家的开牌动画2
function HandleOpenPokerCardAnimationStepTwo()
    ---- 扑克牌飞回到原始位置
    for i = 1, 2, 1 do
        local pokerIndex = i + 3
        local pokerCard = mRoomData.ZHUJUPlayerList[5].Pokers[pokerIndex]
        local cardItem = mPLAYERS_SOLT[5].Cards[pokerIndex]
        cardItem.gameObject:SetActive(true)
        local script = cardItem.gameObject:AddComponent(typeof(CS.UITweenTransform))

        script.to = mPLAYERS_SOLT[5].Points[pokerIndex]
        script.duration = 0.3
        script:OnFinished("+",
        ( function()
            CS.UnityEngine.Object.Destroy(script)
            isOpenPokerCardAnimation = false
            PlaySplitPokerCardsAnimation(5, true)
        end ))
        script:Play(true)
    end
    -- 搓牌还原
    ShowPokerHandle(false)
end

-- 玩家看牌按钮 call
function OnKPButtonClick()
    -- body
    print('看牌按钮点击')
end

-- 看牌按钮显示设置
function MasterKPButtonShow(showParam)
    -- body
    if mMasterXZInfo.KPButtonGameObject.activeSelf == showParam then
        return
    end
    mMasterXZInfo.KPButtonGameObject:SetActive(showParam)
end

-- ===============PK阶段===============--

-- 设置VSPK显示
function VSPKShow(showParam)
    -- body
    if mVSPK.activeSelf == showParam then
        return
    end
    mVSPK:SetActive(showParam)
end