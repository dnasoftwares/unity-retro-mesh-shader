using UnityEngine;
using System.Collections;

public class CameraRotator : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update ()
	{
	    transform.localRotation = Quaternion.AngleAxis(Time.time*30.0f, Vector3.up);
	}
}
