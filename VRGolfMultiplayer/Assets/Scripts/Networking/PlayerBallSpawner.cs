using Photon.Pun;
using UnityEngine;

public class PlayerBallSpawner : MonoBehaviourPun
{
    public GameObject ballPrefab;

    void Start()
    {
        if (photonView.IsMine)
        {
            SpawnMyBall();
        }
    }

    void SpawnMyBall()
    {
        // Check if manager exists
        if (SpawnAreaManager.Instance == null)
        {
            Debug.LogError("SpawnAreaManager instance not found!");
            return;
        }

        int playerIndex = PhotonNetwork.LocalPlayer.ActorNumber - 1;
        Vector3 spawnPosition = SpawnAreaManager.Instance.GetSpawnPoint(playerIndex);

        GameObject ball = PhotonNetwork.Instantiate(
            ballPrefab.name,
            spawnPosition,
            Quaternion.identity
        );

        Debug.Log($"Spawned ball at {spawnPosition} for player {playerIndex + 1}");
    }
}
