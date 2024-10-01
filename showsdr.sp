#include <sdkhooks>
#include <sdktools>
#include <sourcemod>
#include <steampawn>
#pragma newdecls required
#pragma semicolon 1
char sPublicIP[64];
int PublicSDRIP[4];
bool SDR_IP_Set = false;

public Plugin myinfo =
{
	name = "List SDR Info",
	author = "oog | pugbot.tf",
	description = "Adds a command to list SDR info",
	version = "1.0.0",
	url = "https://pugbot.tf"
};


public void OnPluginStart() {
	RegConsoleCmd("sm_sdr", Command_SDR, "List SDR Info");
}

public void OnConfigsExecuted() {
	int decSDRIP = SteamPawn_GetSDRFakeIP();
	if (decSDRIP == 0)
	{
		LogMessage("SDR IP is not set");
		return;
	}
	SDR_IP_Set = true;
	PublicSDRIP[0] = (decSDRIP >> 24) & 0xFF;
	PublicSDRIP[1] = (decSDRIP >> 16) & 0xFF;
	PublicSDRIP[2] = (decSDRIP >> 8) & 0xFF;
	PublicSDRIP[3] = decSDRIP & 0xFF;
	int SDRPort = SteamPawn_GetSDRFakePort(0);
	Format(sPublicIP, sizeof(sPublicIP), "%u.%u.%u.%u:%d", PublicSDRIP[0], PublicSDRIP[1], PublicSDRIP[2], PublicSDRIP[3], SDRPort);
	
	LogMessage("SDR IP: %s", sPublicIP);
}

public Action Command_SDR(int client, int args) {
	if (!SDR_IP_Set)
	{
		PrintToChat(client, "SDR does not seem to be on for this server.");
		return Plugin_Handled;
	}
	PrintToChat(client, "SDR IP: %s", sPublicIP);
	char password[64];
	FindConVar("sv_password").GetString(password, sizeof(password));
	PrintToChat(client, "Connect Command: connect %s; password %s", sPublicIP, password);
	return Plugin_Handled;
}