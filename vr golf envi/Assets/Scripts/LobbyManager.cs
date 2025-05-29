using UnityEngine;
using UnityEngine.UI;
using Photon.Pun;
using Photon.Realtime;
using TMPro;

public class LobbyManager : MonoBehaviourPunCallbacks
{
    public TMP_InputField roomCodeInput;
    public TMP_Text statusText;
    public Button startGameButton;

    void Start()
    {
        PhotonNetwork.ConnectUsingSettings();
        statusText.text = "Connecting to Photon...";
        startGameButton.gameObject.SetActive(false); // hide at first
    }

    public override void OnConnectedToMaster()
    {
        statusText.text = "Connected to Photon!";
        PhotonNetwork.AutomaticallySyncScene = true;
    }

    public void CreateRoom()
    {
        string roomCode = roomCodeInput.text.Trim();
        if (string.IsNullOrEmpty(roomCode))
        {
            statusText.text = "Please enter a room code.";
            return;
        }

        RoomOptions options = new RoomOptions { MaxPlayers = 2 };
        PhotonNetwork.CreateRoom(roomCode, options);
        statusText.text = "Creating room...";
    }

    public void JoinRoom()
    {
        string roomCode = roomCodeInput.text.Trim();
        if (string.IsNullOrEmpty(roomCode))
        {
            statusText.text = "Please enter a room code.";
            return;
        }

        PhotonNetwork.JoinRoom(roomCode);
        statusText.text = "Joining room...";
    }

    public override void OnJoinedRoom()
    {
        statusText.text = $"Joined room: {PhotonNetwork.CurrentRoom.Name}";

        // Show Start Game only to host
        startGameButton.gameObject.SetActive(PhotonNetwork.IsMasterClient);
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        // If you're the host, and 2 players are now in room, enable Start Game
        if (PhotonNetwork.IsMasterClient && PhotonNetwork.CurrentRoom.PlayerCount == 2)
        {
            startGameButton.gameObject.SetActive(true);
            statusText.text = "Both players joined. Ready to start!";
        }
    }

    public void StartGame()
    {
        if (PhotonNetwork.IsMasterClient)
        {
            statusText.text = "Starting game...";
            PhotonNetwork.LoadLevel("vr_1");
        }
    }

    public override void OnCreateRoomFailed(short returnCode, string message)
    {
        statusText.text = "Create Room Failed: " + message;
    }

    public override void OnJoinRoomFailed(short returnCode, string message)
    {
        statusText.text = "Join Room Failed: " + message;
    }
    
}
