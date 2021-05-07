#include <amxmodx>
#include <hamsandwich>

#tryinclude <reapi>

#if !defined _reapi_included
	#include <fakemeta>
	#include <fun>
#endif

const MAX_WEAPON_NAME_LENGTH = 32

new const g_szWeaponData[][] =
{
	"weapon_p228", 		"weapon_scout", 	"weapon_xm1014", 	"weapon_mac10", 	"weapon_aug", 
	"weapon_elite", 	"weapon_fiveseven",   	"weapon_ump45", 	"weapon_sg550",
	"weapon_galil", 	"weapon_famas", 	"weapon_usp", 		"weapon_glock18", 	"weapon_awp", 
	"weapon_mp5navy", 	"weapon_m249", 		"weapon_m3", 		"weapon_m4a1", 		"weapon_tmp",
	"weapon_g3sg1", 	"weapon_deagle", 	"weapon_sg552", 	"weapon_ak47", 		"weapon_p90"
}

public plugin_init()
{
	register_plugin("Remove Weapons When Out Of Ammo", "1.0", "Huehue @ Gathered-Gaming.COM")
	
	for (new i = 0; i < sizeof(g_szWeaponData); i++)
		RegisterHam(Ham_Weapon_PrimaryAttack, g_szWeaponData[i], "Ham__Weapon_PrimaryAttack", 1)

	register_clcmd("drop", "Command_BlockDrop")
}

public Command_BlockDrop(id)
	return PLUGIN_HANDLED

public Ham__Weapon_PrimaryAttack(iWeapon)
{
	static szWeaponData[MAX_WEAPON_NAME_LENGTH], id

	#if !defined _reapi_included
	id = get_pdata_cbase(iWeapon, 41, 4)
	static iWeaponData
	iWeaponData = get_user_weapon(id)

	static iClip, iAmmo
	get_weaponname(iWeaponData, szWeaponData, charsmax(szWeaponData))
	get_user_ammo(id, iWeaponData, iClip, iAmmo)

	if (iClip <= 1)
	{
		ham_strip_weapon(id, szWeaponData)
	}

	#else
	
	id = get_member(iWeapon, m_pPlayer)

	rg_get_iteminfo(iWeapon, ItemInfo_pszName, szWeaponData, charsmax(szWeaponData))

	if (rg_get_user_ammo(id, rg_get_weapon_info(szWeaponData, WI_ID)) == 0) // if (get_member(iWeapon, m_Weapon_iClip) == 0) // works too
	{
		rg_remove_item(id, szWeaponData, true)
	}
	#endif
	
	return HAM_IGNORED
}

#if !defined _reapi_included
// takes a weapon from a player efficiently
stock ham_strip_weapon(id,weapon[])
{
	if(!equal(weapon,"weapon_",7)) return 0;

	new wId = get_weaponid(weapon);
	if(!wId) return 0;

	new wEnt;
	while((wEnt = engfunc(EngFunc_FindEntityByString,wEnt,"classname",weapon)) && pev(wEnt,pev_owner) != id) {}
	if(!wEnt) return 0;

	if(get_user_weapon(id) == wId) ExecuteHamB(Ham_Weapon_RetireWeapon,wEnt);

	if(!ExecuteHamB(Ham_RemovePlayerItem,id,wEnt)) return 0;
	ExecuteHamB(Ham_Item_Kill,wEnt);

	set_pev(id,pev_weapons,pev(id,pev_weapons) & ~(1<<wId));

	return 1;
}
#endif
