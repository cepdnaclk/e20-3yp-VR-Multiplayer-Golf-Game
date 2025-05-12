// Optional: Custom golf ball script
using UnityEngine;

public class GolfBall : MonoBehaviour
{
    public Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    public void HitBall(Vector3 force)
    {
        rb.AddForce(force, ForceMode.Impulse);
    }
}
