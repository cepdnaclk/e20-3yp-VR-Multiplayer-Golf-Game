using UnityEngine;

public class BallWaterHandler : MonoBehaviour
{
    public Vector3 respawnPosition;
    public AudioClip splashSound;
    private AudioSource audioSource;

    private void Start()
    {
        // Set the respawn point at start (or update during gameplay)
        respawnPosition = transform.position;

        audioSource = gameObject.AddComponent<AudioSource>();
        audioSource.playOnAwake = false;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Water"))
        {
            // Stop movement
            Rigidbody rb = GetComponent<Rigidbody>();
            rb.linearVelocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;

            // Play splash sound
            if (splashSound != null)
            {
                audioSource.PlayOneShot(splashSound);
            }

            // Reset position after a short delay (optional)
            Invoke("RespawnBall", 1.0f);
        }
    }

    void RespawnBall()
    {
        transform.position = respawnPosition;
    }

    public void UpdateRespawnPoint(Vector3 newPosition)
    {
        respawnPosition = newPosition;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            UpdateRespawnPoint(transform.position);
        }
    }

}
