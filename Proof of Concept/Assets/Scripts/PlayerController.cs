using Mirror;
using UnityEngine;

public class PlayerController : NetworkBehaviour
{
    public GameObject ballPrefab;  // Assign GolfBall prefab in Inspector
    private GameObject myBall;
    public float moveSpeed = 5f;

    public override void OnStartLocalPlayer()
    {
        base.OnStartLocalPlayer();
        CmdSpawnBall();
    }

    [Command]
    void CmdSpawnBall()
    {
        // Server spawns the ball at the player's position
        GameObject spawnedBall = Instantiate(ballPrefab, transform.position + Vector3.forward * 2, Quaternion.identity);
        NetworkServer.Spawn(spawnedBall, connectionToClient);
    }

    void Update()
    {
        if (!isLocalPlayer || myBall == null)
            return;

        // Move the ball using input
        float moveX = Input.GetAxis("Horizontal");
        float moveZ = Input.GetAxis("Vertical");

        Vector3 moveDirection = new Vector3(moveX, 0, moveZ);
        myBall.transform.Translate(moveDirection * moveSpeed * Time.deltaTime);
    }
}
