using UnityEngine;

public class BoundaryCreator : MonoBehaviour
{
    [SerializeField] private float areaSize = 1f;
    [SerializeField] private float wallHeight = 3f;

    void Start()
    {
        CreateBoundaryWalls();
    }

    void CreateBoundaryWalls()
    {
        GameObject boundaryParent = new GameObject("BoundaryWalls");

        // Front wall
        CreateWall("FrontWall", new Vector3(0, wallHeight / 2, areaSize / 2),
                  new Vector3(areaSize, wallHeight, 0.1f));

        // Back wall
        CreateWall("BackWall", new Vector3(0, wallHeight / 2, -areaSize / 2),
                  new Vector3(areaSize, wallHeight, 0.1f));

        // Left wall
        CreateWall("LeftWall", new Vector3(-areaSize / 2, wallHeight / 2, 0),
                  new Vector3(0.1f, wallHeight, areaSize));

        // Right wall
        CreateWall("RightWall", new Vector3(areaSize / 2, wallHeight / 2, 0),
                  new Vector3(0.1f, wallHeight, areaSize));
    }

    void CreateWall(string name, Vector3 position, Vector3 scale)
    {
        GameObject wall = new GameObject(name);
        wall.transform.position = position;
        wall.transform.localScale = scale;

        BoxCollider collider = wall.AddComponent<BoxCollider>();
        collider.isTrigger = false;

        // Make invisible
        wall.AddComponent<MeshRenderer>().enabled = false;
    }
}
