using UnityEngine;

public class GolfClubController : MonoBehaviour
{
    public UDPSensorReceiver sensorReceiver;
    public float sensitivity = 100f;
    public Transform clubHead;

    void Update()
    {
        // Apply gyro rotation
        Vector3 rotation = sensorReceiver.gyroData * sensitivity * Time.deltaTime;
        transform.Rotate(rotation, Space.Self);

        // Get button states
        bool swingButton = sensorReceiver.buttonStates[5]; // B6 button
        if (swingButton)
        {
            SwingClub();
        }
    }

    private void SwingClub()
    {
        // Add force to golf ball based on club velocity
        Vector3 swingVelocity = clubHead.GetComponent<Rigidbody>().velocity;
        // Implement your swing physics here
    }
}
