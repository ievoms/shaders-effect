using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class objectpool : MonoBehaviour
{
    public GameObject go1;
    public GameObject go2;
    public GameObject go3;
    public GameObject go4;
    public GameObject go5;
    public int kiekis;
    public int greitis;
    public float dydis;
    float _time;

    void Start()
    {
        generateObject();
    }


    void Update()
    {
        _time += Time.deltaTime;
        while(_time >= 3) {
                generateObject();
                _time -= 3;
        }
    }
    public void generateObject (GameObject go0,Color color,int amount)
    {
        for (int i = 0; i < amount*kiekis; i++)
        {                
            GameObject objectas= Instantiate(go0,this.transform.position+new Vector3(i,i,0), Quaternion.identity);
            objectas.GetComponent<Renderer>().material.color = color;
            objectas.GetComponent<Rigidbody>().AddForce(Vector3.Scale(objectas.transform.forward,new Vector3(greitis,greitis,greitis)));
            objectas.transform.localScale += new Vector3(dydis,dydis,dydis);
        }
    }

    void generateObject (){
        generateObject(go1, new Color(1, 0, 0, 1), 1);
        generateObject(go2, new Color(0, 1, 0, 1), 2);
        generateObject(go3, new Color(0, 1, 1, 1), 3);
        generateObject(go4, new Color(0, 0, 1, 1), 4);
        generateObject(go5, new Color(0,0,0, 1), 5);
    }
}
