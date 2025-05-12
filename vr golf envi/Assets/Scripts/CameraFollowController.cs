using UnityEngine;

public class CameraFollowController : MonoBehaviour
{
    public Transform rightHand; // Assign the RightHand Controller here
    public Vector3 offset = new Vector3(0, 0.2f, -0.5f);
    public float smoothSpeed = 10f;

    void LateUpdate()
    {
        if (rightHand == null) return;

        Vector3 targetPosition = rightHand.TransformPoint(offset);
        transform.position = Vector3.Lerp(transform.position, targetPosition, smoothSpeed * Time.deltaTime);
        transform.rotation = Quaternion.Slerp(transform.rotation, rightHand.rotation, smoothSpeed * Time.deltaTime);
    }
}
