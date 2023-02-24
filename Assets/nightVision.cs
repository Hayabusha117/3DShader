using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class nightVision : MonoBehaviour
{
    public Shader currentshader;
    public float contrast = 2;
    public float brightness = 1f;
    public Color nightVisionColor = Color.white;
    public Texture2D vignetteTexture;
    public Texture2D scanlineTexture;
    public float scanlineAmount = 4f;
    public Texture2D noiseTexture;
    public float noiseXSpeed;
    public float noiseYSpeed;
    public float distortion;
    public float scale;
    public float radomValue;
    private Material currentMaterial;

    Material material
    {
        get
        {
            if(currentMaterial== null)
            {
                currentMaterial = new Material(currentshader);
                currentMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return currentMaterial;
        }
    }


    // Start is called before the first frame update
    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        if(!currentshader && !currentshader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (currentshader != null)
        {
            material.SetFloat("_Contrast", contrast);
            material.SetFloat("_Brightness", brightness);
            material.SetColor("_NightVisionColor", nightVisionColor);
            material.SetFloat("_RandomValue", radomValue);
            material.SetFloat("_Distortion", distortion);
            material.SetFloat("_Scale", scale);
            if (vignetteTexture)
                material.SetTexture("_VignetteTexture", vignetteTexture);

            if (scanlineTexture)
            {
                material.SetTexture("_ScanlineTex", scanlineTexture);
                material.SetFloat("_ScanlineAmount", scanlineAmount);
            }

            if (noiseTexture)
            {
                material.SetTexture("_NooiseTex", noiseTexture);
                material.SetFloat("_NoiseXSpeed", noiseXSpeed);
                material.SetFloat("_NoiseYSpeed", noiseYSpeed);
            }
            Graphics.Blit(sourceTexture, destTexture, currentMaterial);

        }
        else
            Graphics.Blit(sourceTexture, destTexture);
    }


    // Update is called once per frame
    void Update()
    {
        contrast = Mathf.Clamp(contrast, 0f, 4f);
        brightness = Mathf.Clamp(brightness, 0f, 2f);
        radomValue = Random.Range(-1f, 1f);
        distortion = Mathf.Clamp(distortion, -1f, 1f);
        scale = Mathf.Clamp(scale, 0f, 3f);
    }

    private void OnDisable()
    {
        if (currentMaterial)
            DestroyImmediate(currentMaterial);
    }
}
