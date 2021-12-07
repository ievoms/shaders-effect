using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpawnProjectiles : MonoBehaviour
{
    [Tooltip("Key that triggers the projectile")]
    public KeyCode key;
    public GameObject firePoint;
    public List<GameObject> vfx = new List<GameObject>();
    private GameObject effectToSpawn;
    void Start()
    {
        effectToSpawn = vfx[0];
    }
    void Update()
    {
        
    }
    public void SpawnVFX()
    {
        GameObject vfx;

        if(firePoint != null)
        {
            vfx = Instantiate(effectToSpawn, firePoint.transform.position, firePoint.transform.rotation);
        }
        else
            Debug.Log("No Fire Point");
    }
}
