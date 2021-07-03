
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo = 
{
    name        = "[NMRiH] Infinite Fuel Fix",
    author      = "Dysphie",
    description = "",
    version     = "0.1.0",
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

		int wep = GetEntPropEnt(players[i], Prop_Send, "m_hActiveWeapon");
		if (wep != -1 && HasEntProp(wep, Prop_Send, "m_bSawing"))
		{
			SDKHooks_DropWeapon(players[i], wep);
			EquipPlayerWeapon(players[i], wep);
			SetEntPropEnt(players[i], Prop_Send, "m_hActiveWeapon", wep);
		}
	}
	return Plugin_Continue;
}

stock bool IsValidClient(int client)
{
    return 0 < client <= MaxClients && IsClientInGame(client);
}
