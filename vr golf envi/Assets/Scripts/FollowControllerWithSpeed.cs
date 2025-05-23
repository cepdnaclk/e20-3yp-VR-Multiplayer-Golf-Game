using UnityEngine;

public class FollowControllerWithSpeed : MonoBehaviour
{
    public Transform controllerTransform; // assign your VR controller here
    public float speedMultiplier = 2f;    // make this >1 to speed up movement
    public float followSmoothness = 20f;  // how quickly the object catches up

    private Vector3 offset;

    void Start()
    {
        if (controllerTransform == null)
        {
            Debug.LogError("Controller Transform not assigned!");
            enabled = false;
            return;
        }

        offset = transform.position - controllerTransform.position;
    }

    void Update()
    {
        Vector3 targetPosition = controllerTransform.position + offset * speedMultiplier;
        transform.position = Vector3.Lerp(transform.position, targetPosition, Time.deltaTime * followSmoothness);
    }
}
