using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ApplyTexLerp : MonoBehaviour
{
  public Material mat;

  private void Update()
  {
      var delta = Mathf.PingPong(Time.time/2, 1);
      mat.SetFloat("_LerpValue", delta);
      mat.SetFloat("_dir",delta);
  }


}
