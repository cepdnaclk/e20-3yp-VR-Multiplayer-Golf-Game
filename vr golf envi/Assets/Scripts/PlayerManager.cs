using Photon.Pun;
using UnityEngine;
using Photon.Realtime;

public class PlayerManager : MonoBehaviourPunCallbacks
{
    public GameObject golfClub;
    public GameObject golfBall;
    public GameObject xrRig; // Reference to XR Rig root
    public GameObject vrCamera; // Reference to Main Camera inside XR Rig
    public GameObject turnIndicatorText; // Assign from Inspector

    void Start()
    {
        if (!photonView.IsMine)
        {
            // Disable remote player’s camera and VR controls
            vrCamera.SetActive(false);
            xrRig.SetActive(false); // Optional
            if (golfClub != null)
            {
                golfClub.SetActive(false); // ✅ Just disable for remote players
            }
        }
        else
        {
            // This is local player, camera and rig should be active
            vrCamera.SetActive(true);
            xrRig.SetActive(true);

            photonView.Synchronization = ViewSynchronization.ReliableDeltaCompressed;

            // Bluetooth connection for local player only
            BluetoothManager manager = FindFirstObjectByType<BluetoothManager>();
            if (manager != null)
            {
#if UNITY_ANDROID && !UNITY_EDITOR
            Debug.Log("Attempting Bluetooth connection...");
            // The connection is handled in BluetoothManager.Start() for Android,
            // but you can call a connect method here if you want to trigger it manually.
#endif
            }
            else
            {
                Debug.LogWarning("BluetoothManager not found in scene.");
            }
        }
    }

    // 🔧 Add this method for turn-based club control
    public void SetClubActive(bool isActive)
    {
        if (photonView.IsMine)
        {
            golfClub.SetActive(isActive);
            if (turnIndicatorText != null)
                turnIndicatorText.SetActive(!isActive);
        }
    }
}
