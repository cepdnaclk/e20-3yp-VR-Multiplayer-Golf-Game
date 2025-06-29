using Photon.Pun;
using UnityEngine;

public class GolfBallPhysics : MonoBehaviourPun, IPunObservable
{
    [Header("Physics Settings")]
    public float dragCoefficient = 0.47f;
    public float magnusCoefficient = 0.1f;
    public float groundFriction = 0.3f;

    [Header("Network Sync")]
    private Vector3 networkPosition;
    private Vector3 networkVelocity;
    private Quaternion networkRotation;
    private bool isMoving;

    private Rigidbody rb;
    private bool isGrounded;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

        // Only the master client controls physics
        if (PhotonNetwork.IsMasterClient)
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
        if (PhotonNetwork.IsMasterClient && rb.velocity.magnitude > 0.1f)
        {
            ApplyAerodynamicForces();
            ApplyMagnusEffect();
            CheckGroundContact();
        }
    }

    void Update()
    {
        // Non-master clients interpolate position
        if (!PhotonNetwork.IsMasterClient)
        {
            transform.position = Vector3.Lerp(transform.position, networkPosition, Time.deltaTime * 10f);
            // Clamp the interpolation factor between 0 and 1
            float interpolationFactor = Mathf.Clamp01(Time.deltaTime * 10f);
            transform.rotation = Quaternion.Lerp(transform.rotation, networkRotation, interpolationFactor);
        }
    }

    void ApplyAerodynamicForces()
    {
        Vector3 velocity = rb.velocity;
        float speed = velocity.magnitude;

        if (speed > 0.1f)
        {
            // Air resistance
            float dragForce = 0.5f * dragCoefficient * speed * speed * 0.001f;
            Vector3 dragDirection = -velocity.normalized;
            rb.AddForce(dragDirection * dragForce);
        }
    }

    void ApplyMagnusEffect()
    {
        Vector3 velocity = rb.velocity;
        Vector3 angularVelocity = rb.angularVelocity;

        if (velocity.magnitude > 1f && angularVelocity.magnitude > 1f)
        {
            Vector3 magnusForce = Vector3.Cross(angularVelocity, velocity) * magnusCoefficient;
            rb.AddForce(magnusForce);
        }
    }

    void CheckGroundContact()
    {
        isGrounded = Physics.Raycast(transform.position, Vector3.down, 0.5f);

        if (isGrounded && rb.velocity.magnitude < 5f)
        {
            // Apply ground friction
            Vector3 horizontalVelocity = new Vector3(rb.velocity.x, 0, rb.velocity.z);
            rb.AddForce(-horizontalVelocity * groundFriction);
        }
    }

    // Hit the ball (called by club collision)
    public void HitBall(Vector3 force, Vector3 hitPoint)
    {
        if (PhotonNetwork.IsMasterClient)
        {
            rb.AddForceAtPosition(force, hitPoint, ForceMode.Impulse);

            // Add spin based on hit angle
            Vector3 spin = Vector3.Cross(force.normalized, Vector3.up) * force.magnitude * 0.1f;
            rb.AddTorque(spin);
        }
    }

    // Network synchronization
    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting)
        {
            // Send data
            stream.SendNext(transform.position);
            stream.SendNext(rb.velocity);
            stream.SendNext(transform.rotation);
            stream.SendNext(rb.velocity.magnitude > 0.5f);
        }
        else
        {
            // Receive data
            networkPosition = (Vector3)stream.ReceiveNext();
            networkVelocity = (Vector3)stream.ReceiveNext();
            networkRotation = (Quaternion)stream.ReceiveNext();
            isMoving = (bool)stream.ReceiveNext();
        }
    }
}
