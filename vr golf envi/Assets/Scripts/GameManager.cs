using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

public class GameManager : MonoBehaviourPunCallbacks
{
    void Start()
    {
        if (!PhotonNetwork.IsConnected)
        {
            PhotonNetwork.ConnectUsingSettings();
        }
    }

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.JoinOrCreateRoom("GolfRoom", new RoomOptions { MaxPlayers = 2 }, TypedLobby.Default);
    }

    public override void OnJoinedRoom()
    {
        Debug.Log("Joined room successfully.");

        Vector3 spawnPosition = new Vector3(Random.Range(160, 165), Random.Range(8, 12), Random.Range(170, 177));
        PhotonNetwork.Instantiate("PlayerManager", spawnPosition, Quaternion.identity);

        // ✅ MasterClient instantiates TurnManager once
        if (PhotonNetwork.IsMasterClient)
        {
            PhotonNetwork.Instantiate("TurnManager", Vector3.zero, Quaternion.identity);
        }
    }

    public override void OnPlayerEnteredRoom(Player newPlayer)
    {
        if (PhotonNetwork.IsMasterClient && PhotonNetwork.CurrentRoom.PlayerCount == 2)
        {
            TurnManager.Instance.SwitchTurn();
        }
    }

    
}
