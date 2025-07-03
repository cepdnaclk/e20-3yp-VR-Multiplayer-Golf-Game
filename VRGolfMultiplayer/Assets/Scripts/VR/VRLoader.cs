using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR;
using UnityEngine.XR.Management;


public class VRLoader : MonoBehaviour
{
    IEnumerator Start()
    {
        Debug.Log("Initializing XR...");
        yield return XRGeneralSettings.Instance.Manager.InitializeLoader();

        if (XRGeneralSettings.Instance.Manager.activeLoader == null)
        {
            Debug.LogError("Failed to initialize XR");
            yield break;
        }

        XRGeneralSettings.Instance.Manager.StartSubsystems();
        Debug.Log("XR started successfully");

        // ✅ Give the device a frame or two to stabilize
        yield return new WaitForSeconds(0.5f);

        // ✅ Force recenter tracking (required for late init on mobile)
        var inputSubsystems = new List<XRInputSubsystem>();
        SubsystemManager.GetInstances(inputSubsystems);
        foreach (var subsystem in inputSubsystems)
        {
            subsystem.TryRecenter();
        }

        Debug.Log("Tracking recentered.");
    }

    void OnDisable()
    {
        XRGeneralSettings.Instance.Manager.StopSubsystems();
        XRGeneralSettings.Instance.Manager.DeinitializeLoader();
        Debug.Log("XR stopped");
    }
}
