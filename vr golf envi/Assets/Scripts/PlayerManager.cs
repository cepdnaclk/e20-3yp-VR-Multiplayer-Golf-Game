using Photon.Pun;
using UnityEngine;
using Photon.Realtime;

public class PlayerManager : MonoBehaviourPunCallbacks
{
    public GameObject golfClub;
    public GameObject xrRig; // Reference to XR Rig root
    public GameObject vrCamera; // Reference to Main Camera inside XR Rig
    public GameObject turnIndicatorText; // Assign from Inspector

    public GameObject golfBall; // Make sure this matches your Resources folder
    public Vector3 ballSpawnOffset = new Vector3(0, 0.2f, 0.5f); // Adjust as needed
                                                                 // Add this field at the top of PlayerManager
    private GameObject ballObj;
    void Start()
    {
        bool isLocalPlayer = photonView.IsMine;

        // Activate/deactivate VR rig and camera
        vrCamera.SetActive(isLocalPlayer);
        xrRig.SetActive(isLocalPlayer);

        // Assign PhotonView to GolfClubHit component
        if (golfClub != null)
        {
            GolfClubHit clubHit = golfClub.GetComponent<GolfClubHit>();
            if (clubHit != null)
            {
                clubHit.SetOwnerPhotonView(this.photonView); // ✅ Always assign
                Debug.Log("✅ Passed PlayerManager's PhotonView to GolfClubHit.");
            }
            else
            {
                Debug.LogWarning("⚠️ GolfClubHit not found on golfClub object.");
            }

            // Only enable the club for the local player at start
            golfClub.SetActive(isLocalPlayer);
        }

        if (isLocalPlayer)
        {
            photonView.Synchronization = ViewSynchronization.ReliableDeltaCompressed;

            // 🏌️ Instantiate golf ball with ownership
            Vector3 spawnPosition = transform.position + ballSpawnOffset;
            ballObj = PhotonNetwork.Instantiate(golfBall.name, spawnPosition, Quaternion.identity);

            GolfBallOwner ballOwner = ballObj.GetComponent<GolfBallOwner>();
            if (ballOwner != null)
            {
                ballOwner.OwnerView = this.photonView; // 👈 Assign ownership
                Debug.Log("✅ Assigned OwnerView for ball to: " + photonView.Owner.NickName);
            }
            else
            {
                Debug.LogWarning("⚠️ GolfBallOwner not found on instantiated ball.");
            }

            // Bluetooth connection only for local player
            BluetoothManager manager = FindFirstObjectByType<BluetoothManager>();
            if (manager != null)
            {
#if UNITY_ANDROID && !UNITY_EDITOR
                Debug.Log("Attempting Bluetooth connection...");
                // BluetoothManager.Start() should handle connection
#endif
            }
            else
            {
                Debug.LogWarning("BluetoothManager not found in scene.");
            }
        }
    }

    // 🔧 Called by TurnManager to activate/deactivate golf club based on turn
    public void SetClubActive(bool isActive)
    {
        if (photonView.IsMine)
        {
            golfClub.SetActive(isActive);

            if (turnIndicatorText != null)
                turnIndicatorText.SetActive(!isActive); // Show text when it's NOT your turn
        }
    }
}
