using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class teksturugeneravimas : MonoBehaviour
{
    Renderer r;


    // Use this for initialization
    void Start () {
        r = GetComponent<Renderer>();
        r.material.color =new Color(RandomNumber(0,1),RandomNumber(0,1),RandomNumber(0,1),1);
    }

    // Update is called once per frame
    void Update () {

    }
    
    float RandomNumber(int min, int max){  
        // Random random = new Random();
        return Random.Range(0f, 1f);
    }  
}
