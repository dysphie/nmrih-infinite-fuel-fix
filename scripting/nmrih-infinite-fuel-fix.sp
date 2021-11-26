#include <sdktools>
#include <sdkhooks>

public Plugin myinfo = 
{
    name        = "[NMRiH] Infinite Fuel Fix",
    author      = "Dysphie",
    description = "Fix infinite fuel when using inventory box",
    version     = "0.1.1",
    url         = ""
};

public void OnPluginStart()
{
	HookUserMessage(GetUserMessageId("ItemBoxOpen"), ItemBoxOpen, true);
}

public Action ItemBoxOpen(UserMsg msg, BfRead bf, const int[] players, int playersNum, bool reliable, bool init)
{
	for (int i; i < playersNum; i++)
	{
		if (!IsValidClient(players[i]))
			continue;

		int weapon = GetEntPropEnt(players[i], Prop_Send, "m_hActiveWeapon");
		if (weapon == -1)
			continue;

		char classname[32];
		GetEntityClassname(weapon, classname, sizeof(classname));

		if (StrEqual(classname, "me_chainsaw") || StrEqual(classname, "me_abrasivesaw"))
			RequestFrame(TurnOff, EntIndexToEntRef(weapon));
	}

	return Plugin_Continue;
}

bool IsValidClient(int client)
{
    return 0 < client <= MaxClients && IsClientInGame(client);
}

void TurnOff(int chainsawRef)
{
	int chainsaw = EntRefToEntIndex(chainsawRef);
	if (chainsaw == -1)
		return;

	int owner = GetEntPropEnt(chainsaw, Prop_Send, "m_hOwner");
	if (owner == -1)
		return;

	SetEntProp(chainsaw, Prop_Send, "m_bTurnedOn", 0);
	SetEntProp(chainsaw, Prop_Send, "m_bSawing", 0);

	int viewmodel = GetEntPropEnt(owner, Prop_Send, "m_hViewModel", 0);
	if (viewmodel != -1)
		SetEntProp(viewmodel, Prop_Send, "m_nSkin", 0);
}
