using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Selection_manager : MonoBehaviour
{
   [SerializeField] private Material highlightmaterial;
   [SerializeField] private Material DefaultMaterial;  
   [SerializeField] private string selectableTag = "Selectable";
    private bool _selection;

    // Update is called once per frame
    void Update()
    {

        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if(Physics.Raycast(ray, out hit))
        {
            var selection = hit.transform;
            if(selection.CompareTag(selectableTag))
            {
                var selectionRenderer = selection.GetComponent<Renderer>();
            
                if ( selectionRenderer != null )
                {
                    if (Input.GetKeyDown(KeyCode.Mouse0))
                    {
                        if (_selection == true)
                        {
                            selectionRenderer.material = highlightmaterial;
                            _selection = false;
                        }
                        else
                        {
                             selectionRenderer.material = DefaultMaterial;
                                   _selection = true;
                        }
                    }
                }
            }
        }
    }
}
