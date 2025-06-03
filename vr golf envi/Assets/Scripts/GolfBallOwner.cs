using Photon.Pun;
using UnityEngine;

public class GolfBallOwner : MonoBehaviourPun
{
    public PhotonView OwnerView;

    void Start()
    {
        OwnerView = GetComponent<PhotonView>();
        if (OwnerView == null)
        {
            Debug.LogError("❌ PhotonView missing on GolfBall!");
        }
        else
        {
            Debug.Log("✅ GolfBallOwner: Owner is " + OwnerView.Owner?.NickName);
        }
    }
}
