using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class GolfClubHit : MonoBehaviour
{
    public float forceMultiplier = 5f;
    private Vector3 previousPosition;
    private Vector3 velocity;

    private PhotonView photonView;

    void Start()
    {
        previousPosition = transform.position;
    }

    void Update()
    {
        velocity = (transform.position - previousPosition) / Time.deltaTime;
        previousPosition = transform.position;
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("GolfBall"))
        {
            Rigidbody ballRb = collision.gameObject.GetComponent<Rigidbody>();
            Vector3 hitForce = velocity * forceMultiplier;
            Debug.Log("Hitting ball with force: " + hitForce);
            ballRb.AddForce(hitForce, ForceMode.Impulse);

            if (photonView.IsMine) // Or golf hole or after certain delay
            {
                TurnManager.Instance.SwitchTurn();
            }
        }
    }
}
