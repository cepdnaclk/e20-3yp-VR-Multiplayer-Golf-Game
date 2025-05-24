using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

public class TurnManager : MonoBehaviourPunCallbacks
{
    public static TurnManager Instance;

    private PhotonView photonView;
    private int currentPlayerIndex = 0;

    private void Awake()
    {
        if (Instance == null) Instance = this;
        photonView = GetComponent<PhotonView>(); // 💡 Required for RPCs
    }

    public void SwitchTurn()
    {
        currentPlayerIndex = (currentPlayerIndex + 1) % PhotonNetwork.PlayerList.Length;
        photonView.RPC("RPC_SwitchTurn", RpcTarget.All, currentPlayerIndex);
    }

    [PunRPC]
    void RPC_SwitchTurn(int activePlayerIndex)
    {
        var managers = FindObjectsByType<PlayerManager>(FindObjectsSortMode.None);
        for (int i = 0; i < PhotonNetwork.PlayerList.Length; i++)
        {
            bool isActive = i == activePlayerIndex;

            foreach (var manager in managers)
            {
                if (manager.photonView.Owner.ActorNumber == PhotonNetwork.PlayerList[i].ActorNumber)
                {
                    manager.SetClubActive(isActive);
                }
            }
        }
    }
}
