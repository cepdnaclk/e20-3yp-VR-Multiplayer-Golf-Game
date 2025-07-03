using Photon.Pun;
using UnityEngine;

[RequireComponent(typeof(Rigidbody))]
public class GolfBallPhysics : MonoBehaviourPun, IPunObservable
{
    [Header("Physics Settings")]
    public float dragCoefficient = 0.47f;
    public float magnusCoefficient = 0.2f;
    public float groundFriction = 0.3f;
    public float stopThreshold = 0.1f;

    private Rigidbody rb;
    private bool isMoving;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

        if (photonView.IsMine)
        {
            rb.isKinematic = false;
        }
        else
        {
            rb.isKinematic = true;
        }
    }

    void FixedUpdate()
    {
        if (photonView.IsMine)
        {
            ApplyGolfPhysics();
            CheckIfStopped();
        }
    }

    void ApplyGolfPhysics()
    {
        if (rb.velocity.magnitude > 0.1f)
        {
            Vector3 velocity = rb.velocity;
            float speed = velocity.magnitude;

            // Air resistance
            float dragForce = 0.5f * dragCoefficient * speed * speed * 0.001f;
            rb.AddForce(-velocity.normalized * dragForce);

            // Magnus effect
            if (rb.angularVelocity.magnitude > 1f)
            {
                Vector3 magnusForce = Vector3.Cross(rb.angularVelocity, velocity) * magnusCoefficient;
                rb.AddForce(magnusForce);
            }

            // Ground friction
            if (Physics.Raycast(transform.position, Vector3.down, 0.05f))
            {
                Vector3 horizontalVel = new Vector3(velocity.x, 0, velocity.z);
                rb.AddForce(-horizontalVel * groundFriction);
            }
        }
    }

    void CheckIfStopped()
    {
        if (rb.velocity.magnitude < stopThreshold && isMoving)
        {
            rb.velocity = Vector3.zero;
            rb.angularVelocity = Vector3.zero;
            isMoving = false;
        }
        else if (rb.velocity.magnitude >= stopThreshold)
        {
            isMoving = true;
        }
    }

    public void HitBall(Vector3 force, Vector3 hitPoint, Vector3 spin)
    {
        if (photonView.IsMine)
        {
            rb.AddForceAtPosition(force, hitPoint, ForceMode.Impulse);
            rb.AddTorque(spin);
            isMoving = true;
        }
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(transform.position);
            stream.SendNext(rb.velocity);
            stream.SendNext(transform.rotation);
        }
        else
        {
            transform.position = (Vector3)stream.ReceiveNext();
            rb.velocity = (Vector3)stream.ReceiveNext();
            transform.rotation = (Quaternion)stream.ReceiveNext();
        }
    }
}
