using UnityEngine;

public class SensorBridge : MonoBehaviour
{
    public GolfClubController clubController;
    public float dataSmoothing = 0.2f;

    private Vector3 smoothedDirection;
    private float smoothedPower;

    public void OnSensorDataReceived(float power, Vector3 direction)
    {
        smoothedPower = Mathf.Lerp(smoothedPower, power, dataSmoothing);
        smoothedDirection = Vector3.Slerp(smoothedDirection, direction, dataSmoothing);
        clubController.SetSensorInput(smoothedPower, smoothedDirection);
    }

    // For testing without actual sensors
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            // Simulate sensor input
            OnSensorDataReceived(0.8f, Camera.main.transform.forward);
        }
    }
}
