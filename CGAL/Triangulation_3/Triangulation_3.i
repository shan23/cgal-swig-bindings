%module Triangulation_3

%include "../common.i"
%import  "../Kernel/Point_3.h"
%import  "../Common/Macros.h"
%include "../Common/Input_iterator.h"


//input iterator typemap
#ifdef SWIGPYTHON
%typemap(in) Point_range {
    if (!PyList_Check($input)) {
        PyErr_SetString(PyExc_TypeError, "Not a list.");
        return NULL;
    }
    int size = PyList_Size($input);
    $1.reserve(size);
    for (int i = 0; i < size; i++) {
        PyObject *item = PyList_GetItem($input, i);
        void* ret=0;
        int res = SWIG_ConvertPtr(item, &ret, SWIGTYPE_p_Point_3,  0  | 0);
        if (!SWIG_IsOK(res)) {
          PyErr_SetString(PyExc_TypeError, "List item is not a Point_3.");
          return NULL;
        }        
        $1.push_back( &((Point_3*)(ret))->get_data_ref() );
    }
}
#endif

#ifdef SWIGJAVA
%typemap(jni) Point_range "jobjectArray"  //replace in jni class
%typemap(jtype) Point_range "Point_3[]"   //replace in java wrapping class
%typemap(jstype) Point_range "Point_3[]"  //replace in java function args
%typemap(javain) Point_range "$javainput" //replace in java function call to wrapped function


%typemap(in) Point_range {
  int size = jenv->GetArrayLength($input);
  $1.reserve(size);
  for (int i = 0; i < size; ++i){
    jobject j_obj = jenv->GetObjectArrayElement( $input, i);
    jclass clazz = jenv->GetObjectClass(j_obj);
    assert(clazz!=NULL);
    jmethodID id=jenv->GetStaticMethodID(clazz, "getCPtr", "(LCGAL/Kernel/Point_3;)J");
    assert(id!=NULL);
    jlong jpt=(jlong) jenv->CallStaticObjectMethod(clazz,id,j_obj);
    Point_3 *val = (Point_3 *)jpt;
    $1.push_back( &(val->get_data_ref()) );
  }
}
#endif



//include files
%{
  #include "Delaunay_triangulation_3.h"
  #include "triangulation_handles.h"
  #include "../Common/triple.h"
  #include "triangulation_iterators.h"
%}

%pragma(java) jniclassimports=%{import CGAL.Kernel.Point_3;%}



//definitions
%include "Triangulation_3.h"
%include "Delaunay_triangulation_3.h"
%include "triangulation_handles.h"
%include "../Common/triple.h"
%include "triangulation_iterators.h"
%include "../Common/Output_iterator.h"
%include "../Common/Reference_wrapper.h"

//Handles
%template(Delaunay_triangulation_3_Cell_handle)        CGAL_Cell_handle<EPIC_DT3>;
%typemap(javaimports) CGAL_Vertex_handle %{import CGAL.Kernel.Point_3;%}
%template(Delaunay_triangulation_3_Vertex_handle)      CGAL_Vertex_handle<EPIC_DT3>;

%include "std_pair.i"
%template(Delaunay_triangulation_3_Facet) std::pair<CGAL_Cell_handle<EPIC_DT3>,int>;
%template(Delaunay_triangulation_3_Edge)  CGAL_SWIG::Triple<CGAL_Cell_handle<EPIC_DT3>,int,int>;

//Triangulation
%typemap(javaimports) Triangulation_3_wrapper%{import CGAL.Kernel.Point_3;%}
%template(internal_T3_for_DT3)       Triangulation_3_wrapper<EPIC_DT3,CGAL_Vertex_handle<EPIC_DT3>,CGAL_Cell_handle<EPIC_DT3> >;
%typemap(javaimports) Delaunay_triangulation_3_wrapper%{import CGAL.Kernel.Point_3;%}
%template(Delaunay_triangulation_3)      Delaunay_triangulation_3_wrapper<EPIC_DT3,CGAL_Vertex_handle<EPIC_DT3>,CGAL_Cell_handle<EPIC_DT3> >;


//References
%template(Ref_int) Reference_wrapper<int>;

//Iterators
Iterator_for_java(CGAL_All_vertices_iterator,Delaunay_triangulation_3_Vertex_handle,import CGAL.Kernel.Point_3;)
%template(Delaunay_triangulation_3_All_vertices_iterator) CGAL_All_vertices_iterator<EPIC_DT3,CGAL_Vertex_handle<EPIC_DT3> >;

Iterator_for_java(CGAL_Finite_vertices_iterator,Delaunay_triangulation_3_Vertex_handle,import CGAL.Kernel.Point_3;)
%template(Delaunay_triangulation_3_Finite_vertices_iterator) CGAL_Finite_vertices_iterator<EPIC_DT3,CGAL_Vertex_handle<EPIC_DT3> >;

Iterator_for_java(CGAL_All_cells_iterator,Delaunay_triangulation_3_Cell_handle,;)
%template(Delaunay_triangulation_3_All_cells_iterator) CGAL_All_cells_iterator<EPIC_DT3,CGAL_Cell_handle<EPIC_DT3> >;

Iterator_for_java(CGAL_Finite_cells_iterator,Delaunay_triangulation_3_Cell_handle,;)
%template(Delaunay_triangulation_3_Finite_cells_iterator) CGAL_Finite_cells_iterator<EPIC_DT3,CGAL_Cell_handle<EPIC_DT3> >;

Iterator_for_java(CGAL_All_facets_iterator,Delaunay_triangulation_3_Facet,;)
%template(Delaunay_triangulation_3_All_facets_iterator) CGAL_All_facets_iterator<EPIC_DT3,std::pair<CGAL_Cell_handle<EPIC_DT3>,int> >;

Iterator_for_java(CGAL_Finite_facets_iterator,Delaunay_triangulation_3_Facet,;)
%template(Delaunay_triangulation_3_Finite_facets_iterator) CGAL_Finite_facets_iterator<EPIC_DT3,std::pair<CGAL_Cell_handle<EPIC_DT3>,int> >;

Iterator_for_java(CGAL_All_edges_iterator,Delaunay_triangulation_3_Edge,;)
%template(Delaunay_triangulation_3_All_edges_iterator) CGAL_All_edges_iterator<EPIC_DT3,CGAL_SWIG::Triple<CGAL_Cell_handle<EPIC_DT3>,int,int> >;

Iterator_for_java(CGAL_Finite_edges_iterator,Delaunay_triangulation_3_Edge,;)
%template(Delaunay_triangulation_3_Finite_edges_iterator) CGAL_Finite_edges_iterator<EPIC_DT3,CGAL_SWIG::Triple<CGAL_Cell_handle<EPIC_DT3>,int,int> >;

Iterator_for_java(CGAL_Point_iterator,Point_3,import CGAL.Kernel.Point_3;)
%template(Delaunay_triangulation_3_Point_iterator) CGAL_Point_iterator<EPIC_DT3,Point_3>;

Iterator_for_java(CGAL_Cell_circulator,Delaunay_triangulation_3_Cell_handle,;)
%template(Delaunay_triangulation_3_Cell_circulator) CGAL_Cell_circulator<EPIC_DT3,CGAL_Cell_handle<EPIC_DT3> >;

Iterator_for_java(CGAL_Facet_circulator,Delaunay_triangulation_3_Facet,;)
%template(Delaunay_triangulation_3_Facet_circulator) CGAL_Facet_circulator<EPIC_DT3,std::pair<CGAL_Cell_handle<EPIC_DT3>,int> >;

//output iterator
%template(Cell_handle_output_iterator) Output_iterator<CGAL_Cell_handle<EPIC_DT3> >;
Iterator_for_java(General_iterator,Delaunay_triangulation_3_Cell_handle,;)
%template(Iterator_of_cell_handle) General_iterator< Output_iterator<CGAL_Cell_handle<EPIC_DT3> >,CGAL_Cell_handle<EPIC_DT3> >;
