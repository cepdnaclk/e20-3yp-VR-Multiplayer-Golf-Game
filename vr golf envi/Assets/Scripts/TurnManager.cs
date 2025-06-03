using Photon.Pun;
using Photon.Realtime;
using UnityEngine;

public class TurnManager : MonoBehaviourPunCallbacks
{
    public static TurnManager Instance;
    private int currentPlayerIndex = 0;

    private void Awake()
    {
        DontDestroyOnLoad(gameObject);
        if (Instance == null)
        {
            Instance = this;
            Debug.Log("TurnManager instance set.");
        }
        else
        {
            Debug.LogWarning("⚠️ Multiple TurnManager instances found! Destroying duplicate.");
            Destroy(gameObject);
            return;
        }
    }

    public void SwitchTurn()
    {
        currentPlayerIndex = (currentPlayerIndex + 1) % PhotonNetwork.PlayerList.Length;
        photonView.RPC("RPC_SwitchTurn", RpcTarget.All, currentPlayerIndex);
    }

    [PunRPC]
    void RPC_SwitchTurn(int activePlayerIndex)
    {
        Debug.Log("RPC_SwitchTurn called. Active index: " + activePlayerIndex);
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
