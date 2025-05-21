using Photon.Pun;
using UnityEngine;

public class PlayerManager : MonoBehaviourPunCallbacks
{
    public GameObject golfClub;
    public GameObject golfBall;
    public GameObject xrRig; // Reference to XR Rig root
    public GameObject vrCamera; // Reference to Main Camera inside XR Rig

    void Start()
    {
        if (!photonView.IsMine)
        {
            // Disable remote player’s camera and VR controls
            vrCamera.SetActive(false);
            xrRig.SetActive(false); // Optional
            Destroy(golfClub);
        }
        else
        {
            // This is local player, camera and rig should be active
            vrCamera.SetActive(true);
            xrRig.SetActive(true);
        }
    }
}
