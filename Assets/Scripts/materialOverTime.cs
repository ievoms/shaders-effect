using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialOverTime : MonoBehaviour
{
    public Color from = Color.green;
    public Color to = Color.blue;
    private Renderer[] renderers;

    // Start is called before the first frame update
    void Start()
    {
        renderers = GetComponentsInChildren<Renderer>();
    }

    private void Animate(Renderer rend)
    {
        var delta = Mathf.PingPong(Time.time, 1);

        var color = Color.Lerp(from, to, delta);
        rend.material.color = color;
    }

    // Update is called once per frame
    void Update()
    {
        foreach (var rend in renderers)
        {
          Animate(rend);
        }
    }
}
