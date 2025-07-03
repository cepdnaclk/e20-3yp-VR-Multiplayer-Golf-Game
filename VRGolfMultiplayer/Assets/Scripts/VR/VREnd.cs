using UnityEngine.XR.Management;
using System.Collections;
using UnityEngine;
public class ExitVR : MonoBehaviour
{
    IEnumerator Start()
    {
        XRGeneralSettings.Instance.Manager.StopSubsystems();
        XRGeneralSettings.Instance.Manager.DeinitializeLoader();
        yield return null;
        Debug.Log("Exited XR");
    }
}
