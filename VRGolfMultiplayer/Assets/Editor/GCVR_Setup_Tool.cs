#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using UnityEditor.PackageManager;
using UnityEditor.PackageManager.Requests;
using System.IO;

public class GCVR_Setup_Tool : EditorWindow
{
    static AddRequest request;
    float progressValue = 0f;
    string progressMessage = "Idle";

    [MenuItem("Tools/Google Cardboard Setup")]
    public static void ShowWindow()
    {
        GetWindow<GCVR_Setup_Tool>("Google Cardboard Setup");
    }

    void OnGUI()
    {
        GUILayout.Label("Google Cardboard Setup for Beginners", EditorStyles.boldLabel);

        if (GUILayout.Button("Install Google SDK"))
        {
            InstallGoogleSDK();
        }

        if (GUILayout.Button("Open Package Manager to Import HelloCardboard"))
        {
            OpenPackageManagerSamples();
        }

        if (GUILayout.Button("Switch Platform to Android"))
        {
            SwitchPlatformToAndroid();
        }

        if (GUILayout.Button("Configure Player Settings"))
        {
            ConfigurePlayerSettings();
        }

        // if (GUILayout.Button("Open Player Settings - Publishing Settings"))
        // {
        //     OpenPlayerSettings();
        // }

        if (GUILayout.Button("Update Gradle Files"))
        {
            UpdateGradleFiles();
        }

        // Add the Progress Bar UI
        GUILayout.Space(20);
        GUILayout.Label(progressMessage, EditorStyles.boldLabel);
        EditorGUI.ProgressBar(EditorGUILayout.GetControlRect(), progressValue, $"{progressValue * 100}%");
        GUILayout.Space(10);
    }

    static void InstallGoogleSDK()
    {
        request = Client.Add("https://github.com/googlevr/cardboard-xr-plugin.git");
        EditorApplication.update += Progress;
    }

    static void Progress()
    {
        GCVR_Setup_Tool window = (GCVR_Setup_Tool)GetWindow(typeof(GCVR_Setup_Tool));
        if (request == null) return;

        if (request.IsCompleted)
        {
            if (request.Status == StatusCode.Success)
            {
                window.progressMessage = "Google Cardboard SDK Installed";
                Debug.Log("Google Cardboard SDK Installed: " + request.Result.packageId);
            }
            else if (request.Status >= StatusCode.Failure)
            {
                window.progressMessage = "Failed to install Google Cardboard SDK";
                Debug.LogError("Failed to install Google Cardboard SDK: " + request.Error.message);
            }
            window.progressValue = 1f;
            EditorApplication.update -= Progress;
        }
        else
        {
            // Simulate progress
            window.progressMessage = "Installing Google SDK...";
            window.progressValue += 0.01f;
            if (window.progressValue > 1f) window.progressValue = 0.99f;  // Capping progress
        }
        window.Repaint();  // Repaint the editor to show progress updates
    }

    static void OpenPackageManagerSamples()
    {
        EditorApplication.ExecuteMenuItem("Window/Package Manager");
    }

    static void SwitchPlatformToAndroid()
    {
        EditorUserBuildSettings.SwitchActiveBuildTarget(BuildTargetGroup.Android, BuildTarget.Android);
        Debug.Log("Switched to Android Platform");
    }

    static void ConfigurePlayerSettings()
    {
        PlayerSettings.defaultInterfaceOrientation = UIOrientation.LandscapeLeft;

        PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.Android, false);
        var graphicsAPIs = new[] { UnityEngine.Rendering.GraphicsDeviceType.OpenGLES3 };
        PlayerSettings.SetGraphicsAPIs(BuildTarget.Android, graphicsAPIs);

        PlayerSettings.SetScriptingBackend(BuildTargetGroup.Android, ScriptingImplementation.IL2CPP);
        PlayerSettings.Android.minSdkVersion = AndroidSdkVersions.AndroidApiLevel26;
        PlayerSettings.Android.targetSdkVersion = AndroidSdkVersions.AndroidApiLevel33;

        Debug.Log("Player settings configured.");
    }

    // Open Player Settings window focused on Publishing Settings
    // static void OpenPlayerSettings()
    // {
    //     SettingsService.OpenProjectSettings("Project/Player");
    //     Debug.Log("Opened Player Settings - Publishing Settings.");
    // }

    void UpdateGradleFiles()
    {
        string gradlePath = "Assets/Plugins/Android/mainTemplate.gradle";
        if (File.Exists(gradlePath))
        {
            string content = File.ReadAllText(gradlePath);

            if (!content.Contains("androidx.appcompat"))
            {
                content += @"
                dependencies {
                    implementation 'androidx.appcompat:appcompat:1.6.1'
                    implementation 'com.google.android.gms:play-services-vision:20.1.3'
                    implementation 'com.google.android.material:material:1.6.1'
                    implementation 'com.google.protobuf:protobuf-javalite:3.19.4'
                }";
                File.WriteAllText(gradlePath, content);
                Debug.Log("Added dependencies to mainTemplate.gradle.");
            }
        }

        string gradlePropertiesPath = "Assets/Plugins/Android/gradleTemplate.properties";
        if (File.Exists(gradlePropertiesPath))
        {
            string content = File.ReadAllText(gradlePropertiesPath);

            if (!content.Contains("android.enableJetifier"))
            {
                content += @"
                android.enableJetifier=true
                android.useAndroidX=true
                ";
                File.WriteAllText(gradlePropertiesPath, content);
                Debug.Log("Added properties to gradleTemplate.properties.");
            }
        }
    }
}
#endif
