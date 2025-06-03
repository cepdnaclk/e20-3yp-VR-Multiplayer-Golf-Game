using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class GolfClubHit : MonoBehaviour
{
    public float forceMultiplier = 10f;
    private Vector3 previousPosition;
    private Vector3 velocity;

    private PhotonView ownerPhotonView; // reference to owning PlayerManager's PhotonView

    void Start()
    {
        previousPosition = transform.position;

        Rigidbody rb = GetComponent<Rigidbody>();
        Debug.Log(rb != null ? "✅ Rigidbody found on club" : "❌ Missing Rigidbody on club");

        Collider[] cols = GetComponents<Collider>();
        Debug.Log("✅ Number of colliders on club: " + cols.Length);
        foreach (var c in cols)
            Debug.Log("   └▶ Collider type: " + c.GetType().Name + ", isTrigger: " + c.isTrigger);

        if (ownerPhotonView == null)
        {
            Debug.LogError("❌ ownerPhotonView is not set! Cannot determine turn ownership.");
        }
        else
        {
            Debug.Log("✅ ownerPhotonView set. IsMine: " + ownerPhotonView.IsMine + " | Owner: " + ownerPhotonView.Owner.NickName);
        }
    }

    public void SetOwnerPhotonView(PhotonView view)
    {
        ownerPhotonView = view;
    }

    void Update()
    {
        velocity = (transform.position - previousPosition) / Time.deltaTime;
        previousPosition = transform.position;
    }

    private void OnCollisionEnter(Collision collision)
    {
        Debug.Log("Collision detected with: " + collision.gameObject.name + ", tag: " + collision.gameObject.tag);
        Debug.Log("Club velocity: " + velocity.magnitude);
        Debug.Log("photonView.IsMine = " + ownerPhotonView.IsMine);

        if (!ownerPhotonView.IsMine) return;

        if (collision.gameObject.CompareTag("GolfBall"))
        {
            // Check if the ball belongs to the local player
            GolfBallOwner ballOwner = collision.gameObject.GetComponent<GolfBallOwner>();
            if (ballOwner == null)
            {
                Debug.LogWarning("⛔ Ball does not have GolfBallOwner script");
                return;
            }

            if (!ballOwner.OwnerView.IsMine)
            {
                Debug.Log("⛳ This ball does not belong to me. Ignoring hit.");
                return;
            }

            if (velocity.magnitude < 0.2f)
            {
                Debug.Log("⛳ Club movement too slow. No force applied.");
                return;
            }

            Rigidbody ballRb = collision.gameObject.GetComponent<Rigidbody>();
            Vector3 direction = -collision.contacts[0].normal;
            Vector3 hitForce = forceMultiplier * velocity.magnitude * direction;

            Debug.Log($"→ Applying force: {hitForce} | direction: {direction} | velocity: {velocity} | magnitude: {velocity.magnitude}");
            Debug.DrawRay(collision.contacts[0].point, hitForce, Color.red, 1f);

            ballRb.AddForce(hitForce, ForceMode.VelocityChange);

            // Switch turn
            if (TurnManager.Instance == null)
            {
                Debug.LogError("❌ TurnManager.Instance is null! Did you instantiate it?");
                return;
            }

            Debug.Log("✅ Switching turn...");
            TurnManager.Instance.SwitchTurn();
        }
    }
}
