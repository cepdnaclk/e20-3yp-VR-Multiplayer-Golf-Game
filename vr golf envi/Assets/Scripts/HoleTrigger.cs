using UnityEngine;

public class HoleTrigger : MonoBehaviour
{
    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("GolfBall"))
        {
            Debug.Log("Ball in the hole!");
            // You can trigger a score, animation, sound, etc.
        }
    }
}
