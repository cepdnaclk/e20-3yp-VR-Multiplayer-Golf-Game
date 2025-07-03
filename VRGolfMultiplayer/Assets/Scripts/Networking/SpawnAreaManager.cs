using Unity.VisualScripting;
using UnityEngine;

public class SpawnAreaManager : MonoBehaviour
{
    // Add static Instance declaration
    public static SpawnAreaManager Instance;

    [Header("Spawn Area Settings")]
    public Vector3 center;
    public Vector3 size = new Vector3(10f, 0f, 20f);
    public int maxSpawnPoints = 8;
    public float minDistanceBetweenPoints = 3f;

    private Vector3[] spawnPoints;

    void Awake()
    {
        Instance = this;
        // Initialize singleton instance
        if (Instance == null)
        {
            Instance = this;
        }
        else
        {
            Destroy(gameObject);
            return;
        }

        GenerateSpawnPoints();
    }

    void GenerateSpawnPoints()
    {
        spawnPoints = new Vector3[maxSpawnPoints];

        for (int i = 0; i < maxSpawnPoints; i++)
        {
            Vector3 candidate;
            bool validPosition;
            int attempts = 0;

            do
            {
                candidate = new Vector3(
                    center.x + Random.Range(-size.x / 2, size.x / 2),
                    center.y,
                    center.z + Random.Range(-size.z / 2, size.z / 2)
                );

                validPosition = IsPositionValid(candidate, i);
                attempts++;

            } while (!validPosition && attempts < 100);

            spawnPoints[i] = candidate;
        }
    }

    bool IsPositionValid(Vector3 position, int currentIndex)
    {
        // Check against existing points
        for (int i = 0; i < currentIndex; i++)
        {
            if (spawnPoints[i] != null &&
                Vector3.Distance(position, spawnPoints[i]) < minDistanceBetweenPoints)
            {
                return false;
            }
        }
        return true;
    }

    public Vector3 GetSpawnPoint(int playerIndex)
    {
        if (spawnPoints == null || spawnPoints.Length == 0)
        {
            Debug.LogWarning("Spawn points not generated! Using fallback position");
            return center;
        }
        return spawnPoints[playerIndex % maxSpawnPoints];
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = new Color(0, 1, 0, 0.5f);
        Gizmos.DrawCube(center, size);

        if (spawnPoints != null)
        {
            Gizmos.color = Color.red;
            foreach (Vector3 point in spawnPoints)
            {
                Gizmos.DrawSphere(point, 0.5f);
            }
        }
    }
    // Add to SpawnAreaManager.cs for debugging:
    void Start()
    {
        Debug.Log("Generated spawn points:");
        foreach (Vector3 point in spawnPoints)
        {
            Debug.Log(point);
        }
    }
    
}
