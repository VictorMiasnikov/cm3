(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtCalendarWidget;

FROM QtSize IMPORT QSize;
FROM QtDateTime IMPORT QDate;
FROM QGuiStubs IMPORT QTextCharFormat;
FROM QtWidget IMPORT QWidget;
FROM QtNamespace IMPORT DayOfWeek;


TYPE T = QCalendarWidget;


TYPE                             (* Enum HorizontalHeaderFormat *)
  HorizontalHeaderFormat = {NoHorizontalHeader, SingleLetterDayNames,
                            ShortDayNames, LongDayNames};

TYPE                             (* Enum VerticalHeaderFormat *)
  VerticalHeaderFormat = {NoVerticalHeader, ISOWeekNumbers};

TYPE                             (* Enum SelectionMode *)
  SelectionMode = {NoSelection, SingleSelection};

TYPE
  QCalendarWidget <: QCalendarWidgetPublic;
  QCalendarWidgetPublic =
    QWidget BRANDED OBJECT
    METHODS
      init_0                    (parent: QWidget; ): QCalendarWidget;
      init_1                    (): QCalendarWidget;
      sizeHint                  (): QSize; (* virtual *)
      minimumSizeHint           (): QSize; (* virtual *)
      selectedDate              (): QDate;
      yearShown                 (): INTEGER;
      monthShown                (): INTEGER;
      minimumDate               (): QDate;
      setMinimumDate            (date: QDate; );
      maximumDate               (): QDate;
      setMaximumDate            (date: QDate; );
      firstDayOfWeek            (): DayOfWeek;
      setFirstDayOfWeek         (dayOfWeek: DayOfWeek; );
      isHeaderVisible           (): BOOLEAN;
      setHeaderVisible          (show: BOOLEAN; );
      isNavigationBarVisible    (): BOOLEAN;
      isGridVisible             (): BOOLEAN;
      selectionMode             (): SelectionMode;
      setSelectionMode          (mode: SelectionMode; );
      horizontalHeaderFormat    (): HorizontalHeaderFormat;
      setHorizontalHeaderFormat (format: HorizontalHeaderFormat; );
      verticalHeaderFormat      (): VerticalHeaderFormat;
      setVerticalHeaderFormat   (format: VerticalHeaderFormat; );
      setHeaderTextFormat       (format: QTextCharFormat; );
      setWeekdayTextFormat (dayOfWeek: DayOfWeek; format: QTextCharFormat; );
      setDateTextFormat       (date: QDate; format: QTextCharFormat; );
      isDateEditEnabled       (): BOOLEAN;
      setDateEditEnabled      (enable: BOOLEAN; );
      dateEditAcceptDelay     (): INTEGER;
      setDateEditAcceptDelay  (delay: INTEGER; );
      setSelectedDate         (date: QDate; );
      setDateRange            (min, max: QDate; );
      setCurrentPage          (year, month: INTEGER; );
      setGridVisible          (show: BOOLEAN; );
      setNavigationBarVisible (visible: BOOLEAN; );
      showNextMonth           ();
      showPreviousMonth       ();
      showNextYear            ();
      showPreviousYear        ();
      showSelectedDate        ();
      showToday               ();
      destroyCxx              ();
    END;


END QtCalendarWidget.
