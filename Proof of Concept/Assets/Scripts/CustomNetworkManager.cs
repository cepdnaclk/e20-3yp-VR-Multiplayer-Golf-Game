using Mirror;
using UnityEngine;
using kcp2k;  // Add this for KCPTransport support

public class CustomNetworkManager : NetworkManager
{
    public override void Awake()
    {
        base.Awake();

        // Ensure a transport is assigned
        if (transport == null)
        {
            transport = GetComponent<KcpTransport>();  // Use KcpTransport (lowercase "c")
        }
    }
}
