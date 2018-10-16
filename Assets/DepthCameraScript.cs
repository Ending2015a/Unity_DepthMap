using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DepthCameraScript : MonoBehaviour {

	private Material mat;
	private Camera cam;

    [HideInInspector] public Shader depth_shader;
    public bool GrayScale = false;

	void Awake (){
        if (!depth_shader) {
            depth_shader = Shader.Find ("Custom/DepthGrayscale");
        }
        mat = new Material (depth_shader);
		cam = this.GetComponent<Camera> ();
	}

	void Start () {
		cam.depthTextureMode = DepthTextureMode.Depth;
	}

    void Update(){
        mat.SetFloat ("_gray", GrayScale ? 1.0f : 0.0f);
    }

	void OnRenderImage (RenderTexture source, RenderTexture destination){
		Graphics.Blit(source,destination,mat);
	}
}
