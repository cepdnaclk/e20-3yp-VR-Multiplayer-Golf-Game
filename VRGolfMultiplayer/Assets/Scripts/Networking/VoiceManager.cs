using Photon.Voice.Unity;
using Photon.Voice.PUN;
using UnityEngine;

public class VoiceManager : MonoBehaviour
{
    [Header("Voice Components")]
    public Recorder voiceRecorder;
    public GameObject speakerPrefab;

    [Header("Voice Settings")]
    public bool enableDebugEcho = true;
    public bool pushToTalk = false;

    private UnityVoiceClient voiceClient;

    void Start()
    {
        Debug.Log("=== VOICE CHAT MANAGER STARTED ===");

        // Get voice client component
        voiceClient = GetComponent<UnityVoiceClient>();

        // Setup recorder
        SetupVoiceRecorder();

        // Setup speaker prefab
        SetupSpeakerPrefab();

        // Configure voice client
        ConfigureVoiceClient();
    }

    void SetupVoiceRecorder()
    {
        if (voiceRecorder == null)
        {
            Debug.LogError("Voice Recorder not assigned!");
            return;
        }

        // Enable transmission
        voiceRecorder.TransmitEnabled = true;

        // Enable voice detection (automatic speaking detection)
        voiceRecorder.VoiceDetection = true;
        voiceRecorder.VoiceDetectionThreshold = 0.01f;

        // Enable debug echo for single-client testing
        voiceRecorder.DebugEchoMode = enableDebugEcho;

        Debug.Log("✓ Voice Recorder configured successfully");
    }

    void SetupSpeakerPrefab()
    {
        if (speakerPrefab == null)
        {
            Debug.LogError("Speaker Prefab not assigned!");
            return;
        }

        Debug.Log("✓ Speaker Prefab configured successfully");
    }

    void ConfigureVoiceClient()
    {
        if (voiceClient == null)
        {
            Debug.LogError("UnityVoiceClient component missing!");
            return;
        }

        // Assign primary recorder
        voiceClient.PrimaryRecorder = voiceRecorder;

        // Assign speaker prefab
        voiceClient.SpeakerPrefab = speakerPrefab;

        Debug.Log("✓ Voice Client configured successfully");
    }

    // Toggle push-to-talk (for ESP32 button integration later)
    public void SetPushToTalk(bool enabled)
    {
        if (voiceRecorder != null)
        {
            voiceRecorder.TransmitEnabled = enabled;
        }
    }

    // Voice quality settings for mobile optimization
    public void OptimizeForMobile()
    {
        if (voiceRecorder != null)
        {
            voiceRecorder.SamplingRate = POpusCodec.Enums.SamplingRate.Sampling16000;
            voiceRecorder.Bitrate = 30000; // Lower bitrate for mobile
        }
    }

    void OnGUI()
    {
        GUI.Box(new Rect(10, 120, 300, 80), "Voice Chat Status");

        if (voiceRecorder != null)
        {
            GUI.Label(new Rect(20, 140, 280, 20), $"Recording: {voiceRecorder.IsCurrentlyTransmitting}");
            GUI.Label(new Rect(20, 160, 280, 20), $"Voice Level: {voiceRecorder.LevelMeter:F2}");
            GUI.Label(new Rect(20, 180, 280, 20), $"Debug Echo: {voiceRecorder.DebugEchoMode}");

        }
    }
}