using UnityEngine;

public class CardboardGolfClub : MonoBehaviour
{
    [Header("Club Settings")]
    public Transform clubHead;
    public float swingForceMultiplier = 10f;
    public LayerMask ballLayer = 1;

    [Header("Cardboard Input")]
    public Camera playerCamera;
    private bool isSwinging = false;
    private Vector3 lastClubPosition;
    private Vector3 clubVelocity;

    void Start()
    {
        if (playerCamera == null)
            playerCamera = Camera.main;

        lastClubPosition = clubHead.position;
    }

    void Update()
    {
        HandleCardboardInput();
        CalculateClubVelocity();
        if (Input.GetMouseButtonDown(0)) // Screen tap or click
        {
            SwingClub();
        }
    }

    void HandleCardboardInput()
    {
        // Cardboard trigger button (screen tap or viewer button)
        if (Input.GetMouseButtonDown(0) || Input.GetKeyDown(KeyCode.Space))
        {
            StartSwing();
        }

        if (Input.GetMouseButtonUp(0) || Input.GetKeyUp(KeyCode.Space))
        {
            EndSwing();
        }
    }

    void CalculateClubVelocity()
    {
        clubVelocity = (clubHead.position - lastClubPosition) / Time.deltaTime;
        lastClubPosition = clubHead.position;
    }

    void StartSwing()
    {
        isSwinging = true;
        Debug.Log("Started golf swing");
    }

    void EndSwing()
    {
        if (isSwinging)
        {
            // Raycast from camera to detect ball
            RaycastHit hit;
            if (Physics.Raycast(playerCamera.transform.position, playerCamera.transform.forward, out hit, 10f, ballLayer))
            {
                if (hit.collider.CompareTag("GolfBall"))
                {
                    HitGolfBall(hit.collider.gameObject, hit.point);
                }
            }
        }
        isSwinging = false;
    }

    void HitGolfBall(GameObject ball, Vector3 hitPoint)
    {
        GolfBallPhysics ballPhysics = ball.GetComponent<GolfBallPhysics>();
        if (ballPhysics != null)
        {
            // Calculate force based on camera forward direction and swing power
            Vector3 swingDirection = playerCamera.transform.forward;
            float swingPower = Mathf.Clamp(clubVelocity.magnitude, 0f, 20f);
            Vector3 force = swingDirection * swingPower * swingForceMultiplier;

            ballPhysics.HitBall(force, hitPoint);

            Debug.Log($"Hit golf ball with force: {force.magnitude}");
        }
    }

    void SwingClub()
    {
        // Example: Apply force to the ball in front of the camera
        RaycastHit hit;
        if (Physics.Raycast(Camera.main.transform.position, Camera.main.transform.forward, out hit, 10f))
        {
            if (hit.collider.CompareTag("GolfBall"))
            {
                Rigidbody ballRb = hit.collider.GetComponent<Rigidbody>();
                if (ballRb != null)
                {
                    ballRb.AddForce(Camera.main.transform.forward * swingForceMultiplier, ForceMode.Impulse);
                }
            }
        }
    }
}
