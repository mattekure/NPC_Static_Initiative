origHandleCombatAddInitDnD = nil
origRollTypeInit = nil
function onInit()
	Interface.onDesktopInit = onDesktopInit;
end

function onDesktopInit()
	if not Session.IsHost then return; end
	CombatManager.setCustomRoundStart(customCTRoundStart)
	origHandleCombatAddInitDnD = CombatRecordManager.handleCombatAddInitDnD;
	CombatRecordManager.handleCombatAddInitDnD = newHandleCombatAddInitDnD
	origRollTypeInit = CombatManager.rollTypeInit
	CombatManager.rollTypeInit = newRollTypeInit	
end

	
function customCTRoundStart(nCurrent)
	CombatManager.callForEachCombatant(updateInit);
end

function updateInit(ctNode)
	local useStaticInit = DB.getValue(ctNode, "useStaticInit", 0)
	local staticInit = DB.getValue(ctNode, "staticInit", 0)
	if useStaticInit == 1 then
		DB.setValue(ctNode, "initresult", "number", staticInit);
	end
end

function newHandleCombatAddInitDnD(tCustom)
		origHandleCombatAddInitDnD(tCustom)
		updateInit(tCustom.nodeCT)
end

function newRollTypeInit(sType, fRollCombatantEntryInit, ...)
	origRollTypeInit(sType, fRollCombatantEntryInit, ...)
	customCTRoundStart()
end