using Photon.Pun;
using UnityEngine;

public class Launcher : MonoBehaviourPunCallbacks
{
    void Start()
    {
        PhotonNetwork.ConnectUsingSettings(); // Connects to Photon Cloud using App ID
    }

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.JoinOrCreateRoom("GolfRoom", new Photon.Realtime.RoomOptions(), Photon.Realtime.TypedLobby.Default);
    }

    public override void OnJoinedRoom()
    {
        Debug.Log("Joined Room: Spawning players...");
        // Spawn player prefabs here or trigger next stage
    }
}
