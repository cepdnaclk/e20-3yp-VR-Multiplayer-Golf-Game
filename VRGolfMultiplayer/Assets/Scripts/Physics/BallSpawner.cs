using UnityEngine;
using System.Collections;
using Photon.Pun; // Add this at the top of BallSpawner.cs
public class BallSpawner : MonoBehaviour
{
    [Header("Spawn Settings")]
    public GameObject golfBallPrefab;
    public Transform spawnPoint;
    public float spawnHeightAboveGround = 2f; // Increased height
    public LayerMask groundLayer = 1 << 8;
    public LayerMask obstacleLayer = 1 << 9;

    [Header("Safety Settings")]
    public float safetyRadius = 2f; // Larger safety radius
    public float maxSpawnHeight = 10f;
    public int maxAttempts = 20;

    void Start()
    {
        SpawnBall();
    }

    public void SpawnBall()
    {
        Vector3 safePosition = FindSafeSpawnPosition();
        GameObject ball = PhotonNetwork.Instantiate(golfBallPrefab.name, safePosition, Quaternion.identity);
        StartCoroutine(SafelyInitializeBall(ball));
    }

    Vector3 FindSafeSpawnPosition()
    {
        Vector3 basePosition = spawnPoint.position;
        
        // Try positions in expanding circles
        for (int attempt = 0; attempt < maxAttempts; attempt++)
        {
            Vector3 testPosition = GetTestPosition(basePosition, attempt);
            
            if (IsPositionSafe(testPosition))
            {
                return GetFinalPosition(testPosition);
            }
        }
        
        // Emergency fallback - spawn high in the air
        Debug.LogError("No safe position found! Using emergency spawn");
        return basePosition + Vector3.up * maxSpawnHeight;
    }

    Vector3 GetTestPosition(Vector3 center, int attempt)
    {
        if (attempt == 0) return center;
        
        // Create expanding spiral pattern
        float angle = attempt * 45f;
        float distance = attempt * 0.5f;
        
        Vector3 offset = new Vector3(
            Mathf.Cos(angle * Mathf.Deg2Rad) * distance,
            0,
            Mathf.Sin(angle * Mathf.Deg2Rad) * distance
        );
        
        return center + offset;
    }

    bool IsPositionSafe(Vector3 position)
    {
        // Check for obstacles in all directions
        Vector3[] checkPositions = {
            position,
            position + Vector3.up * 0.5f,
            position + Vector3.down * 0.5f,
            position + Vector3.forward * 0.5f,
            position + Vector3.back * 0.5f,
            position + Vector3.left * 0.5f,
            position + Vector3.right * 0.5f
        };

        foreach (Vector3 checkPos in checkPositions)
        {
            if (Physics.CheckSphere(checkPos, safetyRadius, obstacleLayer))
            {
                return false;
            }
        }
        
        return true;
    }

    Vector3 GetFinalPosition(Vector3 safePosition)
    {
        // Raycast down to find ground
        if (Physics.Raycast(safePosition + Vector3.up * 10f, Vector3.down, out RaycastHit hit, 20f, groundLayer))
        {
            return hit.point + Vector3.up * spawnHeightAboveGround;
        }
        
        return safePosition + Vector3.up * spawnHeightAboveGround;
    }

    IEnumerator SafelyInitializeBall(GameObject ball)
    {
        Rigidbody rb = ball.GetComponent<Rigidbody>();
        if (rb == null) yield break;

        // Completely freeze the ball
        rb.isKinematic = true;
        rb.velocity = Vector3.zero;
        rb.angularVelocity = Vector3.zero;
        
        // Wait longer for physics to settle
        yield return new WaitForSeconds(1f);
        
        // Final safety check before enabling physics
        if (Physics.CheckSphere(ball.transform.position, 0.5f, obstacleLayer))
        {
            Debug.LogWarning("Ball still near obstacle! Moving to emergency position");
            ball.transform.position = spawnPoint.position + Vector3.up * maxSpawnHeight;
        }
        
        // Enable physics
        rb.isKinematic = false;
        
        Debug.Log($"Ball spawned safely at: {ball.transform.position}");
    }

    void OnDrawGizmosSelected()
    {
        if (spawnPoint != null)
        {
            // Show spawn point
            Gizmos.color = Color.green;
            Gizmos.DrawWireSphere(spawnPoint.position, 0.2f);
            
            // Show safety radius
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(spawnPoint.position, safetyRadius);
            
            // Show test positions
            Gizmos.color = Color.yellow;
            for (int i = 0; i < 8; i++)
            {
                Vector3 testPos = GetTestPosition(spawnPoint.position, i);
                Gizmos.DrawWireSphere(testPos, 0.1f);
            }
        }
    }
}
