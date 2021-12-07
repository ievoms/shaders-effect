using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class targetExtrude : MonoBehaviour
{
  public float speedX = 0f;

private MaterialPropertyBlock myBlock;
private Renderer renderer;
private Camera camera;
    private bool isTouched=false;

    void Awake()
    {
        myBlock = new MaterialPropertyBlock(); 
        renderer = GetComponentInParent<Renderer>(); 
        camera = Camera.main;
    }
    void Update()
    {
        if(isTouched){
            float dist = Vector3.Distance(camera.transform.position, transform.position);
            renderer.GetPropertyBlock(myBlock);
            myBlock.SetFloat("_Amount", Mathf.Lerp(myBlock.GetFloat("_Amount"),dist/100,0.5f));
            renderer.SetPropertyBlock(myBlock); 
        }
    }
    private void OnTriggerEnter(Collider other)
    {
        if(other.tag=="MainCamera"){
            isTouched=true;          
        }
    }
    private void OnTriggerExit(Collider other)
    {
        if(other.tag=="MainCamera"){
            isTouched=false;
        }
    }

    
    
}
