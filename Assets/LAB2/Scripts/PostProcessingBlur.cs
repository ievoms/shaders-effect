using UnityEngine;

namespace Lec_05
{
    [ExecuteInEditMode]
    public class PostProcessingBlur : MonoBehaviour
    {
        [SerializeField]
        private Material blur = default;

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            var temporaryTexture = RenderTexture.GetTemporary(source.width, source.height);

            Graphics.Blit(source, temporaryTexture, blur, 0);
            Graphics.Blit(temporaryTexture, destination, blur, 0);

            RenderTexture.ReleaseTemporary(temporaryTexture);
        }
    }
}
