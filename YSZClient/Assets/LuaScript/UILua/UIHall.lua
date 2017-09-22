-- 选择的房间ID
-- 房间类型1(竞咪厅) 偏移量
local RoomType1Offset = 0
-- 房间类型2(试水厅) 偏移量
local RoomType2Offset = 200

local IsUpDate = true

function Awake()
	-- 注册区域功能区域按钮
	this.transform:Find('Canvas/Bottom/ButtonStore'):GetComponent("Button").onClick:AddListener(StoreButtonOnClick)
	this.transform:Find('Canvas/Bottom/ButtonMail'):GetComponent("Button").onClick:AddListener(MailButtonOnClick)
	this.transform:Find('Canvas/Bottom/ButtonRank'):GetComponent("Button").onClick:AddListener(RankButtonOnClick)
	this.transform:Find('Canvas/Bottom/ButtonSetting'):GetComponent("Button").onClick:AddListener(SettingButtonOnClick)
	this.transform:Find('Canvas/SwithRoomType/LeftArrow'):GetComponent("Button").onClick:AddListener(RoomTypeOfLeftArrowButton_OnClick)
	this.transform:Find('Canvas/SwithRoomType/RightArrow'):GetComponent("Button").onClick:AddListener(RoomTypeOfRightArrowButton_OnClick)
	this.transform:Find('Canvas/DetailInfo/Panel1/EnterRoom'):GetComponent("Button").onClick:AddListener(EnterSelectedGameRoom)
	this.transform:Find('Canvas/DetailInfo/Panel1/Statistics/StatisticsLeft'):GetComponent("ScrollRectExtend2").onClick:AddListener(EnterSelectedGameRoom)
	this.transform:Find('Canvas/DetailInfo/Panel1/Statistics/StatisticsRight'):GetComponent("ScrollRectExtend2").onClick:AddListener(EnterSelectedGameRoom)
	this.transform:Find('Canvas/DetailInfo/Panel2/Content/CreateRoom'):GetComponent("Button").onClick:AddListener(CreateVipRoomButtonOnClick)
	this.transform:Find('Canvas/DetailInfo/Panel2/Content/JoinRoom'):GetComponent("Button").onClick:AddListener(JoinVipRoomButtonOnClick)
	this.transform:Find('Canvas/RoleInfo/Gold/Icon'):GetComponent("Button").onClick:AddListener(AddGoldButtonOnClick)
	this.transform:Find('Canvas/RoleInfo/RoomCard/Icon'):GetComponent("Button").onClick:AddListener(AddRoomCardButtonOnClick)
	this.transform:Find('Canvas/RoleInfo/Diamond/Icon'):GetComponent("Button").onClick:AddListener(AddDiamondButton_OnClick)
	this.transform:Find('Canvas/RoleInfo/RoleIcon'):GetComponent("Button").onClick:AddListener(HallUI_HeadIconOnClick)
	this.transform:Find('Canvas/Shishuiting/RoomCards/RoomInfo1'):GetComponent("Button").onClick:AddListener(EnterSelectedGameRoom)
	InitHallUIRoomTypeInfo()
end

function RefreshWindowData( windowData )
	-- body
	RefreshHallUIByWindowData(windowData)
end

function WindowOpened()
	CS.EventDispatcher.Instance:AddEventListener(tostring(ProtrocolID.S_Update_Gold), UpdateRoleInfos)
	CS.EventDispatcher.Instance:AddEventListener(tostring(ProtrocolID.S_Update_Diamond), UpdateRoleInfos)
	CS.EventDispatcher.Instance:AddEventListener(tostring(ProtrocolID.S_Update_RoomCard), UpdateRoleInfos)
	CS.EventDispatcher.Instance:AddEventListener(tostring(ProtrocolID.S_Update_Charge), UpdateRoleInfos)
	CS.EventDispatcher.Instance:AddEventListener(tostring(ProtrocolID.CS_Request_Relative_Room), UpdateRelationRoomList)
	CS.EventDispatcher.Instance:AddEventListener(EventDefine.NotifyHeadIconChange, NotifyHeadIconChange)
	CS.EventDispatcher.Instance:AddEventListener(EventDefine.NotifyChangeAccountName, HandleNotifyChangeAccountName)
	CS.EventDispatcher.Instance:AddEventListener(EventDefine.UpdateStatistics, HandleUpdateStatisticsInfo)
	CS.EventDispatcher.Instance:AddEventListener(EventDefine.UpdateUnHandleFlag, HandleUpdateUnHandleFlagEvent)
	HandleRoomTypeChanged(GameData.HallData.SelectType)
	
	TryShowInputInviteCodeTips()
end

function WindowClosed()
	CS.EventDispatcher.Instance:RemoveEventListener(tostring(ProtrocolID.S_Update_Gold), UpdateRoleInfos)
	CS.EventDispatcher.Instance:RemoveEventListener(tostring(ProtrocolID.S_Update_Diamond), UpdateRoleInfos)
	CS.EventDispatcher.Instance:RemoveEventListener(tostring(ProtrocolID.S_Update_RoomCard), UpdateRoleInfos)
	CS.EventDispatcher.Instance:RemoveEventListener(tostring(ProtrocolID.S_Update_Charge), UpdateRoleInfos)
	CS.EventDispatcher.Instance:RemoveEventListener(tostring(ProtrocolID.CS_Request_Relative_Room), UpdateRelationRoomList)
	CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.NotifyHeadIconChange, NotifyHeadIconChange)
	CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.NotifyChangeAccountName, HandleNotifyChangeAccountName)
	CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.UpdateStatistics, HandleUpdateStatisticsInfo)
	CS.EventDispatcher.Instance:RemoveEventListener(EventDefine.UpdateUnHandleFlag, HandleUpdateUnHandleFlagEvent)
end

function RefreshHallUIByWindowData(windowData)
	this.transform:Find('Canvas/RoleInfo/RoleName'):GetComponent("Text").text = GameData.RoleInfo.AccountName
	this.transform:Find('Canvas/RoleInfo/Diamond/Number'):GetComponent("Text").text = lua_CommaSeperate(GameData.RoleInfo.DiamondCount)
	
	this.transform:Find('Canvas/RoleInfo/Gold/Number'):GetComponent("Text").text =lua_CommaSeperate(GameConfig.GetFormatColdNumber(GameData.RoleInfo.GoldCount))
	this.transform:Find('Canvas/RoleInfo/RoomCard/Number'):GetComponent("Text").text =lua_CommaSeperate(GameData.RoleInfo.RoomCardCount)
	this.transform:Find('Canvas/RoleInfo/RoleIcon'):GetComponent("Image"):ResetSpriteByName(GameData.GetRoleIconSpriteName(GameData.RoleInfo.AccountIcon))
	this.transform:Find('Canvas/RoleInfo/RoleIcon/Vip/Value'):GetComponent("Text").text = "VIP".. GameData.RoleInfo.VipLevel
	--GameData.ServerID
	this.transform:Find('Canvas/RoleInfo/SeverID'):GetComponent("Text").text = string.format( "当前服务器:%d服", GameData.ServerID )
	this.transform:Find('Canvas/RoleInfo/SeverID').gameObject:SetActive(CS.AppDefineConst.IsOpenSFT==1)

	-- 刷新未读邮件
	this.transform:Find('Canvas/Bottom/ButtonMail/Flag').gameObject:SetActive(GameData.RoleInfo.UnreadMailCount > 0)
	if(GameData.OpenInstallRoomID == nil or GameData.OpenInstallReferralsID == nil) then
		ReqOpenInstallData();
	end
end

-- 进入选中房间
function EnterSelectedGameRoom()
	if GameData.HallData.SelectType == 1 or GameData.HallData.SelectType == 2 then
		EnterGameRoomByRoomID(GameData.HallData.Data[GameData.HallData.SelectType])
	end
end

-- 进入房间
function EnterGameRoomByRoomID(roomID)
	if roomID > 0 then
		NetMsgHandler.Send_CS_Enter_Room(roomID)
	end
end

-- 响应商场按钮点击事件
function StoreButtonOnClick()
	OpenStoreUI()
end

-- 响应邮件按钮点击事件
function MailButtonOnClick()
	local initParam = CS.WindowNodeInitParam("UIEmail")
	initParam.WindowData = 1
	if EmailMgr:GetMailList() == nil then
		initParam.WindowData = nil
		NetMsgHandler.SendRequestEmails(0)
	end
	CS.WindowManager.Instance:OpenWindow(initParam)
end

-- 邮件数据刷新处理小红点提示
function HandleUpdateUnHandleFlagEvent( eventArg )
	-- body
	if eventArg ~= nil then
		if eventArg.UnHandleType == UNHANDLE_TYPE.EMAIL then
			this.transform:Find('Canvas/Bottom/ButtonMail/Flag').gameObject:SetActive(eventArg.ContainsUnHandle)
		end
	end
end

-- 响应排行榜按钮点击事件
function RankButtonOnClick()
	local initParam = CS.WindowNodeInitParam("UIRank")
	initParam.WindowData = 1
	CS.WindowManager.Instance:OpenWindow(initParam)
	if GameData.RankInfo.RichList == nil then
		NetMsgHandler.SendRequestRanks(1)
	else
		local dayOfyear = lua_GetTimeToYearDay()
		print("点击排行榜按钮时的日期 = "..dayOfyear)
		if dayOfyear > GameData.RankInfo.DayOfYear then
			print("排行榜已过期，需要请求新的排行榜数据")
			NetMsgHandler.SendRequestRanks(1)
		end
	end
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

-- 响应设置按钮点击事件
function SettingButtonOnClick()
	CS.WindowManager.Instance:OpenWindow("UISetting")
end

-- 响应 创建VIP 房间按钮点击事件
function CreateVipRoomButtonOnClick()
	CS.WindowManager.Instance:OpenWindow("UICreateRoom", this.WindowNode)
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

-- 响应 加入VIP 房间按钮点击事件
function JoinVipRoomButtonOnClick()
	CS.WindowManager.Instance:OpenWindow("UIJoinRoom", this.WindowNode)
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

-- 响应 加金币按钮点击事件
function AddGoldButtonOnClick()
	OpenConvertUI(1)
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

-- 响应 加房卡按钮点击事件
function AddRoomCardButtonOnClick()
	OpenConvertUI(2)
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

-- 打开兑换界面
function OpenConvertUI(param)
	local initParam =CS.WindowNodeInitParam("UIConvert")
	initParam.WindowData = param
	CS.WindowManager.Instance:OpenWindow(initParam)
end

-- 响应 加钻石按钮点击事件
function AddDiamondButton_OnClick()
	OpenStoreUI()
end

-- 更新角色信息
function UpdateRoleInfos(param)
	this.transform:Find('Canvas/RoleInfo/RoleName'):GetComponent("Text").text = GameData.RoleInfo.AccountName
	this.transform:Find('Canvas/RoleInfo/Diamond/Number'):GetComponent("Text").text = lua_CommaSeperate(GameData.RoleInfo.DiamondCount)
	this.transform:Find('Canvas/RoleInfo/Gold/Number'):GetComponent("Text").text =lua_CommaSeperate(GameConfig.GetFormatColdNumber(GameData.RoleInfo.GoldCount))
	this.transform:Find('Canvas/RoleInfo/RoomCard/Number'):GetComponent("Text").text =lua_CommaSeperate(GameData.RoleInfo.RoomCardCount)
	this.transform:Find('Canvas/RoleInfo/RoleIcon/Vip/Value'):GetComponent("Text").text = "VIP".. GameData.RoleInfo.VipLevel
end

-- 玩家头像变化
function NotifyHeadIconChange(icon)
	-- body
	this.transform:Find('Canvas/RoleInfo/RoleIcon'):GetComponent("Image"):ResetSpriteByName(GameData.GetRoleIconSpriteName(GameData.RoleInfo.AccountIcon))
end

--刷新主界面上的角色昵称
function HandleNotifyChangeAccountName()
	this.transform:Find('Canvas/RoleInfo/RoleName'):GetComponent("Text").text = GameData.RoleInfo.AccountName
end

-- 响应 头像按钮点击事件
function HallUI_HeadIconOnClick()
	local openParam = CS.WindowNodeInitParam("PlayerInfoUI")
	openParam.WindowData = 0
	CS.WindowManager.Instance:OpenWindow(openParam)
end

-- 开启商城UI
function OpenStoreUI()
	CS.WindowManager.Instance:OpenWindow("UIStore")
	CS.EventDispatcher.Instance:TriggerEvent(EventDefine.NotifyPlayClickBtnSoundEffect, nil)
end

----------------------------------------------------------------------
------------------------房间类型选择----------------------------------
-- 初始化房间基础信息
function InitHallUIRoomTypeInfo()
	-- 初始化试水厅信息
	local shishuitingRoot = this.transform:Find('Canvas/Shishuiting/RoomCards')
	for index = 1, 1, 1 do
		local roomConfig = data.RoomConfig[RoomType2Offset + index]
		shishuitingRoot:Find('RoomInfo'.. index .. '/RoomID'):GetComponent("Text").text = roomConfig.ShowName
		local betLimitText = 	shishuitingRoot:Find('RoomInfo'..index..'/BetLimit/Value'):GetComponent("Text")
		betLimitText.text = string.format("限注:%s-%s", lua_NumberToStyle1String(GameConfig.GetFormatColdNumber(roomConfig.BettingLongHu[1])), lua_NumberToStyle1String(GameConfig.GetFormatColdNumber(roomConfig.BettingLongHu[2])))
	end
	
	-- 初始化竞咪厅信息
	local roomCards = this.transform:Find('Canvas/Jingmiting/RoomCards')
	
	for	index = 1, 7, 1 do
		local roomInfoItem = roomCards:Find('RoomInfo'.. index)
		local roomConfig = data.RoomConfig[RoomType1Offset + index]
		if roomConfig ~= nil then
			roomInfoItem.gameObject:SetActive(true)
			roomInfoItem:Find('RoomID'):GetComponent("Text").text = roomConfig.ShowName
			roomInfoItem:GetComponent("CoverFlowItem"):OnValueChanged('+',(function (selected) JingmitingRoomInfo_OnValueChanged(selected, roomConfig) end))
			roomInfoItem:GetComponent("CoverFlowItem"):CenterItemOnClicked('+', EnterSelectedGameRoom)
			roomInfoItem:Find('BetLimit/Value'):GetComponent("Text").text = string.format("限注:%s-%s", lua_NumberToStyle1String(GameConfig.GetFormatColdNumber(roomConfig.BettingLongHu[1])), lua_NumberToStyle1String(GameConfig.GetFormatColdNumber(roomConfig.BettingLongHu[2])))
		else
			roomInfoItem.gameObject:SetActive(false)
		end
	end
	
	for index = 1, 3, 1 do
		local vipTypeItem = this.transform:Find('Canvas/Vipting/VipTypes/VipType'.. index)
		vipTypeItem:GetComponent("CoverFlowItem"):OnValueChanged('+',( function (selected) ViptingRoomType_OnValueChanged(selected, index) end))
	end
end

-- 房间Left 按钮响应
function RoomTypeOfLeftArrowButton_OnClick()
	local roomType = GameData.HallData.SelectType + 1
	if roomType > 3 then
		roomType = 1
	end
	GameData.HallData.SelectType = roomType
	HandleRoomTypeChanged(roomType)
end

-- 房间Right 按钮响应
function RoomTypeOfRightArrowButton_OnClick()
	local roomType = GameData.HallData.SelectType - 1
	if roomType < 1 then
		roomType = 3
	end
	GameData.HallData.SelectType = roomType
	HandleRoomTypeChanged(roomType)
end

-- 房间类型改变刷新
function HandleRoomTypeChanged(roomType)
	local index = GameData.HallData.Data[roomType]
	RefreshRoomTitleNameByRoomType(roomType)
	this.transform:Find('Canvas/Jingmiting').gameObject:SetActive(roomType == 1)
	this.transform:Find('Canvas/Shishuiting').gameObject:SetActive(roomType == 2)
	this.transform:Find('Canvas/Vipting').gameObject:SetActive(roomType == 3)
	
	this.transform:Find('Canvas/DetailInfo/Panel1').gameObject:SetActive(roomType == 1 or roomType == 2)
	this.transform:Find('Canvas/DetailInfo/Panel2').gameObject:SetActive(roomType == 3)
	
	-- 刷新细节
	if roomType == 1 then
		HandleRoomTypeChangedToJingmiting(index)
	elseif roomType == 2 then
		HandleRoomTypeChangedToShishuiting(index)
	elseif roomType == 3 then
		HandleRoomTypeChangedToVipting(index)
	end
	
	TryShowGuideOfRoomType(roomType)
end

function RefreshRoomTitleNameByRoomType(roomType)
	for	index = 1, 3, 1 do
		this.transform:Find('Canvas/SwithRoomType/TitleName/Name'.. index).gameObject:SetActive(index == roomType)
	end
end

-- 进入试水厅
function HandleRoomTypeChangedToShishuiting(roomID)
	-- 免费试玩房间仅有一个，故不需要选项卡切换来请求数据
	RefreshDetailPanel1InfoByRoomInfo(2, roomID)
end

-- 进入Vip 厅
function HandleRoomTypeChangedToVipting(vipType)
	HandleViptingVipTypeChanged(vipType)
	this.transform:Find('Canvas/Vipting/VipTypes'):GetComponent("CoverFlow"):ResetCenterItem(vipType -1)
end

-- 进入搓牌厅
function HandleRoomTypeChangedToJingmiting(roomID)
	-- 传入的序号从 0开始的：计算方式（房间ID - 房间类型偏移量 - 1）
	if GameData.HallData.Data[1] == roomID then
		if data.RoomConfig[roomID] ~= nil then
			HandleJingmitingRoomCardChanged(data.RoomConfig[roomID].TemplateID)
		end
	end
	this.transform:Find('Canvas/Jingmiting/RoomCards'):GetComponent("CoverFlow"):ResetCenterItem(roomID - RoomType1Offset -1)
end

-- 搓牌厅 轮盘选中变化通知
function JingmitingRoomInfo_OnValueChanged(selected, roomConfig)
	if selected == true then
		GameData.HallData.Data[1] = roomConfig.TemplateID
		HandleJingmitingRoomCardChanged(roomConfig.TemplateID)
		--音效:轮盘选中
		MusicMgr:PlaySoundEffect(11)
	end
end

-- 搓牌厅 选中房间变化
function HandleJingmitingRoomCardChanged(roomID)
	this.transform:Find('Canvas/Jingmiting/PageIndex/Value'):GetComponent("Text").text = "<size=72>"..roomID - RoomType1Offset.."</size>/7"
	RefreshDetailPanel1InfoByRoomInfo(1, roomID)
end

-- 搓牌厅 刷新详细面板1内容
function RefreshDetailPanel1InfoByRoomInfo(roomType, roomID)
	local roomDetail = this.transform:Find('Canvas/DetailInfo/Panel1')
	local roomConfig = data.RoomConfig[roomID]
	if roomConfig ~= nil then
		roomDetail:Find('RoomID/Value'):GetComponent("Text").text = roomConfig.ShowName
		RefreshDetailPanel1InfoOfRoomType(roomID)
		if roomType == 1 then
			roomDetail:Find('RoleCount').gameObject:SetActive(true)
			TryRefreshRoomOnlineRoleCount(roomID)
			roomDetail:Find('LeftCount').gameObject:SetActive(false)
		else
			roomDetail:Find('RoleCount').gameObject:SetActive(false)
			roomDetail:Find('LeftCount').gameObject:SetActive(true)
			if GameData.RoleInfo.FreePlayTimes < 0 then
				roomDetail:Find('LeftCount/Value'):GetComponent("Text").text = "不限"
			else
				roomDetail:Find('LeftCount/Value'):GetComponent("Text").text = tostring(GameData.RoleInfo.FreePlayTimes)
			end
		end
	end
	
	-- 每次均请求单个的房间数据
	NetMsgHandler.Send_CS_Request_Statistics(roomID)
	
	local trendScrpit = this.transform:Find('Canvas/DetailInfo/Panel1/Statistics'):GetComponent("LuaBehaviour").LuaScript
	trendScrpit.ResetRelativeRoomID(roomID)
end

-- 搓牌厅 刷新详细面板1的房间类型
function RefreshDetailPanel1InfoOfRoomType(roomID)
	local roomTypeRoot = this.transform:Find('Canvas/DetailInfo/Panel1/RoomID/RoomType')
	if roomID < RoomType1Offset + 4 then
		roomTypeRoot:Find('RoomType1').gameObject:SetActive(true)
		roomTypeRoot:Find('RoomType2').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType3').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType4').gameObject:SetActive(false)
	elseif roomID < RoomType1Offset + 7 then
		roomTypeRoot:Find('RoomType1').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType2').gameObject:SetActive(true)
		roomTypeRoot:Find('RoomType3').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType4').gameObject:SetActive(false)
	elseif roomID == RoomType1Offset + 7 then
		roomTypeRoot:Find('RoomType1').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType2').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType3').gameObject:SetActive(true)
		roomTypeRoot:Find('RoomType4').gameObject:SetActive(false)
	elseif roomID > RoomType2Offset then
		roomTypeRoot:Find('RoomType1').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType2').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType3').gameObject:SetActive(false)
		roomTypeRoot:Find('RoomType4').gameObject:SetActive(true)
	end
end

-- 搓牌厅 刷新详细信息部分的房间人数
function HandleUpdateStatisticsInfo(eventArgs)
	-- 当前选择类型是竞咪厅
	if GameData.HallData.SelectType == 1 then
		local roomID = GameData.HallData.Data[GameData.HallData.SelectType]
		if eventArgs.RoomID == roomID then
			TryRefreshRoomOnlineRoleCount(roomID)
		end
	end
end

-- 搓牌厅 尝试刷新在线人数
function TryRefreshRoomOnlineRoleCount(roomID)
	local statistics = GameData.RoomInfo.StatisticsInfo[roomID]
	local roleCount = 0
	if statistics ~= nil then
		roleCount = statistics.Counts.RoleCount
	end
	local roleCountText = this.transform:Find('Canvas/DetailInfo/Panel1/RoleCount/Value'):GetComponent("Text")
	roleCountText.text = tostring(roleCount)
end

-- VIP 厅数据刷新
function ViptingRoomType_OnValueChanged(selected, vipType)
	if selected == true then
		GameData.HallData.Data[3] = vipType
		HandleViptingVipTypeChanged(vipType)
		--音效:轮盘选中
		MusicMgr:PlaySoundEffect(11)
	end
end

-- VIP 厅数据变化
function HandleViptingVipTypeChanged(vipType)
	this.transform:Find('Canvas/Vipting/PageIndex/Value'):GetComponent("Text").text = "<size=72>"..vipType.."</size>/3"
	RefreshDetailPanel2InfoByVipType(vipType)
end

-- VIP 厅刷新Bottom信息
function RefreshDetailPanel2InfoByVipType(vipType)
	local detailPanel2 = this.transform:Find('Canvas/DetailInfo/Panel2')
	for	index = 1, 3, 1 do
		detailPanel2:Find('VipType/Value'.. index).gameObject:SetActive(index == vipType)
	end
	
	detailPanel2:Find('Content/Tips').gameObject:SetActive(vipType ~= 1)
	detailPanel2:Find('Content/CreateRoom').gameObject:SetActive(vipType == 1)
	detailPanel2:Find('Content/JoinRoom').gameObject:SetActive(vipType == 1)
	detailPanel2:Find('Content/RelativeRooms').gameObject:SetActive(vipType == 1)
	if vipType == 1 then
		NetMsgHandler.Send_CS_Request_Relative_Room()
	end
end

-- VIP厅刷新关联的房间列表
function UpdateRelationRoomList(param)
	local vipRelativeRoomItem = this.transform:Find('Canvas/DetailInfo/Panel2/Content/RelativeRooms/Viewport/Content/RoomItem')
	local vipParent = vipRelativeRoomItem.parent
	lua_Transform_ClearChildren(vipParent, true)
	local isShowNoneTips = true
	
	for roomID, masterName in pairs(GameData.RoomInfo.RelationRooms) do
		local item = CS.UnityEngine.Object.Instantiate(vipRelativeRoomItem).transform
		item:GetComponent("Button").onClick:AddListener(function ()  EnterGameRoomByRoomID(roomID) end)
		item:Find('RoomID'):GetComponent("Text").text = tostring(roomID)
		item:Find('MasterName'):GetComponent("Text").text = masterName
		item.gameObject:SetActive(true)
		CS.Utility.ReSetTransform(item, vipParent)
		isShowNoneTips = false
	end
	
	this.transform:Find('Canvas/DetailInfo/Panel2/Content/RelativeRooms/Viewport/NoneTip').gameObject:SetActive(isShowNoneTips)
end

-- 显示邀请码填写提示Tips
function TryShowInputInviteCodeTips()
	
	if GameData.IsShowInviteBtn == 0 and LoginMgr.RunningPlatformID == 3 then
		--审核版本不能显示此tips
		return
	end
	
	if GameData.IsPromptedInviteTips == false then
		if GameData.RoleInfo.InviteCode == 0 then
			-- 弹出设置界面和邀请界面
			local boxData = CS.MessageBoxData()
			boxData.Title = "提示"
			boxData.Content = data.GetString("Input_Invite_Code_Tips")
			boxData.Style = 2
			boxData.OKButtonName = "前往"
			boxData.CancelButtonName = "稍后"
			boxData.LuaCallBack = InputInviteCodeMessageBoxCallBack
			local parentWindow = this.WindowNode
			CS.MessageBoxUI.Show(boxData,parentWindow)
			GameData.IsPromptedInviteTips = true
		end
	end
end

-- 开启邀请填写UI
function InputInviteCodeMessageBoxCallBack(result)
	if result == 1 then
		local settingUI = CS.WindowManager.Instance:OpenWindow("UISetting")
		local initParam =CS.WindowNodeInitParam("UIInviteCode")
		initParam.ParentNode = settingUI
		CS.WindowManager.Instance:OpenWindow(initParam)		
	end
end

-- 显示(Guide)引导 UI
function TryShowGuideOfRoomType(roomType)
	local userGuideRoot = this.transform:Find('Canvas/UserGuide')
	if userGuideRoot == nil then
		return
	end
	
	local childCount = userGuideRoot.childCount
	for index = childCount - 1, 0, -1 do
		userGuideRoot:GetChild(index).gameObject:SetActive(false)
	end	
	
	local guideHallOfRoomType = CS.UnityEngine.PlayerPrefs.GetString("SHOWED_Hall_GUIDE_".. roomType, "0")
	
	if guideHallOfRoomType ~= "1" then
		local guidePart = userGuideRoot:Find('Guide'.. roomType)
		if guidePart ~= nil then
			guidePart.gameObject:SetActive(true)
			local iKnowButton = guidePart:Find('KnowButton'):GetComponent("Button")
			iKnowButton.gameObject:SetActive(true)
			iKnowButton.onClick:AddListener(
				function()
					guidePart.gameObject:SetActive(false)
				end
			)
			CS.UnityEngine.PlayerPrefs.SetString("SHOWED_Hall_GUIDE_".. roomType, "1")
		end
	end
end


-- 请求OpenInstallData
function ReqOpenInstallData()
	PlatformBridge:CallFunc(PLATFORM_TYPE.PLATFORM_TOURISTS, PLATFORM_FUNCTION_ENUM.PLATFORM_FUNCTION_INVITE, '参数:请求OpenInstall数据')
end

function Update()
	if GameData.OpenInstallRoomID ~= nil and GameData.OpenInstallRoomID ~= -1 then
		NetMsgHandler.Send_CS_Enter_Room(tonumber(GameData.OpenInstallRoomID))
		GameData.OpenInstallRoomID = -1
	end
	if GameData.OpenInstallReferralsID ~= nil and tonumber(GameData.OpenInstallReferralsID) ~= -1 then
		if GameData.RoleInfo.InviteCode == 0 and GameData.RoleInfo.PromoterStep < 2 and tonumber(GameData.OpenInstallReferralsID) ~= GameData.RoleInfo.AccountID then
			NetMsgHandler.Send_CS_Invite_Code(tonumber(GameData.OpenInstallReferralsID))
			GameData.OpenInstallReferralsID = -1
		end
	end
end