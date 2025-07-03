using Photon.Pun;
using UnityEngine;

public class GolfClubController : MonoBehaviourPun
{
    [Header("Club Settings")]
    [Tooltip("Leave empty to use this GameObject as club head")]
    public Transform clubHead; // Optional - can be null
    public float maxSwingForce = 50f;
    public float chargeSpeed = 2f;
    public LayerMask ballLayer;

    [Header("Input Settings")]
    public KeyCode swingKey = KeyCode.Space;
    public bool useSensorInput = false;
    public float sensorPower;
    public Vector3 sensorDirection;

    private float currentCharge;
    private bool isCharging;
    private Transform actualClubHead;

    void Start()
    {
        // If no clubHead assigned, use this GameObject
        actualClubHead = clubHead != null ? clubHead : transform;

        Debug.Log($"Using {actualClubHead.name} as club head");
    }

    void Update()
    {
        if (!photonView.IsMine) return;

        if (useSensorInput)
        {
            HandleSensorInput();
        }
        else
        {
            HandleKeyboardInput();
        }
    }

    void HandleKeyboardInput()
    {
        if (Input.GetKeyDown(swingKey))
        {
            StartCharging();
        }

        if (isCharging && Input.GetKey(swingKey))
        {
            currentCharge += chargeSpeed * Time.deltaTime;
            currentCharge = Mathf.Clamp01(currentCharge);
        }

        if (isCharging && Input.GetKeyUp(swingKey))
        {
            ExecuteSwing();
        }
    }

    void HandleSensorInput()
    {
        if (sensorPower > 0.1f)
        {
            ExecuteSensorSwing();
            sensorPower = 0f;
        }
    }

    void StartCharging()
    {
        isCharging = true;
        currentCharge = 0f;
    }

    void ExecuteSwing()
    {
        isCharging = false;
        Vector3 swingDirection = Camera.main.transform.forward;
        float swingForce = currentCharge * maxSwingForce;
        Vector3 spin = Vector3.Cross(swingDirection, Vector3.up) * currentCharge * 10f;
        AttemptHit(swingDirection * swingForce, spin);
        currentCharge = 0f;
    }

    void ExecuteSensorSwing()
    {
        Vector3 spin = Vector3.Cross(sensorDirection, Vector3.up) * sensorPower * 10f;
        AttemptHit(sensorDirection * sensorPower, spin);
    }

    void AttemptHit(Vector3 force, Vector3 spin)
    {
        // Use the actual club head position for raycasting
        Vector3 rayOrigin = actualClubHead.position;
        Vector3 rayDirection = Camera.main.transform.forward;

        RaycastHit hit;
        if (Physics.Raycast(rayOrigin, rayDirection, out hit, 3f, ballLayer))
        {
            GolfBallPhysics ball = hit.collider.GetComponent<GolfBallPhysics>();
            if (ball != null && ball.photonView.IsMine)
            {
                ball.HitBall(force, hit.point, spin);
                Debug.Log($"Hit ball with force: {force.magnitude}");
            }
        }
        else
        {
            Debug.Log("Swing missed - no ball detected");
        }
    }

    public void SetSensorInput(float power, Vector3 direction)
    {
        sensorPower = power;
        sensorDirection = direction.normalized;
    }

    // Visual debugging
    void OnDrawGizmosSelected()
    {
        if (actualClubHead != null)
        {
            Gizmos.color = Color.red;
            Gizmos.DrawWireSphere(actualClubHead.position, 0.5f);

            Gizmos.color = Color.blue;
            Vector3 rayDirection = Camera.main != null ? Camera.main.transform.forward : Vector3.forward;
            Gizmos.DrawRay(actualClubHead.position, rayDirection * 3f);
        }
    }
}
