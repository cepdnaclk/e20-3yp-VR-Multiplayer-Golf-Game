using UnityEngine;

public class BallCollisionHandler : MonoBehaviour
{
    public float bounceBackForce = 5f;
    public AudioClip collisionSound;
    private AudioSource audioSource;

    private void Start()
    {
        audioSource = gameObject.AddComponent<AudioSource>();
        audioSource.clip = collisionSound;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Obstacle"))
        {
            // Move ball backward
            Vector3 bounceDirection = -collision.contacts[0].normal;
            GetComponent<Rigidbody>().AddForce(bounceDirection * bounceBackForce, ForceMode.Impulse);

            // Play sound
            if (collisionSound != null)
            {
                audioSource.Play();
            }
        }
    }
}
