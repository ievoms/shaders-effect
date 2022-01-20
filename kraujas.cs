using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;


public class kraujas : MonoBehaviour
{
    public float weight = 0;
    public Shader shader;
    public Material material;
    PostProcessVolume volume;
 
    void Start()
    {
        volume = gameObject.GetComponent<PostProcessVolume>();
        // gameObject.GetComponent<Camera>().RenderWithShader(shader,"RenderType");
         material = new Material( Shader.Find("Custom/golfas su seseliaias") );


    }
    void OnRenderImage (RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit (source, destination, material);

    }

    void Update()
    {
        // gameObject.GetComponent<Camera>().targetTexture. = texture;
        volume.weight = weight;
        
    }

    // void onCollisionEnter(Collision collision)
    // {
    //     Debug.Log("Collision "+collision.relativeVelocity.magnitude);
    //     volume.weight = collision.relativeVelocity.magnitude;

    // }
}
