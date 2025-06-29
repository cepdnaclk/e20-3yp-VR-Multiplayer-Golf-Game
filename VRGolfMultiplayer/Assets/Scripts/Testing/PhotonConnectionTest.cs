using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

public class PhotonConnectionTest : MonoBehaviourPunCallbacks
{
    [Header("Connection Status")]
    public bool isConnected = false;
    public string connectionStatus = "Not Connected";

    void Start()
    {
        Debug.Log("=== PHOTON CONNECTION TEST STARTED ===");
        Debug.Log("Attempting to connect to Photon Network...");

        // Set player nickname for testing
        PhotonNetwork.NickName = "TestPlayer_" + Random.Range(1000, 9999);

        // Connect to Photon
        PhotonNetwork.ConnectUsingSettings();
        connectionStatus = "Connecting...";
    }

    public override void OnConnectedToMaster()
    {
        isConnected = true;
        connectionStatus = "Connected to Master Server";

        Debug.Log("✓ SUCCESS: Connected to Photon Master Server!");
        Debug.Log($"✓ Server Region: {PhotonNetwork.CloudRegion}");
        Debug.Log($"✓ App Version: {PhotonNetwork.AppVersion}");
        Debug.Log($"✓ Player Nickname: {PhotonNetwork.NickName}");

        // Automatically join lobby for testing
        PhotonNetwork.JoinLobby();
    }

    public override void OnJoinedLobby()
    {
        connectionStatus = "Connected - In Lobby";
        Debug.Log("✓ SUCCESS: Joined Photon Lobby!");
        Debug.Log($"✓ Players online: {PhotonNetwork.CountOfPlayers}");
        Debug.Log("=== PHOTON CONNECTION TEST COMPLETE ===");
    }

    public override void OnDisconnected(DisconnectCause cause)
    {
        isConnected = false;
        connectionStatus = $"Disconnected: {cause}";
        Debug.LogError($"✗ FAILED: Disconnected from Photon - {cause}");

        // Common troubleshooting info
        if (cause == DisconnectCause.InvalidAuthentication)
        {
            Debug.LogError("Check your App ID in PhotonServerSettings!");
        }
    }

    // Display status in Unity Inspector
    void OnGUI()
    {
        GUI.Box(new Rect(10, 10, 300, 100), $"Photon Status: {connectionStatus}");

        if (isConnected)
        {
            GUI.color = Color.green;
            GUI.Label(new Rect(20, 40, 280, 20), "✓ Photon Connection Working!");
        }
        else
        {
            GUI.color = Color.red;
            GUI.Label(new Rect(20, 40, 280, 20), "✗ Photon Connection Failed");
        }
        GUI.color = Color.white;
    }
}
