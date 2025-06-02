using UnityEngine;

public class WaterFlow : MonoBehaviour
{
    public float scrollSpeedX = 0.02f;
    public float scrollSpeedY = 0.01f;
    private Renderer rend;
    private Vector2 offset;

    void Start()
    {
        rend = GetComponent<Renderer>();
        offset = Vector2.zero;
    }

    void Update()
    {
        offset.x += scrollSpeedX * Time.deltaTime;
        offset.y += scrollSpeedY * Time.deltaTime;
        rend.material.mainTextureOffset = offset;
    }
}
