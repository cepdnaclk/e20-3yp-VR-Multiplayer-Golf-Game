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

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Vector3 testForce = Vector3.forward * 50f;
            GetComponent<Rigidbody>().AddForce(testForce, ForceMode.Impulse);
            Debug.Log("Test force applied via SPACE");
        }
    }

}
