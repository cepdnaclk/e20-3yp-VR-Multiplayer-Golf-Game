using UnityEngine;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading;

public class UDPSensorReceiver : MonoBehaviour
{
    [SerializeField] private int port = 4210;
    private UdpClient udpClient;
    private Thread receiveThread;
    private bool isReceiving = true;
    public Vector3 gyroData { get; private set; }
    public bool[] buttonStates { get; private set; } = new bool[6];

    void Start()
    {
        udpClient = new UdpClient(port);
        receiveThread = new Thread(new ThreadStart(ReceiveData));
        receiveThread.IsBackground = true;
        receiveThread.Start();
    }

    private void ReceiveData()
    {
        while (isReceiving)
        {
            try
            {
                IPEndPoint remoteEP = null;
                byte[] data = udpClient.Receive(ref remoteEP);
                string packet = Encoding.UTF8.GetString(data);
                ProcessPacket(packet);
            }
            catch (System.Exception e) { Debug.LogError(e.Message); }
        }
    }

    private void ProcessPacket(string packet)
    {
        string[] values = packet.Split(',');
        if (values.Length == 9) // 3 gyro + 6 buttons
        {
            // Parse gyro data
            gyroData = new Vector3(
                float.Parse(values[0]),
                float.Parse(values[1]),
                float.Parse(values[2])
            );

            // Parse button states
            for (int i = 0; i < 6; i++)
            {
                buttonStates[i] = values[3 + i] == "0"; // 0 = pressed
            }
        }
    }

    void OnDestroy()
    {
        isReceiving = false;
        udpClient.Close();
    }
}
