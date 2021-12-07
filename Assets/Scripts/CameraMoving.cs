using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMoving : MonoBehaviour
{
 [Range(1f, 20f)]
    [Tooltip("Camera flight speed")]
    public float movementSpeed = 8f;
    [Range(1f, 10f)]
    [Tooltip("Mouse look sensitivity")]
    public float freeLookSensitivity = 3f;
    private void Start()
    {
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }
    private void Update()
    {
        var tr = transform;
        var position = tr.position;
        var angles = tr.localEulerAngles;
        var speed = movementSpeed * Time.deltaTime;

        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
        {
            position += (-transform.right * speed);
        }
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
        {
            position += (transform.right * speed);
        }
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            position += (transform.forward * speed);
        }
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
        {
            position += (-transform.forward * speed);
        }
        var newRotationX = angles.y + Input.GetAxis("Mouse X") * freeLookSensitivity;
        var newRotationY = angles.x - Input.GetAxis("Mouse Y") * freeLookSensitivity;
        tr.localEulerAngles = new Vector3(newRotationY, newRotationX, 0f);
        tr.position = position;
    }
}
