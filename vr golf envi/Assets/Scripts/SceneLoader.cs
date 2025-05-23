using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneLoader : MonoBehaviour
{
    public void LoadLevelSelection()
    {
        SceneManager.LoadScene("level_selection");
    }

    public void LoadLevel1()
    {
        SceneManager.LoadScene("Level_1");
    }

    public void LoadLevel2()
    {
        SceneManager.LoadScene("level_2");
    }

    public void LoadHome()
    {
        SceneManager.LoadScene("Home_page");
    }
}
