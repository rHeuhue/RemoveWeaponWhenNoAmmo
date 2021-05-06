#include <amxmodx>
#include <hamsandwich>
#include <reapi>

new const g_szWeaponData[][] =
{
	"weapon_p228", 		"weapon_scout", 	"weapon_xm1014", 	"weapon_mac10", 	"weapon_aug", 
	"weapon_elite", 	"weapon_fiveseven", 	"weapon_ump45", 	"weapon_sg550",
	"weapon_galil", 	"weapon_famas", 	"weapon_usp", 		"weapon_glock18", 	"weapon_awp", 
	"weapon_mp5navy", 	"weapon_m249", 		"weapon_m3", 		"weapon_m4a1", 		"weapon_tmp",
	"weapon_g3sg1", 	"weapon_deagle", 	"weapon_sg552", 	"weapon_ak47", 		"weapon_p90"
}

public plugin_init()
{
	register_plugin("Remove Weapons When Out Of Ammo", "1.0", "Huehue @ Gathered-Gaming.COM")
	
	for (new i = 0; i < sizeof(g_szWeaponData); i++)
		RegisterHam(Ham_Weapon_PrimaryAttack, g_szWeaponData[i], "Ham__Weapon_PrimaryAttack", 1)
}

public Ham__Weapon_PrimaryAttack(iWeapon)
{
	new id = get_member(iWeapon, m_pPlayer)
	static szWeaponData[64]

	if (rg_get_user_ammo(id, rg_get_weapon_info(iWeapon, WI_ID)) == 0)
	{
		rg_get_iteminfo(iWeapon, ItemInfo_pszName, szWeaponData, charsmax(szWeaponData))
		rg_remove_item(id, szWeaponData, true)
	}
	return HAM_IGNORED
}
