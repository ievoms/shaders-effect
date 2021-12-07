using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OnMouseClick : MonoBehaviour
{
    public Material[] materials;
    private Renderer[] renderers;
    int cur;
    void Start()
    {
        cur = 0;
        renderers = GetComponentsInChildren<Renderer>();
    }

    public void OnMouseDown()
     {
         if(cur < materials.Length)
         ++cur;
         if(cur == materials.Length)
         cur = 0;
          foreach (var rend in renderers)
        {
            rend.material = materials[cur];
        }
     }
}
