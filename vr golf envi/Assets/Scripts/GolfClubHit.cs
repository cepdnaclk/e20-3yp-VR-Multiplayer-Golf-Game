using UnityEngine;

public class GolfClubHit : MonoBehaviour
{
    public float forceMultiplier = 5f;
    private Vector3 previousPosition;
    private Vector3 velocity;

    void Update()
    {
        // Track club velocity manually
        velocity = (transform.position - previousPosition) / Time.deltaTime;
        previousPosition = transform.position;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("GolfBall"))
        {
            Rigidbody ballRb = collision.gameObject.GetComponent<Rigidbody>();
            ballRb.AddForce(velocity * forceMultiplier, ForceMode.Impulse);
        }
    }
}
