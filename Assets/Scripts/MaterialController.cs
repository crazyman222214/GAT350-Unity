using UnityEngine;

public class MaterialController : MonoBehaviour
{

    public float bloat = 0.0f;
    public MeshRenderer meshRenderer;
    


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        print("hola papi");
        meshRenderer = GetComponent<MeshRenderer>();

    }

    // Update is called once per frame
    void Update()
    {
        meshRenderer.material.SetFloat("_Bloat", bloat);
    }
}
