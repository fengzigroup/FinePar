
#define VEC2DWIDTH 1024
#define CSR_VEC_GROUP_SIZE 64
//#define WARPSIZE 64
#define WARPSIZE 32
#define DAM 0.85


__kernel void gpu_csr_ve_slm_pm_fs(__global int* rowptr,  __global int* colid, __global float* data, __global float* vec, __global float* result, int row_num , __global unsigned long* bitmap)
//__kernel void gpu_csr_ve_slm_pm_fs(__global int* rowptr,  __global int* colid, __global float* data, __global float* vec, __global float* result, int row_num , __global unsigned long* bitmap, __global float* prold, __global float* prnew, int midrow)
{

    int r = get_global_id(0);
    //int row = get_global_id(0)+midrow;
    int getnumsum=get_global_size(0);
//    r+=midrow;//zf
    
    for(;r<row_num; r+=getnumsum){
      int row=r;
      if(bitmap[row>>6]&(1ul<<(row&0x3f))){
        float sum = 0;
        int start = rowptr[row];
        int end = rowptr[row+1];
        for (int i = start; i < end; i++)
        {
          int col = colid[i];
          sum = mad(data[i], vec[col], sum);
        }
        result[row] = sum;
      }  
    }

}

__kernel void cpu_csr_ve_slm_pm_fs(__global int* rowptr,  __global int* colid, __global float* data, __global float* vec, __global float* result, int rowtotal, __global int* rowall, int rowallsize){
//__kernel void cpu_csr(__global int* rowptr,  __global int* colid, __global float* data, __global float* vec, __global float* result, int rowtotal, __global int* rowall, int rowallsize, __global float* prold, __global float* prnew,  int midrow){

    int r = get_global_id(0);
    //int row = get_global_id(0)+midrow;
    int getnumsum=get_global_size(0);
//    r+=midrow;//zf
    
    for(;r<rowallsize; r+=getnumsum){
    //  int row=r;
      int row=rowall[r];
//      if (row < row_num)
 //     {   
        float sum = 0;
        //float sum = result[row];
        int start = rowptr[row];
        int end = rowptr[row+1];
        for (int i = start; i < end; i++)
        {
          int col = colid[i];
          sum = mad(data[i], vec[col], sum);
        }
//        sum=sum*DAM + (1.0-DAM)*vec[row];
        result[row] = sum;
  //          if(row==1)
    //          printf("cpu res[1]=%f\n",sum);
        //result[row] = sum;
  //    }  
    }

}




/*
__kernel void caldistance(int rowtotal, __global float* prold, __global float* prnew, __global float* distance){
  distance[0]=0;
  for(int i=0; i<rowtotal; i++){
    (distance[0])+=(prnew[i]-prold[i])*(prnew[i]-prold[i]);
  //printf("prenew[i]=%f, prold[i]=%f\n",prnew[i],prold[i]);
  }
//  distance=sqrt(distance);

}
    
__kernel void cpu_csr(__global int* rowptr,  __global int* colid, __global float* data, __global float* vec, __global float* result, int rowtotal, __global int* rowall){

    //int row = get_global_id(0);
    int r = get_global_id(0);
    int row=rowall[r];
    
    //if (row < row_num)
    {   
        float sum = result[row];
        int start = rowptr[row];
        int end = rowptr[row+1];
        for (int i = start; i < end; i++)
        {
            int col = colid[i];
            sum = mad(data[i], vec[col], sum);
        }
        result[row] = sum;
    }  

}
*/
