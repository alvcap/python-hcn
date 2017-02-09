from libc.stdint cimport uint32_t, uint16_t
from libcpp cimport string
from libcpp cimport bool

cdef inline int raise_py_error() except *:
    # unfortunately no way to get details from halcon exceptions here....
    raise RuntimeError("Halcon Error")


cdef extern from "HalconCpp.h" namespace "HalconCpp":

    cdef union Hpar:
        double d
        char* s
        long l

    cdef struct Hcpar:
        Hpar par
        int type

    cdef cppclass HPose:
        HPose() except +raise_py_error
        HTuple ConvertToTuple()

    cdef cppclass HString:
        HString() except +raise_py_error
        HString(const char*) except +raise_py_error
        const char* Text() const

    cdef cppclass HTupleElement:
        #HTupleElement() except +raise_py_error
        HTupleElement(double) except +raise_py_error
        HTupleElement(int) except +raise_py_error
        int Type()
        int L()
        double D()
        Hcpar P()
        HString S()
        const char* C()

    cdef cppclass HTuple:
        HTuple() except +raise_py_error
        HTuple(const char*) except +raise_py_error
        HTuple(const HString&) except +raise_py_error
        HTuple(long) except +raise_py_error
        HTuple(double) except +raise_py_error
        HTuple(double*, int) except +raise_py_error
        HTuple(long*, int) except +raise_py_error
        int Type()
        int Length()

        long*  LArr();
        double* DArr();
        char**  SArr();
        long*  ToLArr();
        double* ToDArr();
        char**  ToSArr();
        Hcpar*  ToPArr();

        void assign "operator="(int)
        void assign "operator="(double)
        void assign "operator="(char*)
        void add "operator+="(double)
        void add "operator+="(int)
        void add "operator+="(HTuple)
        HTupleElement operator[](int)
        HString ToString()
        HTuple& Append(const HTuple&) except +raise_py_error
        void Clear()


cdef extern from "HObjectModel3D.h" namespace "HalconCpp":
    cdef cppclass HObjectModel3D:
        #constructors
        HObjectModel3D() except +raise_py_error
        HObjectModel3D(const HTuple& X, const HTuple& Y, const HTuple& Z) except +raise_py_error
        HObjectModel3D(const HString& FileName, const HTuple& Scale, const HTuple& GenParamName, const HTuple& GenParamValue, HTuple* Status) except +raise_py_error
        void GenPlaneObjectModel3d(const HPose& Pose, double XExtent, double YExtent) except +raise_py_error
        void GenSphereObjectModel3dCenter(double X, double Y, double Z, double Radius) except +raise_py_error

        #write
        void WriteObjectModel3d(const HString& FileType, const HString& FileName, const HTuple& GenParamName, const HTuple& GenParamValue) except +raise_py_error

        #operations
        HObjectModel3D SelectPointsObjectModel3d(const char* Attrib, double MinValue, double MaxValue) const;
        HPose SmallestBoundingBoxObjectModel3d(const char*, double*, double*, double*) except +raise_py_error
        HObjectModel3D ConvexHullObjectModel3d() const;
        HTuple GetObjectModel3dParams(const HTuple& GenParamName) const;
        HObjectModel3D FitPrimitivesObjectModel3d(const HTuple& GenParamName, const HTuple& GenParamValue) const;
        HObjectModel3D SurfaceNormalsObjectModel3d(const char* Method, const HTuple& GenParamName, const HTuple& GenParamValue) const;
        HObjectModel3D SmoothObjectModel3d(const char* Method, const HTuple& GenParamName, const HTuple& GenParamValue) const;
        #HSurfaceModel CreateSurfaceModel(double RelSamplingDistance, const char* GenParamName, const char* GenParamValue) const;
        void DistanceObjectModel3d(const HObjectModel3D& ObjectModel3DTo, const HPose& Pose, double MaxDistance, const char* GenParamName, const char* GenParamValue) const;
        HObjectModel3D SampleObjectModel3d(const char* Method, double SampleDistance, const HTuple& GenParamName, const HTuple& GenParamValue) const;
        
        HObjectModel3D EdgesObjectModel3d(const HTuple& MinAmplitude, const HTuple& GenParamName, const HTuple& GenParamValue) const;