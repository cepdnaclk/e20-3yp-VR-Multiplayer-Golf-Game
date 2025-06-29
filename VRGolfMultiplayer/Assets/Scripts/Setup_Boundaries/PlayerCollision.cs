using UnityEngine;

[RequireComponent(typeof(CharacterController))]
public class PlayerCollision : MonoBehaviour
{
    private CharacterController controller;

    void Start()
    {
        controller = GetComponent<CharacterController>();
        controller.height = 1.8f;
        controller.radius = 0.3f;
        controller.center = new Vector3(0, 0.9f, 0);
        controller.detectCollisions = true;
    }
}
