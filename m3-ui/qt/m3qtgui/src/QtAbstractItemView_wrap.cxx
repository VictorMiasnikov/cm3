/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 * 
 * This file is not intended to be easily readable and contains a number of 
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG 
 * interface file instead. 
 * ----------------------------------------------------------------------------- */

#define SWIGMODULA3


#ifdef __cplusplus
/* SwigValueWrapper is described in swig.swg */
template<typename T> class SwigValueWrapper {
  struct SwigMovePointer {
    T *ptr;
    SwigMovePointer(T *p) : ptr(p) { }
    ~SwigMovePointer() { delete ptr; }
    SwigMovePointer& operator=(SwigMovePointer& rhs) { T* oldptr = ptr; ptr = 0; delete oldptr; ptr = rhs.ptr; rhs.ptr = 0; return *this; }
  } pointer;
  SwigValueWrapper& operator=(const SwigValueWrapper<T>& rhs);
  SwigValueWrapper(const SwigValueWrapper<T>& rhs);
public:
  SwigValueWrapper() : pointer(0) { }
  SwigValueWrapper& operator=(const T& t) { SwigMovePointer tmp(new T(t)); pointer = tmp; return *this; }
  operator T&() const { return *pointer.ptr; }
  T *operator&() { return pointer.ptr; }
};

template <typename T> T SwigValueInit() {
  return T();
}
#endif

/* -----------------------------------------------------------------------------
 *  This section contains generic SWIG labels for method/variable
 *  declarations/attributes, and other compiler dependent labels.
 * ----------------------------------------------------------------------------- */

/* template workaround for compilers that cannot correctly implement the C++ standard */
#ifndef SWIGTEMPLATEDISAMBIGUATOR
# if defined(__SUNPRO_CC) && (__SUNPRO_CC <= 0x560)
#  define SWIGTEMPLATEDISAMBIGUATOR template
# elif defined(__HP_aCC)
/* Needed even with `aCC -AA' when `aCC -V' reports HP ANSI C++ B3910B A.03.55 */
/* If we find a maximum version that requires this, the test would be __HP_aCC <= 35500 for A.03.55 */
#  define SWIGTEMPLATEDISAMBIGUATOR template
# else
#  define SWIGTEMPLATEDISAMBIGUATOR
# endif
#endif

/* inline attribute */
#ifndef SWIGINLINE
# if defined(__cplusplus) || (defined(__GNUC__) && !defined(__STRICT_ANSI__))
#   define SWIGINLINE inline
# else
#   define SWIGINLINE
# endif
#endif

/* attribute recognised by some compilers to avoid 'unused' warnings */
#ifndef SWIGUNUSED
# if defined(__GNUC__)
#   if !(defined(__cplusplus)) || (__GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4))
#     define SWIGUNUSED __attribute__ ((__unused__)) 
#   else
#     define SWIGUNUSED
#   endif
# elif defined(__ICC)
#   define SWIGUNUSED __attribute__ ((__unused__)) 
# else
#   define SWIGUNUSED 
# endif
#endif

#ifndef SWIG_MSC_UNSUPPRESS_4505
# if defined(_MSC_VER)
#   pragma warning(disable : 4505) /* unreferenced local function has been removed */
# endif 
#endif

#ifndef SWIGUNUSEDPARM
# ifdef __cplusplus
#   define SWIGUNUSEDPARM(p)
# else
#   define SWIGUNUSEDPARM(p) p SWIGUNUSED 
# endif
#endif

/* internal SWIG method */
#ifndef SWIGINTERN
# define SWIGINTERN static SWIGUNUSED
#endif

/* internal inline SWIG method */
#ifndef SWIGINTERNINLINE
# define SWIGINTERNINLINE SWIGINTERN SWIGINLINE
#endif

/* exporting methods */
#if (__GNUC__ >= 4) || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4)
#  ifndef GCC_HASCLASSVISIBILITY
#    define GCC_HASCLASSVISIBILITY
#  endif
#endif

#ifndef SWIGEXPORT
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   if defined(STATIC_LINKED)
#     define SWIGEXPORT
#   else
#     define SWIGEXPORT __declspec(dllexport)
#   endif
# else
#   if defined(__GNUC__) && defined(GCC_HASCLASSVISIBILITY)
#     define SWIGEXPORT __attribute__ ((visibility("default")))
#   else
#     define SWIGEXPORT
#   endif
# endif
#endif

/* calling conventions for Windows */
#ifndef SWIGSTDCALL
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   define SWIGSTDCALL __stdcall
# else
#   define SWIGSTDCALL
# endif 
#endif

/* Deal with Microsoft's attempt at deprecating C standard runtime functions */
#if !defined(SWIG_NO_CRT_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_CRT_SECURE_NO_DEPRECATE)
# define _CRT_SECURE_NO_DEPRECATE
#endif

/* Deal with Microsoft's attempt at deprecating methods in the standard C++ library */
#if !defined(SWIG_NO_SCL_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_SCL_SECURE_NO_DEPRECATE)
# define _SCL_SECURE_NO_DEPRECATE
#endif




#include <stdlib.h>
#include <string.h>
#include <stdio.h>


#include <QtGui/qabstractitemview.h>
#define  EditTriggers  QAbstractItemView::EditTriggers


#ifdef __cplusplus
extern "C" {
#endif

SWIGEXPORT void Delete_QAbstractItemView(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  delete arg1;
}


SWIGEXPORT void QAbstractItemView_setModel(QAbstractItemView * self, QAbstractItemModel * model) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemModel *arg2 = (QAbstractItemModel *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QAbstractItemModel **)&model; 
  (arg1)->setModel(arg2);
}


SWIGEXPORT QAbstractItemModel * QAbstractItemView_model(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemModel *result = 0 ;
  QAbstractItemModel * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemModel *)((QAbstractItemView const *)arg1)->model();
  *(QAbstractItemModel **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setSelectionModel(QAbstractItemView * self, QItemSelectionModel * selectionModel) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QItemSelectionModel *arg2 = (QItemSelectionModel *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QItemSelectionModel **)&selectionModel; 
  (arg1)->setSelectionModel(arg2);
}


SWIGEXPORT QItemSelectionModel * QAbstractItemView_selectionModel(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QItemSelectionModel *result = 0 ;
  QItemSelectionModel * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QItemSelectionModel *)((QAbstractItemView const *)arg1)->selectionModel();
  *(QItemSelectionModel **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setItemDelegate(QAbstractItemView * self, QAbstractItemDelegate * delegate) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemDelegate *arg2 = (QAbstractItemDelegate *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QAbstractItemDelegate **)&delegate; 
  (arg1)->setItemDelegate(arg2);
}


SWIGEXPORT QAbstractItemDelegate * QAbstractItemView_itemDelegate(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemDelegate *result = 0 ;
  QAbstractItemDelegate * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemDelegate *)((QAbstractItemView const *)arg1)->itemDelegate();
  *(QAbstractItemDelegate **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setSelectionMode(QAbstractItemView * self, QAbstractItemView::SelectionMode mode) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::SelectionMode arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (QAbstractItemView::SelectionMode)mode; 
  (arg1)->setSelectionMode(arg2);
}


SWIGEXPORT QAbstractItemView::SelectionMode QAbstractItemView_selectionMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::SelectionMode result;
  QAbstractItemView::SelectionMode cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemView::SelectionMode)((QAbstractItemView const *)arg1)->selectionMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setSelectionBehavior(QAbstractItemView * self, QAbstractItemView::SelectionBehavior behavior) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::SelectionBehavior arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (QAbstractItemView::SelectionBehavior)behavior; 
  (arg1)->setSelectionBehavior(arg2);
}


SWIGEXPORT QAbstractItemView::SelectionBehavior QAbstractItemView_selectionBehavior(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::SelectionBehavior result;
  QAbstractItemView::SelectionBehavior cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemView::SelectionBehavior)((QAbstractItemView const *)arg1)->selectionBehavior();
  cresult = result; 
  return cresult;
}


SWIGEXPORT QModelIndex * QAbstractItemView_currentIndex(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  *(QModelIndex **)&cresult = new QModelIndex((const QModelIndex &)((QAbstractItemView const *)arg1)->currentIndex());
  return cresult;
}


SWIGEXPORT QModelIndex * QAbstractItemView_rootIndex(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  *(QModelIndex **)&cresult = new QModelIndex((const QModelIndex &)((QAbstractItemView const *)arg1)->rootIndex());
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setEditTriggers(QAbstractItemView * self, EditTriggers triggers) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  EditTriggers arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (EditTriggers)triggers; 
  (arg1)->setEditTriggers(arg2);
}


SWIGEXPORT EditTriggers QAbstractItemView_editTriggers(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  EditTriggers cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  *(EditTriggers **)&cresult = new EditTriggers((const EditTriggers &)((QAbstractItemView const *)arg1)->editTriggers());
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setVerticalScrollMode(QAbstractItemView * self, QAbstractItemView::ScrollMode mode) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::ScrollMode arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (QAbstractItemView::ScrollMode)mode; 
  (arg1)->setVerticalScrollMode(arg2);
}


SWIGEXPORT QAbstractItemView::ScrollMode QAbstractItemView_verticalScrollMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::ScrollMode result;
  QAbstractItemView::ScrollMode cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemView::ScrollMode)((QAbstractItemView const *)arg1)->verticalScrollMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setHorizontalScrollMode(QAbstractItemView * self, QAbstractItemView::ScrollMode mode) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::ScrollMode arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (QAbstractItemView::ScrollMode)mode; 
  (arg1)->setHorizontalScrollMode(arg2);
}


SWIGEXPORT QAbstractItemView::ScrollMode QAbstractItemView_horizontalScrollMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::ScrollMode result;
  QAbstractItemView::ScrollMode cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemView::ScrollMode)((QAbstractItemView const *)arg1)->horizontalScrollMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setAutoScroll(QAbstractItemView * self, bool enable) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = enable ? true : false; 
  (arg1)->setAutoScroll(arg2);
}


SWIGEXPORT bool QAbstractItemView_hasAutoScroll(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->hasAutoScroll();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setAutoScrollMargin(QAbstractItemView * self, int margin) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)margin; 
  (arg1)->setAutoScrollMargin(arg2);
}


SWIGEXPORT int QAbstractItemView_autoScrollMargin(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int result;
  int cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (int)((QAbstractItemView const *)arg1)->autoScrollMargin();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setTabKeyNavigation(QAbstractItemView * self, bool enable) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = enable ? true : false; 
  (arg1)->setTabKeyNavigation(arg2);
}


SWIGEXPORT bool QAbstractItemView_tabKeyNavigation(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->tabKeyNavigation();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setDropIndicatorShown(QAbstractItemView * self, bool enable) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = enable ? true : false; 
  (arg1)->setDropIndicatorShown(arg2);
}


SWIGEXPORT bool QAbstractItemView_showDropIndicator(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->showDropIndicator();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setDragEnabled(QAbstractItemView * self, bool enable) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = enable ? true : false; 
  (arg1)->setDragEnabled(arg2);
}


SWIGEXPORT bool QAbstractItemView_dragEnabled(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->dragEnabled();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setDragDropOverwriteMode(QAbstractItemView * self, bool overwrite) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = overwrite ? true : false; 
  (arg1)->setDragDropOverwriteMode(arg2);
}


SWIGEXPORT bool QAbstractItemView_dragDropOverwriteMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->dragDropOverwriteMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setDragDropMode(QAbstractItemView * self, QAbstractItemView::DragDropMode behavior) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::DragDropMode arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (QAbstractItemView::DragDropMode)behavior; 
  (arg1)->setDragDropMode(arg2);
}


SWIGEXPORT QAbstractItemView::DragDropMode QAbstractItemView_dragDropMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QAbstractItemView::DragDropMode result;
  QAbstractItemView::DragDropMode cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (QAbstractItemView::DragDropMode)((QAbstractItemView const *)arg1)->dragDropMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setDefaultDropAction(QAbstractItemView * self, Qt::DropAction dropAction) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  Qt::DropAction arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (Qt::DropAction)dropAction; 
  (arg1)->setDefaultDropAction(arg2);
}


SWIGEXPORT Qt::DropAction QAbstractItemView_defaultDropAction(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  Qt::DropAction result;
  Qt::DropAction cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (Qt::DropAction)((QAbstractItemView const *)arg1)->defaultDropAction();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setAlternatingRowColors(QAbstractItemView * self, bool enable) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = enable ? true : false; 
  (arg1)->setAlternatingRowColors(arg2);
}


SWIGEXPORT bool QAbstractItemView_alternatingRowColors(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (bool)((QAbstractItemView const *)arg1)->alternatingRowColors();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setIconSize(QAbstractItemView * self, QSize * size) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QSize *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QSize **)&size;
  (arg1)->setIconSize((QSize const &)*arg2);
}


SWIGEXPORT QSize * QAbstractItemView_iconSize(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QSize * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  *(QSize **)&cresult = new QSize((const QSize &)((QAbstractItemView const *)arg1)->iconSize());
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setTextElideMode(QAbstractItemView * self, Qt::TextElideMode mode) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  Qt::TextElideMode arg2 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (Qt::TextElideMode)mode; 
  (arg1)->setTextElideMode(arg2);
}


SWIGEXPORT Qt::TextElideMode QAbstractItemView_textElideMode(QAbstractItemView const * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  Qt::TextElideMode result;
  Qt::TextElideMode cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  result = (Qt::TextElideMode)((QAbstractItemView const *)arg1)->textElideMode();
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_keyboardSearch(QAbstractItemView * self, QString * search) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QString *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QString **)&search;
  (arg1)->keyboardSearch((QString const &)*arg2);
}


SWIGEXPORT QSize * QAbstractItemView_sizeHintForIndex(QAbstractItemView const * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  QSize * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  *(QSize **)&cresult = new QSize((const QSize &)((QAbstractItemView const *)arg1)->sizeHintForIndex((QModelIndex const &)*arg2));
  return cresult;
}


SWIGEXPORT int QAbstractItemView_sizeHintForRow(QAbstractItemView const * self, int row) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  int result;
  int cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)row; 
  result = (int)((QAbstractItemView const *)arg1)->sizeHintForRow(arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT int QAbstractItemView_sizeHintForColumn(QAbstractItemView const * self, int column) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  int result;
  int cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)column; 
  result = (int)((QAbstractItemView const *)arg1)->sizeHintForColumn(arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_openPersistentEditor(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->openPersistentEditor((QModelIndex const &)*arg2);
}


SWIGEXPORT void QAbstractItemView_closePersistentEditor(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->closePersistentEditor((QModelIndex const &)*arg2);
}


SWIGEXPORT void QAbstractItemView_setIndexWidget(QAbstractItemView * self, QModelIndex * index, QWidget * widget) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  QWidget *arg3 = (QWidget *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  arg3 = *(QWidget **)&widget; 
  (arg1)->setIndexWidget((QModelIndex const &)*arg2,arg3);
}


SWIGEXPORT QWidget * QAbstractItemView_indexWidget(QAbstractItemView const * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  QWidget *result = 0 ;
  QWidget * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  result = (QWidget *)((QAbstractItemView const *)arg1)->indexWidget((QModelIndex const &)*arg2);
  *(QWidget **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setItemDelegateForRow(QAbstractItemView * self, int row, QAbstractItemDelegate * delegate) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  QAbstractItemDelegate *arg3 = (QAbstractItemDelegate *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)row; 
  arg3 = *(QAbstractItemDelegate **)&delegate; 
  (arg1)->setItemDelegateForRow(arg2,arg3);
}


SWIGEXPORT QAbstractItemDelegate * QAbstractItemView_itemDelegateForRow(QAbstractItemView const * self, int row) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  QAbstractItemDelegate *result = 0 ;
  QAbstractItemDelegate * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)row; 
  result = (QAbstractItemDelegate *)((QAbstractItemView const *)arg1)->itemDelegateForRow(arg2);
  *(QAbstractItemDelegate **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_setItemDelegateForColumn(QAbstractItemView * self, int column, QAbstractItemDelegate * delegate) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  QAbstractItemDelegate *arg3 = (QAbstractItemDelegate *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)column; 
  arg3 = *(QAbstractItemDelegate **)&delegate; 
  (arg1)->setItemDelegateForColumn(arg2,arg3);
}


SWIGEXPORT QAbstractItemDelegate * QAbstractItemView_itemDelegateForColumn(QAbstractItemView const * self, int column) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  int arg2 ;
  QAbstractItemDelegate *result = 0 ;
  QAbstractItemDelegate * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = (int)column; 
  result = (QAbstractItemDelegate *)((QAbstractItemView const *)arg1)->itemDelegateForColumn(arg2);
  *(QAbstractItemDelegate **)&cresult = result; 
  return cresult;
}


SWIGEXPORT QAbstractItemDelegate * QAbstractItemView_itemDelegate1(QAbstractItemView const * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  QAbstractItemDelegate *result = 0 ;
  QAbstractItemDelegate * cresult ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  result = (QAbstractItemDelegate *)((QAbstractItemView const *)arg1)->itemDelegate((QModelIndex const &)*arg2);
  *(QAbstractItemDelegate **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void QAbstractItemView_update(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->update();
}


SWIGEXPORT void QAbstractItemView_reset(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->reset();
}


SWIGEXPORT void QAbstractItemView_setRootIndex(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->setRootIndex((QModelIndex const &)*arg2);
}


SWIGEXPORT void QAbstractItemView_doItemsLayout(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->doItemsLayout();
}


SWIGEXPORT void QAbstractItemView_selectAll(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->selectAll();
}


SWIGEXPORT void QAbstractItemView_edit(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->edit((QModelIndex const &)*arg2);
}


SWIGEXPORT void QAbstractItemView_clearSelection(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->clearSelection();
}


SWIGEXPORT void QAbstractItemView_setCurrentIndex(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->setCurrentIndex((QModelIndex const &)*arg2);
}


SWIGEXPORT void QAbstractItemView_scrollToTop(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->scrollToTop();
}


SWIGEXPORT void QAbstractItemView_scrollToBottom(QAbstractItemView * self) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  (arg1)->scrollToBottom();
}


SWIGEXPORT void QAbstractItemView_update1(QAbstractItemView * self, QModelIndex * index) {
  QAbstractItemView *arg1 = (QAbstractItemView *) 0 ;
  QModelIndex *arg2 = 0 ;
  
  arg1 = *(QAbstractItemView **)&self; 
  arg2 = *(QModelIndex **)&index;
  (arg1)->update((QModelIndex const &)*arg2);
}


SWIGEXPORT long Modula3_QAbstractItemViewToQAbstractScrollArea(long objectRef) {
    long baseptr = 0;
    *(QAbstractScrollArea **)&baseptr = *(QAbstractItemView **)&objectRef;
    return baseptr;
}

#ifdef __cplusplus
}
#endif

