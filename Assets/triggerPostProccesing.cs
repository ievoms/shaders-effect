using System.Collections;
using System.Collections.Generic;

using UnityEngine.Rendering.PostProcessing;

using UnityEngine;

public class triggerPostProccesing : MonoBehaviour
{
 public float fromIntensity = 1f;
        public float toIntensity = 10f;

        private PostProcessVolume volume;
        private Bloom bloom;

        private static Bloom GetBloom(PostProcessVolume volume)
        {
            var profile = volume.profile;
            if (!profile.TryGetSettings<Bloom>(out var bloom))
            {
                bloom = profile.AddSettings<Bloom>();
            }
        
            bloom.intensity.overrideState = true;
        
            return bloom;
        }

        private void Start()
        {
            volume = GetComponent<PostProcessVolume>();
            bloom = GetBloom(volume);
        }

        private void Update()
        {
            var delta = Mathf.PingPong(Time.time, 1);
            var intensity = Mathf.Lerp(fromIntensity, toIntensity, delta);

            bloom.intensity.value = intensity;
        }
        private void OnTriggerEnter(Collider other)
    {
Debug.Log("As cia atejau");
    }
}
