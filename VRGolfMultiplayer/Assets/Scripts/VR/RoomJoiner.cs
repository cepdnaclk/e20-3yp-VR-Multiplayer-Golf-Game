using UnityEngine;
using Photon.Pun;

public class RoomJoiner : MonoBehaviourPunCallbacks
{
    void Start()
    {
        string roomName = PlayerPrefs.GetString("PhotonRoomName", "");
        if (!string.IsNullOrEmpty(roomName))
        {
            Debug.Log("Trying to join room: " + roomName);
            PhotonNetwork.JoinRoom(roomName);
        }
        else
        {
            Debug.LogError("No room name found to join!");
            // Maybe fallback to join random room or show error UI
        }
    }

    public override void OnJoinedRoom()
    {
        Debug.Log("Successfully joined room: " + PhotonNetwork.CurrentRoom.Name);
        // Start your VR game logic here
    }

    public override void OnJoinRoomFailed(short returnCode, string message)
    {
        Debug.LogError("Failed to join room: " + message);
        // Handle failure (e.g., show UI, try different room)
    }
}
