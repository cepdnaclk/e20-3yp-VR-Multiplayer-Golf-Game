using Photon.Pun;
using Photon.Realtime;
using UnityEngine;
using UnityEngine.UI;

public class RoomManager : MonoBehaviourPunCallbacks
{
    [Header("UI References - Assign in Inspector")]
    public InputField roomCodeInput;
    public Button createRoomButton;
    public Button joinRoomButton;
    public Text statusText;
    public Text playersCountText;

    [Header("Room Settings")]
    public int maxPlayersPerRoom = 2;
    
    private string currentRoomCode = "";

    void Start()
    {
        Debug.Log("=== ROOM MANAGER STARTED ===");
        
        // Disable buttons until connected
        if (createRoomButton) createRoomButton.interactable = false;
        if (joinRoomButton) joinRoomButton.interactable = false;
        
        // Setup button listeners
        if (createRoomButton) createRoomButton.onClick.AddListener(CreateRoom);
        if (joinRoomButton) joinRoomButton.onClick.AddListener(JoinRoom);
        
        // Connect to Photon if not already connected
        if (!PhotonNetwork.IsConnected)
        {
            PhotonNetwork.NickName = "Player_" + Random.Range(1000, 9999);
            PhotonNetwork.ConnectUsingSettings();
            UpdateStatus("Connecting to Photon...");
        }
        else
        {
            OnConnectedToMaster();
        }
    }

    public void CreateRoom()
    {
        currentRoomCode = GenerateRoomCode();
        
        RoomOptions roomOptions = new RoomOptions();
        roomOptions.MaxPlayers = (byte)maxPlayersPerRoom;
        roomOptions.IsVisible = false; // Private rooms
        roomOptions.IsOpen = true;
        
        PhotonNetwork.CreateRoom(currentRoomCode, roomOptions);
        UpdateStatus($"Creating room: {currentRoomCode}");
        
        Debug.Log($"Attempting to create room: {currentRoomCode}");
    }

    public void JoinRoom()
    {
        string roomCode = roomCodeInput.text.ToUpper().Trim();
        
        if (string.IsNullOrEmpty(roomCode))
        {
            UpdateStatus("Please enter a room code!");
            return;
        }
        
        if (roomCode.Length != 4)
        {
            UpdateStatus("Room code must be 4 letters!");
            return;
        }
        
        PhotonNetwork.JoinRoom(roomCode);
        UpdateStatus($"Joining room: {roomCode}");
        
        Debug.Log($"Attempting to join room: {roomCode}");
    }

    string GenerateRoomCode()
    {
        string chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        string code = "";
        for (int i = 0; i < 4; i++)
        {
            code += chars[Random.Range(0, chars.Length)];
        }
        return code;
    }

    void UpdateStatus(string message)
    {
        if (statusText) statusText.text = message;
        Debug.Log($"Room Status: {message}");
    }

    void UpdatePlayersCount()
    {
        if (PhotonNetwork.InRoom && playersCountText)
        {
            playersCountText.text = $"Players: {PhotonNetwork.CurrentRoom.PlayerCount}/{PhotonNetwork.CurrentRoom.MaxPlayers}";
        }
    }

    // === PHOTON CALLBACKS ===
    
    public override void OnConnectedToMaster()
    {
        UpdateStatus("Connected! Ready to create or join rooms.");
        if (createRoomButton) createRoomButton.interactable = true;
        if (joinRoomButton) joinRoomButton.interactable = true;
        
        Debug.Log("✓ Connected to Photon Master Server - Room features enabled");
    }

    public override void OnCreatedRoom()
    {
        UpdateStatus($"Room created: {currentRoomCode}");
        if (roomCodeInput) roomCodeInput.text = currentRoomCode;
        
        Debug.Log($"✓ Room created successfully: {currentRoomCode}");
    }

    public override void OnJoinedRoom()
    {
        UpdateStatus($"Joined room: {PhotonNetwork.CurrentRoom.Name}");
        UpdatePlayersCount();
        
        Debug.Log("✓ Successfully joined room!");
        Debug.Log($"Room: {PhotonNetwork.CurrentRoom.Name}");
        Debug.Log($"Players: {PhotonNetwork.CurrentRoom.PlayerCount}/{PhotonNetwork.CurrentRoom.MaxPlayers}");
        
        // Check if room is full
        if (PhotonNetwork.CurrentRoom.PlayerCount == maxPlayersPerRoom)
        {
            StartGolfGame();
        }
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        UpdateStatus($"Player joined: {newPlayer.NickName}");
        UpdatePlayersCount();
        
        Debug.Log($"✓ New player joined: {newPlayer.NickName}");
        
        if (PhotonNetwork.CurrentRoom.PlayerCount == maxPlayersPerRoom)
        {
            StartGolfGame();
        }
    }

    public override void OnPlayerLeftRoom(Player otherPlayer)
    {
        UpdateStatus($"Player left: {otherPlayer.NickName}");
        UpdatePlayersCount();
        
        Debug.Log($"Player left room: {otherPlayer.NickName}");
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {
        UpdateStatus($"Failed to create room: {message}");
        Debug.LogError($"✗ Create room failed: {message} (Code: {returnCode})");
    }

    public override void OnJoinRoomFailed(short returnCode, string message)
    {
        UpdateStatus($"Failed to join room: {message}");
        Debug.LogError($"✗ Join room failed: {message} (Code: {returnCode})");
    }

    void StartGolfGame()
    {
        UpdateStatus("Both players connected! Starting VR Golf Game...");
        Debug.Log("=== STARTING VR GOLF GAME ===");
        
        // TODO: Load VR Golf scene
        // PhotonNetwork.LoadLevel("VRGolfGameScene");
    }
}
