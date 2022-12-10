ESX.ShowNotification = function(msg, type)
	TriggerEvent('notificaciones:pequeña', msg, type)
end

ESX.ShowAdvancedNotification = function(title, subject, msg)
		TriggerEvent('notificaciones:grande', title, subject, msg)
end

ESX.ShowFloatingHelpNotification = function(msg, coords)
	AddTextEntry('esxFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

ESX.ShowFloatingHelpNotification = function(msg)
	--if not IsHelpMessageBeingDisplayed() then
		BeginTextCommandDisplayHelp('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	--end
end

-- ESX.ShowNotification = function(msg)
-- 	SetNotificationTextEntry('STRING')
-- 	AddTextComponentString(msg)
-- 	DrawNotification(0,1)
-- end

-- ESX.ShowAdvancedNotification = function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
-- 	if saveToBrief == nil then saveToBrief = true end
-- 	AddTextEntry('esxAdvancedNotification', msg)
-- 	BeginTextCommandThefeedPost('esxAdvancedNotification')
-- 	if hudColorIndex then ThefeedNextPostBackgroundColor(hudColorIndex) end
-- 	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
-- 	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
-- end

-- ESX.ShowFloatingHelpNotification = function(msg, thisFrame, beep, duration)
-- 	AddTextEntry('esxHelpNotification', msg)

-- 	if thisFrame then
-- 		DisplayHelpTextThisFrame('esxHelpNotification', false)
-- 	else
-- 		if beep == nil then beep = true end
-- 		BeginTextCommandDisplayHelp('esxHelpNotification')
-- 		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
-- 	end
-- end