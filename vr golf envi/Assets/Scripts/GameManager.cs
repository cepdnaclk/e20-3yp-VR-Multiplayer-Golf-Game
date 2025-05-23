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

        Vector3 spawnPosition = new Vector3(Random.Range(8, 12), Random.Range(8, 12), Random.Range(8, 12));
        PhotonNetwork.Instantiate("PlayerManager", spawnPosition, Quaternion.identity);

        // ✅ Only the MasterClient should start the first turn
        if (PhotonNetwork.IsMasterClient && PhotonNetwork.CurrentRoom.PlayerCount == 2)
        {
            TurnManager.Instance.SwitchTurn();
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
