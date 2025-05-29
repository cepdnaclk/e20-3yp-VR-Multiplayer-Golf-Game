using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class GolfClubHit : MonoBehaviour
{
    public float forceMultiplier = 10f;
    private Vector3 previousPosition;
    private Vector3 velocity;

    private PhotonView photonView;

    void Start()
    {
        Debug.Log("photonView.IsMine = " + photonView.IsMine + " | Owner: " + photonView.Owner.NickName);
        photonView = GetComponentInParent<PhotonView>(); // ✅ Gets the player's PhotonView
        previousPosition = transform.position;

        Rigidbody rb = GetComponent<Rigidbody>();
        Debug.Log(rb != null ? "✅ Rigidbody found on club" : "❌ Missing Rigidbody on club");

        Collider[] cols = GetComponents<Collider>();
        Debug.Log("✅ Number of colliders on club: " + cols.Length);
        foreach (var c in cols)
            Debug.Log("   └▶ Collider type: " + c.GetType().Name + ", isTrigger: " + c.isTrigger);
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
        Debug.Log("photonView.IsMine = " + photonView.IsMine);


        if (!photonView.IsMine) return;

        if (collision.gameObject.CompareTag("GolfBall"))
        {
            Rigidbody ballRb = collision.gameObject.GetComponent<Rigidbody>();

            Vector3 direction = -collision.contacts[0].normal; // better collision normal
            Vector3 hitForce = forceMultiplier * velocity.magnitude * direction;

            Debug.Log($"→ Applying force: {hitForce} | direction: {direction} | velocity: {velocity} | magnitude: {velocity.magnitude}");
            Debug.DrawRay(collision.contacts[0].point, hitForce, Color.red, 1f);

            ballRb.AddForce(forceMultiplier * velocity.magnitude * velocity.normalized, ForceMode.VelocityChange);

            if (TurnManager.Instance == null)
            {
                Debug.LogError("❌ TurnManager.Instance is null! Did you instantiate it?");
                return;
            }
            Debug.Log("Switching turn...");
            TurnManager.Instance.SwitchTurn();
        }
    }

}
