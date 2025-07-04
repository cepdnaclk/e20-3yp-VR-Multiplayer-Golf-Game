using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadingSceneController : MonoBehaviour
{
    void Start()
    {
        // Wait for a short time then load lobby
        Invoke("LoadLobby", 2f);  // 2 sec delay (adjust as needed)
    }

    void LoadLobby()
    {
        SceneManager.LoadScene("Lobby");
    }
}
