using UnityEngine;

public class ClampToTerrain : MonoBehaviour
{
    void LateUpdate()
    {
        // Get the player's current position
        Vector3 pos = transform.position;

        // Get the terrain height at the player's X and Z position
        if (Terrain.activeTerrain != null)
        {
            float terrainY = Terrain.activeTerrain.SampleHeight(pos)
                           + Terrain.activeTerrain.transform.position.y;

            // Set the player's Y to match the terrain height
            pos.y = terrainY;

            // Apply the clamped position
            transform.position = pos;
        }
    }
}
