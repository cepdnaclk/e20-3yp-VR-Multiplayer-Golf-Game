using UnityEngine;

public class BallMovementConstraint : MonoBehaviour
{
    public Vector3 spawnPosition;
    public float maxDistance = 2f;
    
    private Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void Update()
    {
        // Check if ball is moving toward obstacles
        float distanceFromSpawn = Vector3.Distance(transform.position, spawnPosition);
        
        if (distanceFromSpawn > maxDistance)
        {
            // Pull ball back toward spawn area
            Vector3 directionToSpawn = (spawnPosition - transform.position).normalized;
            rb.AddForce(directionToSpawn * 5f);
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == LayerMask.NameToLayer("Obstacles"))
        {
            // Push ball away from obstacle
            Vector3 pushDirection = (transform.position - other.transform.position).normalized;
            rb.AddForce(pushDirection * 10f, ForceMode.Impulse);
        }
    }
}
