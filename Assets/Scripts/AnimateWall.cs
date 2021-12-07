using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimateWall : MonoBehaviour
{    
    public Material[] materials;
    int cur;
    private Renderer[] renderers;
    public int wait_time = 2;
    // Start is called before the first frame update
    void Start()
    {
        cur = 0;
        renderers = GetComponentsInChildren<Renderer>();
        StartCoroutine(Animate());
    }

    IEnumerator Animate()
    {
        if(cur < materials.Length)
         ++cur;
         if(cur == materials.Length)
         cur = 0;
        
        yield return new WaitForSeconds(wait_time);

        foreach (var rend in renderers)
        {
            rend.material = materials[cur];
        }

       StartCoroutine(Animate());
    }

}
