using UnityEngine;
using System;
using System.Globalization;

public class BluetoothManager : MonoBehaviour
{
    private static AndroidJavaClass bluetoothPlugin;

    private float vx = 0, vy = 0, vz = 0;
    private bool tracking = false;
    private long lastTime = 0;

    void Start()
    {
#if UNITY_ANDROID && !UNITY_EDITOR
        bluetoothPlugin = new AndroidJavaClass("com.vrgolfgame.bluetooth.BluetoothPlugin");
        bluetoothPlugin.CallStatic("connectToESP32", "ESP32");
#endif
    }

    public void OnBluetoothConnected(string message)
    {
        Debug.Log("Bluetooth Connected: " + message);
    }

    public void OnBluetoothData(string data)
    {
        Debug.Log("Data Received: " + data);
        float[] parsed = ParseSensorData(data);
        if (parsed.Length >= 12)
        {
            ProcessSensorData(parsed);
        }
    }

    public void OnBluetoothError(string error)
    {
        Debug.LogError("Bluetooth Error: " + error);
    }

    public void OnBluetoothDisconnected(string message)
    {
        Debug.Log("Bluetooth Disconnected: " + message);
    }

    float[] ParseSensorData(string input)
    {
        string[] parts = input.Split(',');
        float[] result = new float[parts.Length];

        for (int i = 0; i < parts.Length; i++)
        {
            float.TryParse(parts[i], NumberStyles.Float, CultureInfo.InvariantCulture, out result[i]);
        }
        return result;
    }

    void ProcessSensorData(float[] data)
    {
        float ax = data[0];
        float ay = data[1];
        float az = data[2];
        float button6 = data[11];

        long currentTime = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();

        if (button6 == 1.0f && az >= 8.0f && az <= 10.0f)
        {
            if (!tracking)
            {
                tracking = true;
                lastTime = currentTime;
                vx = vy = vz = 0;
                Debug.Log("Tracking started...");
            }
            else
            {
                float deltaTime = (currentTime - lastTime) / 1000.0f;
                vx += ax * deltaTime;
                vy += ay * deltaTime;
                vz += az * deltaTime;
                lastTime = currentTime;

                Debug.Log($"Velocity => vx: {vx:F2}, vy: {vy:F2}, vz: {vz:F2}");
            }
        }
        else
        {
            if (tracking)
            {
                Debug.Log($"Tracking stopped. Final velocity => vx: {vx:F2}, vy: {vy:F2}, vz: {vz:F2}");
            }
            tracking = false;
            lastTime = 0;
        }
    }
}
