# iir-designer-cmsis-dsp
A collection of GNU Octave scripts to design IIR filters that can be HW accelerated on ARM Cortex cores via CMSIS DSP.

These filters have been written by [Silex Embedded](https://silexembedded.co.uk) and [Elimo Engineering](https://elimo.io)

These scripts compute the coefficients for IIR filters implementented as [biquad cascade using a Direct Form II transposed structure](http://www.keil.com/pack/doc/CMSIS/DSP/html/group__BiquadCascadeDF2T.html "Biquad DF2 documentation").
This is the IIR implementation that is used by ARM's [CMSIS DSP](http://www.keil.com/pack/doc/CMSIS/DSP/html/index.html "CMSIS DSP' documentation"), which means they can run optimally on ARM Cortex cores over floating point data.

# Usage
See [the examples file](./iir_designer_usage_examples.txt) for usage examples.
After running each of those examples, you will get the coefficients array in the format CMSIS expects.

Example 1 will output:
```
coeffs =

   0.99799
  -1.99597
   0.99799
   1.99597
  -0.99598
```


That array of coefficients can be directly used in ARM code like the following:
```
#define IIR_ORDER     2
#define IIR_NUMSTAGES (IIR_ORDER/2)

static float32_t m_biquad_state[IIR_ORDER];
static float32_t m_biquad_coeffs[5*IIR_NUMSTAGES] =
{
   0.99799,
  -1.99597,
   0.99799,
   1.99597,
  -0.99598
};

arm_biquad_cascade_df2T_instance_f32 const iir_inst = 
{
  IIR_ORDER/2,
  m_biquad_state,
  m_biquad_coeffs
};

extern float32_t* pSrc;
extern float32_t* pDst;
extern uint16_t blockSize;

arm_biquad_cascade_df2T_f32(&iir_inst, pSrc, pDst, blockSize);

```
